# Numeracy Exam Engine Root Cause Report

---

## Pool vs Active Path

| Metric | Value |
|---|---|
| POOL_COUNT | 128 |
| ACTIVE_PATH_COUNT | 16 |
| NEW_SESSION_QUESTION_COUNT | 16 |
| RESUMED_SESSION_QUESTION_COUNT | 128 (before fix) → 16 (after fix) |

The 128-question pool is intentional — 8 adaptive nodes × 16 questions each.  
The student-facing active path must always be the current testlet's 16 questions only.

---

## Defect A — Spelling Copy on Numeracy SHORT_ANSWER

| Field | Value |
|---|---|
| DEFECT_A | FIXED |
| FILE | `frontend/src/features/exam/ExamPlayer.tsx` |
| AFFECTED_QUESTION_TYPE | SHORT_ANSWER |
| AFFECTED_DOMAINS | All non-SPELLING domains (NUMERACY, READING, WRITING, GRAMMAR_PUNCTUATION) |

**Root cause:** `ExamPlayer.tsx` hardcoded Spelling-specific copy — `"Type the missing word here"` and `"Type one word. Spelling counts."` — for ALL `SHORT_ANSWER` questions regardless of domain. No domain check existed.

**Affected question (from UAT screenshot):**
- UUID: `5c240d7c-f976-5885-8c47-c66cb18a48dc`
- Text: "A marker on the public park upgrade map moves from 18 to 28 on a number line. How many units is the movement?"
- `question_type = SHORT_ANSWER`, `domain = NUMERACY`, `options = NULL`, `correct_answer = {"value":"10"}`
- `testlet_id` IS populated in `exam_questions`

**Fix:**
- Extracted `shortAnswerPlaceholder(domain)` and `showSpellingHint(domain)` into `frontend/src/utils/examPlayerUtils.ts`
- `ExamPlayer.tsx` now uses these utilities
- `SPELLING` domain → `"Type the missing word here"` + hint visible
- All other domains → `"Type your answer here"` + no spelling hint

| Field | Value |
|---|---|
| OPTIONS_IN_DB | NO / NOT_APPLICABLE (SHORT_ANSWER legitimately has no options) |
| OPTIONS_IN_API | NOT_APPLICABLE |
| CORRECT_RENDERER | Domain-aware text input |
| ACTUAL_RENDERER (before fix) | Spelling-specific text input for all SHORT_ANSWER |
| FIXED_RENDERER (after fix) | Domain-aware: SPELLING gets spelling copy; NUMERACY gets neutral copy |

---

## Defect B — Student Receives 128 Questions (Full Adaptive Pool)

| Field | Value |
|---|---|
| DEFECT_B | FIXED |
| DEFECT_B_ROOT_CAUSE | `currentTestletId` is NULL on resumed exam sessions |
| DEFECT_B_LAYER | SESSION |

**Data flow confirmed:**

1. Frontend: `GET /exams/sessions/{sessionId}/questions` → `ExamService.getSessionQuestions`
2. `getSessionQuestions` checks `session.getHasSnapshot()`:
   - If `hasSnapshot = true` AND `currentTestletId != null` → `findByIdSessionIdAndTestletIdOrderByQuestionOrder` → **16 questions** ✓
   - If `hasSnapshot = true` AND `currentTestletId == null` → `findByIdSessionIdOrderByQuestionOrder` → **128 questions** ✗
3. `displayTotal = questions.length` (line 229 of ExamPlayer.tsx) → shows "Question 1 of 128"

**Why `currentTestletId` was null on resumed sessions:**

`startAdminExam` correctly sets `currentTestletId` when creating a NEW session (from the first ordered snapshot). However the **idempotent resume path** (lines 122–128) simply returned `buildStartResponse(resume, examId)` without checking whether the resumed session had `currentTestletId` populated. Sessions created before the testlet-aware initialization was introduced — or sessions where session creation was interrupted before the second `save` — had `currentTestletId = null` in the database.

**Why `exam_questions.testlet_id` is not the issue:**
- V295 and all Numeracy migrations correctly populate `testlet_id` in `exam_questions`
- `ExamSnapshotService.createSnapshots` correctly propagates `testletId` from `eq.getTestletId()` into snapshots
- Column `current_testlet_id` EXISTS on `exam_sessions` (added in V50)

**Fix:** Added backfill logic to the idempotent resume path in `ExamService.startAdminExam`:

