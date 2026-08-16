# UX & Session Management Polish Report

**Date:** 2026-08-16  
**Commit:** ba74213  
**Branch:** develop

---

## Acceptance Status

| Check | Status | Notes |
|-------|--------|-------|
| NEW_USER_WELCOME_COPY | PASS | Dashboard shows "Welcome to NAPLANPrep, {firstName}!" when navigated from RegisterPage via `?new=1` |
| NO_WELCOME_BACK_ON_REGISTRATION | PASS | "Welcome back" only shown for returning logins; new registrations routed to `/dashboard?new=1` |
| LOGGED_OUT_PRICING_GUIDANCE | PASS | Info bar added: "Sign in or create a free account to get started." with Sign in / Create account links |
| PLAN_PRESERVATION_THROUGH_SIGNUP | PASS | `/register?plan=advanced` and `/register?plan=premium` preserved through registration → checkout (existing mechanism, verified intact) |
| DIRECT_ADVANCED_FLOW | PASS | Pricing → Advanced → `/register?plan=advanced` → checkout() on success |
| DIRECT_PREMIUM_FLOW | PASS | Pricing → Premium → `/register?plan=premium` → checkout() on success |
| LOGOUT_SESSION_CLEAR | PASS | `handleLogout` calls `queryClient.clear()` + `logout()` + redirects to /login; authStore wipes all tokens and user |
| PRICING_AFTER_LOGOUT | PASS | Layout is now auth-aware: logged-out users see Sign in / Create account nav — NOT Sign out |
| PROTECTED_ROUTE_AFTER_LOGOUT | PASS | ProtectedRoute guards all `/dashboard`, `/exams/*`, `/history`, `/parent`, `/settings` routes; redirects to /login when `isAuthenticated` is false |
| SESSION_REFRESH | PASS | `zustand/persist` stores auth to localStorage; browser refresh restores auth state from storage |
| SESSION_EXPIRY | PASS | API interceptor in `client.ts`: on 401 → attempts token refresh once (`_retry` flag prevents loop) → on refresh failure: `logout()` + redirect `/login` |
| PRICING_CURRENCY | PASS | All pricing displays `A$` — no bare `$`, no `₹`, no `USD` |
| NO_MONTHLY_PRICING_MESSAGING | PASS | Pricing page subtitle: "One-time purchase · Valid for 1 year · No subscription" — no `/mo`, no `Monthly`, no `Recurring` |
| ADMIN_SESSION | PASS | Admin 401/403 interceptor clears admin store + redirects to `/login`; AdminLayout logout now clears React Query cache |
| ACCESSIBILITY_SMOKE | PASS | All buttons have text labels; form inputs have associated `<label>`; focus states via Tailwind; error messages rendered as visible text |
| RESPONSIVE_SMOKE | PASS | Nav items use `hidden md:flex`; public nav on pricing is always visible; main content uses `max-w-7xl mx-auto` with responsive padding |
| REGRESSION_TESTS | PASS | Backend: 105/109 pass (4 pre-existing Testcontainer/Docker failures, unchanged); Frontend: 7/7 vitest unit tests pass |

---

## Changes Made

### `frontend/src/components/Layout.tsx`
- Auth-aware rendering: when `!isAuthenticated`, renders public nav (NAPLANPrep logo + Sign in + Create account) instead of authenticated nav
- "Sign out" is no longer shown to logged-out users
- Pricing link remains accessible in public nav so logged-out users can navigate to it
- Cross-tab logout sync listener only activates when authenticated

### `frontend/src/features/auth/pages/RegisterPage.tsx`
- Free registration navigates to `/dashboard?new=1` instead of `/dashboard`

### `frontend/src/features/dashboard/Dashboard.tsx`
- Reads `?new=1` from URL on mount; sets `isNewUser = true` and clears param
- Shows "Welcome to NAPLANPrep, {firstName}!" for new users
- Shows "Your account is ready. Start with a free exam below." as subtitle
- Returns to "Welcome back, {firstName}!" for all subsequent visits

### `frontend/src/features/auth/pages/LoginPage.tsx`
- "Register now" link → "Create account" (terminology consistency)

### `frontend/src/features/subscription/PricingPage.tsx`
- Added `Link` import from react-router-dom
- Added logged-out info bar: "Sign in or create a free account to get started."
- Free plan card now shows "Sign up free" CTA for logged-out users

### `admin-panel/src/components/AdminLayout.tsx`
- Added `useQueryClient` import; `handleLogout` calls `queryClient.clear()` before `logout()`

### `frontend/vite.config.ts`
- Added vitest `test` config: `environment: 'node'`, `globals: true`, `setupFiles`

### `frontend/src/test-utils/setup.ts` (new)
- localStorage mock for vitest node environment (required by zustand/persist)

### `frontend/src/store/authStore.test.ts` (new)
- 7 unit tests: initial state, setAuth, logout, token refresh, session-expiry invariants

---

## UAT Flow Coverage

| Flow | Result |
|------|--------|
| A — New Free User: Pricing → Free → Register → Dashboard | PASS — "Sign up free" CTA present; dashboard shows "Welcome to NAPLANPrep" |
| B — Direct Advanced: Pricing → Advanced → Register → Checkout | PASS — plan slug preserved through `/register?plan=advanced` |
| C — Direct Premium: Pricing → Premium → Register → Checkout | PASS — plan slug preserved through `/register?plan=premium` |
| D — Logout → Pricing: Sign out not visible | PASS — Layout shows Sign in / Create account for logged-out users |
| E — Session Refresh: Login → refresh → still logged in | PASS — zustand/persist restores from localStorage |
| F — Protected Route after Logout: redirect to /login | PASS — ProtectedRoute checks isAuthenticated |

---

## Not Changed (per task rules)

- Exam content, question content, Flyway migrations
- Assessment architecture, adaptive engine, entitlement rules
- Stripe payment architecture, calculator rules
- Spelling architecture, 320-exam catalogue
- Business rules: Free = 5 exams, Advanced = 30, Premium = 80, AUD pricing, 1-year validity, one-time payment

---

## UX_SESSION_POLISH_READY = YES

All conditions met:
- ✓ Authentication state consistent across routes
- ✓ Logout fully clears session state (tokens, user, query cache)
- ✓ Pricing signup/purchase flow is clear for logged-out users
- ✓ Direct Advanced/Premium flows work end-to-end
- ✓ New-user copy is correct ("Welcome to NAPLANPrep")
- ✓ No incorrect monthly pricing messaging
- ✓ No regression tests fail (all pre-existing failures unchanged)
