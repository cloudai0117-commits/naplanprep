# NAPLANPrep

![CI](https://github.com/cloudai0117/naplanprep/actions/workflows/ci.yml/badge.svg)
![Deploy UAT](https://github.com/cloudai0117/naplanprep/actions/workflows/deploy-uat.yml/badge.svg)
![Deploy Prod](https://github.com/cloudai0117/naplanprep/actions/workflows/deploy-prod.yml/badge.svg)
![Java](https://img.shields.io/badge/Java-21-blue?logo=openjdk)
![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.2-green?logo=springboot)
![React](https://img.shields.io/badge/React-18-blue?logo=react)
![TypeScript](https://img.shields.io/badge/TypeScript-5-blue?logo=typescript)

A subscription-based NAPLAN exam preparation platform for Australian students (Years 3, 5, 7, 9).

---

## Live URLs

| Environment | Student App | Admin Panel | API |
|-------------|-------------|-------------|-----|
| **UAT**     | _after first deploy_ | _after first deploy_ | _after first deploy_ |
| **PROD**    | _after first deploy_ | _after first deploy_ | _after first deploy_ |

---

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        Phase 1 (Railway + Vercel)           │
│                                                             │
│   Student App (React)      Admin Panel (React)             │
│   └── Vercel               └── Vercel                      │
│              │                        │                    │
│              └──────────┬─────────────┘                    │
│                         ▼                                  │
│               Backend API (Spring Boot)                    │
│               └── Railway                                  │
│                    │           │                           │
│               PostgreSQL    Redis                          │
│               └── Railway   └── Railway                   │
└─────────────────────────────────────────────────────────────┘

naplanprep/
├── backend/            Java 21 + Spring Boot 3.2 REST API (port 8080)
├── frontend/           React 18 + TypeScript  student app  (port 5173)
├── admin-panel/        React 18 + TypeScript  admin app    (port 5174)
├── scripts/            Setup, deploy, seed, and test scripts
├── docs/               Deployment guide and environment reference
└── .github/workflows/  CI/CD pipelines (ci, deploy-uat, deploy-prod)
```

---

## Quick Start (Local Dev)

### Prerequisites
- Java 21+, Node 20+, Docker, openssl

### One-shot setup (Mac/Linux/WSL)

```bash
bash scripts/setup-local.sh
```

This script checks prerequisites, copies `.env.example` files, generates JWT keys,
starts Docker services, and seeds sample data.

### Manual setup

```bash
# Copy env files
cp backend/.env.example backend/.env.development
cp frontend/.env.example frontend/.env.development
cp admin-panel/.env.example admin-panel/.env.development

# Generate JWT keys
bash scripts/generate-keys.sh

# Start all services
docker compose up -d

# Seed the database
bash scripts/seed-data.sh
```

| URL | Service |
|-----|---------|
| http://localhost:5173 | Student App |
| http://localhost:5174 | Admin Panel |
| http://localhost:8080 | Backend API |
| http://localhost:8080/swagger-ui.html | Swagger UI |

---

## Deploying (Phase 1 — Railway + Vercel)

```bash
# Interactive setup — sets Railway, Vercel, and GitHub Secrets in one go
bash scripts/deploy-phase1.sh
```

Then push to deploy:
- `develop` → UAT (automatic)
- `main` → Production (automatic or manual via workflow_dispatch)

See [docs/deployment.md](docs/deployment.md) for the full step-by-step guide.

---

## Running Tests

```bash
# Run all test suites and print a summary
bash scripts/run-tests.sh

# Or individually:
cd backend && ./mvnw verify
cd frontend && npm test
cd admin-panel && npm test
```

---

## Environment Profiles

| Profile | Database | Stripe | CORS |
|---------|----------|--------|------|
| `dev`  | localhost:5432/naplanprep_dev | TEST keys | localhost:5173, localhost:5174 |
| `uat`  | Railway UAT / naplanprep_uat  | TEST keys | uat.naplanprep.com.au |
| `prod` | Railway PROD / naplanprep_prod | LIVE keys | naplanprep.com.au |

See [docs/environments.md](docs/environments.md) for the full variable reference.

---

## Subscription Plans

| Plan | Monthly | Annual | Features |
|------|---------|--------|----------|
| FREE | $0 | $0 | 1 diagnostic per year level, 10 questions/day |
| STANDARD | $14.99 | $129 | Full question bank, 12 mock exams/year |
| PREMIUM | $24.99 | $219 | Adaptive learning, unlimited mocks, parent dashboard |
| FAMILY | $34.99 | — | Up to 4 children, all Premium features |

---

## Default Credentials (dev/seed only)

| Account | Email | Password |
|---------|-------|----------|
| Admin | admin@naplanprep.com.au | Admin123! |
| Test Student 1 (Year 3) | student1@test.com | Admin123! |
| Test Student 2 (Year 5) | student2@test.com | Admin123! |

---

## Tech Stack

**Backend:** Java 21, Spring Boot 3.2, Spring Security (JWT RS256), Spring Data JPA, Flyway, Redis, Stripe SDK

**Frontend:** React 18, TypeScript, Vite, React Router v6, Zustand, TanStack Query, Tailwind CSS, Stripe Elements

**Database:** PostgreSQL 16

**Infrastructure:** Docker, GitHub Actions CI/CD, Railway, Vercel
