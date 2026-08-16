# LLD — Admin Panel on Azure

**Project:** NAPLANPrep  
**Version:** 1.0  
**Date:** 2026-08-16  
**Status:** Draft — Pre-Implementation

---

## 1. Overview

The NAPLANPrep admin panel is a React/Vite single-page application providing content management, student management, subscription oversight, and exam catalogue administration for PLATFORM_ADMIN users.

On Azure, the admin panel is deployed as an Azure Static Web App, separate from the student frontend, with its own custom domain (`admin.naplanprep.com.au`) routed through Azure Front Door Premium.

---

## 2. Admin Panel Architecture

```
                    ┌─────────────────────────────────────────────────────────┐
                    │                Azure Front Door Premium                  │
                    │   WAF Policy (OWASP 3.2, Rate limits, Geo-filter AU)    │
                    └───────────────┬──────────────────────┬───────────────────┘
                                    │                      │
                    ┌───────────────▼───────┐  ┌──────────▼──────────────────┐
                    │ Static Web App        │  │   Container App             │
                    │ admin.naplanprep.com  │  │   api.naplanprep.com.au     │
                    │ (Admin SPA — React)   │  │   (Spring Boot backend)     │
                    └───────────────────────┘  └─────────────────────────────┘
```

---

## 3. Deployment on Azure Static Web Apps

### 3.1 Resource Configuration

| Property | Value |
|---|---|
| Resource name | `npp-prod-swa-admin` |
| Resource group | `npp-prod-rg-app` |
| Plan tier | Standard (custom domains, auth) |
| Region | Australia East |
| Custom domain | `admin.naplanprep.com.au` |
| Front Door integration | Yes — routed through Front Door Premium |
| GitHub Actions integration | Yes — auto-generated deployment token |

### 3.2 Build Configuration (`staticwebapp.config.json`)

Place in the `admin-panel/` directory root:

```json
{
  "routes": [
    {
      "route": "/api/*",
      "allowedRoles": ["authenticated"]
    },
    {
      "route": "/*",
      "allowedRoles": ["anonymous"]
    }
  ],
  "navigationFallback": {
    "rewrite": "/index.html",
    "exclude": ["/assets/*", "/favicon.ico", "/robots.txt"]
  },
  "mimeTypes": {
    ".json": "text/json"
  },
  "responseOverrides": {
    "401": {
      "redirect": "/login",
      "statusCode": 302
    }
  },
  "globalHeaders": {
    "X-Content-Type-Options": "nosniff",
    "X-Frame-Options": "DENY",
    "Referrer-Policy": "strict-origin-when-cross-origin",
    "Content-Security-Policy": "default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline'; img-src 'self' data:; connect-src 'self' https://api.naplanprep.com.au; frame-ancestors 'none'"
  }
}
```

### 3.3 GitHub Actions Deploy Step

```yaml
- name: Deploy Admin Panel
  uses: Azure/static-web-apps-deploy@v1
  with:
    azure_static_web_apps_api_token: ${{ secrets.PROD_SWA_ADMIN_TOKEN }}
    repo_token: ${{ secrets.GITHUB_TOKEN }}
    action: upload
    app_location: admin-panel
    output_location: dist
    app_build_command: npm run build
  env:
    VITE_API_URL: https://api.naplanprep.com.au/v1
    # Note: Admin panel does not use Stripe keys
```

---

## 4. Authentication and Authorisation

### 4.1 Authentication Flow

The admin panel authenticates using the same JWT flow as the student frontend:

1. Admin user navigates to `admin.naplanprep.com.au`
2. Frontend sends `POST /v1/auth/login` to backend with credentials
3. Backend returns access token (900s) + refresh token (7d) as JSON payload
4. Tokens stored in localStorage (P3-004 — accepted risk, deferred to Phase 20)
5. All subsequent API calls include `Authorization: Bearer {token}` header

### 4.2 Role Enforcement

The admin panel may only be used with a `PLATFORM_ADMIN` role JWT. All admin-sensitive backend endpoints are annotated:

```java
@PreAuthorize("hasRole('PLATFORM_ADMIN')")
```

If a non-admin JWT is used against admin endpoints, the backend returns HTTP 403. The admin panel should redirect to an error page on receiving 403.

### 4.3 Session Management

| Property | Value |
|---|---|
| Access token TTL | 900 seconds (15 min) |
| Refresh token TTL | 7 days |
| Token blacklist | Redis — `blacklist:{token}` |
| Logout | `POST /v1/auth/logout` — blacklists current access token |

---

## 5. Admin Panel Capabilities

### 5.1 Content Management

