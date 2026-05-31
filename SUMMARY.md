# NAPLANPrep — Session Handover Summary

**Last updated:** 2026-05-31  
**Session work:** Bug fixes, UAT deployment, test suite stabilisation

---

## Environment URLs

| Service | URL |
|---|---|
| Student App | https://frontend-nu-topaz-20.vercel.app |
| Admin Panel | https://admin-panel-sigma-orcin.vercel.app |
| Backend API | https://naplanprep-backend-uat-uat.up.railway.app |
| Swagger | https://naplanprep-backend-uat-uat.up.railway.app/swagger-ui.html |

## Repositories (Local)

| Repo | Local Path | Remote |
|---|---|---|
| Main app | `C:\Badal\Apps\Naplan\naplanprep` | https://github.com/cloudai0117-commits/naplanprep |
| Tests | `C:\Badal\Apps\Naplan\naplanprep-tests` | https://github.com/cloudai0117-commits/naplanprep-tests |
| Skills | `C:\Badal\Apps\Naplan\naplanprep\skills` | (same repo) |

**Deploy branch:** `develop` → pushes trigger `deploy-uat.yml` GitHub Actions workflow

---

## Credentials

| Account | Email | Password | Notes |
|---|---|---|---|
| Admin | admin@naplanprep.com.au | Admin123! | PLATFORM_ADMIN role |
| Student1 (free, Year 3) | student1@test.com | Admin123! | All 4 Year 3 exams completed — use practice fallback |
| Student2 (STANDARD, Year 5) | student2@test.com | Admin123! | **BROKEN** — has 2 ACTIVE subscriptions (V27+V28 bug) causing 500 on `/subscriptions/current` and `/exams/available`. Do NOT use until V30 deploys. |
| Student3 (free, Year 5) | student3@test.com | Admin123! | **Working proxy for Year 5 tests**. No subscription, sees all Year 5 exams as UPGRADE_REQUIRED. firstName="Badal" |

---

## Current Deployment State

### Backend (Railway) — commit 1791edd deployed

**Applied:**
- ✅ `@JsonIgnore` on `User.password` and `UserProfile.user` → fixes `/admin/users` 500 error
- ✅ `UserRepository.searchUsers` JPQL fixed (proper `countQuery`, handles empty `search` param)
- ✅ V29 migration — resets test exam sessions, seeds 15 schools (incl. Hobart College)
- ✅ V28 migration — student2 STANDARD subscription (causes duplicate, see below)

**Pending (commit ad20d41 — deployed by GitHub Actions but not confirmed):**
- ⏳ V30 migration — removes duplicate subscription for student2 (`sub_test_student2_standard`)
- ⏳ `SubscriptionRepository.findFirstByUserIdAndStatusInOrderByCreatedAtDesc` replaces `findByUserIdAndStatusIn` to handle multiple results gracefully

**To verify if ad20d41 is deployed:** Check if student2 `/subscriptions/current` returns 200 (instead of 500). If still 500, V30 hasn't run.

### Student Frontend (Vercel)
- ✅ `VITE_API_URL` = Railway URL (was broken pointing to `api.uat.naplanprep.com.au`)
- ✅ `ResultsPage.tsx` — fixed domain chart (was reading `domainBreakdown`, API returns `domainScores`)
- ✅ `ExamSelection.tsx` — removed FAMILY from tier labels/order
- ✅ `.env.uat` → `https://naplanprep-backend-uat-uat.up.railway.app/v1`

### Admin Panel (Vercel)
- ✅ `VITE_API_URL` = Railway URL (was broken)
- ✅ API interceptor — added redirect guard (prevents 401 → logout → redirect loop causing dashboard continuous refresh)
- ✅ School Management page added (route `/schools`, nav item "Schools")
- ✅ ExamForm — removed FAMILY from tier dropdown
- ✅ `.env.uat` → Railway URL

---

## Known Issues / Bug Register

See `C:\Badal\Apps\Naplan\naplanprep-tests\ISSUES.md` for full register.

### Active (needs fixing)
| ID | Severity | Description |
|---|---|---|
| student2-dup-sub | P1 | student2@test.com has 2 ACTIVE subscriptions (V27+V28 both inserted). Causes 500 on any endpoint that calls `findByUserIdAndStatusIn`. V30 migration fixes this once deployed. |
| ISS-007 | P3 | Admin exam list table occasional timeout — intermittent timing issue |
| backend-ghcr | P2 | GHCR Docker images may not always be pullable by Railway. If V30 doesn't deploy, check GitHub Actions logs and Railway dashboard. |

