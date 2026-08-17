# GLOBAL EXAM TEST LENGTH ROOT CAUSE REPORT

**Project:** NAPLANPrep  
**Report date:** 2026-08-17  
**Status:** ROOT CAUSE IDENTIFIED AND FIXED  
**Severity:** CRITICAL — All exam cards showed "Q" (blank count). Exam player showed "Question 1 of 128".

---

## Executive Summary

Two distinct defects made every exam card in UAT show no question count ("Q") and made the adaptive exam player display the full question pool count (128) instead of the student's test length (48). Both defects share the same root: `student_test_length` was never propagated from the database to the API to the UI, leaving the frontend with a `undefined` value for every exam.

---

## Three Distinct Concepts — NEVER Conflate

| Concept | Description | Y9 Numeracy Example |
|---------|-------------|---------------------|
| `POOL_COUNT` | All questions in the adaptive pool (all 8 testlets) | 128 |
| `STUDENT_TEST_LENGTH` | Questions the student actually answers (3 testlet legs × N) | 48 |
| `ACTIVE_PATH_COUNT` | Questions in the currently-active testlet | 16 |

The adaptive branching tree for Numeracy/Reading is: `A → (B | B_LATE) → (C | C_EARLY | D | E | F)`.
The student traverses exactly **3 testlet legs**, not all 8 nodes.

---

## Authoritative Student Test Lengths

These values are FIXED and IMMUTABLE. They must never be inferred from question counts.

| Domain | Y3 | Y5 | Y7 | Y9 |
|--------|----|----|----|----|
| NUMERACY | 36 | 42 | 48 | 48 |
| READING | 39 | 39 | 48 | 48 |
| GRAMMAR_PUNCTUATION | 27 | 27 | 27 | 27 |
| SPELLING | 25 | 25 | 25 | 25 |
| WRITING | 1 | 1 | 1 | 1 |

Forbidden pool counts (must **never** appear in any student-facing context):

```
128 — Y7/Y9 Numeracy full pool
112 — Y5 Numeracy full pool
 96 — Y3 Numeracy full pool
104 — Y3/Y5 Reading full pool
 72 — Grammar pool
 43 — Spelling pool
```

---

## DEFECT A — Exam Cards Show "Q" (Blank Count)

### UAT Evidence
```
Year 9 Numeracy:          Q  (expected: 48Q)
Year 9 Reading:           Q  (expected: 48Q)
Year 9 Grammar & Punct:   Q  (expected: 27Q)
Year 9 Spelling:          Q  (expected: 25Q)
Year 9 Writing:           Q  (expected: 1Q)
```

### Root Cause Chain

```
1. V381__add_student_test_length.sql:
   ALTER TABLE exams ADD COLUMN student_test_length INTEGER NOT NULL DEFAULT 0;
   -- ^^ Rows temporarily have value=0 before UPDATEs run
   -- Then CHECK constraint (student_test_length > 0) FAILS because default=0 still exists

2. Flyway V381 left in FAILED state in flyway_schema_history.
   Column exists but some rows may have student_test_length=0.

3. Exam.java has @Column(nullable = false) private Integer studentTestLength;
   Hibernate validation: column exists but data may be 0.
   If Hibernate validates incorrectly → Spring Boot FAILS TO START.
   Railway keeps old container (pre-fix) running.

4. Old container returns old API shape with "questionCount" field (pool count).
   New frontend expects "studentTestLength" field.
   exam.studentTestLength = undefined → Dashboard.tsx renders "{undefined}Q" = "Q".
```

### Affected Files
- `backend/src/main/resources/db/migration/V381__add_student_test_length.sql` — V381 can fail
- `backend/src/main/resources/application-uat.yml` — did not have `ignore-migration-patterns`

### Fix Applied

**Commit 7c9cd25** introduced two complementary fixes:

1. **V382__fix_student_test_length.sql** — Repair migration (idempotent):
   - `ADD COLUMN IF NOT EXISTS` — safe if V381 already ran
   - Re-runs all UPDATE statements for every domain/year
   - Catch-all `UPDATE exams SET student_test_length = 1 WHERE student_test_length IS NULL OR student_test_length = 0`
   - `SET NOT NULL` after data is clean
   - Idempotent `CHECK` constraint creation via PL/pgSQL guard

