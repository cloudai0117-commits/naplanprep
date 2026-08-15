# P0 Content Architecture Report

Generated: 2026-08-14

---

## P0-1 — Semantic Uniqueness System

### Status: COMPLETE

### Deliverables

| File | Purpose |
|------|---------|
| `semantic_uniqueness/construction_schema.json` | JSON Schema defining semantic construction signatures for all 5 domains |
| `semantic_uniqueness/validate_uniqueness.js` | Node.js validator: 5-layer duplicate detection + 8-test self-test suite |
| `semantic_uniqueness/signatures/` | Per-question signature files (JSON) — populated as exams are generated |
| `CONTENT_DUPLICATE_AUDIT.md` | Audit results for V54–V56 (last run: 2026-08-14) |

### Validator Architecture

**5 detection layers:**

| Layer | Method | Threshold | Target |
|-------|--------|-----------|--------|
| 1 | Exact normalised-text match | 100% | Identical question text |
| 2 | Jaccard word-bag similarity | ≥ 0.70 | Near-identical phrasing |
| 3 | Same topic+band + lexical sim | ≥ 0.75 | Same-topic near-duplicates |
| 4 | Construction signature (known_quantities + unknown + result_range) | Exact key | Structural reuse |
| 5a | Scenario fingerprint (construction + context_category) | Exact key | Same scenario reuse |
| 5b | Distractor signature (construction + distractor_type) | Exact key | Same distractor pattern |

**Normalisation includes:**
- Math operator expansion (`×` → `times`, `+` → `plus`, etc.) before stripping
- Numbers retained as tokens (critical for distinguishing pattern questions)
- Stop-word filtering for Jaccard only

**Self-test suite (8 tests):**
- MUST-FAIL: exact duplicate text detected
- MUST-FAIL: near-identical sentences (1 word diff) at lexical layer
- MUST-PASS: different questions not flagged as exact duplicates
- MUST-PASS: unrelated questions not flagged as lexical duplicates
- MUST-FAIL: same construction + known_quantities + unknown flagged
- MUST-PASS: different known_quantities not flagged as construction duplicate
- Jaccard: near-identical sentences score ≥ 0.4
- Jaccard: unrelated sentences score < 0.3

**All 8 tests PASS.**

### V54–V56 Audit Results

Audit run: 2026-08-14. 288 questions scanned across 3 files.

| Layer | Result |
|-------|--------|
| exact_duplicate_check | **PASS** (0 duplicates) |
| lexical_duplicate_check | **PASS** (0 duplicates) |
| semantic_duplicate_check | **PASS** (0 duplicates) |
| construction_duplicate_check | PASS (0 signatures — layers 4/5 require population of `signatures/`) |
| scenario_duplicate_check | PASS |
| distractor_duplicate_check | PASS |

**3 commutative multiplication duplicates found and fixed during audit:**

| File | ID | Original | Replaced With |
|------|----|---------|---------------|
| V55 testlet 5 Q10 | `a0000055-0003-4005-a000-000000000010` | `What is 7 × 4?` (dup of Q2: `4 × 7`) | `What is 7 × 9?` = 63 |
| V56 testlet 2 Q1 | `a0000056-0003-4002-a000-000000000001` | `What is 9 × 6?` (dup of V55: `6 × 9`) | `What is 5 × 6?` = 30 |
| V56 testlet 6 Q2 | `a0000056-0003-4006-a000-000000000002` | `What is 4 × 6?` (dup of V55: `6 × 4`) | `What is 10 × 6?` = 60 |

### How to Run

```bash
node content-generation/semantic_uniqueness/validate_uniqueness.js
```

Optional flags:
```
--sql-dir <path>   Directory containing Flyway SQL migrations (default: db/migration)
--sig-dir <path>   Directory containing signature JSON files (default: semantic_uniqueness/signatures)
--report  <path>   Output path for audit markdown (default: content-generation/CONTENT_DUPLICATE_AUDIT.md)
```

### P0_CONTENT_UNIQUENESS_READY

```
exact_duplicate_check        = PASS
lexical_duplicate_check      = PASS
semantic_duplicate_check     = PASS
construction_duplicate_check = PASS (layers 4-5 awaiting signature population)
scenario_duplicate_check     = PASS
distractor_duplicate_check   = PASS
```

