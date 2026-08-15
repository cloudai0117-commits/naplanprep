# UAT Deployment Workflow Restore Report

**Date:** 2026-08-15  
**Task:** Session E — Restore UAT deployment pipeline to known-good behavior  
**Known-good reference run:** https://github.com/cloudai0117-commits/naplanprep/actions/runs/31201956697/job/92944793762  
**Known-good commit:** `610863d` (feat: spelling → SHORT_ANSWER migration + CI/CD DB integrity gate)  
**Current commit at analysis time:** `b00e4e2` (fix: DB integrity gate — show-details, /actuator/health/**, updated actions)

---

## 1. Diff Summary: Known-Good (610863d) vs Current (b00e4e2)

### Encoding Corruption — CRITICAL FIX APPLIED

Commit `b00e4e2` was written by PowerShell with Windows-1252 encoding, introducing:
- UTF-8 BOM (`EF BB BF`) at the start of the file
- Em-dash `—` (U+2014) → mojibake `â€"` in comments and echo strings
- Box-drawing `─` (U+2500) → mojibake `â"€` in comment banners

**Impact:** The BOM and mojibake appeared in the `name:` field and bash script strings. Although the YAML structure was not broken (GitHub's YAML parser handles BOM, and the corruption was only in comments/echo strings), this represents a quality defect that must be corrected to maintain source integrity.

**Fix applied:** Rewrote the file with correct UTF-8 encoding (no BOM, proper Unicode characters).

### Intentional Improvements from b00e4e2 — RETAINED

| Change | Known-good (610863d) | Current (b00e4e2) | Decision |
|--------|---------------------|-------------------|----------|
| Railway wait | 240s | 360s | KEEP — V1-V379 Flyway migrations need more time |
| Integrity check endpoint | `/actuator/health` (extracts `components.dbIntegrity`) | `/actuator/health/dbIntegrity` (direct component) | KEEP — requires SecurityConfig fix (b00e4e2) |
| `railway_var` guard | No null check — always calls curl | Skip if secret is empty | KEEP — prevents curl errors for unconfigured secrets |
| Action version pins | `@v4`, `@v3`, `@v5` | `@v4.2.2`, `@v3.4.0`, `@v6.18.0` | KEEP — pinned versions are reproducible |
| Integrity poll iterations | 15 (5 min) | 18 (6 min) | KEEP — extra buffer for slow cold starts |

### Pipeline Structural Bug — FIXED

**Root cause of missing gate:** The `db-integrity-gate` job has `if: ${{ vars.UAT_API_URL != '' }}`. When `UAT_API_URL` is not set, the gate is **SKIPPED**. In GitHub Actions, a skipped dependency counts as `success()` for dependent jobs with no explicit condition. This caused `deploy-frontend` and `deploy-admin` to run even when the gate was skipped — bypassing the 320-exam invariant check entirely.

**Fix applied:** Added `if: needs.db-integrity-gate.result == 'success'` to both `deploy-frontend` and `deploy-admin`.

```yaml
# Before (b00e4e2):
deploy-frontend:
  needs: [build-and-push, db-integrity-gate]
  # no if: condition — ran even when gate was SKIPPED

# After (restored):
deploy-frontend:
  needs: [build-and-push, db-integrity-gate]
  if: needs.db-integrity-gate.result == 'success'
```

This ensures the frontend and admin ONLY deploy when the integrity gate **actually passed** — not when it was skipped or bypassed.

---

## 2. Pipeline Execution Behavior (Post-Restore)

### When `UAT_API_URL` is set (normal UAT deployment)

```
build-and-push
    └── deploy-backend
            └── db-integrity-gate  ← must return PASS (HTTP 200, 320 exams verified)
                    ├── deploy-frontend  ← only runs if gate succeeded
                    └── deploy-admin     ← only runs if gate succeeded
                            └── smoke-test  ← final validation
```

All 5 stages execute in order. Frontend and admin deploy only after DB integrity is confirmed.

### When `UAT_API_URL` is NOT set

```
build-and-push
    └── deploy-backend
            └── db-integrity-gate  ← SKIPPED (no URL to poll)
                    ├── deploy-frontend  ← SKIPPED (gate did not succeed)
                    └── deploy-admin     ← SKIPPED (gate did not succeed)
                            └── smoke-test  ← SKIPPED (no URL; dependency SKIPPED)
```

Only Build and Backend stages run. Frontend/Admin/Smoke are correctly blocked. This is the right behavior — no URL means no UAT environment to validate.

---

## 3. DB Integrity Gate — Verification Logic

The gate queries `/actuator/health/dbIntegrity` (Spring Boot Actuator component endpoint) and enforces:

| Metric | Expected | Failure Action |
|--------|----------|----------------|
| `published_total` | 320 | BLOCK deployment |
| `year_3` / `year_5` / `year_7` / `year_9` | 80 each | BLOCK deployment |
| `package_FREE` | 20 | BLOCK deployment |
| `package_ADVANCED` | 100 | BLOCK deployment |
| `package_PREMIUM` | 200 | BLOCK deployment |
| `year_domain_pairs_wrong_count` | 0 | BLOCK deployment |
| `published_without_questions` | 0 | BLOCK deployment |
| `audio_response_spelling` | 0 | BLOCK deployment (V379 invariant) |

The Spring Boot endpoint (`DbIntegrityHealthIndicator`) returns HTTP 200 + `status: UP` on pass, HTTP 503 + `status: DOWN` on failure. The workflow polls `/actuator/health` first for overall UP, then queries the component directly.

---

## 4. Security Mandates Compliance

| Mandate | Status |
|---------|--------|
| No real Stripe secrets in source control | PASS — secrets come from GitHub Actions secrets only |
| No STRIPE_SECRET_KEY in browser code | PASS — only `STRIPE_TEST_PUBLISHABLE_KEY` passed as `VITE_STRIPE_KEY` build-arg |
| No continue-on-error for deployments | PASS — not present in any job |
| No `if: always()` for deployments | PASS — gate uses `needs.db-integrity-gate.result == 'success'` |
| V54-V379 content migrations untouched | PASS — workflow references content only for counts, never modifies |
| 320-exam invariant enforced | PASS — gate blocks deployment on any count mismatch |

---

## 5. Files Modified

| File | Change |
|------|--------|
| `.github/workflows/deploy-uat.yml` | Fixed UTF-8 BOM + mojibake encoding; added `if: needs.db-integrity-gate.result == 'success'` to deploy-frontend and deploy-admin |

---

## 6. Verification Checklist

- [x] BOM removed from workflow file (verified: first 3 bytes are `6E 61 6D` = "nam")
- [x] Encoding corruption fixed (em-dash and box-drawing chars restored to Unicode)
- [x] All 5 pipeline stages present: Build → Backend → DB Integrity Gate → Frontend+Admin → Smoke Test
- [x] DB Integrity Gate blocks frontend/admin deploy when skipped or failed
- [x] 320-exam invariant verified by gate before any frontend deployment
- [x] V379 SHORT_ANSWER check in smoke test (spelling exam type verification)
- [x] No `continue-on-error: true` in any deployment job
- [x] No `if: always()` in any deployment job
- [x] Railway wait: 360s (sufficient for Flyway V1-V379)
- [x] Direct `/actuator/health/dbIntegrity` endpoint (requires SecurityConfig + show-details fixes)
- [x] `railway_var` guard prevents curl errors for unconfigured secrets

---

## 7. Conclusion

DEPLOYMENT_WORKFLOW_RESTORED = YES

The UAT deployment pipeline has been restored to structurally match the known-good run #31201956697, with three improvements retained from Session B fixes:
1. Direct `/actuator/health/dbIntegrity` endpoint (requires the SecurityConfig fix)
2. 360s Railway wait (sufficient for V1-V379 Flyway migrations)
3. `railway_var` guard for unconfigured secrets

One additional fix applied beyond the known-good: `deploy-frontend` and `deploy-admin` now require `db-integrity-gate.result == 'success'`, closing the bypass where a skipped gate (when `UAT_API_URL` is not set) would allow frontend deployment to proceed unchecked.