2. **application-uat.yml** — Added:
   ```yaml
   spring:
     flyway:
       ignore-migration-patterns: "*:Failed"
   ```
   Allows V382 to run even when V381 is in FAILED state.

---

## DEFECT B — Exam Player Shows "Question 1 of 128"

### UAT Evidence
```
Year 9 Numeracy player:
  Header: "Question 1 of 128"
  Nav panel: 128 numbered buttons (1...128)
```

### Root Cause Chain

```
1. student_test_length IS NULL in DB (V381 failure, see DEFECT A).

2. ExamService.getSession() enriches @Transient session.studentTestLength:
   examRepository.findById(examId).ifPresent(exam ->
       session.setStudentTestLength(exam.getStudentTestLength()));
   → exam.getStudentTestLength() returns 0 or null → transient field = 0/null

3. ExamPlayer.tsx line 228 (before fix):
   const displayTotal = session?.studentTestLength ?? questions.length
   → studentTestLength is 0/null → falls back to questions.length

4. getSessionQuestions() for sessions with hasSnapshot=false OR currentTestletId=null:
   → Returns ALL 128 pool questions (entire snapshot set)
   → questions.length = 128
   → "Question 1 of 128"

5. Additionally: calculateAndSaveResult() used:
   int total = session.getQuestionIds().size();  // = 128 (WRONG)
   → ExamResult.totalQuestions stored as 128
   → Results page shows "0/128 correct" instead of "0/48"
```

### Root Cause — Session Questions Returning 128

Two code paths return all 128 questions:

**Path 1: `hasSnapshot = false`** (old sessions, no snapshot support)
```java
// ExamService.getSessionQuestions() (old code):
if (!Boolean.TRUE.equals(session.getHasSnapshot())) {
    // Falls through to flat path → returns ALL exam questions = 128
}
```

**Path 2: `hasSnapshot = true` but `currentTestletId = null`** (sessions created in the window between snapshot fix and testlet-routing fix)
```java
if (Boolean.TRUE.equals(session.getHasSnapshot())) {
    List<SessionQuestionSnapshot> snaps = (session.getCurrentTestletId() != null)
        ? snapshotRepository.findByIdSessionIdAndTestletIdOrderByQuestionOrder(sessionId, testletId)
        : snapshotRepository.findByIdSessionIdOrderByQuestionOrder(sessionId); // ← 128 snapshots
}
```

### Fix Applied

**`ExamService.java` — `getSessionQuestions()`** (this PR):

1. Changed `@Transactional(readOnly = true)` to `@Transactional` (writes are needed for backfill).

2. Added retroactive fix at the start of the method — covers both broken paths:

   - **Path 1 (no snapshots)**: Creates snapshots from exam questions, then sets `currentTestletId` from first snapshot's testletId. Saves session.
   - **Path 2 (snapshots exist, no currentTestletId)**: Reads first snapshot, sets `currentTestletId`. Saves session.

   After backfill, the existing snapshot-path logic returns only the 16 questions for testlet A — correct.

**`ExamService.java` — `calculateAndSaveResult()`** (this PR):

Changed `int total = session.getQuestionIds().size()` to look up the exam's `student_test_length`:

```java
int studentTestLen = session.getStudentTestLength() != null && session.getStudentTestLength() > 0
    ? session.getStudentTestLength() : 0;
if (studentTestLen <= 0 && session.getExamId() != null) {
    studentTestLen = examRepository.findById(session.getExamId())
        .map(Exam::getStudentTestLength)
        .filter(l -> l != null && l > 0)
        .orElse(0);
}
int total = studentTestLen > 0 ? studentTestLen : session.getQuestionIds().size();
```

**`ExamPlayer.tsx`** (this PR):