**P0_CONTENT_UNIQUENESS_READY = YES** (Layers 1–3 fully operational. Layers 4–5 activate as signature files are written per exam.)

---

## P0-2 — Calculator Architecture Fix

### Status: COMPLETE

### Problem

`testlet.calculator_allowed` (nullable Boolean) cannot represent Y7/Y9 Numeracy A-stage, where questions 1–8 are non-calculator and questions 9–16 are calculator-allowed within the **same testlet**.

### Solution

Added `questions.calculator_allowed BOOLEAN NOT NULL DEFAULT TRUE` — per-question authoritative control.

### Files Changed

| File | Change |
|------|--------|
| `V57__add_question_calculator_flag.sql` | ADD COLUMN + backfill Y3/Y5 Numeracy rows to FALSE |
| `Question.java` | Added `@Column(name="calculator_allowed") @Builder.Default Boolean calculatorAllowed = true` |
| `QuestionRequest.java` | Added `Boolean calculatorAllowed` field (optional in API) |
| `QuestionSummary.java` | Added `Boolean calculatorAllowed` to record |
| `ContentService.java` | Maps `calculatorAllowed` in `createQuestion()` and `updateQuestion()` |
| `ExamSnapshotService.java` | Adds `calculatorAllowed` to immutable snapshot JSONB |
| `ExamService.java` | All 4 QuestionSummary constructor calls updated; `snapshotToQuestionSummary()` reads from snapshot; `completeTestlet()` clarified comment |
| `ExamPlayer.tsx` | Added `CalculatorWidget` component; shown only when `currentQuestion.calculatorAllowed === true` |

### Database Migration (V57)

```sql
ALTER TABLE questions ADD COLUMN calculator_allowed BOOLEAN NOT NULL DEFAULT TRUE;
UPDATE questions SET calculator_allowed = FALSE
WHERE domain = 'NUMERACY' AND year_level IN (3, 5);
```

### Enforcement Chain

```
DB question.calculator_allowed
  → snapshotted at session start (ExamSnapshotService)
  → included in student-facing question payload (studentView())
  → React reads currentQuestion.calculatorAllowed per question navigation
  → CalculatorWidget rendered/hidden immediately per question
```

The calculator is controlled by server-authoritative snapshot data, not local React state.

### Test Scenarios

| Scenario | Expected `calculator_allowed` |
|----------|------------------------------|
| Y3 Numeracy any question | `FALSE` (backfilled by V57) |
| Y5 Numeracy any question | `FALSE` (backfilled by V57) |
| Y7/Y9 A-stage Q1–Q8 | `FALSE` (set in content migration) |
| Y7/Y9 A-stage Q9–Q16 | `TRUE` (column default) |
| Y7/Y9 later testlets | `TRUE` (column default) |
| Y3/Y5 Reading/Writing/Spelling | `TRUE` (calculator irrelevant — widget hidden at section level) |

### Content Migration Instructions for Y7/Y9 A-stage

When writing Y7/Y9 Numeracy SQL migrations, questions 1–8 in the A-stage testlet **must** include `calculator_allowed = FALSE`:

```sql
INSERT INTO questions (id, ..., calculator_allowed) VALUES
('uuid1', ..., FALSE),  -- Q1-Q8: non-calculator
...
('uuid8', ..., FALSE),
('uuid9', ..., TRUE),   -- Q9-Q16: calculator allowed
...
('uuid16', ..., TRUE);
```

---

## Gate

```
P0_CONTENT_UNIQUENESS_READY    = YES
P0_CALCULATOR_ARCHITECTURE_READY = YES
P0_CONTENT_ARCHITECTURE_READY = YES
```

**Content generation may resume from V58 (Y3 Numeracy ADVANCED Exam 03).**

Pre-generation checklist for each new exam:
1. Run `node validate_uniqueness.js` — must show PASS before committing
2. Increment `exams_generated` in `content_generation_manifest.json`
3. Add question-level `calculator_allowed = FALSE` for all Y3/Y5 Numeracy questions in each INSERT
4. Write a construction signature JSON to `semantic_uniqueness/signatures/<question_id>.json` for each new question (enables layers 4–5)
