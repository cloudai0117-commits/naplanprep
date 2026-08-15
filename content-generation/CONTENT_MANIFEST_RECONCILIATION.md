# CONTENT MANIFEST RECONCILIATION

**Audit Date:** 2026-08-14  
**Manifest File:** `content_generation_manifest.json`  
**Scope:** Reconcile manifest metadata against actual SQL files on disk

---

## 1. Batch-Level Status Reconciliation

| Batch | Manifest Status | Manifest exams_generated | Actual Files on Disk | Reconciled? |
|---|---|---|---|---|
| BATCH_1 | COMPLETE | 160 | 161 (includes 1 extra) | PARTIAL MISMATCH — manifest says 160, disk has 161 |
| BATCH_2 | NOT_STARTED | 0 | 160 | MISMATCH — manifest stale, 160 files exist |

**Finding ERR-P0-004:** Manifest BATCH_2 has never been updated after file generation. The manifest records BATCH_2 as "NOT_STARTED" despite 160 complete SQL files covering all Year 7 and Year 9 content being present on disk. Any CI/CD pipeline or deployment gate that reads this manifest will falsely conclude Batch 2 is ungenerated.

---

## 2. Canonical Exam UUID Reconciliation (V54–V56)

The manifest stores placeholder-pattern UUIDs for the three canonical exams created before the DDL migration:

| Exam Slot | Manifest UUID | Actual SQL UUID | Match? |
|---|---|---|---|
| V54 (Y3 Num Free 01) | a0000054-0000-4000-a000-000000000001 | fcd31c21-9680-5cd3-b56a-522b4ad8f762 | MISMATCH |
| V55 (Y3 Num Adv 01) | a0000055-0000-4000-a000-000000000001 (expected) | Not inspected (file exists) | LIKELY MISMATCH |
| V56 (Y3 Num Adv 02) | a0000056-0000-4000-a000-000000000001 (expected) | Not inspected (file exists) | LIKELY MISMATCH |

**Finding ERR-P1-003:** The manifest canonical exam UUIDs are placeholders, not the real UUIDs from the SQL files. UUID-based lookups against the manifest for these three exams will fail.

---

## 3. Manifest Filename Field Reconciliation (Batch 1 Shifted Content)

The manifest records filenames using **REPO version numbers**, but Batch 1 files are named with **DOWNLOAD version numbers**.

| Exam Slot | Manifest Filename | Actual File on Disk | Download → Repo Shift |
|---|---|---|---|
| Y3 Num Adv 03 | V58__seed_y3_num_advanced_exam03.sql | V57__seed_y3_num_advanced_exam03.sql | +1 ✓ (but filename in manifest uses repo V) |
| Y3 Writ Free 01 | V87__seed_y3_writ_free_exam01.sql | V86__seed_y3_writ_free_exam01.sql | +1 ✓ |

**Finding ERR-P1-004:** All 157 Batch 1 shifted entries have mismatched `filename` fields. The manifest records repo-version filenames, but actual Batch 1 files use download-version filenames. Searching the filesystem using manifest filenames will fail for 157 of 160 Batch 1 entries.

**Correctly recorded filenames:** Only V54, V55, V56 (canonical, no shift) have matching filenames.

---

## 4. Manifest Exam UUID Reconciliation (Batch 1 Shifted — Sample)

For Batch 1 exams from exam 4 onwards (download V57 content and later), the manifest does record actual UUIDs (not placeholders). Spot-checked against actual files:

| Exam Slot | Manifest UUID | Actual File UUID | Match? |
|---|---|---|---|
| Y3 Num Adv 03 (exam 4) | af57a3dc-8acf-5b3c-8911-f94bd0345c5c | af57a3dc-8acf-5b3c-8911-f94bd0345c5c | MATCH ✓ |
| Y3 Writ Free 01 (exam 33) | fe04607c-bb7c-5117-98d0-a12c9b2e1455 | fe04607c-bb7c-5117-98d0-a12c9b2e1455 | MATCH ✓ |

**Verdict:** Manifest exam UUIDs for Batch 1 shifted content (exams 4–160) appear to be correctly recorded. Only the three canonical exam UUIDs (exams 1–3) are mismatched.

---

## 5. Batch 2 Exam UUID Reconciliation

Manifest records `BATCH_2.exams_generated = 0`, meaning no Batch 2 exam UUIDs are in the manifest. No reconciliation is possible until the manifest is updated.

| Batch 2 File | Exam UUID (from file) | Manifest UUID | Match? |
|---|---|---|---|
| V215 (Y7 Num Free 01) | b8acc2ff-c86a-558f-b189-e4c6a77e72f0 | Not in manifest | N/A |
| V247 (Y7 Writ Free 01) | 6ce1b770-17f8-5bc5-b7be-d6b76ba1f869 | Not in manifest | N/A |
| V279 (Y7 Spell Free 01) | 17681ece-5095-5d7c-9250-20e5741a6fd9 | Not in manifest | N/A |
| V311 (Y9 Read Free 01) | d0e3cbb4-ca46-5299-a123-e0269c5eade3 | Not in manifest | N/A |
| V374 (Y9 Spell Prem 10) | 4f16940f-d2c5-51fa-97f7-28389ba49f19 | Not in manifest | N/A |

---

## 6. Global Uniqueness Ledger (Manifest)

The manifest records a `global_uniqueness_ledger` with:
- `question_uuid_collisions: 0` (for Batch 1 only)
- `semantic_fingerprint_collisions: 0` (Batch 1)
- `scenario_fingerprint_collisions: 0` (Batch 1)

This ledger covers only Batch 1. Batch 2 uniqueness has not been formally recorded in the manifest. The files themselves show no structural problems with Batch 2 question UUIDs (based on sampling), but the manifest's own gate has not been run for Batch 2.

---

## 7. Extra File (V214) Manifest Status

The extra file `V214__seed_y5_spell_premium_exam10.sql` with exam UUID `153771b7-bd0c-55f1-86c9-1a685fb3cd13` is not referenced in the manifest at all. The manifest records exam 160 (Y5 Spell Prem 10) as a single entry with the V213 UUID (`2b21f7e5-3f80-5329-bcf9-bc07605133a4`), not the V214 UUID. The V214 extra file appears to have been generated outside the manifest-tracked generation process.

---

## Summary

| Reconciliation Check | Verdict |
|---|---|
| BATCH_1 status (COMPLETE) matches file count (160) | FAIL — 161 files on disk |
| BATCH_2 status (COMPLETE) — 160 files exist | FAIL — manifest shows NOT_STARTED |
| Canonical exam UUIDs (V54–V56) | FAIL — manifest has placeholders |
| Batch 1 shifted exam UUIDs (exams 4–160, sampled) | PASS — match confirmed |
| Batch 1 filename fields | FAIL — repo versions in manifest, download versions on disk |
| Batch 2 exam UUIDs | N/A — not in manifest |
| Extra V214 file in manifest | ABSENT — not tracked |

**Overall Manifest Reconciliation: FAIL** — 4 reconciliation failures; manifest cannot serve as reliable deployment source of truth in current state.