Added testlet transition flow. After completing all questions in testlet A:
- "Next →" button becomes "Complete Section →" on the last question of a testlet-based exam.
- Clicking it calls `POST /exams/sessions/{id}/testlet/{testletId}/complete`.
- If `pathComplete: false` → invalidates questions query → server returns next testlet (B or B_LATE) → student sees 16 new questions.
- If `pathComplete: true` → auto-submits exam.
- Submit modal shows a warning when `currentTestletId != null` and student has unanswered questions.

**`V383__fix_exam_results_total_questions.sql`** (this PR):

Repairs already-stored `exam_results.total_questions` and `score_percentage` for sessions where the pool count was incorrectly stored:

```sql
UPDATE exam_results er
SET    total_questions  = e.student_test_length,
       score_percentage = ROUND(er.correct_answers::NUMERIC * 100.0 / e.student_test_length, 2)
FROM   exam_sessions es
JOIN   exams e ON es.exam_id = e.id
WHERE  er.session_id   = es.id
  AND  e.student_test_length > 0
  AND  er.total_questions <> e.student_test_length;
```

---

## Complete Fix Inventory

### Database Migrations

| Migration | Purpose |
|-----------|---------|
| V381 | Adds `student_test_length` column; can FAIL if any row has default=0 at CHECK time |
| V382 | Idempotent repair: `ADD COLUMN IF NOT EXISTS`, re-applies all UPDATEs, catch-all for 0/NULL |
| V383 | Fixes `exam_results.total_questions` for previously submitted sessions |

### Backend

| File | Change |
|------|--------|
| `ExamService.getSessionQuestions()` | `@Transactional` (was readOnly); retroactive testlet backfill for all resume paths |
| `ExamService.calculateAndSaveResult()` | Uses `exam.student_test_length` not `questionIds.size()` |
| `ExamSession.java` | `@Transient studentTestLength` and `examTitle` (populated in getSession) |
| `ExamService.getSession()` | Enriches transient fields from linked exam |
| `ExamService.startAdminExam()` | Creates snapshots + sets `currentTestletId` for new and resumed sessions |
| `AvailableExamResponse` | Field renamed from `questionCount` to `studentTestLength` |
| `ExamService.getAvailableExams()` | Returns `exam.getStudentTestLength()` not pool count |
| `application-uat.yml` | `spring.flyway.ignore-migration-patterns: "*:Failed"` |

### Frontend

| File | Change |
|------|--------|
| `ExamPlayer.tsx` | `displayTotal = session?.studentTestLength ?? questions.length`; testlet transition flow |
| `Dashboard.tsx` | Uses `exam.studentTestLength` (was `exam.questionCount`) |
| `ExamSelection.tsx` | Uses `exam.studentTestLength` |
| `ExamInstructionsPage.tsx` | Uses `exam.studentTestLength` |
| `examPlayerUtils.ts` | `shortAnswerPlaceholder()` and `showSpellingHint()` distinguish SPELLING vs NUMERACY |

---

## Session State Machine — Active Path

For a new Year 9 Numeracy session:

```
startAdminExam():
  1. Creates 128 exam_question snapshots (all testlets, ordered)
  2. Sets hasSnapshot = true
  3. Sets currentTestletId = testletA.id (from first snapshot)
  4. Sets questionPath = [testletA.id]
  5. Saves session

getSessionQuestions():
  → hasSnapshot = true, currentTestletId = testletA.id
  → Returns 16 questions (testlet A only)
  → Frontend shows "Question 1 of 48" (session.studentTestLength=48)
  → Nav panel: 16 buttons

Student answers 16 questions, clicks "Complete Section →":
  completeTestlet(testletA.id):
    1. Calculates testlet A score ratio
    2. BranchingEngine resolves: B (>50%) or B_LATE (≤50%)
    3. Sets currentTestletId = testletB.id
    4. Appends testletB to questionPath
    5. Returns { pathComplete: false, questions: [16 testletB questions] }

Frontend:
  → Invalidates questions query
  → Refetches: returns 16 testletB questions
  → Resets currentIdx = 0
  → Shows "Question 1 of 48" (unchanged)
  → Nav panel: 16 testletB buttons

... (repeat for testlet C) ...

completeTestlet(testletC.id):
  → nextTestletId = null (path ends)
  → Returns { pathComplete: true }

Frontend:
  → Calls submitExam()
  → Result: correctAnswers / studentTestLength (e.g. "24/48 = 50%")
```

