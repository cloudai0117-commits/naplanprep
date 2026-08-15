# CONTENT FLYWAY ERROR LIST

**Audit Date:** 2026-08-14  
**Auditor:** Production QA (automated audit — VERIFICATION ONLY, no files modified)  
**Scope:** Batch 1 (NAPLANPrep_Batch1_V54_V214/flyway/) + Batch 2 (NAPLANPrep_MasterBatch2_V215_V374/)

---

## P0 BLOCKERS — Must be resolved before any production deployment

---

### ERR-P0-001 · Extra File Creates Flyway Version Collision at V215

**File:** `NAPLANPrep_Batch1_V54_V214/flyway/V214__seed_y5_spell_premium_exam10.sql`  
**Severity:** P0 BLOCKER  
**Category:** Flyway version conflict  

**Description:**  
Batch 1 directory contains 161 files instead of the expected 160. The extra file is a second version of "Y5 Spelling Premium Exam 10", which already exists as `V213__seed_y5_spell_premium_exam10.sql`. As a Batch 1 download file, V214 maps to Repo V215 (following the +1 shift rule). Batch 2's first file is `V215__seed_y7_num_free_exam01.sql`, creating a direct Flyway version collision.

**Impact:**  
Flyway will refuse to apply migrations if two scripts occupy the same version slot. The entire combined migration run (Batch 1 + Batch 2) will fail.

**Evidence:**  
- V213 exam UUID: `2b21f7e5-3f80-5329-bcf9-bc07605133a4` (Y5 Spell Prem 10)  
- V214 exam UUID: `153771b7-bd0c-55f1-86c9-1a685fb3cd13` (also Y5 Spell Prem 10 — different exam, different UUID)  
- Both files contain the content label `y5_spell_premium_exam10` but are structurally different (different formats, different UUIDs, different time limits)  
- V214 download → Repo V215 (shift rule: download ≥ 57 maps to repo download+1)  
- Batch 2 Repo V215 = `V215__seed_y7_num_free_exam01.sql` (Year 7 Numeracy Free Exam 01)

**Action required:** Remove or rename the extra V214 file and determine which version of Y5 Spell Prem 10 is authoritative.

---

### ERR-P0-002 · calculator_allowed Missing in 29 Y3/Y5 Numeracy Files (Post-DDL Content)

**Files:** Download V57–V69 (13 files, Y3 Numeracy Adv 03 – Prem 10) and Download V134–V149 (16 files, Y5 Numeracy Free 01 – Prem 10)  
**Severity:** P0 BLOCKER  
**Category:** Data correctness — business rule violation  

**Description:**  
The V57 DDL migration (`V57__add_question_calculator_flag.sql` in the backend repo) adds `calculator_allowed BOOLEAN NOT NULL DEFAULT TRUE` and then runs an UPDATE to set it FALSE for all pre-existing NUMERACY rows for year_level 3 and 5. However, that backfill UPDATE only covers the three canonical content files (V54, V55, V56) that existed when the DDL ran.

All 29 subsequent Y3/Y5 Numeracy content files (download V57 through V149) do NOT include `calculator_allowed` in their `INSERT INTO questions` column lists. On a fresh database, after the DDL migration has added the column with `DEFAULT TRUE`, these inserts will store `calculator_allowed = TRUE` for all Y3 and Y5 Numeracy questions — violating the business rule that Y3/Y5 Numeracy must always be FALSE.

**Evidence (grep):**  
```
grep -r "calculator_allowed" Batch1/Y3_Num/ → 0 hits (all 16 files)
grep -r "calculator_allowed" Batch1/Y5_Num/ → 0 hits (all 16 files)
grep -r "calculator_allowed" Batch1/Y3_Num_canonical/ → 0 hits (OK — covered by DDL backfill UPDATE)
```
The FROZEN_CONTENT_INSERT_CONTRACT.md explicitly states:  
> "Do NOT rely on the column default for Y3/Y5 Numeracy. The V57 backfill UPDATE fixed existing rows, but new INSERT statements for Y3/Y5 Numeracy MUST supply FALSE explicitly."

**Affected files:** 29 files (13 Y3 Numeracy + 16 Y5 Numeracy), all Batch 1.  
**Questions affected:** Y3 Num ≈ 13 × 96 = 1,248 questions; Y5 Num ≈ 16 × 112 = 1,792 questions. Total: 3,040 questions will have wrong calculator_allowed = TRUE.

**Action required:** Add `calculator_allowed = FALSE` to every `INSERT INTO questions` statement in all 29 affected files, for all questions in those exams.

---

### ERR-P0-003 · "Choice 4" Placeholder Text in 64 Batch 2 Files

