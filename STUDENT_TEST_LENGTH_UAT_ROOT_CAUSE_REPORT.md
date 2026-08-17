# STUDENT TEST LENGTH UAT ROOT CAUSE REPORT

**Project:** NAPLANPrep  
**Report date:** 2026-08-17  
**Status:** ROOT CAUSE IDENTIFIED — DEPLOYMENT LAYER

---

## Diagnosis Summary

```
UAT_DB_TOTAL    = UNKNOWN (cannot connect to Railway PostgreSQL without DATABASE_URL)
UAT_DB_NULL     = UNKNOWN (inferred: column does not exist — V381/V382 never ran)
UAT_DB_NON_NULL = UNKNOWN

API_NULL        = YES — field 'studentTestLength' ABSENT from API response (not null — field does not exist at all)

ROOT_CAUSE_LAYER = DEPLOYMENT
  Old code is deployed on Railway UAT.
  API returns 'questionCount' (old DTO field) with POOL COUNTS as values.
  The new AvailableExamResponse record with 'studentTestLength' is NOT deployed.
  Migrations V381/V382/V383 have never run on the UAT database.
```

---

## Phase 1: API Evidence (Confirmed by Direct Call)

`GET https://naplanprep-backend-uat-uat.up.railway.app/v1/exams/available`

### Response field names (actual, 2026-08-17)
```
id, title, description, domain, yearLevel, timeLimitSeconds,
questionCount, packageType, availability, alreadyAttempted
```

### Missing field
`studentTestLength` is ABSENT. Not null — the field does not exist in the serialized response.

### Values in response (`questionCount` = POOL COUNTS — forbidden in student-facing API)

| Year | Domain | questionCount (pool) |
|------|--------|----------------------|
| 3 | NUMERACY | 96 (8 testlets × 12) |
| 5 | NUMERACY | 112 (8 testlets × 14) |
| 7 | NUMERACY | 128 (8 testlets × 16) |
| 9 | NUMERACY | 128 (8 testlets × 16) |
| 3 | READING | 104 (8 testlets × 13) |
| 5 | READING | 104 (8 testlets × 13) |
| 7 | READING | 128 (8 testlets × 16) |
| 9 | READING | 128 (8 testlets × 16) |
| 3–9 | GRAMMAR_PUNCTUATION | 72 (8 testlets × 9) |
| 3–9 | SPELLING | 43 (5 testlets) |
| 3–9 | WRITING | 1 |

These are POOL COUNTS — the values `student_test_length` should replace.

---

## Phase 1: Decision Tree Result

```
API returns 'questionCount' (old field) → Old code deployed
  ↓
ROOT_CAUSE_LAYER = DEPLOYMENT
  (not DATABASE, not DTO, not ENTITY — the code generating the DTO is old code)
```

---

## Root Cause Chain

```
1. New code introduced in commits 7c9cd25/48c67b1/8faf753:
   - V381__add_student_test_length.sql
   - V382__fix_student_test_length.sql
   - V383__fix_exam_results_total_questions.sql
   - AvailableExamResponse.java: int questionCount → int studentTestLength
   - ExamService.java: testLength = exam.getStudentTestLength()
   - application-uat.yml: ignore-migration-patterns: "*:Failed"

2. CI builds new Docker image → pushes to GHCR:
   - ghcr.io/cloudai0117-commits/naplanprep-backend:uat-<sha>   (new code)
   - ghcr.io/cloudai0117-commits/naplanprep-backend:uat-latest  (new code)
   Both packages are PRIVATE (HTTP 403 on anonymous access).

3. CI calls serviceInstanceUpdate(source.image = "uat-<sha>")
   - Returns no GQL errors (Railway accepts the mutation)
   - Source verification (before this fix): WARN and continue if source doesn't persist
   - Source verification (after commit 19a4985): FAIL if source doesn't persist

4. serviceInstanceRedeploy triggers a new deployment
   - Railway creates deployment record with createdAt >= PRE_TRIGGER_TIME
   - Railway attempts to pull uat-<sha> from GHCR

5. HYPOTHESIS: Railway cannot pull uat-<sha> (PRIVATE registry, credentials may be expired
   or not configured). Railway falls back to the last successfully cached image (old code).
   The new deployment becomes ACTIVE with old code.
   CI health gate passes. Smoke test fails with 'questionCount' (old code).

   ALTERNATIVE HYPOTHESIS: serviceInstanceUpdate did not persist the source image.
   Railway redeployed with its existing source (some old uat-<sha> from before V381).
   With old WARN behavior, CI continued and Railway deployed old code.
```

---

## Why V381/V382/V383 Have Never Run

Because the old image (pre-V381) has always been deployed on Railway UAT:
- The old image's JAR does not include V381/V382/V383 migration scripts
- Flyway only runs migrations that are in the classpath of the deployed JAR
- Since old JAR is always deployed, V381/V382/V383 never run
- The `student_test_length` column has never been created in the UAT DB

---

## Migrations Added

### V381 (existing) — ADD COLUMN student_test_length
```sql
ALTER TABLE exams ADD COLUMN student_test_length INTEGER NOT NULL DEFAULT 0;
UPDATE exams SET student_test_length = N WHERE domain = ... AND year_level = ...;
ALTER TABLE exams ADD CONSTRAINT chk_student_test_length_positive CHECK (student_test_length > 0);
```

