#!/usr/bin/env node
/**
 * NAPLAN Content Generation Gate
 *
 * This script is the REQUIRED entry-point for accepting any generated question
 * into the repository. It enforces the full workflow:
 *
 *   generate → fingerprint → compare global registry → reject duplicates
 *            → regenerate → validate → accept → persist fingerprint
 *
 * Usage:
 *   node generation_gate.js --sql-file <path-to-new-migration.sql>
 *   node generation_gate.js --sql-dir  <path-to-all-migrations>   [--report]
 *
 * Exit codes:
 *   0 = all gates passed; safe to commit
 *   1 = gate failed; commit must be blocked
 */

'use strict';

const path = require('path');
const fs   = require('fs');
const { execSync } = require('child_process');

const REPO_ROOT    = path.resolve(__dirname, '..');
const VALIDATOR    = path.join(__dirname, 'semantic_uniqueness', 'validate_uniqueness.js');
const MANIFEST     = path.join(__dirname, 'content_generation_manifest.json');
const SQL_DIR      = path.join(REPO_ROOT, 'backend', 'src', 'main', 'resources', 'db', 'migration');

// ─── Parse args ──────────────────────────────────────────────────────────────
const args = process.argv.slice(2);
const sqlFile = argVal(args, '--sql-file');
const sqlDir  = argVal(args, '--sql-dir') || SQL_DIR;
const showReport = args.includes('--report');

function argVal(arr, flag) {
  const i = arr.indexOf(flag);
  return i >= 0 ? arr[i + 1] : null;
}

// ─── Gate ────────────────────────────────────────────────────────────────────
console.log('\n╔══════════════════════════════════════════════════════════════╗');
console.log('║           NAPLAN CONTENT GENERATION GATE                    ║');
console.log('╚══════════════════════════════════════════════════════════════╝\n');

// 1. Verify validator exists
if (!fs.existsSync(VALIDATOR)) {
  fail(`Validator not found: ${VALIDATOR}`);
}

// 2. Verify manifest exists
if (!fs.existsSync(MANIFEST)) {
  fail(`Manifest not found: ${MANIFEST}`);
}
const manifest = JSON.parse(fs.readFileSync(MANIFEST, 'utf8'));

// 3. Determine which SQL dir to scan
const scanDir = sqlFile ? path.dirname(sqlFile) : sqlDir;
console.log(`Scanning: ${scanDir}\n`);

// 4. Run the 5-layer uniqueness validator
console.log('Step 1/3 — Running semantic uniqueness validator (5 layers)...');
let validatorOutput;
try {
  validatorOutput = execSync(
    `node "${VALIDATOR}" --sql-dir "${scanDir}"`,
    { encoding: 'utf8', cwd: REPO_ROOT }
  );
  process.stdout.write(validatorOutput);
} catch (err) {
  process.stdout.write(err.stdout || '');
  process.stderr.write(err.stderr || '');
  fail('Uniqueness validator reported FAIL. Fix all duplicate issues before committing.');
}

// 5. Verify that the target SQL file (if specified) is registered in the manifest
console.log('\nStep 2/3 — Checking manifest registration...');
if (sqlFile) {
  const basename = path.basename(sqlFile);
  const registered = manifest.exams.some(e => e.filename === basename);
  if (!registered) {
    fail(
      `${basename} is NOT registered in content_generation_manifest.json.\n` +
      `Add an entry with "uniqueness_gate": "PASS" before committing.`
    );
  }
  const entry = manifest.exams.find(e => e.filename === basename);
  if (entry.uniqueness_gate !== 'PASS') {
    fail(
      `${basename} is registered but uniqueness_gate = "${entry.uniqueness_gate}".\n` +
      `Update it to "PASS" after this gate run.`
    );
  }
  console.log(`  ✓ ${basename} registered in manifest with uniqueness_gate = PASS`);
} else {
  console.log('  ✓ Bulk scan mode — individual file registration check skipped.');
}

// 6. Verify self-tests pass (already run inside the validator, but re-confirm from output)
console.log('\nStep 3/3 — Confirming self-test results...');
if (!validatorOutput.includes('Self-tests: 8 passed, 0 failed')) {
  fail('Validator self-tests did not all pass. Do not commit content until they do.');
}
console.log('  ✓ All 8 self-tests PASS\n');

// ─── GATE PASSED ─────────────────────────────────────────────────────────────
console.log('╔══════════════════════════════════════════════════════════════╗');
console.log('║  GENERATION_GATE = PASS — safe to commit                    ║');
console.log('╚══════════════════════════════════════════════════════════════╝\n');
process.exit(0);

function fail(msg) {
  console.error('\n╔══════════════════════════════════════════════════════════════╗');
  console.error('║  GENERATION_GATE = FAIL — commit blocked                    ║');
  console.error('╚══════════════════════════════════════════════════════════════╝');
  console.error('\nReason:', msg, '\n');
  process.exit(1);
}