**Files:** V215–V230 (Y7 Numeracy, 16 files), V263–V278 (Y7 Grammar/Punctuation, 16 files), V295–V310 (Y9 Numeracy, 16 files), V343–V358 (Y9 Grammar/Punctuation, 16 files)  
**Severity:** P0 BLOCKER  
**Category:** Incomplete content generation — placeholder text not substituted  

**Description:**  
807 occurrences of the literal text `"Choice 4"` appear as answer option text values across 64 Batch 2 files. This represents questions where the fourth answer option was never given a real value — the generation template placeholder `"Choice 4"` was left verbatim in the SQL. Students using the platform would see "Choice 4" as one of four answer options.

**Evidence (grep):**  
```
Select-String -Path Batch2/*.sql -Pattern "Choice 4" → 807 matches in 64 files
Y7 Numeracy:  112 hits across 16 files (V215–V230)
Y7 GP:        288 hits across 16 files (V263–V278, 18 hits each)
Y9 Numeracy:  119 hits across 16 files (V295–V310)
Y9 GP:        288 hits across 16 files (V343–V358, 18 hits each)
```

**Sample evidence (V215 line 21):**  
```json
[{"label":"A","text":"14"},{"label":"B","text":"Choice 4"},{"label":"C","text":"13"},{"label":"D","text":"47"}]
```

**Domains NOT affected:** Y7/Y9 Reading, Writing, Spelling — 0 Choice 4 hits confirmed.  
**Domains affected:** ALL Y7/Y9 Numeracy and ALL Y7/Y9 Grammar/Punctuation.

**Action required:** Replace all instances of `"Choice 4"` with the actual fourth answer option text for each affected question. This requires regenerating or manually correcting 807 answer options across 64 files.

---

### ERR-P0-004 · Manifest BATCH_2 Status "NOT_STARTED" — 160 Files Exist

**File:** `content_generation_manifest.json`  
**Severity:** P0 BLOCKER  
**Category:** Manifest–file discrepancy  

**Description:**  
The `content_generation_manifest.json` records `BATCH_2.status = "NOT_STARTED"` and `BATCH_2.exams_generated = 0`. However, 160 complete, non-empty SQL migration files exist in the Batch 2 directory (V215–V374), covering all Year 7 and Year 9 content. The manifest has never been updated to reflect Batch 2 completion.

**Impact:**  
Any process or CI check that reads the manifest to determine deployment readiness will incorrectly conclude Batch 2 is ungenerated. The manifest cannot be used as a reliable source of truth for Batch 2.

**Evidence:**  
```json
"BATCH_2": {
  "status": "NOT_STARTED",
  "exams_generated": 0,
  ...
}
```
Actual Batch 2 directory: 160 .sql files, V215–V374, all non-empty, all with BEGIN/COMMIT ✓.

**Action required:** Update manifest BATCH_2 status to "COMPLETE" and populate exams_generated = 160 and all exam metadata. Also resolve Batch 2 UUID/filename entries which are likely still at defaults.

---

## P1 ISSUES — Must be resolved before content is considered specification-compliant

---

### ERR-P1-001 · Batch 1 Spelling Testlet Names Non-Standard (All 32 Files)

**Files:** V118–V133 (Y3 Spelling, 16 files), V198–V213 (Y5 Spelling, 16 files)  
**Severity:** P1  
**Category:** Specification non-conformance — testlet naming  

**Description:**  
The FROZEN_CONTENT_INSERT_CONTRACT.md specifies Spelling testlets as: S1, S2A, S2B, S3A, S3B.  
Batch 2 Spelling correctly uses: "S1 — Spelling stage", "S2A — Spelling stage", "S2B — Spelling stage", "S3A — Proofreading", "S3B — Proofreading".  
Batch 1 Spelling uses: **S1, SD, SB, PD, PB** — non-standard abbreviations.

Confirmed from `V119__seed_y3_spell_advanced_exam01.sql` and `V198__seed_y5_spell_free_exam01.sql`:
- testlet_order=1: title = `S1`
- testlet_order=2: title = `SD`
- testlet_order=3: title = `SB`
- testlet_order=4: title = `PD`
- testlet_order=5: title = `PB`

Additionally, Batch 1 Spelling testlets have `calculator_allowed = NULL` instead of FALSE (Batch 2 Spelling testlets correctly have FALSE).

**Affected files:** 32 files (all Batch 1 Spelling). Batch 2 Spelling (V279–V294, V359–V374) is unaffected.

**Action required:** Rename Batch 1 Spelling testlet titles to match the contract (S1→"S1 — Spelling stage", SD→"S2A — Spelling stage", SB→"S2B — Spelling stage", PD→"S3A — Proofreading", PB→"S3B — Proofreading"). Set testlet.calculator_allowed = FALSE.