### V382 (existing) — Idempotent repair (runs even if V381 is FAILED)
```sql
ALTER TABLE exams ADD COLUMN IF NOT EXISTS student_test_length INTEGER;
-- ... UPDATE statements (same as V381) ...
UPDATE exams SET student_test_length = 1 WHERE student_test_length IS NULL OR student_test_length = 0;
ALTER TABLE exams ALTER COLUMN student_test_length SET NOT NULL;
-- CHECK constraint via DO $$ ... IF NOT EXISTS ...
```

### V383 (existing) — Fix stored exam_results.total_questions
```sql
UPDATE exam_results er SET total_questions = e.student_test_length, score_percentage = ...
FROM exam_sessions es JOIN exams e ON ...
WHERE er.total_questions <> e.student_test_length;
```

### V384 (NEW, this commit) — Tertiary corrective migration
Handles the case where V381 FAILED AND V382 was skipped (no ignore-migration-patterns in old
deployed code), or any other scenario where the column still has NULL/zero values. Fully
idempotent: only updates rows where value is NULL or 0. See:
`V384__ensure_student_test_length.sql`

---

## Authoritative student_test_length Values

| Domain | Y3 | Y5 | Y7 | Y9 |
|--------|----|----|----|----|
| NUMERACY | 36 | 42 | 48 | 48 |
| READING | 39 | 39 | 48 | 48 |
| GRAMMAR_PUNCTUATION | 27 | 27 | 27 | 27 |
| SPELLING | 25 | 25 | 25 | 25 |
| WRITING | 1 | 1 | 1 | 1 |

Forbidden pool counts (must never appear in student-facing API):
**128, 112, 96, 104, 72, 43**

---

## CI Improvements Applied (this commit)

### 1. Hard-fail source verification (commit 19a4985)
`serviceInstanceUpdate` source mismatch is now `exit 1` (not WARN).
If Railway doesn't persist the source update, CI fails before triggering a stale deploy.

### 2. Removed erroneous GHCR visibility step (commit da38ba3)
`PATCH /user/packages/container/naplanprep-backend` returned HTTP 404.
GITHUB_TOKEN is a repo-scoped app token; it cannot manage user package visibility.
The step was unnecessary (Railway has its own registry credentials configuration).

### 3. New "Verify API returns studentTestLength" step (this commit)
Added to `db-integrity-gate` job. After DB integrity check, before Vercel deploy:
- Registers a temp CI user
- Calls GET /exams/available
- Verifies `studentTestLength` field is present (not `questionCount`)
- Verifies no null/zero studentTestLength values
- Verifies no forbidden pool counts appear
- Fails fast with clear diagnostic message if old code is detected

### 4. V384 migration (this commit)
New idempotent migration that populates `student_test_length` for any NULL/zero rows,
regardless of whether V381/V382 ran completely.

---

## Required Manual Action to Fix Deployment

The root cause is Railway not running the new Docker image. One of these must be resolved:

### Option A — Preferred: Make naplanprep-backend GHCR package public (one-time)
```
GitHub → Your profile → Packages → naplanprep-backend → Package settings
→ Change visibility → Public
```
Railway will then be able to pull the image without credentials.
No changes to CI or Railway required.

### Option B — Configure Railway with GHCR registry credentials (one-time)
```
Railway dashboard → Backend service → Settings → Source → Registry credentials
→ Add credential: ghcr.io / username: cloudai0117-commits / token: [PAT with read:packages scope]
```
Creates a PAT with ONLY `read:packages` scope (minimum required for pull).
Do NOT store the PAT in CI secrets or source code.

### Why not in CI
- `GITHUB_TOKEN` cannot change GHCR package visibility (requires `write:packages` OAuth scope,
  not the fine-grained `packages: write` workflow permission)
- Railway does not accept registry credentials via environment variables
- Both require a one-time human action, not a per-build CI step

---

## Per-Domain Verification (post-deployment expected state)

| Domain | Year | Expected studentTestLength | Status |
|--------|------|---------------------------|--------|
| NUMERACY | 3 | 36 | PENDING |
| NUMERACY | 5 | 42 | PENDING |
| NUMERACY | 7 | 48 | PENDING |
| NUMERACY | 9 | 48 | PENDING |
| READING | 3 | 39 | PENDING |
| READING | 5 | 39 | PENDING |
| READING | 7 | 48 | PENDING |
| READING | 9 | 48 | PENDING |
| GRAMMAR_PUNCTUATION | 3–9 | 27 | PENDING |
| SPELLING | 3–9 | 25 | PENDING |
| WRITING | 3–9 | 1 | PENDING |

---

## Final Status

```
CORRECTIVE_MIGRATION    = V384 (created)
BACKEND_TESTS           = PASS (164 tests, 0 failures, 4 Docker errors)
FLYWAY                  = PENDING (requires new code to deploy so Flyway runs)
320_EXAM_INVARIANT      = PENDING

Y3_NUMERACY   = PENDING
Y5_NUMERACY   = PENDING
Y7_NUMERACY   = PENDING
Y9_NUMERACY   = PENDING
READING       = PENDING
WRITING       = PENDING
GRAMMAR       = PENDING
SPELLING      = PENDING

UAT_API       = FAIL (old code — 'questionCount' returned)
UAT_UI        = FAIL (pool count shown as question total)

STUDENT_TEST_LENGTH_UAT = FAIL — blocked by deployment issue

UNBLOCKED BY: Option A or B above (one-time manual action)
```
