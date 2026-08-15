#!/usr/bin/env node
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

const files = fs.readdirSync(dir)
  .filter(f => /^V(\d+)__/.test(f) && parseInt(f.match(/^V(\d+)/)[1],10) >= 54)
  .sort();

const seen = new Map();
const exact = [];
let total = 0;

for (const file of files) {
  const content = fs.readFileSync(path.join(dir, file), 'utf8');
  const domainM = content.match(/'(NUMERACY|READING|WRITING|GRAMMAR_PUNCTUATION|SPELLING)'/);
  const domain = domainM ? domainM[1] : 'UNKNOWN';

  const re = /INSERT\s+INTO\s+questions\s*\([^)]+\)\s*VALUES\s*/gi;
  let m;
  while ((m = re.exec(content)) !== null) {
    total++;
    const after = content.slice(m.index + m[0].length);
    let depth=0, start=-1, i=0, tuple='';
    while (i < after.length) {
      const ch = after[i];
      if (ch === "'") {
        i++;
        while (i < after.length) {
          if (after[i]==="'" && after[i+1]==="'") { i+=2; continue; }
          if (after[i]==="'") { i++; break; }
          i++;
        }
        continue;
      }
      if (ch==='(') { if(depth===0) start=i; depth++; }
      else if (ch===')') { depth--; if(depth===0 && start!==-1){ tuple=after.slice(start+1,i); break; } }
      else if (ch===';' && depth===0) break;
      i++;
    }
    if (!tuple) continue;

    const idM = tuple.match(/'([a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12})'/i);
    if (!idM) continue;
    const id = idM[1];

    const qtM = tuple.match(/'([^']{5,})'\s*,\s*'[\[{]/);
    const qText = qtM ? qtM[1] : '';
    if (!qText || qText.length < 5) continue;

    const key = normalise(qText);
    if (seen.has(key)) {
      exact.push({ domain, file, id, text: qText.substring(0,120) });
    } else {
      seen.set(key, { domain, file, id, text: qText.substring(0,120) });
    }
  }
}

// Group by domain
const byDomain = {};
for (const d of exact) {
  byDomain[d.domain] = (byDomain[d.domain] || 0) + 1;
}

// Group by exact text
const byText = {};
for (const d of exact) {
  const k = d.text.substring(0,80);
  byText[k] = (byText[k] || 0) + 1;
}

console.log('=== EXACT DUPLICATES BY DOMAIN ===');
for (const [dom, cnt] of Object.entries(byDomain).sort((a,b) => b[1]-a[1])) {
  console.log(`  ${dom}: ${cnt} duplicates`);
}

console.log('\n=== TOP 10 REPEATED QUESTION TEXTS ===');
const topTexts = Object.entries(byText).sort((a,b) => b[1]-a[1]).slice(0,10);
for (const [text, cnt] of topTexts) {
  console.log(`  [${cnt}x] "${text}"`);
}

console.log(`\nTotal: ${exact.length} duplicate instances from ${total} questions`);