---

### ERR-P1-002 · V214 Extra File Sets calculator_allowed = FALSE for Spelling Questions

**File:** `NAPLANPrep_Batch1_V54_V214/flyway/V214__seed_y5_spell_premium_exam10.sql`  
**Severity:** P1 (in addition to P0-001 which covers the version collision)  
**Category:** Data correctness — business rule violation  

**Description:**  
The extra V214 file (the rogue Y5 Spell Prem 10 duplicate) explicitly sets `calculator_allowed = FALSE` for all Spelling questions. Per the frozen business rule, all non-Numeracy domains must have `calculator_allowed = TRUE` (or omit it to use the DEFAULT TRUE). Setting FALSE on Spelling questions would incorrectly disable the calculator UI toggle for a domain where it should be available.

**Action required:** This file should be removed (see ERR-P0-001). If retained, all Spelling questions must be updated to `calculator_allowed = TRUE`.

---

### ERR-P1-003 · Manifest Batch 1 Exam UUIDs Mismatch Actual File UUIDs (Canonical V54–V56)

**File:** `content_generation_manifest.json`  
**Severity:** P1  
**Category:** Manifest data integrity  

**Description:**  
The manifest records placeholder-pattern UUIDs for the three canonical Batch 1 exams (V54, V55, V56):
- Manifest exam 1 UUID: `a0000054-0000-4000-a000-000000000001`
- Actual V54 file exam UUID: `fcd31c21-9680-5cd3-b56a-522b4ad8f762`

These are entirely different UUIDs. Any UUID-based lookup against the manifest for canonical exams will fail. The manifest cannot be used to retrieve or identify V54–V56 exams by UUID.

**Action required:** Update manifest exam UUIDs for all three canonical exams to match the actual UUIDs in the SQL files. Also verify Batch 1 shifted files (V57–V213) have correct UUIDs in the manifest.

---

### ERR-P1-004 · Manifest Batch 1 Filename References Wrong (Repo Version vs Download Version)

**File:** `content_generation_manifest.json`  
**Severity:** P1  
**Category:** Manifest data integrity  

**Description:**  
For Batch 1 exams from exam 4 onwards (download V57 content and later), the manifest `filename` field records the REPO version filename (e.g., `V58__seed_y3_num_advanced_exam03.sql`) rather than the actual DOWNLOAD filename on disk (`V57__seed_y3_num_advanced_exam03.sql`). Batch 1 download files are named with download version numbers, not repo version numbers. Using manifest filenames to locate Batch 1 files will fail for 157 out of 160 Batch 1 entries.

**Action required:** Correct manifest `filename` fields for all Batch 1 shifted entries to use download version numbers.

---

## P2 ISSUES — Should be resolved for production quality

---

### ERR-P2-001 · Batch 2 Spelling Audio URL Path Uses MC Number (Not Repo Version)

**Files:** All 32 Batch 2 Spelling files (V279–V294, V359–V374)  
**Severity:** P2  
**Category:** Audio asset path convention inconsistency  

**Description:**  
Batch 2 Spelling audio paths follow the pattern:  
`/content/audio/spelling/yN/exam_MMM/SX_NN.mp3`  
where `MMM` is the **Master Card (MC) number**, not the repo version number.  
Example: V279 (MC278) uses path `/content/audio/spelling/y7/exam_278/S1_01.mp3`.  
Example: V374 (MC373) uses path `/content/audio/spelling/y9/exam_373/S1_01.mp3`.

This is internally consistent (all Batch 2 Spelling files use MC numbering), but differs from Batch 1 Spelling which uses `s3://naplanprep-content/audio/N/VXXX__seed_.../` format with the download version filename, and from other CDN paths. The MC-based path convention may cause audio files to not be found if the CDN stores them under repo version numbers.

**Action required:** Confirm that S3/CDN audio files are stored at MC-numbered paths (e.g., `exam_278/`) and document the convention formally.

---

### ERR-P2-002 · Batch 1 and Batch 2 Spelling Use Incompatible Audio URL Formats

**Files:** Batch 1 Spelling (V118–V133, V198–V213) vs Batch 2 Spelling (V279–V294, V359–V374)  
**Severity:** P2  
**Category:** Infrastructure inconsistency  

**Description:**  
Two different audio URL formats are used:  
- **Batch 1:** `s3://naplanprep-content/audio/3/V119__seed_y3_spell_advanced_exam01/S1_01.wav` (S3 direct, WAV format, uses download version filename)  
- **Batch 2:** `/content/audio/spelling/y7/exam_278/S1_01.mp3` (CDN relative path, MP3 format, uses MC number)  

