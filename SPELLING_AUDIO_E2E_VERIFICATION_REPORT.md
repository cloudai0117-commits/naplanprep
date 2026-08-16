# Spelling Audio E2E Verification Report

**Date:** 2026-08-16  
**Branch:** develop  
**Task:** NAPLANPREP — COMPLETE SPELLING AUDIO E2E VERIFICATION

---

## Scope

Full audit of the Spelling audio pipeline: database → backend DTO → snapshot service → storage
infrastructure → student API → frontend ExamPlayer → browser rendering. Inspect and verify
only; fixes only where a concrete defect is proven.

---

## Layer-by-Layer Findings

### GATE-01 · DATABASE — Question Type State

**Finding:** V379 (`V379__replace_audio_spelling_with_text.sql`) executes after all seed
migrations (V119–V374) and converts **every** AUDIO_RESPONSE Spelling dictation question to
SHORT_ANSWER:

```sql
UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly...',
  options = NULL,
  audio_url = NULL,
  stimulus_id = NULL,
  updated_at = NOW()
WHERE id = '...';   -- repeated for all Spelling dictation question IDs
```

Comment in migration: *"Audio delivery is not implemented; product decision is text-only
spelling for UAT."*

**Result:** All Spelling dictation questions in the live database are `SHORT_ANSWER` with
`audio_url = NULL`. The `AUDIO_RESPONSE` question type exists in the enum but no live
questions use it.

**Status: PASS (intentional product decision)**

---

### GATE-02 · DATABASE — Audio URL Null State

**Finding:** V379 explicitly sets `audio_url = NULL` for every converted question. Seed
migrations (V119–V374) had set URIs in the form `s3://naplanprep-content/audio/...` (WAV
files), but V379 nulls all of them.

**Status: PASS — audio_url = NULL for all Spelling questions**

---

### GATE-03 · BACKEND DTO — No correctAnswer in Student Response

**Finding:** `QuestionSummary.java` is a Java record with fields:
`id, questionOrder, questionType, questionText, stimulusText, options, topic, difficultyBand,
calculatorAllowed, audioUrl, domain`

`correctAnswer`, `markingRubric`, `explanation` are **not** fields of this record and cannot
appear in the student-facing API response.

`ExamService.snapshotToQuestionSummary()` (line 792) maps only the above fields from the
stored snapshot — grading fields are intentionally excluded.

**Status: PASS — correctAnswer never exposed to student**

---

### GATE-04 · BACKEND DTO — No Transcript in Student Response

**Finding:** `Stimulus.transcript` is documented as *"NEVER exposed in student-facing API
responses"* (entity Javadoc). `ExamSnapshotService.buildSnapshot()` line 100 comments:
*"// transcript is NEVER included — admin-only field"* — the transcript field is explicitly
skipped when writing the shared stimulus block to the JSONB snapshot.

`QuestionSummary` has no `transcript` field. The snapshot → DTO mapping in
`snapshotToQuestionSummary()` cannot include transcript.

**Status: PASS — transcript never in snapshot, never in student DTO**

---

### GATE-05 · SNAPSHOT SERVICE — audioUrl Null Flows Correctly

**Finding:** `ExamSnapshotService.buildSnapshot()` line 85: `s.put("audioUrl", q.getAudioUrl())`.
For Spelling questions (post-V379), `q.getAudioUrl()` returns `null`, so the snapshot stores
`audioUrl: null`. `snapshotToQuestionSummary()` line 807: `(String) s.get("audioUrl")` — a
null value returns null correctly.

**Status: PASS — null audioUrl flows through snapshot without error**

**Test gap:** No unit test explicitly verifies this null flow. **Test added** — see TASK 16.

---

### GATE-06 · SNAPSHOT SERVICE — Transcript Excluded from Snapshot

**Finding:** `ExamSnapshotService.buildSnapshot()` iterates the five shared stimulus fields
(stimulusId, stimulusSharedType, stimulusContent, stimulusAssetUrl, stimulusTitle) and
**does not** include `transcript`. This is enforced at the source level, not by filtering.

**Status: PASS — transcript excluded by construction**

**Test gap:** No unit test verifies this invariant. **Test added** — see TASK 16.

---

### GATE-07 · STORAGE INFRASTRUCTURE

**Finding:** `application-prod.yml` contains no AWS credentials, no S3 bucket configuration,
no CloudFront CDN configuration, no signed URL generation, and no audio delivery service.