### Fixed in this session
- ISS-001 ✅ Stripe payment redirect URL (was naplanprep.com.au instead of Vercel URL)
- ISS-002 ✅ Year 5 student saw all year-level exams
- ISS-003 ✅ Back button not blocked during exam
- ISS-004 ✅ Dashboard completed exam missing View Results link
- ISS-005 ✅ Exam history missing `data-testid="result-row"`
- ISS-009 ✅ Results page correct answers not highlighted green
- ISS-010 ✅ Admin panel continuous refresh (401 redirect loop)
- ISS-011 ✅ Admin `/users` 500 (circular JSON serialization)
- ISS-012 ✅ Frontend/admin wrong API URL in deployed apps
- ISS-013 ✅ Results page NaN% (wrong field name)
- ISS-014 ✅ FAMILY tier in exam creation form
- ISS-015 ✅ No School Management in admin panel

---

## Test Suite

**Location:** `C:\Badal\Apps\Naplan\naplanprep-tests\playwright`  
**Run:** `npx playwright test --project=chromium`  
**Status:** 33/33 passing (as of 2026-05-31)

### Key test accounts in `.env`:
```
STUDENT_FREE_EMAIL=student1@test.com     # Year 3, no sub, all exams completed
STUDENT_STANDARD_EMAIL=student3@test.com # Year 5, no sub — proxy for Year 5 tests
ADMIN_EMAIL=admin@naplanprep.com.au
```

### Critical test design decisions:
1. **student3 as standard-student proxy**: `student2@test.com` has a duplicate subscription bug. Until V30 deploys, `student3@test.com` (Year 5, FREE tier) is used for Year 5 tests. All Year 5 exams show as UPGRADE_REQUIRED — sufficient for lock-indicator and exam-card presence tests.
2. **`loginAs` clears localStorage**: Tests in the same browser context share localStorage. `loginAs` now navigates to `/login`, clears localStorage, reloads, then fills credentials. This prevents auth state leakage between parallel tests.
3. **Practice exam fallback**: When all admin-created exams are completed for free-student (Year 3), tests fall back to the practice exam flow (`POST /exams/sessions`) which always creates a fresh session.
4. **ExamResultsDetailPage for question-review**: Results tests that need `data-testid="review-correct-answer"` must navigate to `/exams/{examId}/results/{sessionId}` (ExamResultsDetailPage), NOT `/exams/{sessionId}/results` (ResultsPage which has no question review section).

---

## Architecture Notes

### Two Results Pages (important!)
- `ResultsPage.tsx` → route `/exams/:sessionId/results` — summary only (score, band, domain chart). Used for practice exams.
- `ExamResultsDetailPage.tsx` → route `/exams/:examId/results/:sessionId` — full question review with green/red answer highlighting. Used for admin-created exams.

### Tier Naming
Database tiers: `FREE`, `STANDARD`, `PREMIUM` (FAMILY exists but deactivated in V23 migration)  
UI labels: FREE="Free", STANDARD="Premium", PREMIUM="Advanced"

### Admin Panel Auth
- Zustand persist key: `naplanprep-admin`
- Token stored in localStorage: `admin-token`  
- JWT expiry: 900 seconds (15 min)

### Student Auth
- Zustand persist key: `naplanprep-auth`

---

## Pending Work / Next Session Tasks

### High Priority
1. **Verify V30 is deployed** — check student2 `/subscriptions/current` returns 200 not 500. If not deployed, trigger Railway rebuild manually or check GitHub Actions.
2. **If V30 not deployed**: Switch `STUDENT_STANDARD_EMAIL` in `.env` back to `student2@test.com` once fixed. Update auth.ts default as well.
3. **Admin panel signup page** — user requested signup without parent (simple signup). Current `RegisterPage.tsx` already has simple signup (no parent requirement). Verify it works.

### Medium Priority
4. **Student dashboard static data** — dashboard stats (Total Exams, Avg Score, NAPLAN Band, Streak) show 0/empty for new students. The backend `/progress/overview` endpoint needs actual exam data. This is correct behaviour — stats only show after completing exams.
5. **Exam on `/exams` page for Year 5 student** — the `/exams` Practice section uses the student's registered year level automatically (`user.yearLevel`). No dropdown needed — verify this is correct.
6. **Student signup school dropdown** — `RegisterPage.tsx` has school search dropdown (`GET /schools`). Schools are now seeded (15 schools). Test the signup flow.

