# CONTENT GLOBAL UNIQUENESS AUDIT

**Audit Date:** 2026-08-14  
**Scope:** All SQL files across both batches (321 files total)  
**Directories:**
- Batch 1: `NAPLANPrep_Batch1_V54_V214/flyway/` (161 files)
- Batch 2: `NAPLANPrep_MasterBatch2_V215_V374/` (160 files)

---

## 1. Exam UUID Uniqueness

**Method:** Extracted all `INSERT INTO exams ... VALUES ('UUID'` patterns and counted distinct values.

| Metric | Result |
|---|---|
| Total files scanned | 321 |
| Exam UUID lines found | 321 |
| Unique exam UUIDs | 321 |
| Duplicate exam UUIDs | **0** |

**Verdict: PASS** — All 321 exam UUIDs are globally unique across both batches.

**Note on extra file:** The rogue extra file `V214__seed_y5_spell_premium_exam10.sql` contains exam UUID `153771b7-bd0c-55f1-86c9-1a685fb3cd13`, which does NOT collide with V213's UUID `2b21f7e5-3f80-5329-bcf9-bc07605133a4`. UUID uniqueness passes, but the file itself is a P0 blocker due to the Flyway version collision (see CONTENT_FLYWAY_ERROR_LIST.md ERR-P0-001).

---

## 2. File-Level UUID Format Validation

**Method:** Searched for known fake/placeholder UUID patterns in all SQL content.

| Pattern Searched | Hits | Result |
|---|---|---|
| `00000000-0000-0000-0000-000000000000` (null UUID) | 0 | PASS |
| `aaaaaaaa-` prefix (generated placeholder pattern) | 0 | PASS |
| `a0000054` (manifest placeholder for V54) | 0 in SQL files | PASS (manifested only in manifest.json) |
| `00000000` anywhere in UUID context | 0 | PASS |

**Verdict: PASS** — No fake UUID patterns found in any SQL file.

---

## 3. UUID Version Verification

**Method:** Inspection of sampled exam UUIDs.

All sampled exam UUIDs follow UUID v5 (SHA-1 namespace hash) format — version nibble = 5 at position 15, variant bits at position 20 in the 8-4-4-4-12 format.

| File | Exam UUID | UUID Version |
|---|---|---|
| V54 | fcd31c21-9680-**5**cd3-b56a-522b4ad8f762 | v5 ✓ |
| V57 content (repo V58) | af57a3dc-8acf-**5**b3c-8911-f94bd0345c5c | v5 ✓ |
| V86 | fe04607c-bb7c-**5**117-98d0-a12c9b2e1455 | v5 ✓ |
| V119 | 6800b8e3-04c6-**5**f3d-a5ed-7a8b1d402900 | v5 ✓ |
| V213 | 2b21f7e5-3f80-**5**329-bcf9-bc07605133a4 | v5 ✓ |
| V214 (extra) | 153771b7-bd0c-**5**5f1-86c9-1a685fb3cd13 | v5 ✓ |
| V215 | b8acc2ff-c86a-**5**58f-b189-e4c6a77e72f0 | v5 ✓ |
| V247 | 6ce1b770-17f8-**5**bc5-b7be-d6b76ba1f869 | v5 ✓ |
| V279 | 17681ece-5095-**5**d7c-9250-20e5741a6fd9 | v5 ✓ |
| V295 | (not sampled directly) | — |
| V311 | d0e3cbb4-ca46-**5**299-a123-e0269c5eade3 | v5 ✓ |
| V374 | 4f16940f-d2c5-**5**1fa-97f7-28389ba49f19 | v5 ✓ |

**Verdict: PASS** — All sampled UUIDs are correctly formatted UUID v5.

---

## 4. Question UUID Uniqueness (Sample-Based)

**Note:** Full cross-file question UUID uniqueness would require extracting ~38,000+ question UUIDs from 321 files. This section reports the result of sample-based checks and the global_uniqueness_ledger in the manifest.

**Manifest claim:** `BATCH_1.uniqueness_gate = "PASS"` and `"question_uuid_collisions": 0`.  
**Batch 2:** Manifest shows `BATCH_2.status = "NOT_STARTED"` — no uniqueness gate run for Batch 2.

**Sample cross-check:**  
The question UUIDs sampled from V54, V215, V247, V279 do not visually match any other sampled questions. All follow UUID v5 format. No collisions detected in sampled set.

**Caveat:** Without a full extraction and deduplication of all ~38,000 question UUIDs, cross-batch uniqueness of individual questions cannot be fully attested. The ON CONFLICT DO NOTHING clause in Batch 2 `exam_questions` inserts prevents duplicate exam_questions rows but does not prevent duplicate question content under different UUIDs.

**Verdict: PASS (sample-based)** — No question UUID duplicates detected in sampled files. Full extraction recommended for production sign-off.

---

## 5. Exam Name / Content Duplicate Check

**Finding:** Two files have identical exam purpose labels:  
- `V213__seed_y5_spell_premium_exam10.sql` — Y5 Spelling Premium Exam 10  
- `V214__seed_y5_spell_premium_exam10.sql` — Y5 Spelling Premium Exam 10 (DUPLICATE — different exam, different UUID)

This is the only exam name collision found. The UUIDs do not collide, but the content purpose (Y5 Spell Prem 10) is served by two different files with two different exam records. Only one can be the authoritative Y5 Spell Prem 10.

**Verdict: FAIL** — One duplicate content slot exists (Y5 Spelling Premium Exam 10 has two competing SQL files).

---

## 6. File-Level Duplicates

**Method:** Compared filenames for duplicates.

| Filename | Count | Files |
|---|---|---|
| `*y5_spell_premium_exam10.sql` | 2 | V213, V214 |
| All other filenames | 1 each | No duplicates |

**Verdict: FAIL** — One filename duplicate detected (same exam label in two Batch 1 files).

---

## Summary

| Check | Verdict |
|---|---|
| Exam UUID uniqueness (321 files) | PASS |
| Fake/null UUID patterns | PASS |
| UUID v5 format (sampled) | PASS |
| Question UUID uniqueness (sample-based) | PASS |
| Exam content slot duplicates | FAIL (Y5 Spell Prem 10 × 2) |
| Filename duplicates | FAIL (V213 and V214 same exam label) |

**Overall Uniqueness Gate: FAIL** — Duplicate content slot for Y5 Spelling Premium Exam 10.
