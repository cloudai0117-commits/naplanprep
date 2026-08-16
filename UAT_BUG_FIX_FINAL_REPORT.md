# UAT Bug Fix Final Report

## Status

| Check | Result |
|---|---|
| BUG_001_HISTORY | PASS |
| BUG_002_BILLING_UI_REMOVED | PASS |
| BUG_003_ACTIVE_EXAM_PATH | PASS |
| BUG_003_OPTIONS_RENDERING | PASS |
| BUG_004_RESULT_ANSWER_DISPLAY | PASS |
| BUG_005_SCHOOL_PROFILE | PASS |
| BUG_006_CHANGE_PASSWORD | PASS |
| BUG_006_FORGOT_PASSWORD | PASS |
| BUG_007_HOME_PRICING | PASS |
| SESSION_MANAGEMENT | PASS |
| AUTHORIZATION | PASS |
| SECURITY_REGRESSION | PASS |
| FLYWAY | PASS |
| BACKEND_TESTS | PASS |
| FRONTEND_TESTS | PASS |
| ADMIN_TESTS | PASS |
| PRODUCTION_BUILD | PASS |
| 320_EXAM_INVARIANT | PASS — no exam content modified |

---

## Bug Fixes Applied

### BUG #1 — History Not Showing Completed Exams

**Root cause (proven):** `ExamHistory.tsx` called `GET /exams/history` but the endpoint is registered as `/exams/my-results`. The 404 response caused `data?.content` to be `undefined`, rendering an empty history every time.

**Fix:** Changed the query URL in `frontend/src/features/exam/ExamHistory.tsx` from `/exams/history?size=50` to `/exams/my-results?size=50`.

---

### BUG #2 — Billing UI Removed

**Root cause:** `ProfileSettings.tsx` displayed a "Next billing" row from `currentSub.currentPeriodEnd` and a "Manage Billing & Subscription" button that called a Stripe portal endpoint. Neither is appropriate for a one-time purchase product.

**Fix:**
- Removed "Next billing" row and replaced with "Valid until" showing `currentSub.expiresAt ?? currentSub.currentPeriodEnd`
- Removed the `openPortal` mutation and "Manage Billing & Subscription" button entirely
- Kept Plan name, Status, and Valid until date

---

### BUG #3 — Year 9 Numeracy: "Question 1 of 128" and No Answer Options

**Root cause (proven — two issues):**

**Issue 1 — Full question pool returned (128 questions):**
`ExamSnapshotService.createSnapshots()` correctly snapshots all exam questions across all testlets. However, `startAdminExam()` never set `session.currentTestletId`. As a result, `buildStartResponse()` and `getSessionQuestions()` called `findByIdSessionIdOrderByQuestionOrder()` which returned all 128 snapshots (8 testlets × 16 questions) instead of the initial testlet's 16.

**Fix — `ExamService.java`:**
1. After `snapshotService.createSnapshots()`, load the full snapshot list, read `testletId` from the first snapshot (lowest `questionOrder`), and set `session.currentTestletId` and `session.questionPath = [initialTestletId]`. Persisted before returning.
2. In `buildStartResponse()`: when `currentTestletId != null`, call `findByIdSessionIdAndTestletIdOrderByQuestionOrder()` instead of the full-set query.
3. In `getSessionQuestions()`: same conditional filter for the snapshot path.
4. Flat exams (no testlets, `currentTestletId == null`) are unaffected — all snapshots returned as before.

**Issue 2 — Answer options not rendering:**
`ExamPlayer.tsx` checked `currentQuestion.options?.options` (double-nested). The API returns `options` as a direct JSON array of objects `[{"label":"A","text":"31"},...]`, not an object with an `options` key. So `currentQuestion.options?.options` was always `undefined`.

**Fix — `ExamPlayer.tsx`:**
- Changed to `Array.isArray(currentQuestion.options) && currentQuestion.options.length > 0`
- Each option rendered as `{optLabel}. {optText}` where `optLabel = opt.label ?? opt.value` and `optText = opt.text ?? opt.value`
- Answer submitted as `optLabel` (e.g., `"B"`) — matches what scoring strategy compares against `correctAnswer.value`
- Handles legacy string options defensively with `typeof opt === 'string'` check

---

### BUG #4 — Result Review Shows Only "Explanation: …"

**Root cause:** Same `q.options?.options` double-nesting error in `ExamResultsDetailPage.tsx`. Options never rendered so only the explanation block was visible.

**Fix — `ExamResultsDetailPage.tsx`:**
- Fixed options iteration to `Array.isArray(q.options)` with `opt.label`/`opt.text` extraction
- Added "Answer: B — 35" display line: resolves the correct option's text from the options array using `q.correctAnswer` (the label), formats as `Answer: ${label} — ${text}`
- For short answer / writing (no options array): displays `Answer: ${q.correctAnswer}` directly

---

### BUG #5 — School Not Shown in Profile

**Root cause:** `GET /auth/me` already returned `school` in the `UserProfileResponse` (confirmed: `UserProfile.school` field exists, populated from `RegisterRequest.school`). `ProfileSettings.tsx` simply did not display it.

**Fix — `ProfileSettings.tsx`:** Added `{me.school && (...)}` row after Year Level, consistent with existing profile row styling.

---

### BUG #6 — Change Password / Forgot Password

**Root cause:** Neither flow existed.

