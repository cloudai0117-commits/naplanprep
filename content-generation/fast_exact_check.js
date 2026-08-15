#!/usr/bin/env node
/**
 * Fast Layer-1 exact-duplicate check.
 * Handles SQL-escaped apostrophes ('' → ') correctly.
 */
'use strict';
const fs = require('fs');
const path = require('path');

const dir = process.argv[2] || process.cwd();

function normalise(t) {
  return t.toLowerCase()
    .replace(/×|✕|\*/g,' times ').replace(/÷|\//g,' div ')
    .replace(/\+/g,' plus ').replace(/−|–/g,' minus ')
    .replace(/[^a-z0-9\s]/g,'').replace(/\s+/g,' ').trim();
}

/** Depth-tracking extractor — handles '' escapes in SQL strings */
function extractTuple(str) {
  let depth=0, start=-1, i=0;
  while (i < str.length) {
    const ch = str[i];
    if (ch === "'") {
      i++;
      while (i < str.length) {
        if (str[i]==="'" && str[i+1]==="'") { i+=2; continue; }
        if (str[i]==="'") { i++; break; }
        i++;
      }
      continue;
    }
    if (ch==='(') { if(depth===0) start=i; depth++; }
    else if (ch===')') {
      depth--;
      if (depth===0 && start!==-1) return str.slice(start+1, i);
    } else if (ch===';' && depth===0) break;
    i++;
  }
  return '';
}

/**
 * Extract all SQL single-quoted string values from a tuple,
 * resolving '' → ' escapes. Returns array of strings in order.
 */
function extractStrings(tuple) {
  const strings = [];
  let i = 0;
  while (i < tuple.length) {
    if (tuple[i] === "'") {
      i++;
      let s = '';
      while (i < tuple.length) {
        if (tuple[i]==="'" && tuple[i+1]==="'") { s += "'"; i+=2; continue; }
        if (tuple[i]==="'") { i++; break; }
        s += tuple[i++];
      }
      strings.push(s);
    } else {
      i++;
    }
  }
  return strings;
}

const files = fs.readdirSync(dir)
  .filter(f => /^V(\d+)__/.test(f) && parseInt(f.match(/^V(\d+)/)[1],10) >= 54)
  .sort();

console.log(`Scanning ${files.length} files in ${dir}`);

const seen = new Map();
const exact = [];
let total = 0, parsed = 0;

for (const file of files) {
  const content = fs.readFileSync(path.join(dir, file), 'utf8');
  const re = /INSERT\s+INTO\s+questions\s*\([^)]+\)\s*VALUES\s*/gi;
  let m;
  while ((m = re.exec(content)) !== null) {
    total++;
    const after = content.slice(m.index + m[0].length);
    const tuple = extractTuple(after);
    if (!tuple) continue;

    // Extract first UUID (any version)
    const idM = tuple.match(/'([a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12})'/i);
    if (!idM) continue;
    const id = idM[1];

    // Extract all string values from the tuple
    const strings = extractStrings(tuple);

    // question_text: the string immediately before the '[{' JSON array
    // Find the index where '[{' or '[{' appears in the raw tuple
    let qText = '';
    // Find position of JSON array start '[{' or '["' or '[]' in the raw tuple
    const jsonStart = tuple.search(/'[\[{]/);
    if (jsonStart > 0) {
      // Find the last string end before jsonStart
      // Re-parse just the prefix up to jsonStart
      const prefix = tuple.slice(0, jsonStart);
      const prefixStrings = extractStrings(prefix);
      // The question_text should be the last meaningful string
      // Filter out known enum values and short non-text strings
      const KNOWN_ENUMS = new Set([
        'MULTIPLE_CHOICE','SHORT_ANSWER','EXTENDED_RESPONSE',
        'NUMERACY','READING','WRITING','SPELLING','GRAMMAR_PUNCTUATION',
        'FREE','ADVANCED','PREMIUM','PUBLISHED','DRAFT','ARCHIVED',
        'EASY','MEDIUM','HARD','MEDIUM_HARD',
        'RECALL','COMPREHENSION','ANALYSIS','APPLICATION','Comprehension','Application','Recall',
        'Number and Algebra','Measurement and Geometry','Statistics and Probability',
        'Number and place value','Addition and subtraction','Multiplication and division',
        'Fractions and decimals','Measurement','Shape and location','Statistics and data',
        'Chance and probability','Language conventions','None',
      ]);
      for (let k = prefixStrings.length - 1; k >= 0; k--) {
        const s = prefixStrings[k];
        if (s.length >= 5 && !KNOWN_ENUMS.has(s) && !(/^[A-Z_]+$/.test(s)) && !/^[0-9]+$/.test(s)) {
          qText = s;
          break;
        }
      }
    }

    if (!qText || qText.length < 5) continue;
    parsed++;

    const key = normalise(qText);
    if (seen.has(key)) {
      const prev = seen.get(key);
      exact.push({ a: prev, b: {file, id, raw:qText} });
    } else {
      seen.set(key, {file, id, raw:qText});
    }
  }
}

console.log(`Parsed ${parsed}/${total} questions`);
console.log(`\n=== EXACT DUPLICATES: ${exact.length} ===`);

if (exact.length === 0) {
  console.log('LAYER 1: PASS — no exact duplicates');
} else {
  // Group by domain (infer from filename)
  const byDomain = {};
  for (const d of exact) {
    const dm = d.b.file.match(/_(num|read|writ|gp|spell)_/);
    const dom = dm ? dm[1].toUpperCase() : 'OTHER';
    byDomain[dom] = (byDomain[dom] || 0) + 1;
  }
  console.log('By domain:');
  for (const [dom, cnt] of Object.entries(byDomain).sort((a,b)=>b[1]-a[1])) {
    console.log(`  ${dom}: ${cnt}`);
  }
  console.log('\nFirst 10 duplicate pairs:');
  for (const d of exact.slice(0,10)) {
    console.log(`  A: ${d.a.file} [${d.a.id.substring(0,8)}...]`);
    console.log(`     "${d.a.raw.substring(0,100)}"`);
    console.log(`  B: ${d.b.file} [${d.b.id.substring(0,8)}...]`);
    console.log('');
  }
  if (exact.length > 10) console.log(`  ... and ${exact.length - 10} more`);
}