These differences (protocol scheme, file format, path structure) indicate Batch 1 Spelling was generated targeting a different storage/CDN configuration from Batch 2. The application audio delivery layer must support both URL patterns simultaneously.

---

### ERR-P2-003 · Batch 2 Spelling Questions Use stimulus_id = NULL (Stimuli Records Orphaned)

**Files:** All 32 Batch 2 Spelling files  
**Severity:** P2  
**Category:** Data model inconsistency  

**Description:**  
Batch 2 Spelling files insert stimulus records (type = AUDIO) into the `stimuli` table but then set `stimulus_id = NULL` in the `questions` INSERT. The questions use `audio_url` directly in the question row. The stimuli records are not linked to any question and are functionally orphaned.

Batch 1 Spelling (e.g., V119) links stimuli to questions via FK correctly.  
This inconsistency means Batch 2 Spelling stimulus records consume database space but serve no functional purpose.

---

### ERR-P2-004 · Y3/Y5 Numeracy Question Count Lower Than Y7/Y9 (12–14 vs 16 per testlet)

**Files:** All Y3 and Y5 Numeracy files (Batch 1)  
**Severity:** P2  
**Category:** Structural specification ambiguity  

**Description:**  
The audit spec implies 16 questions per testlet for all Numeracy. Actual counts verified:
- Y3 Numeracy: 12 questions per testlet × 8 testlets = 96 total (V54 confirmed)  
- Y5 Numeracy: 14 questions per testlet × 8 testlets = 112 total (V134 confirmed)  
- Y7 Numeracy: 16 questions per testlet × 8 testlets = 128 total (V215 confirmed)  
- Y9 Numeracy: 16 questions per testlet × 8 testlets = 128 total (V295 confirmed)  

The progressive increase (12→14→16) is internally consistent and may be intentional (more complex adaptive testing for older year levels), but the spec does not document this variation. If 16 is the required minimum, Y3 and Y5 are under-spec.

---

### ERR-P2-005 · Writing Testlet calculator_allowed Field Inconsistency

**Files:** V247 (Y7 Writ Free) and by inference all 32 Writing files  
**Severity:** P2  
**Category:** Structural field inconsistency  

**Description:**  
Writing exams have testlet.calculator_allowed = FALSE (you don't use a calculator for writing) but question.calculator_allowed = TRUE. The question-level value is authoritative (correct for Writing domain per contract). The testlet-level FALSE is not wrong functionally, but differs from the per-question TRUE, creating a slight schema inconsistency.

---

## VERIFICATION PASSED — NO ISSUES FOUND

| Check | Result |
|---|---|
| BEGIN present in all 321 files | PASS (321 hits in Batch 1+2) |
| COMMIT present in all 321 files | PASS (321 hits in Batch 1+2) |
| Zero-byte files | PASS (none found) |
| TODO/PLACEHOLDER in SQL content | PASS (0 hits) |
| Fake UUID patterns (00000000/aaaaaaaa) | PASS (0 hits) |
| Duplicate exam UUIDs across 321 files | PASS (321 unique UUIDs) |
| Package count (1 FREE + 5 ADV + 10 PREM per domain/year) | PASS (all 20 domain/year combos correct) |
| Batch 2 Y7 Numeracy calculator_allowed present | PASS (2,877 hits across Y7 Num files) |
| V215 A-stage calculator split (Q1-8 FALSE, Q9-16 TRUE) | PASS (confirmed by inspection) |
| V247 Writing structure (EXTENDED_WRITING, totalMarks=46, 1Q) | PASS |
| All 160 Batch 2 files have status = PUBLISHED | PASS |
| Markdown fences (``` in SQL) | PASS (0 hits) |
| V54 transitions (SCORE_BELOW, SCORE_ABOVE, ALWAYS pattern) | PASS (10 transitions, correct structure) |
| V215 transitions | PASS (8 transitions) |
| Batch 2 Spelling testlet names (S1, S2A, S2B, S3A, S3B) | PASS (V279/V374 confirmed) |
| AUDIO_RESPONSE question type in Spelling | PASS (confirmed in V279) |
| EXTENDED_WRITING in Writing (marks=46, 10 criteria, value=null) | PASS (V86, V247 confirmed) |
| ON CONFLICT DO NOTHING in Batch 2 exam_questions | PASS |
| Batch 2 Y9 Numeracy calculator_allowed present | PASS (V295: 137 hits) |

---

**Total Findings:**  
- P0 Blockers: 4  
- P1 Issues: 4  
- P2 Issues: 5  
- Total: 13 findings  

**Overall Gate: FAIL** — 4 P0 blockers prevent production deployment.