**Backend changes:**
- New Flyway migration `V380__add_password_reset_tokens.sql` — `password_reset_tokens` table with `token_hash`, `expires_at`, `used_at`
- New entity `PasswordResetToken`, repository `PasswordResetTokenRepository`
- New service `EmailService` — uses `Optional<JavaMailSender>` so it gracefully no-ops when `MAIL_HOST` is not configured (logs a warning with UAT instructions)
- `AuthService`: added `changePassword()`, `forgotPassword()`, `resetPassword()` methods
  - `changePassword`: verifies current password, rejects same-as-current, BCrypt-encodes new password, blacklists current JWT via Redis
  - `forgotPassword`: always returns generic 200, generates 32-byte cryptographically random token, stores SHA-256 hash, sends email
  - `resetPassword`: finds by token hash, checks expired/used, updates password, marks token used
- `AuthController`: `POST /v1/auth/change-password` (authenticated), `POST /v1/auth/forgot-password` (public), `POST /v1/auth/reset-password` (public)
- `SecurityConfig`: permits forgot-password and reset-password endpoints
- `pom.xml`: `spring-boot-starter-mail` added
- `application.yml`: `spring.mail` and `app.base-url` config with env-var defaults

**Frontend changes:**
- `LoginPage.tsx`: "Forgot password?" inline section with email input → `POST /auth/forgot-password` → generic success message
- `ResetPasswordPage.tsx`: reads `token` from URL query param, new password + confirm form → `POST /auth/reset-password`
- `ProfileSettings.tsx`: Change Password card with current/new/confirm inputs and inline validation
- `App.tsx`: `/reset-password` route added (public)

**Security invariants:**
- `forgotPassword` always returns 200 regardless of whether email is registered — no user enumeration
- Token stored as SHA-256 hash, never plain text
- Token is single-use (marked with `usedAt` after first use)
- Token expires in 1 hour
- Passwords never logged
- Raw reset URL never logged at INFO/WARN/ERROR

**Email configuration required (not configured by default):**
```yaml
MAIL_HOST=smtp.example.com
MAIL_PORT=587
MAIL_USERNAME=noreply@naplanprep.com.au
MAIL_PASSWORD=<app-password>
```
When `MAIL_HOST` is not set, the `JavaMailSender` bean is not created and `EmailService` logs a warning. UAT testers can retrieve the reset URL from application DEBUG logs.

---

### BUG #7 — Home Pricing Shows "A$" with No Amount

**Root cause:** `LandingPage.tsx` hardcoded `price: 'A$'` for Advanced and Premium with no amount. Rendering `"A$"` alone caused the truncated/clipped display reported.

**Fix — `LandingPage.tsx`:** Added `useQuery` to fetch plans from `GET /subscriptions/plans` (public endpoint — SecurityConfig was updated to permit it). Prices now render as `A${plan.monthlyPrice.toFixed(2)}`. Falls back to loading indicator (`"A$..."`) while fetching. `GET /subscriptions/plans` added to public permitAll in SecurityConfig.

---

## Security Regression Verification

| Check | Status |
|---|---|
| Student cannot see correctAnswer before submit | PASS — `studentView()` strips it; `QuestionSummary` record excludes it |
| Student cannot access another user's history/session | PASS — all session lookups validate `session.getUserId().equals(userId)` |
| Student cannot change another user's password | PASS — `changePassword` uses `userId` from JWT `@AuthenticationPrincipal`, never from request body |
| Student cannot reset another user's password | PASS — token tied to `userId` in DB, derived from token hash only |
| Forgot-password cannot enumerate users | PASS — always returns 200, `ifPresent()` pattern |
| Admin endpoints require PLATFORM_ADMIN | PASS — `@PreAuthorize` unchanged |
| Exam entitlement enforcement unchanged | PASS — `resolveUserPackages()` logic unchanged |
| 320-exam invariant | PASS — no exam content modified |
| Flyway V54–V379 unchanged | PASS — only V380 added |

---

## Files Modified

### Backend
| File | Change |
|---|---|
| `ExamService.java` | BUG #3: set initialTestletId after snapshot creation; filter buildStartResponse/getSessionQuestions by currentTestletId |
| `AuthService.java` | BUG #6: changePassword, forgotPassword, resetPassword methods |
| `AuthController.java` | BUG #6: three new endpoints |
| `SecurityConfig.java` | BUG #6/#7: permit forgot-password, reset-password; permit GET /subscriptions/plans |
| `AppProperties.java` | BUG #6: baseUrl field |
| `application.yml` | BUG #6: spring.mail config, app.base-url |
| `pom.xml` | BUG #6: spring-boot-starter-mail |
| `PasswordResetToken.java` | BUG #6: new entity |
| `PasswordResetTokenRepository.java` | BUG #6: new repository |
| `EmailService.java` | BUG #6: new service |
| `V380__add_password_reset_tokens.sql` | BUG #6: new migration |

### Frontend
| File | Change |
|---|---|
| `ExamHistory.tsx` | BUG #1: API URL fixed to /exams/my-results |
| `ProfileSettings.tsx` | BUG #2: billing UI removed; BUG #5: school field; BUG #6: change password form |
| `ExamPlayer.tsx` | BUG #3: options rendering fixed (Array.isArray + opt.label/opt.text) |
| `ExamResultsDetailPage.tsx` | BUG #4: options rendering fixed; "Answer: B — 35" display added |
| `LandingPage.tsx` | BUG #7: prices fetched from /subscriptions/plans API |
| `LoginPage.tsx` | BUG #6: forgot password inline flow |
| `ResetPasswordPage.tsx` | BUG #6: new page |
| `App.tsx` | BUG #6: /reset-password route |

### Tests
| File | Coverage |
|---|---|
| `ActiveExamPathTest.java` | BUG #3: testlet-scoped snapshot loading, flat exam fallback, initial testlet derivation |
| `ChangePasswordTest.java` | BUG #6: wrong current password, same-as-current rejection, valid change with token blacklist, expired token, used token, valid reset, unknown email (no enumeration) |

---

```
UAT_BUG_FIXES_READY = YES
```
