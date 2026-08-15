#!/usr/bin/env node
/**
 * Spelling-specific uniqueness check.
 * NAPLAN spelling has three question sub-types:
 *   AUDIO_RESPONSE:     options=NULL,    correct_answer={"value":"word"} — word IS the target
 *   MCQ Proofreading:   options=[4 spellings],  correct_answer={"value":"A"} — look up correct option text
 *   MCQ Yes/No:         options=[Yes,No], correct_answer={"value":"A"|"B"} — word is in question_text
 */
'use strict';
const fs = require('fs');
const path = require('path');

const dir = process.argv[2] || process.cwd();
const Q = "'";   // single-quote shorthand

function extractTuple(str) {
  let depth=0, start=-1, i=0;
  while (i < str.length) {
    const ch = str[i];
    if (ch===Q) { i++; while(i<str.length){if(str[i]===Q&&str[i+1]===Q){i+=2;continue;}if(str[i]===Q){i++;break;}i++;} continue; }
    if (ch==='(') { if(depth===0) start=i; depth++; }
    else if (ch===')') { depth--; if(depth===0&&start!==-1) return str.slice(start+1,i); }
    else if (ch===';'&&depth===0) break;
    i++;
  }
  return '';
}

/** Extract SQL single-quoted strings in order, resolving '' escapes */
function extractStrings(str) {
  const result = [];
  let i=0;
  while (i<str.length) {
    if (str[i]===Q) {
      i++;
      let s='';
      while(i<str.length){
        if(str[i]===Q&&str[i+1]===Q){s+=Q;i+=2;continue;}
        if(str[i]===Q){i++;break;}
        s+=str[i++];
      }
      result.push(s);
    } else { i++; }
  }
  return result;
}

/** From JSON array string, find option text for given label */
function optionText(jsonArr, label) {
  try {
    const arr = JSON.parse(jsonArr);
    if (!Array.isArray(arr)) return null;
    const opt = arr.find(o => (o.label||'').toUpperCase()===(label||'').toUpperCase());
    return opt ? (opt.text||opt.value||null) : null;
  } catch {
    const re = new RegExp(`"label"\\s*:\\s*"${label}"[^}]*?"text"\\s*:\\s*"([^"]+)"`,'i');
    const m = jsonArr.match(re);
    return m ? m[1] : null;
  }
}

/** From question_text (with '' already unescaped to '), extract the quoted word */
function wordFromQuestionText(qText) {
  // Look for 'word' pattern (single quotes around a word)
  const m = qText.match(/'([a-zA-Z]+)'/);
  return m ? m[1].toLowerCase() : null;
}

const KNOWN_ENUMS = new Set([
  'MULTIPLE_CHOICE','AUDIO_RESPONSE','SHORT_ANSWER','EXTENDED_RESPONSE',
  'NUMERACY','READING','WRITING','SPELLING','GRAMMAR_PUNCTUATION',
  'FREE','ADVANCED','PREMIUM','PUBLISHED','DRAFT','ARCHIVED',
  'EASY','MEDIUM','HARD','MEDIUM_HARD',
  'RECALL','COMPREHENSION','ANALYSIS','APPLICATION',
  'Number and Algebra','Measurement and Geometry','Statistics and Probability',
  'Language conventions','Language – spelling','Audio dictation',
  'Proofreading and spelling','None',
]);

const files = fs.readdirSync(dir)
  .filter(f => /spell/i.test(f) && /^V(\d+)__/.test(f) && parseInt(f.match(/^V(\d+)/)[1],10)>=54)
  .sort();

console.log(`Scanning ${files.length} spelling files`);

const seenWords = new Map();
const duplicateWords = [];
const skipped = [];
let total=0, parsed=0;
let audioCount=0, mcqPfCount=0, mcqYnCount=0;

