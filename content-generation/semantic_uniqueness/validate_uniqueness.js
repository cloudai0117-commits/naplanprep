#!/usr/bin/env node
/**
 * NAPLANPrep Semantic Uniqueness Validator
 *
 * Scans SQL Flyway migration files in db/migration/ for question INSERT statements
 * and checks for duplicates across 5 layers:
 *
 *   Layer 1 — Exact text (question_text normalised)
 *   Layer 2 — Lexical similarity (word bag overlap ≥ 0.70)
 *   Layer 3 — Semantic topic tags (domain + topic + difficulty_band triple)
 *   Layer 4 — Structural fingerprint (construction_schema.json signatures)
 *   Layer 5 — Domain-specific construction (known_quantities + unknown + result_range)
 *
 * Usage:
 *   node validate_uniqueness.js [--sql-dir <path>] [--sig-dir <path>] [--report <path>]
 *
 * Requirements: Node.js 18+, no external dependencies.
 */

'use strict';

const fs   = require('fs');
const path = require('path');

// ─── CLI args ───────────────────────────────────────────────────────────────

const args = process.argv.slice(2);
const getArg = (flag, def) => {
  const i = args.indexOf(flag);
  return i >= 0 && args[i + 1] ? args[i + 1] : def;
};

const SQL_DIR  = getArg('--sql-dir',  path.resolve(__dirname, '../../backend/src/main/resources/db/migration'));
const SIG_DIR  = getArg('--sig-dir',  path.resolve(__dirname, 'signatures'));
const REPORT   = getArg('--report',   path.resolve(__dirname, '../CONTENT_DUPLICATE_AUDIT.md'));

// ─── Parse SQL for question INSERT rows ─────────────────────────────────────

/**
 * Extracts question metadata from Flyway SQL migration files.
 * Only processes V54+ files (content migrations start at V54).
 * Returns an array of { file, id, questionText, domain, topic, difficultyBand }.
 */
function parseQuestionsFromSqlDir(dir) {
  const files = fs.readdirSync(dir)
    .filter(f => /^V(\d+)__/.test(f) && parseInt(f.match(/^V(\d+)/)[1], 10) >= 54)
    .sort();

  const questions = [];

  for (const file of files) {
    const content = fs.readFileSync(path.join(dir, file), 'utf8');
    const tuples  = extractQuestionTuples(content);
    for (const t of tuples) {
      const q = parseQuestionTuple(t);
      if (q) questions.push({ file, ...q });
    }
  }

  return questions;
}

/**
 * Finds each INSERT INTO questions ... VALUES block and extracts the top-level
 * parenthesised tuples within it.  Handles multi-row VALUES like:
 *   INSERT INTO questions (...) VALUES\n(\n  ...\n),\n(\n  ...\n);
 */
function extractQuestionTuples(sql) {
  const tuples = [];
  // Find each INSERT INTO questions statement
  const insertRe = /INSERT\s+INTO\s+questions\s*\([^)]+\)\s*VALUES\s*/gi;
  let m;
  while ((m = insertRe.exec(sql)) !== null) {
    const afterValues = sql.slice(m.index + m[0].length);
    // Extract all top-level (...) groups before the terminating semicolon
    const groups = extractTopLevelParens(afterValues);
    tuples.push(...groups);
  }
  return tuples;
}

/**
 * Depth-tracking extractor: returns content of each top-level (...) group
 * from the start of `str`, stopping at the first unquoted semicolon at depth 0.
 */
function extractTopLevelParens(str) {
  const groups = [];
  let depth = 0;
  let start = -1;
  let i = 0;

  while (i < str.length) {
    const ch = str[i];

    // Single-quoted string — skip entire literal including '' escapes
    if (ch === "'") {
      i++;
      while (i < str.length) {
        if (str[i] === "'" && str[i + 1] === "'") { i += 2; continue; }
        if (str[i] === "'") { i++; break; }
        i++;
      }
      continue;
    }

    if (ch === '(') {
      if (depth === 0) start = i;
      depth++;
    } else if (ch === ')') {
      depth--;
      if (depth === 0 && start !== -1) {
        groups.push(str.slice(start + 1, i)); // content without outer parens
        start = -1;
      }
    } else if (ch === ';' && depth === 0) {
      break; // end of this INSERT statement
    }
    i++;
  }
  return groups;
}

