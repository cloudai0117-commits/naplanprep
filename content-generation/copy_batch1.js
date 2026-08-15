#!/usr/bin/env node
/**
 * Option A: Copy download V57-V213 → repo V58-V214
 * download Vn__ → repo V(n+1)__  (shift +1)
 * Content is preserved exactly. Only the Flyway filename prefix changes.
 *
 * Run with --dry-run to preview; omit to execute.
 */
'use strict';
const fs   = require('fs');
const path = require('path');
const crypto = require('crypto');

const DL_DIR   = 'C:/Users/PC/Downloads/NAPLANPrep_Batch1_V54_V213/flyway';
const REPO_DIR = 'C:/Badal/Apps/Naplan/naplanprep/backend/src/main/resources/db/migration';
const DRY_RUN  = process.argv.includes('--dry-run');

if (DRY_RUN) console.log('=== DRY RUN — no files will be written ===\n');

// Build list of download files V57-V213 sorted by version number
const dlFiles = fs.readdirSync(DL_DIR)
  .filter(f => {
    const m = f.match(/^V(\d+)__/);
    if (!m) return false;
    const v = parseInt(m[1], 10);
    return v >= 57 && v <= 213;
  })
  .sort((a, b) => {
    const va = parseInt(a.match(/^V(\d+)/)[1], 10);
    const vb = parseInt(b.match(/^V(\d+)/)[1], 10);
    return va - vb;
  });

// Pre-flight: exactly 157 files expected
if (dlFiles.length !== 157) {
  console.error(`ABORT: Expected 157 download files (V57-V213), found ${dlFiles.length}`);
  process.exit(1);
}

// Build mapping and run conflict check
const mapping = [];
for (const f of dlFiles) {
  const dlVer  = parseInt(f.match(/^V(\d+)/)[1], 10);
  const desc   = f.replace(/^V\d+__/, '');
  const newVer = dlVer + 1;  // shift +1
  const newName = `V${newVer}__${desc}`;

  const srcPath  = path.join(DL_DIR, f);
  const destPath = path.join(REPO_DIR, newName);

  if (fs.existsSync(destPath)) {
    console.error(`ABORT: Target already exists: ${newName}`);
    process.exit(1);
  }

  mapping.push({ dlVer, newVer, f, newName, srcPath, destPath });
}

// Verify target range is exactly V58-V214
const firstTarget = mapping[0].newVer;
const lastTarget  = mapping[mapping.length - 1].newVer;
if (firstTarget !== 58 || lastTarget !== 214) {
  console.error(`ABORT: Expected target range V58-V214, got V${firstTarget}-V${lastTarget}`);
  process.exit(1);
}

console.log(`Files to copy: ${mapping.length}`);
console.log(`Source range:  download V${mapping[0].dlVer} – V${mapping[mapping.length-1].dlVer}`);
console.log(`Target range:  repo     V${firstTarget} – V${lastTarget}`);
console.log(`\nFirst 5 mappings:`);
for (const m of mapping.slice(0, 5)) {
  console.log(`  dl V${m.dlVer}__${m.f.replace(/^V\d+__/,'')} → repo ${m.newName}`);
}
console.log('  ...');
console.log(`Last 5 mappings:`);
for (const m of mapping.slice(-5)) {
  console.log(`  dl V${m.dlVer}__${m.f.replace(/^V\d+__/,'')} → repo ${m.newName}`);
}

if (DRY_RUN) {
  console.log('\nDRY RUN complete. Re-run without --dry-run to execute.');
  process.exit(0);
}

// Execute copy
console.log('\nCopying files...');
let copied = 0;
let totalBytes = 0;
for (const m of mapping) {
  const src = fs.readFileSync(m.srcPath);
  fs.writeFileSync(m.destPath, src);
  copied++;
  totalBytes += src.length;
  if (copied % 20 === 0 || copied === mapping.length) {
    process.stdout.write(`\r  ${copied}/${mapping.length} files copied`);
  }
}
console.log(`\n\nCopy complete: ${copied} files, ${(totalBytes/1024/1024).toFixed(1)} MB`);

// Verify: count target files in repo
const repoAfter = fs.readdirSync(REPO_DIR).filter(f => {
  const m2 = f.match(/^V(\d+)__/);
  if (!m2) return false;
  const v = parseInt(m2[1], 10);
  return v >= 58 && v <= 214;
});
console.log(`Repo V58-V214 count: ${repoAfter.length} (expected 157)`);
if (repoAfter.length !== 157) {
  console.error('ERROR: File count mismatch after copy!');
  process.exit(1);
}

// Spot-check: verify first and last file content matches source
const first = mapping[0];
const last  = mapping[mapping.length - 1];
const h1src  = crypto.createHash('sha256').update(fs.readFileSync(first.srcPath)).digest('hex');
const h1dest = crypto.createHash('sha256').update(fs.readFileSync(first.destPath)).digest('hex');
const h2src  = crypto.createHash('sha256').update(fs.readFileSync(last.srcPath)).digest('hex');
const h2dest = crypto.createHash('sha256').update(fs.readFileSync(last.destPath)).digest('hex');
const hash1ok = h1src === h1dest;
const hash2ok = h2src === h2dest;
console.log(`Content integrity (first file): ${hash1ok ? 'PASS' : 'FAIL'}`);
console.log(`Content integrity (last file):  ${hash2ok ? 'PASS' : 'FAIL'}`);

if (!hash1ok || !hash2ok) {
  console.error('ERROR: Content integrity check failed!');
  process.exit(1);
}

console.log('\n=== COPY COMPLETE ===');
console.log('All 157 files copied with content integrity verified.');
