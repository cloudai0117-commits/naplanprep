# NAPLANPrep — Environment Reference

## Three Environments

| Environment | Branch    | Backend         | Frontend           | Stripe Keys |
|-------------|-----------|-----------------|---------------------|-------------|
| **dev**     | any       | localhost:8080  | localhost:5173/5174 | TEST        |
| **uat**     | `develop` | Railway UAT     | Vercel UAT preview  | TEST        |
| **prod**    | `main`    | Railway PROD    | Vercel PROD         | LIVE        |

## Environment Variable Reference

### Backend

| Variable                      | dev                          | uat                         | prod                        |
|-------------------------------|------------------------------|-----------------------------|-----------------------------|
| `SPRING_PROFILES_ACTIVE`      | `dev`                        | `uat`                       | `prod`                      |
| `SPRING_DATASOURCE_URL`       | `jdbc:postgresql://localhost:5432/naplanprep_dev` | Set via Railway env | Set via Railway env |
| `SPRING_DATASOURCE_USERNAME`  | `postgres`                   | Railway secret              | Railway secret              |
| `SPRING_DATASOURCE_PASSWORD`  | `postgres`                   | GitHub Secret               | GitHub Secret               |
| `SPRING_DATA_REDIS_HOST`      | `localhost`                  | Railway Redis host          | Railway Redis host          |
| `APP_STRIPE_SECRET_KEY`       | `sk_test_...` (local .env)   | `sk_test_...` (GH Secret)   | `sk_live_...` (GH Secret)   |
| `APP_STRIPE_WEBHOOK_SECRET`   | `whsec_test_...`             | `whsec_test_...`            | `whsec_live_...`            |
| `APP_CORS_ALLOWED_ORIGINS`    | `http://localhost:5173,...`  | `https://uat.naplanprep...` | `https://naplanprep.com.au` |
| `APP_JWT_PRIVATE_KEY_PATH`    | `classpath:keys/private.pem` | Railway volume / env        | Railway volume / env        |

### Frontend / Admin

| Variable           | dev                          | uat                               | prod                              |
|--------------------|------------------------------|-----------------------------------|-----------------------------------|
| `VITE_API_URL`     | `http://localhost:8080/v1`   | `https://<uat>.railway.app/v1`    | `https://<prod>.railway.app/v1`   |
| `VITE_STRIPE_KEY`  | `pk_test_...`                | `pk_test_...`                     | `pk_live_...`                     |

## Stripe Key Rules

- **UAT always uses TEST keys** (`pk_test_` / `sk_test_` / `whsec_test_`)
- **PROD uses LIVE keys** (`pk_live_` / `sk_live_` / `whsec_live_`)
- Never commit real keys — all keys must come from GitHub Secrets or Railway environment variables

## Local Dev — .env Files

Each service has a `.env.example` file. To set up locally:

```bash
cp backend/.env.example backend/.env.development
cp frontend/.env.example frontend/.env.development
cp admin-panel/.env.example admin-panel/.env.development
```

Edit the `.env.development` files with your local values. These files are gitignored.