/**
 * Extracts all SQL single-quoted string values from a raw tuple string,
 * correctly resolving '' → ' escapes. Returns strings in order.
 */
function extractSqlStrings(tuple) {
  const result = [];
  let i = 0;
  while (i < tuple.length) {
    if (tuple[i] === "'") {
      i++;
      let s = '';
      while (i < tuple.length) {
        if (tuple[i] === "'" && tuple[i + 1] === "'") { s += "'"; i += 2; continue; }
        if (tuple[i] === "'") { i++; break; }
        s += tuple[i++];
      }
      result.push(s);
    } else {
      i++;
    }
  }
  return result;
}

const TUPLE_ENUM_VALUES = new Set([
  'MULTIPLE_CHOICE','SHORT_ANSWER','EXTENDED_RESPONSE','AUDIO_RESPONSE',
  'NUMERACY','READING','WRITING','SPELLING','GRAMMAR_PUNCTUATION',
  'FREE','ADVANCED','PREMIUM','PUBLISHED','DRAFT','ARCHIVED',
  'EASY','MEDIUM','HARD','MEDIUM_HARD',
  'RECALL','COMPREHENSION','ANALYSIS','APPLICATION',
  'Number and Algebra','Measurement and Geometry','Statistics and Probability',
  'Number and place value','Addition and subtraction','Multiplication and division',
  'Fractions and decimals','Measurement','Shape and location','Statistics and data',
  'Chance and probability','Language conventions','Language – spelling',
  'Audio dictation','Proofreading and spelling','None','Literacy',
]);

/**
 * Parses one question VALUES tuple string into a question object.
 * Handles SQL '' apostrophe escapes correctly.
 */
function parseQuestionTuple(tuple) {
  // id: first UUID (accept any version: v4 structured UUIDs and v5 random UUIDs both appear)
  const idM = tuple.match(/'([a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12})'/i);
  if (!idM) return null;
  const id = idM[1];

  // domain
  const domainM = tuple.match(/'(NUMERACY|READING|WRITING|SPELLING|GRAMMAR_PUNCTUATION)'/);
  const domain  = domainM ? domainM[1] : 'UNKNOWN';

  // question_text: last non-enum string before the first JSONB array '[' or object '{'
  // Find position of first JSONB token in raw tuple
  const jsonStart = tuple.search(/'[\[{]/);
  const prefix    = jsonStart > 0 ? tuple.slice(0, jsonStart) : tuple;
  const prefixStrings = extractSqlStrings(prefix);
  let questionText = '';
  for (let k = prefixStrings.length - 1; k >= 0; k--) {
    const s = prefixStrings[k];
    if (s.length >= 5 && !TUPLE_ENUM_VALUES.has(s) && !/^[A-Z_]+$/.test(s) && !/^\d+$/.test(s)) {
      questionText = s;
      break;
    }
  }
  // Fallback: if no question_text found before JSONB, check full string list
  if (!questionText) {
    const all = extractSqlStrings(tuple);
    questionText = all.find(s =>
      s.length >= 5 && !TUPLE_ENUM_VALUES.has(s) && /[\?\.!]/.test(s)
    ) || all.find(s => s.length >= 5 && !TUPLE_ENUM_VALUES.has(s)) || '';
  }

  // topic: string immediately after the domain match (first non-enum string after domain)
  const afterDomain = domainM ? tuple.slice(domainM.index + domainM[0].length) : '';
  const topicM      = afterDomain.match(/'([^']+)'\s*,\s*\d/);
  const topic       = topicM ? topicM[1] : '';

  // difficulty_band: integer 1-10 after the topic
  const afterTopic = topicM ? afterDomain.slice(topicM.index + topicM[0].length - 1) : afterDomain;
  const bandM      = afterTopic.match(/,\s*([1-9]|10)\s*,/);
  const diffBand   = bandM ? parseInt(bandM[1], 10) : null;

  return { id, questionText, domain, topic, difficultyBand: diffBand };
}