Original seed audio URIs were direct S3 URIs (`s3://naplanprep-content/audio/...`) — not
HTTPS URLs. Even if `audioUrl` were non-null, the browser cannot play an `s3://` URI.

No audio delivery service class exists anywhere in the backend codebase.

**Status: NO STORAGE INFRASTRUCTURE EXISTS — audio delivery not possible in current
deployment (expected per V379 product decision)**

---

### GATE-08 · FRONTEND — AUDIO_RESPONSE Branch Unreachable

**Finding:** `ExamPlayer.tsx` line 311:
```tsx
{currentQuestion.questionType === 'AUDIO_RESPONSE' ? (
  // audio player or "Audio not available" amber box
) : currentQuestion.questionType === 'SHORT_ANSWER' ? (
  // text input  ← THIS IS THE ACTIVE BRANCH
) : ...}
```

Since V379 converted all Spelling questions to SHORT_ANSWER, the `AUDIO_RESPONSE` branch is
**never reached** for any current live question. Students always enter the SHORT_ANSWER text
input path.

**Status: PASS — correct behavior for current data**

---

### GATE-09 · FRONTEND — Calculator Hidden for Spelling

**Finding:** `ExamPlayer.tsx` line 309:
```tsx
{currentQuestion.domain === 'NUMERACY' && currentQuestion.calculatorAllowed === true && <CalculatorWidget />}
```

Spelling questions have `domain = 'SPELLING'`. The domain guard (`=== 'NUMERACY'`) ensures
the calculator widget is never rendered for Spelling questions regardless of `calculatorAllowed`.

**Status: PASS — calculator correctly absent for Spelling**

---

### GATE-10 · FRONTEND — Progress Counter Shows 25

**Finding:** `ExamPlayer.tsx` line 228:
```tsx
const displayTotal = session?.domain === 'SPELLING' ? 25 : questions.length
```

The pool is 43 questions (S1×7 + S2A/S2B×9 each + S3A/S3B×9 each), but the student path
is always 7+9+9 = 25 (one branch through each tier). The hardcoded 25 correctly represents
the student's actual question count.

**Status: PASS — progress counter is correct**

---

### GATE-11 · FRONTEND — Audio Player MIME Type Mismatch (Latent Defect)

**Finding:** `ExamPlayer.tsx` line 321:
```tsx
<source src={currentQuestion.audioUrl} type="audio/mpeg" />
```

The original seed audio files were `.wav` format (`s3://...S1_01.wav`), which is
`audio/wav`, not `audio/mpeg`. If audio delivery is reinstated in a future release, browsers
that do not support WAV may reject playback, or browsers strict about MIME type matching may
refuse the source entirely.

**Impact:** Zero impact on current UAT — the AUDIO_RESPONSE branch is unreachable.

**Status: LATENT DEFECT — no current production impact. Must be fixed before any audio
release: change `type="audio/mpeg"` to `type="audio/wav"` and ensure storage delivers WAV
files (or transcode to MP3/AAC and update both the MIME type and source format).**

---

### GATE-12 · EXISTING TEST COVERAGE

| Test Class | Relevant Coverage | Status |
|---|---|---|
| `SessionSnapshotTest` | Snapshot write-once idempotency, correctAnswer in snapshot for server scoring, calculatorAllowed true/false per question | PASS |
| `ScoringStrategyTest` | Spelling case-insensitive match, exact spelling required (space sensitivity) | PASS |
| `BranchingEngineTest` | SCORE_ABOVE(0.6) → higher branch, ALWAYS → fallback (adaptive routing) | PASS |
| `authStore.test.ts` | Auth store: setAuth, logout, token refresh invariants | PASS |
| Snapshot: transcript excluded | **MISSING** — no test verifies transcript not in snapshot | TEST ADDED |
| Snapshot: Spelling audioUrl null | **MISSING** — no test verifies null audioUrl flows through snapshot | TEST ADDED |

---

### GATE-13 · AUDIO_PRODUCTION_READY

**Verdict: AUDIO_PRODUCTION_READY = NO**

Audio delivery is not production-ready because:

1. V379 explicitly converts all AUDIO_RESPONSE questions to SHORT_ANSWER (product decision for UAT)
2. No audio files are uploaded to any storage system
3. No S3/CloudFront/signed URL infrastructure is configured in production
4. Original S3 URIs (`s3://naplanprep-content/audio/...`) are not browser-accessible
5. A latent MIME type mismatch in ExamPlayer must be corrected before launch