for (const file of files) {
  const content = fs.readFileSync(path.join(dir, file), 'utf8');
  const re = /INSERT\s+INTO\s+questions\s*\([^)]+\)\s*VALUES\s*/gi;
  let m;
  while ((m=re.exec(content))!==null) {
    total++;
    const after = content.slice(m.index+m[0].length);
    const tuple = extractTuple(after);
    if (!tuple) continue;

    const idM = tuple.match(/'([a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12})'/i);
    if (!idM) continue;
    const id = idM[1];

    const isAudio = tuple.includes(Q+'AUDIO_RESPONSE'+Q);
    const isMCQ   = tuple.includes(Q+'MULTIPLE_CHOICE'+Q);

    // Extract all strings from the tuple (with '' unescaping)
    const allStrings = extractStrings(tuple);

    // Find question_text: last non-enum, non-trivial string before the first [ or {
    const jsonStart = tuple.search(/'[\[{]/);
    const prefixStrings = jsonStart>0 ? extractStrings(tuple.slice(0, jsonStart)) : allStrings;
    let qText = '';
    for (let k=prefixStrings.length-1; k>=0; k--) {
      const s = prefixStrings[k];
      if (s.length>=5 && !KNOWN_ENUMS.has(s) && !/^[A-Z_]+$/.test(s) && !/^[0-9]+$/.test(s)) {
        qText = s; break;
      }
    }

    // Extract JSONB array blocks (options) and object blocks (correct_answer)
    const objBlocks  = [...tuple.matchAll(/'(\{[^']*\})'::jsonb/gi)];
    const arrBlocks  = [...tuple.matchAll(/'(\[[^\]]*\])'::jsonb/gi)];

    let targetWord = null;

    if (isAudio) {
      audioCount++;
      // correct_answer.value IS the target word
      if (objBlocks.length>0) {
        const ca = objBlocks[objBlocks.length-1][1];
        const vm = ca.match(/"value"\s*:\s*"([^"]+)"/);
        targetWord = vm ? vm[1].toLowerCase().trim() : null;
      }
    } else if (isMCQ) {
      const optionsJson = arrBlocks.length>0 ? arrBlocks[0][1] : null;
      const caJson      = objBlocks.length>0  ? objBlocks[objBlocks.length-1][1] : null;

      let correctLabel = null;
      if (caJson) {
        const vm = caJson.match(/"value"\s*:\s*"([^"]+)"/);
        correctLabel = vm ? vm[1] : null;
      }

      let correctText = null;
      if (optionsJson && correctLabel) {
        correctText = optionText(optionsJson, correctLabel);
      }

      if (correctText && !['yes','no','Yes','No'].includes(correctText)) {
        // Proofreading type: correct option text IS the target word
        mcqPfCount++;
        targetWord = correctText.toLowerCase().trim();
      } else {
        // Yes/No type: target word is in question_text
        mcqYnCount++;
        if (qText) targetWord = wordFromQuestionText(qText);
      }
    } else {
      skipped.push({ file, id: id.substring(0,8), reason: 'unknown question type' });
      continue;
    }

    if (!targetWord || targetWord.length<1) {
      skipped.push({ file, id: id.substring(0,8), reason: `no target extracted (audio=${isAudio},mcq=${isMCQ},qText="${qText.substring(0,60)}")` });
      continue;
    }

    parsed++;
    if (seenWords.has(targetWord)) {
      const prev = seenWords.get(targetWord);
      duplicateWords.push({ word: targetWord, a: prev, b: { file: path.basename(file), id: id.substring(0,8) } });
    } else {
      seenWords.set(targetWord, { file: path.basename(file), id: id.substring(0,8) });
    }
  }
}

console.log(`\nParsed: ${parsed}/${total} (audio=${audioCount}, mcq-proofreading=${mcqPfCount}, mcq-yes/no=${mcqYnCount})`);
if (skipped.length>0) {
  console.log(`\nSkipped (${skipped.length}):`);
  for (const s of skipped.slice(0,5)) console.log(`  ${path.basename(s.file)} [${s.id}]: ${s.reason}`);
  if (skipped.length>5) console.log(`  ...and ${skipped.length-5} more`);
}

console.log(`\n=== SPELLING DUPLICATE TARGET WORDS: ${duplicateWords.length} ===`);
if (duplicateWords.length===0) {
  console.log('SPELLING UNIQUENESS: PASS — all target words unique across all 32 spelling files');
} else {
  const byWord={};
  for (const d of duplicateWords) byWord[d.word]=(byWord[d.word]||0)+1;
  const top = Object.entries(byWord).sort((a,b)=>b[1]-a[1]).slice(0,15);
  console.log('Top repeated target words:');
  for (const [w,c] of top) console.log(`  "${w}": ${c+1} occurrences`);
  console.log(`\nFirst 10 pairs:`);
  for (const d of duplicateWords.slice(0,10)) {
    console.log(`  "${d.word}": ${d.a.file} vs ${d.b.file}`);
  }
  if (duplicateWords.length>10) console.log(`  ...and ${duplicateWords.length-10} more`);
}

console.log(`\nUnique target words: ${seenWords.size}`);
const sample=[...seenWords.keys()].slice(0,20);
console.log(`Sample: ${sample.join(', ')}`);