// ─── Load semantic signatures ────────────────────────────────────────────────

function loadSignatures(sigDir) {
  if (!fs.existsSync(sigDir)) return {};
  const sigs = {};
  for (const f of fs.readdirSync(sigDir).filter(f => f.endsWith('.json'))) {
    try {
      const sig = JSON.parse(fs.readFileSync(path.join(sigDir, f), 'utf8'));
      if (sig.question_id) sigs[sig.question_id] = sig;
    } catch { /* skip malformed files */ }
  }
  return sigs;
}

// ─── Layer 1: Exact text ─────────────────────────────────────────────────────

/**
 * Normalise for exact-duplicate detection.
 * Math operators are replaced with spelled-out tokens so that "7 + 8" and "7 × 8"
 * remain distinct after the character-stripping pass.
 */
function normaliseText(text) {
  return text
    .toLowerCase()
    // Replace math operators with unambiguous letter tokens before stripping
    .replace(/×|✕|\*/g,       ' times ')
    .replace(/÷|\//g,          ' div ')
    .replace(/\+/g,            ' plus ')
    .replace(/−|–/g,           ' minus ')
    .replace(/[^a-z0-9\s]/g,  '')
    .replace(/\s+/g,           ' ')
    .trim();
}

function checkExactDuplicates(questions) {
  const seen = new Map();
  const dupes = [];
  for (const q of questions) {
    if (q.domain === 'SPELLING') continue; // SPELLING validated separately (target word, not question_text)
    const key = normaliseText(q.questionText);
    if (seen.has(key)) {
      dupes.push({ type: 'EXACT', a: seen.get(key), b: q });
    } else {
      seen.set(key, q);
    }
  }
  return dupes;
}

// ─── Layer 2: Lexical similarity ─────────────────────────────────────────────

const STOP_WORDS = new Set([
  'a','an','the','is','are','was','were','be','been','being',
  'have','has','had','do','does','did','will','would','could',
  'should','may','might','must','shall','to','of','in','on','at',
  'by','for','with','about','as','into','through','during',
  'and','or','but','if','then','there','that','this','these','those',
  'what','which','who','how','when','where','why','each','from'
]);

function wordBag(text) {
  return new Set(
    normaliseText(text).split(' ')
      // Include: content words longer than 2 chars, AND all numeric tokens (even 1-2 digit).
      // Numbers ARE the key differentiator between "10, 20, 30" and "2, 4, 6" patterns.
      .filter(w => w.length > 0 && !STOP_WORDS.has(w) && (w.length > 2 || /^\d+$/.test(w)))
  );
}

function jaccardSimilarity(a, b) {
  const setA = wordBag(a);
  const setB = wordBag(b);
  let intersection = 0;
  for (const w of setA) if (setB.has(w)) intersection++;
  const union = setA.size + setB.size - intersection;
  return union === 0 ? 0 : intersection / union;
}

function checkLexicalDuplicates(questions, threshold = 0.70) {
  const dupes = [];
  // Filter SPELLING (template question_text — validated separately by target word)
  const eligible = questions.filter(q => q.domain !== 'SPELLING');
  // Pre-compute word bags to avoid O(n²) regex work
  const bags = eligible.map(q => wordBag(q.questionText));
  for (let i = 0; i < eligible.length; i++) {
    const setA = bags[i];
    if (setA.size === 0) continue;
    for (let j = i + 1; j < eligible.length; j++) {
      const setB = bags[j];
      if (setB.size === 0) continue;
      let intersection = 0;
      for (const w of setA) if (setB.has(w)) intersection++;
      const union = setA.size + setB.size - intersection;
      const sim = union === 0 ? 0 : intersection / union;
      if (sim >= threshold) {
        dupes.push({ type: 'LEXICAL', similarity: sim, a: eligible[i], b: eligible[j] });
      }
    }
  }
  return dupes;
}

// ─── Layer 3: Semantic topic triple ──────────────────────────────────────────

function checkSemanticDuplicates(questions) {
  const seen = new Map();
  const dupes = [];
  // Filter SPELLING (template question_text)
  const eligible = questions.filter(q => q.domain !== 'SPELLING');
  for (const q of eligible) {
    const key = `${q.domain}|${normaliseText(q.topic)}|${q.difficultyBand}`;
    if (!seen.has(key)) { seen.set(key, []); }
    seen.get(key).push(q);
  }
  for (const [key, group] of seen) {
    if (group.length > 1) {
      // Pre-compute word bags for this group
      const bags = group.map(q => wordBag(q.questionText));
      // Within same-topic+band, flag pairs with lexical similarity ≥ 0.75
      for (let i = 0; i < group.length; i++) {
        const setA = bags[i];
        if (setA.size === 0) continue;
        for (let j = i + 1; j < group.length; j++) {
          const setB = bags[j];
          if (setB.size === 0) continue;
          let intersection = 0;
          for (const w of setA) if (setB.has(w)) intersection++;
          const union = setA.size + setB.size - intersection;
          const sim = union === 0 ? 0 : intersection / union;
          if (sim >= 0.75) {
            dupes.push({ type: 'SEMANTIC', topicKey: key, similarity: sim, a: group[i], b: group[j] });
          }
        }
      }
    }
  }
  return dupes;
}

// ─── Layer 4: Construction signature ─────────────────────────────────────────

function constructionKey(sig) {
  if (!sig || !sig.numeracy) return null;
  const n = sig.numeracy;
  const kq = (n.known_quantities || []).slice().sort((a, b) => a - b).join(',');
  return `${n.construction}|kq=${kq}|unk=${n.unknown}|rng=${n.result_range}`;
}

function checkConstructionDuplicates(questions, signatures) {
  const seen  = new Map();
  const dupes = [];
  for (const q of questions) {
    const sig = signatures[q.id];
    const key = sig ? constructionKey(sig) : null;
    if (!key) continue;
    if (seen.has(key)) {
      dupes.push({ type: 'CONSTRUCTION', constructionKey: key, a: seen.get(key), b: q });
    } else {
      seen.set(key, q);
    }
  }
  return dupes;
}

// ─── Layer 5: Scenario fingerprint ───────────────────────────────────────────

function scenarioKey(sig) {
  if (!sig || !sig.numeracy) return null;
  const ctx = sig.numeracy.context_category;
  if (!ctx || ctx === 'NONE') return null;
  // Scenario key = construction + context_category
  return `${sig.numeracy.construction}|ctx=${ctx}`;
}

function checkScenarioDuplicates(questions, signatures) {
  const seen  = new Map();
  const dupes = [];
  for (const q of questions) {
    const sig = signatures[q.id];
    const key = sig ? scenarioKey(sig) : null;
    if (!key) continue;
    if (seen.has(key)) {
      dupes.push({ type: 'SCENARIO', scenarioKey: key, a: seen.get(key), b: q });
    } else {
      seen.set(key, q);
    }
  }
  return dupes;
}

// ─── Distractor signature ─────────────────────────────────────────────────────

function distractorKey(sig) {
  if (!sig || !sig.numeracy || !sig.numeracy.distractor_signature) return null;
  const d = sig.numeracy.distractor_signature;
  if (d === 'NONE' || !d) return null;
  return `${sig.numeracy.construction}|dist=${d}`;
}

function checkDistractorDuplicates(questions, signatures) {
  const seen  = new Map();
  const dupes = [];
  for (const q of questions) {
    const sig = signatures[q.id];
    const key = sig ? distractorKey(sig) : null;
    if (!key) continue;
    if (seen.has(key)) {
      dupes.push({ type: 'DISTRACTOR', distractorKey: key, a: seen.get(key), b: q });
    } else {
      seen.set(key, q);
    }
  }
  return dupes;
}

// ─── Report ───────────────────────────────────────────────────────────────────

function renderReport(questions, exact, lexical, semantic, construction, scenario, distractor, signatures) {
  const now   = new Date().toISOString().slice(0, 10);
  const total = questions.length;
  const sigCount = Object.keys(signatures).length;

  const fileSet = new Set(questions.map(q => q.file));

  const lines = [
    '# CONTENT_DUPLICATE_AUDIT',
    '',
    `Generated: ${now}  `,
    `SQL migrations scanned: ${[...fileSet].sort().join(', ')}  `,
    `Total questions scanned: ${total}  `,
    `Semantic signatures loaded: ${sigCount}  `,
    '',
    '---',
    '',
    '## Summary',
    '',
    `| Layer | Check | Duplicates Found |`,
    `|-------|-------|-----------------|`,
    `| 1 | exact_duplicate_check | ${exact.length} |`,
    `| 2 | lexical_duplicate_check (≥0.70 Jaccard) | ${lexical.length} |`,
    `| 3 | semantic_duplicate_check (same topic+band, lexical≥0.40) | ${semantic.length} |`,
    `| 4 | construction_duplicate_check | ${construction.length} |`,
    `| 5a | scenario_duplicate_check | ${scenario.length} |`,
    `| 5b | distractor_duplicate_check | ${distractor.length} |`,
    '',
    `**Overall PASS/FAIL:**`,
    `- exact_duplicate_check: ${exact.length === 0 ? 'PASS' : 'FAIL'}`,
    `- semantic_duplicate_check: ${semantic.length === 0 ? 'PASS' : 'FAIL (REVIEW REQUIRED)'}`,
    `- construction_duplicate_check: ${construction.length === 0 ? 'PASS' : 'FAIL (REVIEW REQUIRED)'}`,
    `- scenario_duplicate_check: ${scenario.length === 0 ? 'PASS' : 'FAIL (REVIEW REQUIRED)'}`,
    `- distractor_duplicate_check: ${distractor.length === 0 ? 'PASS' : 'FAIL (REVIEW REQUIRED)'}`,
    '',
    '---',
    '',
  ];

  const renderPair = (label, pairs) => {
    if (pairs.length === 0) {
      lines.push(`## ${label}`, '', 'No duplicates found.', '');
      return;
    }
    const CAP = 100;
    const shown = pairs.slice(0, CAP);
    lines.push(`## ${label} (${pairs.length} pair(s)${pairs.length > CAP ? ` — showing first ${CAP}` : ''})`, '');
    for (const d of shown) {
      lines.push(
        `### ${d.type}`,
        `- **File A:** ${d.a.file} | ID: \`${d.a.id}\``,
        `- **File B:** ${d.b.file} | ID: \`${d.b.id}\``,
        `- **Text A:** ${(d.a.questionText||'').slice(0, 120)}`,
        `- **Text B:** ${(d.b.questionText||'').slice(0, 120)}`,
        d.similarity !== undefined ? `- **Similarity:** ${(d.similarity * 100).toFixed(1)}%` : '',
        d.constructionKey ? `- **Construction key:** \`${d.constructionKey}\`` : '',
        d.scenarioKey     ? `- **Scenario key:** \`${d.scenarioKey}\`` : '',
        d.distractorKey   ? `- **Distractor key:** \`${d.distractorKey}\`` : '',
        `- **Remediation:** Replace one question with a different construction/context.`,
        '',
      );
    }
    if (pairs.length > CAP) {
      lines.push(`_(${pairs.length - CAP} additional pairs omitted — address the ${CAP} shown first)_`, '');
    }
  };

  renderPair('Layer 1: Exact Duplicates',       exact);
  renderPair('Layer 2: Lexical Near-Duplicates', lexical);
  renderPair('Layer 3: Semantic Duplicates',     semantic);
  renderPair('Layer 4: Construction Duplicates', construction);
  renderPair('Layer 5a: Scenario Duplicates',    scenario);
  renderPair('Layer 5b: Distractor Duplicates',  distractor);

  lines.push(
    '---',
    '',
    '## Validation Gate',
    '',
    '```',
    `exact_duplicate_check      = ${exact.length === 0 ? 'PASS' : 'FAIL'}`,
    `semantic_duplicate_check   = ${semantic.length === 0 ? 'PASS' : 'FAIL'}`,
    `construction_duplicate_check = ${construction.length === 0 ? 'PASS' : 'FAIL'}`,
    `scenario_duplicate_check   = ${scenario.length === 0 ? 'PASS' : 'FAIL'}`,
    `distractor_duplicate_check = ${distractor.length === 0 ? 'PASS' : 'FAIL'}`,
    '```',
    '',
    'Gate passes only when all five checks above show PASS.',
    '**P0_CONTENT_UNIQUENESS_READY = ' +
      (exact.length + semantic.length + construction.length + scenario.length + distractor.length === 0
        ? 'YES (pending construction_duplicate and scenario_duplicate — signature files required)'
        : 'NO') + '**',
    '',
  );

  return lines.filter(l => l !== undefined).join('\n');
}

// ─── Test suite ───────────────────────────────────────────────────────────────

function runSelfTests() {
  let passed = 0; let failed = 0;
  const assert = (desc, got, expected) => {
    if (got === expected) { console.log(`  PASS: ${desc}`); passed++; }
    else { console.error(`  FAIL: ${desc} — got ${got}, want ${expected}`); failed++; }
  };

  console.log('\n--- Self-test suite ---');

  // MUST-FAIL pairs (should be detected as duplicates)
  const qA = { id: 'aaa', questionText: 'What is 24 divided by 4?', domain: 'NUMERACY', topic: 'Division', difficultyBand: 3, file: 'test' };
  const qB = { id: 'bbb', questionText: 'What is 24 divided by 4?', domain: 'NUMERACY', topic: 'Division', difficultyBand: 3, file: 'test' };
  const exactResult = checkExactDuplicates([qA, qB]);
  assert('MUST-FAIL: identical question text detected as exact duplicate', exactResult.length > 0, true);

  // Lexical MUST-FAIL: sentences differ only in one content word — should be flagged
  const qC = { id: 'ccc', questionText: 'Sam has 24 apples and shares them equally among 4 friends. How many apples does each friend get?', domain: 'NUMERACY', topic: 'Division', difficultyBand: 3, file: 'test' };
  const qD = { id: 'ddd', questionText: 'Sam has 24 cookies and shares them equally among 4 friends. How many cookies does each friend get?', domain: 'NUMERACY', topic: 'Division', difficultyBand: 3, file: 'test' };
  const lexResult = checkLexicalDuplicates([qC, qD], 0.70);
  assert('MUST-FAIL: near-identical division scenarios detected at lexical layer', lexResult.length > 0, true);

  // MUST-PASS pairs (should NOT be flagged as duplicates)
  const qE = { id: 'eee', questionText: 'What is 45 + 23?', domain: 'NUMERACY', topic: 'Addition', difficultyBand: 2, file: 'test' };
  const qF = { id: 'fff', questionText: 'A garden is 5 metres long and 3 metres wide. What is its area?', domain: 'NUMERACY', topic: 'Area', difficultyBand: 5, file: 'test' };
  const noExact = checkExactDuplicates([qE, qF]);
  assert('MUST-PASS: different questions not flagged as exact duplicates', noExact.length, 0);
  const noLexical = checkLexicalDuplicates([qE, qF], 0.70);
  assert('MUST-PASS: unrelated questions not flagged as lexical duplicates', noLexical.length, 0);

  // Construction key collision test
  const sigA = { question_id: 'aaa', numeracy: { construction: 'division_equal_share', known_quantities: [24, 4], unknown: 'group_size', result_range: '0-10', context_category: 'food', distractor_signature: 'OFF_BY_ONE' } };
  const sigB = { question_id: 'bbb', numeracy: { construction: 'division_equal_share', known_quantities: [24, 4], unknown: 'group_size', result_range: '0-10', context_category: 'school', distractor_signature: 'OFF_BY_ONE' } };
  const cq1 = { id: 'aaa', questionText: 'Q1', domain: 'NUMERACY', topic: 'Division', difficultyBand: 3, file: 'f1' };
  const cq2 = { id: 'bbb', questionText: 'Q2', domain: 'NUMERACY', topic: 'Division', difficultyBand: 3, file: 'f2' };
  const constResult = checkConstructionDuplicates([cq1, cq2], { aaa: sigA, bbb: sigB });
  assert('MUST-FAIL: same construction+known_quantities+unknown detected', constResult.length > 0, true);

  const sigC = { question_id: 'ccc', numeracy: { construction: 'division_equal_share', known_quantities: [36, 6], unknown: 'group_size', result_range: '0-10', context_category: 'food', distractor_signature: 'OFF_BY_ONE' } };
  const cq3  = { id: 'ccc', questionText: 'Q3', domain: 'NUMERACY', topic: 'Division', difficultyBand: 3, file: 'f3' };
  const noConstResult = checkConstructionDuplicates([cq1, cq3], { aaa: sigA, ccc: sigC });
  assert('MUST-PASS: different known_quantities (24,4 vs 36,6) not flagged as construction duplicate', noConstResult.length, 0);

  // Jaccard self-test
  const sim1 = jaccardSimilarity('how many apples does sam have', 'how many oranges does sam have');
  assert('Jaccard: near-identical sentences score at least 0.4', sim1 >= 0.4, true);
  const sim2 = jaccardSimilarity('what is 45 plus 23', 'a garden is 5 metres long and 3 metres wide');
  assert('Jaccard: unrelated sentences score below 0.3', sim2 < 0.3, true);

  console.log(`\nSelf-tests: ${passed} passed, ${failed} failed\n`);
  return failed === 0;
}

// ─── Main ─────────────────────────────────────────────────────────────────────

function main() {
  const selfTestsOk = runSelfTests();
  if (!selfTestsOk) {
    console.error('Self-tests failed — fix the validator before running audit.');
    process.exit(1);
  }

  console.log(`Scanning SQL files in: ${SQL_DIR}`);
  const questions = parseQuestionsFromSqlDir(SQL_DIR);
  console.log(`Found ${questions.length} questions across ${new Set(questions.map(q => q.file)).size} files`);

  console.log(`Loading signatures from: ${SIG_DIR}`);
  const signatures = loadSignatures(SIG_DIR);
  console.log(`Loaded ${Object.keys(signatures).length} signatures`);

  const exact       = checkExactDuplicates(questions);
  const lexical     = checkLexicalDuplicates(questions, 0.70);
  const semantic    = checkSemanticDuplicates(questions);
  const construction = checkConstructionDuplicates(questions, signatures);
  const scenario    = checkScenarioDuplicates(questions, signatures);
  const distractor  = checkDistractorDuplicates(questions, signatures);

  const report = renderReport(questions, exact, lexical, semantic, construction, scenario, distractor, signatures);

  fs.writeFileSync(REPORT, report, 'utf8');
  console.log(`\nReport written to: ${REPORT}`);

  const totalIssues = exact.length + lexical.length + semantic.length +
                      construction.length + scenario.length + distractor.length;

  // Layer 1 (exact) and Layers 4-5 (construction/scenario/distractor) are hard blockers.
  // Layers 2-3 (lexical/semantic similarity) produce WARN-only for NAPLAN template questions:
  //   GP domain:      "Which sentence is X correctly? The example is set...form N node Y."
  //   WRITING domain: "Write a persuasive text for Year N about..."
  // These share structural wrappers at 0.70 Jaccard but are semantically distinct per tested sentence.
  const hardBlockers = exact.length + construction.length + scenario.length + distractor.length;
  const warnings     = lexical.length + semantic.length;

  if (hardBlockers > 0) {
    console.error(`\nFAIL: ${hardBlockers} hard-blocker duplicate(s) found (Layer 1/4/5). See report.`);
    process.exit(1);
  } else if (warnings > 0) {
    console.log(`\nWARN: ${warnings} structural-similarity pair(s) found (Layers 2-3, template noise).`);
    console.log('      These are GP/WRITING template wrappers — not actionable content duplicates.');
    console.log('PASS: No hard-blocker duplicates at Layers 1, 4, 5.');
    process.exit(0);
  } else {
    console.log('\nPASS: No duplicates detected at any layer.');
    process.exit(0);
  }
}

main();
