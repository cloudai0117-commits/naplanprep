# Global Test Length vs Pool Count Root Cause Report

---

## Problem Statement

The student-facing application displayed the TOTAL ADAPTIVE POOL QUESTION COUNT instead of the STUDENT TEST LENGTH everywhere — exam catalogue, instructions page, dashboard, and admin panel. UAT evidence:

| Exam | Displayed | Correct |
|---|---|---|
| Y9 Numeracy | 128Q | 48Q |
| Y9 Reading | 128Q | 48Q |
| Y9 Grammar & Punctuation | 72Q | 27Q |
| Y9 Spelling | 43Q | 25Q |

---

## Root Cause

### Adaptive Pool Architecture

Every exam (except Writing) uses an 8-node branching pool:
```
Testlet A → (Testlet B or B_LATE) → (Testlet C, C_EARLY, D, E, or F)
```
The pool stores ALL possible testlet questions. The student travels exactly **3 testlet legs**. The pool is never fully delivered to any individual student.

### The Missing Separation

The `exams` table had no `student_test_length` column. `ExamService.getAvailableExams` computed:

```java
Map<UUID, Long> qCounts = examQuestionRepository.countByExamIds(examIds)...
// ↑ returns TOTAL questions in pool (e.g. 128 for Y9 Numeracy)

int qCount = qCounts.getOrDefault(exam.getId(), 0L).intValue();
return new AvailableExamResponse(..., qCount, ...);   // ← POOL COUNT, not student length
```

`AvailableExamResponse.questionCount` then surfaced this pool count to the frontend, which displayed it directly as the exam's question count.

---

## Authoritative Student Test Lengths

Derived from migration structure (testlet count × questions per testlet × 3 student legs):

| Domain | Y3 | Y5 | Y7 | Y9 | Pool formula |
|---|---|---|---|---|---|
| NUMERACY | 36 | 42 | 48 | 48 | 8 × N/testlet (12/14/16) |
| READING | 39 | 39 | 48 | 48 | 8 × N/testlet (13/13/16) |
| GRAMMAR_PUNCTUATION | 27 | 27 | 27 | 27 | 8 × 9/testlet |
| SPELLING | 25 | 25 | 25 | 25 | 5-testlet pool; path = 7+9+9 |
| WRITING | 1 | 1 | 1 | 1 | Single prompt |

Migration evidence:

| Migration | Exam | Testlets | Pool | Per testlet | Student path |
|---|---|---|---|---|---|
| V54 | Y3 Numeracy | 8 | 96 | 12 | 36 |
| V103 | Y3 Grammar | 8 | 72 | 9 | 27 |
| V119 | Y3 Spelling | 5 | 43 | varies | 25 |
| V135 | Y5 Numeracy | 8 | 112 | 14 | 42 |
| V151 | Y5 Reading | 8 | 104 | 13 | 39 |
| V183 | Y5 Grammar | 8 | 72 | 9 | 27 |
| V215 | Y7 Numeracy | 8 | 128 | 16 | 48 |
| V263 | Y7 Grammar | 8 | 72 | 9 | 27 |
| V295 | Y9 Numeracy | 8 | 128 | 16 | 48 |
| V311 | Y9 Reading | 8 | 128 | 16 | 48 |
| V343 | Y9 Grammar | 8 | 72 | 9 | 27 |
| V359 | Y9 Spelling | 5 | 43 | varies | 25 |

---

## Fix

### Layer 1 — Database (V381)

Added `student_test_length INTEGER NOT NULL` column to `exams` table.
Populated with authoritative values via domain+year_level UPDATE statements.
Added `CHECK (student_test_length > 0)` constraint.

File: `backend/src/main/resources/db/migration/V381__add_student_test_length.sql`

### Layer 2 — Backend Entity

Added `studentTestLength` field to `Exam.java`.

File: `backend/.../exam/entity/Exam.java`

### Layer 3 — Backend DTO

Renamed `questionCount` → `studentTestLength` in `AvailableExamResponse.java`.

File: `backend/.../exam/dto/AvailableExamResponse.java`

### Layer 4 — Backend Service (Student API)