| Feature | Endpoint | Notes |
|---|---|---|
| List exam catalogue | `GET /v1/content/exams` | Full catalogue with all fields |
| Get exam details | `GET /v1/content/exams/{id}` | All question detail including answer keys |
| List questions | `GET /v1/content/questions` | Full Question entity (correctAnswer, rubric, etc.) |
| Update question status | `PATCH /v1/content/questions/{id}` | PUBLISHED/DRAFT toggle |

**ABSOLUTE RULE:** The admin panel UI must never be used to create or modify V54–V379 migration content. The 320-exam catalogue is immutable. Content additions post-V379 go through new Flyway migrations.

### 5.2 Student Management

| Feature | Endpoint |
|---|---|
| List students | `GET /v1/admin/students` |
| Get student profile | `GET /v1/admin/students/{id}` |
| Get student exam history | `GET /v1/admin/students/{id}/sessions` |
| Reset student password | `POST /v1/admin/students/{id}/reset-password` |

### 5.3 Subscription Management

| Feature | Endpoint |
|---|---|
| List all subscriptions | `GET /v1/admin/subscriptions` |
| Get subscription details | `GET /v1/admin/subscriptions/{id}` |
| Manual status override | `PATCH /v1/admin/subscriptions/{id}/status` |

### 5.4 Platform Monitoring

| Feature | Endpoint | Auth |
|---|---|---|
| Health overview | `GET /actuator/health` | None |
| DB integrity check | `GET /actuator/health/dbIntegrity` | PLATFORM_ADMIN JWT |
| Application metrics | `GET /actuator/metrics` | PLATFORM_ADMIN JWT |
| Log stream | Azure Portal / Log Analytics | Azure AD (not via API) |

---

## 6. Network Access Control

The admin panel (`admin.naplanprep.com.au`) is accessible globally via Front Door. However:

1. **Front Door WAF Geo-filter:** Optional — can restrict to AU IPs if required
2. **Backend admin endpoints:** All route through the same Container App as student API; there is no admin-specific backend
3. **Actuator endpoints:** Accessible only from within the VNet by default; Front Door does not route `/actuator/**` to the public

### 6.1 Front Door Route Rules

```
admin.naplanprep.com.au/* → npp-prod-swa-admin (Static Web App)

api.naplanprep.com.au/v1/* → npp-prod-ca-api (Container App)
  [WAF policy: admin endpoints require PLATFORM_ADMIN JWT — enforced by Spring Security, not WAF]
```

The WAF is not application-aware enough to verify JWT roles. The backend Spring Security config (`@PreAuthorize`) is the authoritative access control for admin endpoints.

---

## 7. Development Environment

For local development, the admin panel runs:

```bash
cd admin-panel
npm run dev    # Vite dev server — proxy configured to localhost:8080
```

Vite proxy configuration (`vite.config.ts`):

```typescript
export default defineConfig({
  server: {
    proxy: {
      '/v1': {
        target: 'http://localhost:8080',
        changeOrigin: true,
      }
    }
  }
})
```

---

## 8. Admin Panel Build

### 8.1 Environment Variables at Build Time

| Variable | Value | Notes |
|---|---|---|
| `VITE_API_URL` | `https://api.naplanprep.com.au/v1` | Prod backend URL |
| `NODE_ENV` | `production` | Set by Vite automatically |

No Stripe keys are required in the admin panel build. Stripe is student-facing only.

### 8.2 Output

Vite produces a `dist/` directory with:
- `index.html` — SPA entry point
- `assets/` — hashed JS/CSS bundles
- `favicon.ico`, `robots.txt`

This output is uploaded directly by the Static Web Apps action. No nginx container is used.

---

## 9. Monitoring

| Signal | Source | Alert Threshold |
|---|---|---|
| Admin login failures | Log Analytics (backend logs) | 5 failures in 5 min → alert |
| Admin actions on exam content | Application logs | Any modification → audit trail |
| DB integrity check failures | CI gate + manual actuator | Immediate incident |
| 401/403 on admin endpoints | Front Door WAF / backend logs | Spike → investigate |

---

## 10. Differences from Student Frontend

| Aspect | Student Frontend | Admin Panel |
|---|---|---|
| Resource name | `npp-prod-swa-frontend` | `npp-prod-swa-admin` |
| Domain | `app.naplanprep.com.au` | `admin.naplanprep.com.au` |
| Stripe integration | Yes (publishable key at build time) | No |
| Role required | STUDENT / TEACHER | PLATFORM_ADMIN only |
| Content access | QuestionSummary (no answers) | Full Question entity |
| Exam access | Package-restricted | Unrestricted catalogue view |
| Deployment token | `PROD_SWA_FRONTEND_TOKEN` | `PROD_SWA_ADMIN_TOKEN` |
