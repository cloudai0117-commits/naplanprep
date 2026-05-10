# NAPLANPrep

A subscription-based NAPLAN exam preparation platform for Australian students (Years 3, 5, 7, 9).

## Architecture

```
naplanprep/
├── backend/          # Java 21 + Spring Boot 3.2 REST API
├── frontend/         # React 18 + TypeScript student app (port 5173)
├── admin-panel/      # React 18 + TypeScript admin app (port 5174)
├── infra/            # Docker, Nginx configs
└── .github/workflows # CI/CD pipelines
```

## Quick Start (Local Dev)

### Prerequisites
- Java 21+
- Node 20+
- Docker + Docker Compose

### Option 1: Docker (recommended)

```bash
docker-compose up -d
```

- Student app: http://localhost:5173
- Admin panel: http://localhost:5174
- Backend API: http://localhost:8080
- Swagger UI: http://localhost:8080/swagger-ui.html

### Option 2: Manual

**Start infrastructure:**
```bash
docker-compose up -d postgres redis
```

**Backend:**
```bash
cd backend
./mvnw spring-boot:run -Dspring-boot.run.profiles=dev
```

**Frontend:**
```bash
cd frontend
npm install
npm run dev
```

**Admin Panel:**
```bash
cd admin-panel
npm install
npm run dev
```

## Environment Profiles

| Profile | Database | Stripe | CORS |
|---------|----------|--------|------|
| `dev` | localhost:5432/naplanprep_dev | TEST keys | localhost:5173, localhost:5174 |
| `uat` | ${DB_HOST}/naplanprep_uat | TEST keys via env vars | uat.naplanprep.com.au |
| `prod` | ${DB_HOST}/naplanprep_prod | LIVE keys via env vars | naplanprep.com.au |

## Subscription Plans

| Plan | Monthly | Annual | Features |
|------|---------|--------|----------|
| FREE | $0 | $0 | 1 diagnostic/year level, 10 questions/day |
| STANDARD | $14.99 | $129 | Full question bank, 12 mocks/year, progress tracking |
| PREMIUM | $24.99 | $219 | Adaptive learning, unlimited mocks, parent dashboard |
| FAMILY | $34.99 | - | Up to 4 children, all Premium features |

## Admin Access

Default admin: `admin@naplanprep.com.au` / `Admin123!`

## Tech Stack

**Backend:** Java 21, Spring Boot 3.2, Spring Security (JWT RS256), Spring Data JPA, Flyway, Redis, Stripe SDK

**Frontend:** React 18, TypeScript, Vite, React Router v6, Zustand, TanStack Query, Recharts, Tailwind CSS, React Hook Form + Zod, Stripe Elements

**Database:** PostgreSQL 16

**Infrastructure:** Docker, GitHub Actions CI/CD

## API Documentation

Swagger UI available at `/swagger-ui.html` in dev/uat profiles.

## Running Tests

```bash
# Backend unit + integration tests
cd backend && ./mvnw verify

# Frontend tests
cd frontend && npm test

# Admin panel tests
cd admin-panel && npm test
```