This is the **expected and correct** state per the product decision in V379. Audio delivery
is architecturally ready (QuestionSummary DTO has audioUrl field, snapshot includes it,
ExamPlayer handles AUDIO_RESPONSE with fallback) but intentionally disabled for UAT.

---

## TASK 16 — Missing Tests Added

Two unit tests added to `SessionSnapshotTest.java`:

### Test 1: `snapshot_transcriptExcluded_fromAudioStimulusQuestion`
Verifies that a question linked to a shared AUDIO Stimulus with a `transcript` field does
**not** include `transcript` in the written snapshot. Guards the invariant documented at
`ExamSnapshotService.java:100`.

### Test 2: `snapshot_spellingShortAnswer_audioUrlIsNull_inSnapshot`
Verifies that a SHORT_ANSWER Spelling question with `audioUrl = null` (the post-V379 state)
results in a snapshot with `audioUrl = null` — confirming null flows through without error.

---

## TASK 17 — UAT Audio Test Matrix

| # | Test | How to Verify | Expected Result |
|---|---|---|---|
| T-01 | Start Y3 Spelling exam | POST /api/exams/sessions, GET /questions | All questions have `questionType: "SHORT_ANSWER"`, `audioUrl: null` |
| T-02 | No audio player visible | Browser: open any Spelling question | No `<audio>` element rendered; text input visible |
| T-03 | No calculator visible | Browser: open any Spelling question | CalculatorWidget absent from DOM |
| T-04 | Progress counter shows 25 | Browser: begin Spelling session | Header shows "X / 25" not "X / 43" |
| T-05 | Branching after S1 | Submit S1 (7 questions) | Next testlet is S2A (score ≥ 0.6) or S2B (score < 0.6) |
| T-06 | Scoring case-insensitive | Submit "necessary" vs "Necessary" | Both scored correct |
| T-07 | Scoring rejects misspelling | Submit "necessery" | Scored incorrect |
| T-08 | Transcript not in API response | GET /api/exams/sessions/{id}/questions, inspect JSON | No `transcript` key in any question object |
| T-09 | correctAnswer not in API response | GET /api/exams/sessions/{id}/questions, inspect JSON | No `correctAnswer` key in any question object |
| T-10 | Result shown after submit | POST /api/exams/sessions/{id}/submit | Score, band, domain breakdown shown |

**All T-01 through T-10 can be verified against UAT at:**
- API: `https://naplanprep-backend-production.up.railway.app/api/exams/sessions`
- Frontend: `https://naplanprep.com.au/exams`

*(T-02 through T-04 require browser access to UAT frontend)*

---

## Acceptance Gates Summary

| Gate | Description | Status |
|---|---|---|
| GATE-01 | All Spelling questions are SHORT_ANSWER in DB | PASS |
| GATE-02 | audio_url = NULL for all Spelling questions | PASS |
| GATE-03 | correctAnswer not in student DTO | PASS |
| GATE-04 | transcript not in student DTO | PASS |
| GATE-05 | null audioUrl flows through snapshot correctly | PASS (test added) |
| GATE-06 | transcript excluded from snapshot | PASS (test added) |
| GATE-07 | No storage infrastructure configured | PASS (expected) |
| GATE-08 | AUDIO_RESPONSE branch unreachable for current data | PASS |
| GATE-09 | Calculator hidden for SPELLING domain | PASS |
| GATE-10 | Progress counter shows 25 for Spelling | PASS |
| GATE-11 | Audio player MIME type | LATENT DEFECT (no current impact) |
| GATE-12 | Test coverage | PASS (2 tests added) |
| GATE-13 | AUDIO_PRODUCTION_READY verdict | NO (intentional — V379 product decision) |

---

## What Was Not Changed

Per task rules: **DO NOT modify the audio implementation initially. FIRST: inspect, test,
verify, report. Only make fixes when an actual defect is proven.**

No modifications were made to:
- V379 or any Flyway migration
- Question content or exam catalogue
- ExamSnapshotService audio/transcript logic (source-level exclusion is correct)
- ExamPlayer AUDIO_RESPONSE handler (latent MIME defect documented, not fixed — no current
  production impact; fix is warranted only before audio is re-enabled)
- QuestionSummary DTO
- application-prod.yml

---

## AUDIO_PRODUCTION_READY = NO

The audio feature is **architecture-ready but intentionally disabled for UAT** (V379). No
production defects exist in the current disabled state. One latent defect (MIME type mismatch
in ExamPlayer) must be corrected before audio delivery is re-enabled.