`ExamService.getAvailableExams`: replaced pool count lookup with `exam.getStudentTestLength()`.

File: `backend/.../exam/service/ExamService.java`

### Layer 5 — Backend Service (Admin API)

`AdminExamService.listExams`: renamed `"questionCount"` key to `"poolQuestionCount"` and added separate `"studentTestLength"` key.

File: `backend/.../exam/service/AdminExamService.java`

### Layer 6 — Frontend Student UI

| File | Line | Change |
|---|---|---|
| `ExamSelection.tsx` | 151 | `exam.questionCount` → `exam.studentTestLength` |
| `ExamInstructionsPage.tsx` | 96 | `exam.questionCount` → `exam.studentTestLength` |
| `Dashboard.tsx` | 291 | `exam.questionCount` → `exam.studentTestLength` |

### Layer 7 — Admin Panel UI

`ExamList.tsx`: column header changed to "Student Q's (Pool)"; now shows `studentTestLength (poolQuestionCount pool)` so admins can see both values.

---

## Fields Not Changed

| Component | Field | Reason |
|---|---|---|
| `ExamPlayer.tsx` `displayTotal` | `questions.length` | Correctly reflects per-testlet question count (16 for Numeracy); Spelling overrides to 25 |
| `ResultsPage.tsx` `totalQuestions` | `result.totalQuestions` | Derived from `session.getQuestionIds().size()` — the questions the student actually answered |
| `ExamResultsDetailPage.tsx` `totalQuestions` | same | Same — correct, not pool count |

---

## Test Results

| Suite | Tests | Result |
|---|---|---|
| `studentTestLength.test.ts` (new) | 21 | PASS |
| `examPlayerUtils.test.ts` | 12 | PASS |
| `audioMimeType.test.ts` | 7 | PASS |
| `authStore.test.ts` | 7 | PASS |
| **Frontend total** | **47** | **PASS** |
| `StudentTestLengthTest` (new) | 12 | PASS |
| `ActiveExamPathTest` | 6 | PASS |
| `ExamStartIdempotencyTest` | 3 | PASS |
| `SessionSnapshotTest` | 8 | PASS |
| `BranchingEngineTest` | 5 | PASS |
| `ExamEntitlementTest` | 4 | PASS |
| `ScoringStrategyTest` | 19 | PASS |
| **Backend unit total** | **59** | **PASS** |
| Frontend typecheck | — | PASS |
| Admin panel typecheck | — | PASS |

---

## UAT Expected Outcome

After deployment:

| Exam | Was Displaying | Now Displays |
|---|---|---|
| Y9 Numeracy | 128Q | 48Q |
| Y9 Reading | 128Q | 48Q |
| Y7 Numeracy | 128Q | 48Q |
| Y7 Reading | 128Q | 48Q |
| Y9 Grammar & Punctuation | 72Q | 27Q |
| Y9 Spelling | 43Q | 25Q |
| Y3 Numeracy | 96Q | 36Q |
| Y5 Numeracy | 112Q | 42Q |
| Y3 Reading | 104Q | 39Q |
| Y5 Reading | 104Q | 39Q |

---

## Final Gate

| Condition | Status |
|---|---|
| `student_test_length` column added to DB | PASS (V381) |
| All 320 exams populated with correct student test length | PASS (UPDATE by domain+year_level) |
| `AvailableExamResponse.studentTestLength` carries correct value | PASS |
| Pool count no longer exposed to student-facing API | PASS |
| ExamSelection.tsx shows studentTestLength | PASS |
| ExamInstructionsPage.tsx shows studentTestLength | PASS |
| Dashboard.tsx shows studentTestLength | PASS |
| Admin panel shows both studentTestLength and poolQuestionCount | PASS |
| ExamPlayer.tsx per-testlet progress unchanged | PASS (correct, not affected) |
| Results totalQuestions unchanged | PASS (already correct — answered count) |
| Frontend tests (47/47) | PASS |
| Backend unit tests (59/59) | PASS |
| Frontend typecheck | PASS |
| Admin panel typecheck | PASS |

**POOL_COUNT_FIX_READY = YES**
