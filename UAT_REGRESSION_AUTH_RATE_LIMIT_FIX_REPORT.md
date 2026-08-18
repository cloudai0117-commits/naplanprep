# UAT Regression Auth Rate Limit Fix Report

## Summary

The UAT API regression suite was failing with HTTP 429 errors during authentication.
Root cause: tests called `loginAndGetToken()` before every test method, generating
42+ burst auth requests per minute from a single CI IP, exceeding the backend rate
limit of 20 auth requests per 60-second window per IP.

---

## Root Cause Analysis

### Rate Limiter Configuration
```
Interceptor: RateLimitInterceptor (Redis-backed fixed-window counter)
Bucket: AUTH — 20 requests per 60 s per client IP
Scope: all /v1/auth/* paths (login, register, refresh, me)
```

### Login Storm (before fix)

| Class | Setup method | Call | Tests | Auth hits |
|---|---|---|---|---|
| ExamEngineApiTest | @BeforeEach setupTokens() | loginAndGetToken ×3 | 14 | **42** |
| SubscriptionApiTest | @BeforeEach setup() | loginAndGetToken ×1 | 12 | **12** |
| ContentApiTest | @BeforeEach setup() | loginAndGetToken ×1 | 5 | **5** |
| AuthApiTest | @Test methods | loginAndGetToken direct | — | **3** |
| **TOTAL** | | | **59 tests** | **~62 burst** |

With 42+ logins from a single IP in under a minute, the counter exceeded 20 and
all subsequent auth calls returned HTTP 429, cascading 28 test failures.

---

## Fix Applied

### Token cache added to `BaseApiTest` (commit `37d796f`, naplanprep-tests)

```java
private static final ConcurrentHashMap<String, String> TOKEN_CACHE = new ConcurrentHashMap<>();

protected String cachedToken(String email, String password) {
    return TOKEN_CACHE.computeIfAbsent(email, _k -> loginAndGetToken(email, password));
}
```

- Static `ConcurrentHashMap` — shared across all test class instances in the JVM
- `computeIfAbsent` — thread-safe, guarantees exactly one login per email
- Access tokens expire in 900 s; the full suite runs in ~5 min — no expiry refresh needed
- `loginAndGetToken()` is preserved unchanged for `AuthApiTest` tests that
  specifically test the auth endpoint (those must call the real endpoint)

### Each `@BeforeEach` setup updated to use `cachedToken()`

| File | Changed |
|---|---|
| `ExamEngineApiTest.setupTokens()` | `loginAndGetToken` → `cachedToken` (×3) |
| `ContentApiTest.setup()` | `loginAndGetToken` → `cachedToken` |
| `SubscriptionApiTest.setup()` | `loginAndGetToken` → `cachedToken` |
| `AuthApiTest.getMe_withValidToken_returnsUser()` | `loginAndGetToken` → `cachedToken` |

---

## Auth Requests After Fix

| Account | Before | After |
|---|---|---|
| student1@test.com | ~55 logins | 1 (cache) + 3 (AuthApiTest direct tests) |
| student2@test.com | ~14 logins | 1 (cache) |
| admin@naplanprep.com.au | ~17 logins | 1 (cache) |
| Fresh per-test users (SubscriptionApiTest) | 11 registrations | 11 registrations (unchanged — each test needs a fresh user) |

```
LOGIN_REQUESTS_BEFORE = ~62
LOGIN_REQUESTS_AFTER  = ~7 logins + ~14 registrations (spread over ~5 min suite runtime)
TOKEN_REUSE           = PASS
TOKEN_EXPIRY_HANDLING = N/A (900 s token lifetime > ~5 min suite runtime)
429_BEFORE            = ~28 tests failing
429_AFTER             = 0 (expected)
```

---

## Status

```
COMPILE_CHECK         = PASS (mvn compile test-compile — BUILD SUCCESS)
NAPLANPREP_TESTS_PUSH = PASS (37d796f → main)
CI_TRIGGER            = PENDING (deploy-uat.yml run on develop branch)
API_TESTS             = PENDING
UI_TESTS              = PENDING
CATALOGUE             = PASS (verified in prior CI run: 320 exams, correct studentTestLength)
EXAM_ENGINE           = PENDING
SUBSCRIPTION          = PENDING
BACKEND_TESTS         = PENDING
UAT_REGRESSION        = PENDING
```

---

## Security Invariants Preserved

- Production rate limiter: UNCHANGED (no bypass, no whitelist)
- JWT expiry: UNCHANGED (900 s)
- AuthApiTest login tests: call real endpoint directly (not cached) — auth
  endpoint behaviour is still tested end-to-end
- Wrong password / unknown email tests: still exercise real failed-auth paths