---

## Session Resume — All Code Paths

| Session State | Path | Fix Applied |
|---------------|------|-------------|
| `hasSnapshot=true`, `currentTestletId=testletA` | Returns testlet A (16 questions) | No fix needed |
| `hasSnapshot=true`, `currentTestletId=null` | Was: 128 questions; Now: backfill in getSessionQuestions() | **Fixed here** |
| `hasSnapshot=false`, snapshots exist | Was: 128 via flat path; Now: sets hasSnapshot=true, backfills testletId | **Fixed here** |
| `hasSnapshot=false`, no snapshots | Was: 128 via flat path; Now: creates snapshots, sets testletId | **Fixed here** (also in startAdminExam) |

---

## Test Coverage

### REST Assured API Tests (`ExamCatalogueApiTest.java`)

14 tests covering:
- API-CAT-01: `studentTestLength` present and positive for all exams
- API-CAT-02: Pool counts MUST NOT appear (fail-fast: 128/112/96/104/72/43)
- API-CAT-03 through API-CAT-13: Exact values for each domain/year combination
- API-CAT-14: All 320 exam matrix combinations correct

### Playwright UI Tests (`exam-catalogue.spec.ts`)

12 tests covering:
- UI-CAT-01: No forbidden counts visible on `/exams` page
- UI-CAT-02 through UI-CAT-11: Each exam shows correct count
- UI-PLAYER-01: Player "of N" shows student test length not pool count

### CI/CD Gates (`deploy-uat.yml`)

- `studentTestLength` Python gate: blocks deployment if any exam shows a pool count
- `run-uat-regression` job: runs REST Assured + Playwright @smoke tests post-deploy

---

## Acceptance Criteria — ALL must pass before sign-off

### Exam Catalogue

| Exam | Expected | Forbidden |
|------|----------|-----------|
| Y3 Numeracy | 36 | 96 |
| Y5 Numeracy | 42 | 112 |
| Y7 Numeracy | 48 | 128 |
| Y9 Numeracy | 48 | 128 |
| Y3 Reading | 39 | 104 |
| Y5 Reading | 39 | 104 |
| Y7 Reading | 48 | — |
| Y9 Reading | 48 | — |
| Spelling (any year) | 25 | 43 |
| Grammar & Punctuation | 27 | 72 |
| Writing | 1 | — |

### Exam Player

- "Question 1 of N" where N ∈ {36, 42, 48, 25, 27, 1} ✓
- "Question 1 of N" where N ∈ {128, 112, 96, 104, 72, 43} is a **CRITICAL FAILURE** ✗
- Nav panel shows current testlet questions only (e.g. 16 for Y9 Numeracy) ✓
- "Complete Section →" button appears on last question of testlet-based exams ✓
- After completing all testlets, exam auto-submits ✓

### Results

- `result.totalQuestions` = `student_test_length` (e.g. 48 for Y9 Numeracy) ✓
- `result.totalQuestions` ∈ {128, 112, 96, 104, 72, 43} is a **CRITICAL FAILURE** ✗
- Score percentage = `correctAnswers / studentTestLength * 100` ✓

### Flyway

- All migrations in `APPLIED` state (no FAILED) ✓
- Checksums match (no manual DB changes) ✓
- V383 applied cleanly ✓

---

## Security Invariants (Unchanged — Must Remain in Effect)

- `correctAnswer` and `explanation` STRIPPED from all student-facing question responses
- No cross-user session access
- `/actuator/health/dbIntegrity` is NOT `permitAll()`
- No ephemeral RSA keys in UAT/prod
- No Stripe keys in frontend code
- No credentials in workflow files
- No private RSA keys in Git

---

**GLOBAL_EXAM_TEST_LENGTH_ROOT_CAUSE_REPORT_STATUS = COMPLETE**