```java
if (Boolean.TRUE.equals(resume.getHasSnapshot()) && resume.getCurrentTestletId() == null) {
    List<SessionQuestionSnapshot> snaps =
        snapshotRepository.findByIdSessionIdOrderByQuestionOrder(resume.getId());
    if (!snaps.isEmpty() && snaps.get(0).getTestletId() != null) {
        resume.setCurrentTestletId(snaps.get(0).getTestletId());
        if (resume.getQuestionPath() == null || resume.getQuestionPath().isEmpty()) {
            resume.setQuestionPath(new ArrayList<>(List.of(snaps.get(0).getTestletId())));
        }
        sessionRepository.save(resume);
    }
}
```

This is a one-time self-healing repair: once saved, subsequent resumes find `currentTestletId != null` and the backfill does not fire again. Adaptive transitions update `currentTestletId` to the new testlet, and the `!= null` guard ensures the resumed post-transition testlet is also preserved.

---

## Session State After Fix

| Scenario | CURRENT_TESTLET_ID |
|---|---|
| New session (initial node) | Testlet A UUID (first ordered snapshot's testletId) |
| Resumed session (null backfilled) | Testlet A UUID (backfilled from first snapshot, then persisted) |
| Resumed session (already set) | Unchanged — persisted value is authoritative |
| After adaptive transition (A → B) | Testlet B UUID |
| Resumed after transition | Testlet B UUID (preserved, backfill guard does not fire) |

---

## Test Results

| Suite | Tests | Result |
|---|---|---|
| `examPlayerUtils.test.ts` (new) | 12 | PASS |
| `audioMimeType.test.ts` | 7 | PASS |
| `authStore.test.ts` | 7 | PASS |
| **Frontend total** | **26** | **PASS** |
| `ActiveExamPathTest` (3 new + 3 existing) | 6 | PASS |
| `ExamStartIdempotencyTest` | 3 | PASS |
| `SessionSnapshotTest` | 8 | PASS |
| `BranchingEngineTest` | 5 | PASS |
| **Backend unit total** | **22** | **PASS** |
| Backend integration (Docker required) | 4 | ERROR (Docker not available locally — pre-existing) |

| Field | Value |
|---|---|
| BACKEND_TESTS | PASS (unit) |
| FRONTEND_TESTS | PASS |
| FRONTEND_TYPECHECK | PASS |

---

## Domain Regression Status

| Domain | Renderer | Defect A | Defect B |
|---|---|---|---|
| Y7_NUMERACY | Domain-aware text input | FIXED | FIXED |
| Y9_NUMERACY | Domain-aware text input | FIXED | FIXED |
| SPELLING | Spelling-specific copy preserved | NOT AFFECTED | NOT AFFECTED |
| READING | Neutral text input (unchanged) | NOT AFFECTED | NOT AFFECTED |
| WRITING | Neutral text input (unchanged) | NOT AFFECTED | NOT AFFECTED |
| GRAMMAR | Neutral text input (unchanged) | NOT AFFECTED | NOT AFFECTED |

---

## Files Changed

| File | Change |
|---|---|
| `frontend/src/features/exam/ExamPlayer.tsx` | Domain-aware SHORT_ANSWER copy; uses `examPlayerUtils` |
| `frontend/src/utils/examPlayerUtils.ts` | New utility: `shortAnswerPlaceholder`, `showSpellingHint` |
| `frontend/src/utils/examPlayerUtils.test.ts` | 12 regression tests |
| `backend/.../exam/service/ExamService.java` | Backfill `currentTestletId` on resume when null |
| `backend/.../exam/ActiveExamPathTest.java` | 3 new regression tests for backfill + transition |

---

## Final Gate

| Condition | Status |
|---|---|
| New session has valid `currentTestletId` | PASS (existing logic, confirmed by SessionSnapshotTest) |
| Resumed session restores `currentTestletId` | PASS (backfill fix + new test) |
| Active path returned, not full 128-question pool | PASS |
| Adaptive transition updates `currentTestletId` | PASS (BranchingEngineTest + new transition test) |
| Transitioned session resumes correctly | PASS (backfill guard: if != null, no overwrite) |
| Numeracy uses correct renderer | PASS (domain-aware utility) |
| Spelling copy only appears for Spelling | PASS |
| Frontend tests | PASS (26/26) |
| Backend unit tests | PASS (22/22) |
| CI | PENDING (commit not yet pushed) |
| UAT E2E | PENDING (UAT deployment pending CI) |

**NUMERACY_EXAM_ENGINE_READY = PENDING CI + UAT**
