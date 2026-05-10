# 🚀 NAPLANPrep — Single-Prompt Full-Stack Build Command

## How to Use

### Option A: Claude Code (Terminal)
```bash
# 1. Install Claude Code if not installed
npm install -g @anthropic-ai/claude-code

# 2. Create your project directory
mkdir naplanprep && cd naplanprep

# 3. Copy the MASTER PROMPT below and paste it into Claude Code
claude
```
Then paste the **MASTER PROMPT** below.

### Option B: Claude Code with Prompt File
```bash
# Save the MASTER PROMPT to a file
cat > build-prompt.md << 'PROMPT_EOF'
<paste the MASTER PROMPT here>
PROMPT_EOF

# Run Claude Code with the prompt
claude -p "$(cat build-prompt.md)"
```

### Option C: Codex / Anthropic API
Use the MASTER PROMPT as the user message in your API call.

---

## ⚡ MASTER PROMPT — Copy Everything Below This Line

```
You are a full-stack development team building NAPLANPrep — a subscription-based NAPLAN exam preparation platform for Australian students (Years 3, 5, 7, 9). Build the ENTIRE system from scratch, commit to Git, and make it runnable.

## WHAT TO BUILD

A monorepo with 3 applications:
1. **Backend API** (Java 21, Spring Boot 3.2)
2. **Student Frontend** (React 18, TypeScript, Vite)
3. **Admin Panel** (React 18, TypeScript, Vite — separate app)

## PAYMENT GATEWAY

Use **Stripe** (most cost-effective in Australia: 1.75% + A$0.30, no monthly fees, best subscription billing API, full sandbox).

Wire up Stripe sandbox in dev/uat profiles, live keys in prod profile only.

Subscription plans to create:
- FREE: $0 — 1 diagnostic per year level, 10 practice questions/day
- STANDARD: $14.99/mo or $129/yr — Full question bank, 12 mock exams/year, progress tracking
- PREMIUM: $24.99/mo or $219/yr — Adaptive learning, unlimited mocks, parent dashboard, detailed analytics
- FAMILY: $34.99/mo — Up to 4 children, all Premium features

## THREE ENVIRONMENT PROFILES

### DEV (local development)
- PostgreSQL on localhost:5432, DB: naplanprep_dev
- Redis on localhost:6379
- Stripe TEST keys (sk_test_/pk_test_)
- CORS: http://localhost:5173, http://localhost:5174
- JWT: dev RSA keypair in classpath
- Logging: DEBUG
- Spring profile: dev

### UAT (staging/testing)
- PostgreSQL via env var ${DB_HOST}, DB: naplanprep_uat
- Redis via env var ${REDIS_HOST}
- Stripe TEST keys via env vars
- CORS: https://uat.naplanprep.com.au, https://admin.uat.naplanprep.com.au
- JWT: keys via env var paths
- Logging: INFO
- Spring profile: uat

### PROD (production)
- PostgreSQL via env var, DB: naplanprep_prod, with password
- Redis via env var with password
- Stripe LIVE keys via env vars
- CORS: https://naplanprep.com.au, https://www.naplanprep.com.au, https://admin.naplanprep.com.au
- JWT: keys via env var paths
- Logging: WARN
- Spring profile: prod

## BACKEND MODULES TO BUILD (in order)

### 1. Shared/Config
- SecurityConfig (JWT RS256 + OAuth2 resource server)
- JwtTokenProvider (generate/validate tokens)
- GlobalExceptionHandler (@RestControllerAdvice with standard ApiResponse)
- ApiResponse<T> record (status, data, errors, meta)
- CORS config per profile
- Redis config
- Flyway migrations

### 2. Auth Module
Entities: User, UserProfile, ParentChildLink
Endpoints:
- POST /v1/auth/register — email/password registration with Zod-style validation
- POST /v1/auth/login — returns JWT access + refresh tokens
- POST /v1/auth/refresh — rotate refresh token
- POST /v1/auth/logout — invalidate refresh token
- GET /v1/auth/me — current user profile
Features: BCrypt (cost 12), rate limiting (5 attempts → 15 min lockout), parent-child linking, roles (STUDENT, PARENT, TEACHER, SCHOOL_ADMIN, PLATFORM_ADMIN)

### 3. Content Module
Entities: Question (with MULTIPLE_CHOICE, DRAG_DROP, SHORT_ANSWER, EXTENDED_WRITING types), CurriculumTag
Endpoints:
- GET /v1/content/questions — search/filter by year_level, domain, topic, difficulty_band (paginated)
- POST /v1/content/questions — admin create
- PUT /v1/content/questions/{id} — admin update
- PATCH /v1/content/questions/{id}/status — admin approve/reject
Fields: id (UUID), question_type, year_level (3/5/7/9), domain (reading/writing/spelling/grammar_punctuation/numeracy), topic, difficulty_band (1-10), stimulus_text, question_text, options (JSONB), correct_answer (JSONB), explanation, status (DRAFT/REVIEW/PUBLISHED)

### 4. Exam Engine Module
Entities: ExamSession, ExamAnswer, ExamResult
Endpoints:
- POST /v1/exams/sessions — start exam (practice/mock/diagnostic)
- GET /v1/exams/sessions/{id} — get current session state
- POST /v1/exams/sessions/{id}/answer — submit answer for a question
- POST /v1/exams/sessions/{id}/submit — complete exam, calculate results
- GET /v1/exams/results/{sessionId} — get detailed results
- GET /v1/exams/history — paginated exam history for current user
Features: Redis-backed active session state, server-side timer, randomized question order, auto-submit on timeout, score calculation with NAPLAN band assignment, domain/topic breakdown in results

### 5. Subscription Module (Stripe)
Entities: Plan, Subscription, Entitlement
Endpoints:
- GET /v1/subscriptions/plans — list available plans
- POST /v1/subscriptions/checkout — create Stripe Checkout Session, return URL
- GET /v1/subscriptions/current — user's active subscription with entitlements
- POST /v1/subscriptions/portal — create Stripe Customer Portal session
- POST /v1/subscriptions/cancel — cancel subscription
- POST /v1/subscriptions/webhooks/stripe — handle Stripe webhooks (verify signature!)
Webhook events to handle: customer.subscription.created, customer.subscription.updated, customer.subscription.deleted, invoice.payment_failed
Features: 7-day free trial for Premium, entitlement enforcement middleware, plan tier checks on exam/feature access

### 6. Progress/Analytics Module
Endpoints:
- GET /v1/progress/overview — dashboard: total exams, avg score, scores by domain, recent trend
- GET /v1/progress/domains/{domain} — domain-specific history and trends
- GET /v1/progress/recommendations — weak areas to practice based on exam history
- GET /v1/progress/children/{childId} — parent viewing linked child's progress (verify parent-child link!)

### 7. Admin Module
Endpoints:
- GET /v1/admin/dashboard — MRR, total users, active subscribers, content stats
- GET /v1/admin/users — paginated user list with search/filter
- PUT /v1/admin/users/{id}/status — activate/deactivate user
- GET /v1/admin/users/{id} — detailed user profile including subscription
- GET /v1/admin/subscriptions/analytics — revenue breakdown, churn rate
- GET /v1/admin/content/stats — question count by year_level/domain, coverage gaps
All admin endpoints require PLATFORM_ADMIN role

### 8. Database Migrations (Flyway)
Create these SQL migrations in backend/src/main/resources/db/migration/:
- V1__create_users_tables.sql
- V2__create_content_tables.sql
- V3__create_exam_tables.sql
- V4__create_subscription_tables.sql
- V5__create_analytics_tables.sql
- V6__seed_plans.sql (insert the 4 plan tiers with Stripe price IDs as placeholders)
- V7__seed_sample_questions.sql (at least 20 sample questions across Year 3 & 5, numeracy & reading)
- V8__create_admin_user.sql (admin@naplanprep.com.au / Admin123! — hashed)

## FRONTEND (Student App — port 5173)

### Pages to Build:
1. **Landing Page** — Hero section, feature highlights, pricing comparison table, CTA buttons
2. **Login Page** — Email/password form, Google OAuth button, link to register
3. **Register Page** — Name, email, password, year level selector, parent/student toggle
4. **Student Dashboard** — Welcome, progress summary chart (Recharts), recent exams list, quick-start buttons by domain, subscription status badge
5. **Exam Selection** — Cards for Practice/Mock/Diagnostic, year level & domain dropdowns, start button
6. **Exam Player** — Full-screen exam mode: question text + options, countdown timer, progress bar, question navigation sidebar (answered/unanswered/flagged), next/prev/flag buttons, submit button with confirmation modal
7. **Results Page** — Overall score, NAPLAN band, domain breakdown bar chart, topic-level analysis, explanation for each question (expandable)
8. **Exam History** — Table of past exams with date, type, domain, score, band
9. **Pricing/Subscription** — Plan comparison cards, Stripe Checkout button, current plan display
10. **Parent Dashboard** — Child selector, child's progress charts, add child flow
11. **Profile/Settings** — Edit name, change password, manage subscription (link to Stripe Portal)

### Frontend Architecture:
- React Router v6 with protected routes
- Zustand for auth state (user, token)
- React Query (TanStack Query) for all API calls
- Stripe Elements (@stripe/react-stripe-js) for checkout
- Recharts for dashboard charts
- React Hook Form + Zod for form validation
- Tailwind CSS for styling
- Feature-based folder structure: src/features/{auth,exam,dashboard,subscription,parent}/

### Environment files:
- .env.development: VITE_API_URL=http://localhost:8080/v1, VITE_STRIPE_KEY=pk_test_placeholder
- .env.uat: VITE_API_URL=https://api.uat.naplanprep.com.au/v1, VITE_STRIPE_KEY=pk_test_placeholder
- .env.production: VITE_API_URL=https://api.naplanprep.com.au/v1, VITE_STRIPE_KEY=pk_live_placeholder

## ADMIN PANEL (Separate React App — port 5174)

### Pages to Build:
1. **Admin Login** — Admin-only login (PLATFORM_ADMIN role check)
2. **Dashboard** — Metric cards (total users, active subscribers, MRR, content count), charts (subscription growth, exam activity over time)
3. **User Management** — Searchable/filterable data table, user detail drawer, activate/deactivate toggle
4. **Question Bank** — Data table of all questions, filters (year level, domain, status), create/edit question modal with form (question type, text, options, correct answer, explanation, difficulty, tags), approve/reject workflow buttons
5. **Subscription Management** — Table of all subscriptions, filter by plan/status, revenue chart
6. **School Management** — Add school, assign license, view student count and usage
7. **Audit Log** — Security event viewer (login attempts, admin actions, data access)
8. **Settings** — Feature flags toggles, platform configuration

### Admin Frontend Architecture:
- Same stack as student frontend (React 18, TS, Vite, Tailwind)
- Separate Vite project with its own package.json
- Shares API client config pattern with student frontend
- Additional auth check: user.role === 'PLATFORM_ADMIN' on all routes
- Data tables using TanStack Table
- .env files with same API URLs as student frontend

## DOCKER SETUP

### docker-compose.yml (local dev)
- postgres:16-alpine (port 5432, DB: naplanprep_dev)
- redis:7-alpine (port 6379)
- Backend Dockerfile (Java 21 multi-stage build)
- Frontend Dockerfile (Node build + nginx:alpine)
- Admin Dockerfile (Node build + nginx:alpine)

### docker-compose.uat.yml
- Same services but with UAT environment variables
- Stripe test keys passed via .env.uat

## CI/CD

### .github/workflows/ci.yml
- On pull_request: run backend tests (mvn verify), frontend lint+test, admin lint+test
- Use PostgreSQL service container for backend integration tests

### .github/workflows/deploy-uat.yml
- On push to develop: build Docker images, push to registry, deploy to UAT

### .github/workflows/deploy-prod.yml
- On push to main (manual trigger): build, push, deploy to prod

## GIT WORKFLOW

Initialize git repo, commit after each major phase:
1. "chore: initial project scaffolding and configs"
2. "feat(auth): user registration, login, JWT, and roles"
3. "feat(content): question bank CRUD with search and filtering"
4. "feat(exam): exam engine with timer, scoring, and results"
5. "feat(subscription): Stripe integration with plans, checkout, and webhooks"
6. "feat(analytics): progress tracking and recommendations"
7. "feat(admin-api): admin endpoints for platform management"
8. "feat(frontend): complete student-facing web application"
9. "feat(admin-panel): admin dashboard and management UI"
10. "feat(infra): Docker, CI/CD, and deployment configurations"
11. "feat(db): Flyway migrations and seed data"
12. "docs: architecture, API reference, and deployment guides"

## CRITICAL RULES

1. EVERY file must be complete working code — no TODOs, no placeholders, no "implement this"
2. All Stripe integration must use sandbox/test mode in dev and uat profiles
3. All 3 environment profiles (dev, uat, prod) must be fully configured
4. Admin panel is a SEPARATE React application, not part of the student frontend
5. Database must include seed data (plans, sample questions, admin user)
6. Security: JWT auth, CORS per profile, input validation on all endpoints, rate limiting on auth
7. API responses use consistent format: { status, data, errors, meta }
8. Git history should be clean with conventional commits
9. docker-compose up should start the entire local dev stack
10. Include unit tests for domain logic and integration tests for key API endpoints
11. No secrets hardcoded — use env vars and .env files (add .env to .gitignore)
12. Include a README.md with setup instructions for each profile

NOW START BUILDING. Begin with project scaffolding and work through each phase sequentially. Commit after each logical unit. Make it production-grade.
```