### Infrastructure
7. **GHCR image visibility** — ensure Railway can always pull Docker images from GHCR. If images are private, Railway needs a configured image pull secret. Check Railway dashboard → service → image configuration.
8. **`vars.UAT_API_URL` in GitHub** — update this GitHub Actions variable to `https://naplanprep-backend-uat-uat.up.railway.app/v1` so it's set correctly and the `.env.uat` fallback in `deploy-uat.yml` isn't needed.

---

## Key File Locations

### Backend
```
backend/src/main/java/au/com/naplanprep/
  auth/entity/User.java                    — @JsonIgnore on password
  auth/entity/UserProfile.java             — @JsonIgnore on user (back-ref)
  auth/repository/UserRepository.java      — searchUsers with countQuery
  subscription/repository/SubscriptionRepository.java — findFirstBy method
  subscription/service/SubscriptionService.java
  exam/service/ExamService.java            — resolveUserTier, getAvailableExams
  admin/service/AdminService.java

backend/src/main/resources/db/migration/
  V29__reset_exam_sessions_and_seed_schools.sql
  V30__fix_duplicate_student2_subscription.sql  ← pending deploy
```

### Frontend
```
frontend/src/features/
  exam/ExamSelection.tsx     — tier labels (FREE/Standard/Premium), practice exam
  exam/ResultsPage.tsx       — domain chart (uses domainScores from API)
  exam/ExamResultsDetailPage.tsx  — detailed question review
  exam/ExamPlayer.tsx        — back button block, submit navigation
  dashboard/Dashboard.tsx    — exam cards with available/completed states
  subscription/PricingPage.tsx  — family plan filtered out
  auth/pages/RegisterPage.tsx   — school dropdown with search

frontend/.env.uat → VITE_API_URL=https://naplanprep-backend-uat-uat.up.railway.app/v1
```

### Admin Panel
```
admin-panel/src/features/
  schools/SchoolManagement.tsx    — NEW: add/delete schools
  exams/ExamForm.tsx              — FAMILY removed from tiers
  auth/AdminLogin.tsx
  dashboard/AdminDashboard.tsx
  users/UserManagement.tsx

admin-panel/src/api/client.ts    — interceptor with redirect guard
admin-panel/src/components/AdminLayout.tsx  — Schools nav item added
admin-panel/.env.uat → VITE_API_URL=https://naplanprep-backend-uat-uat.up.railway.app/v1
```

### CI/CD
```
.github/workflows/
  deploy-uat.yml    — builds Docker → GHCR → Railway + Vercel deployments
  railway-quickfix.yml  — manual trigger to force Railway redeploy
```

---

## How to Run Tests

```bash
# From test repo
cd C:\Badal\Apps\Naplan\naplanprep-tests\playwright

# Full suite (chromium only)
npx playwright test --project=chromium

# Smoke tests only
npx playwright test --project=chromium --grep @smoke

# Single test
npx playwright test --project=chromium --grep "UI-ADM-01"

# Sequential (no parallelism) - most stable
npx playwright test --project=chromium --workers=1
```

## How to Deploy

```bash
# From main repo — push to develop triggers CI/CD
cd C:\Badal\Apps\Naplan\naplanprep
git add .
git commit -m "fix: description"
git push origin develop
# GitHub Actions builds Docker image → pushes to GHCR → deploys to Railway (backend) + Vercel (frontend + admin)
```

## How to Check Deployment

```bash
# Backend health
curl https://naplanprep-backend-uat-uat.up.railway.app/actuator/health

# Check if V30 migration ran (student2 subscription should be 200, not 500)
TOKEN=$(curl -s -X POST https://naplanprep-backend-uat-uat.up.railway.app/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"student2@test.com","password":"Admin123!"}' | grep -o '"accessToken":"[^"]*"' | cut -d'"' -f4)
curl -s https://naplanprep-backend-uat-uat.up.railway.app/v1/subscriptions/current \
  -H "Authorization: Bearer $TOKEN"

# Check GitHub Actions for latest deploy status
curl -s "https://api.github.com/repos/cloudai0117-commits/naplanprep/actions/runs?branch=develop&per_page=3" \
  | grep -o '"name": "[^"]*"\|"conclusion": "[^"]*"'
```