---

## What Happens When You Run This

Claude Code / Codex will:

1. **Create the monorepo** — `naplanprep/` with backend, frontend, admin-panel, infra directories
2. **Initialize Git** — `git init`, proper `.gitignore`
3. **Build the backend** — Full Spring Boot app with all 7 modules, Flyway migrations, Stripe integration
4. **Configure 3 profiles** — `application-dev.yml`, `application-uat.yml`, `application-prod.yml`
5. **Build the student frontend** — 11 pages, exam player, Stripe checkout, dashboard with charts
6. **Build the admin panel** — 8 pages, question bank CRUD, user management, analytics
7. **Wire up Stripe sandbox** — Test keys in dev/uat, webhook handling, checkout flow
8. **Create Docker setup** — `docker-compose.yml` for local dev, UAT variant
9. **Set up CI/CD** — GitHub Actions for testing and deployment
10. **Seed the database** — Plans, sample questions, admin user
11. **Commit everything** — Clean git history with conventional commits

## After the Build

```bash
# Start locally
docker-compose up -d

# Or run without Docker
cd backend && ./mvnw spring-boot:run -Dspring-boot.run.profiles=dev
cd frontend && npm run dev
cd admin-panel && npm run dev

# Access
# Student app: http://localhost:5173
# Admin panel: http://localhost:5174
# Backend API: http://localhost:8080
# API docs: http://localhost:8080/swagger-ui.html
```

## Tips for Best Results

1. **Use Claude Code (not web chat)** — it has persistent file system and can create 100+ files
2. **Run it in a clean directory** — no pre-existing files
3. **Be patient** — this generates ~200+ files, it takes 15-30 minutes
4. **If it stops mid-way** — say "continue building from where you left off"
5. **If a module has issues** — say "fix the [module] and make it work with the rest"
6. **To add features later** — say "add [feature] to the exam engine following the existing architecture"
