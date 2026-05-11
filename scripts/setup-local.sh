#!/usr/bin/env bash
# One-shot local development setup: checks prerequisites, copies env files,
# generates JWT keys, starts Docker services, and seeds sample data.
set -euo pipefail

echo "=== NAPLANPrep Local Setup ==="
echo ""

check_command() {
  if ! command -v "$1" &>/dev/null; then
    echo "ERROR: '$1' not found. Please install it and retry."
    exit 1
  fi
  echo "  ok  $1"
}

echo "Checking prerequisites..."
check_command java
check_command node
check_command docker
check_command openssl

JAVA_VER=$(java -version 2>&1 | grep -oP '(?<=version ")\d+')
if [ "${JAVA_VER:-0}" -lt 21 ]; then
  echo "ERROR: Java 21+ required, found Java ${JAVA_VER:-unknown}"
  exit 1
fi

NODE_VER=$(node -v | grep -oP '(?<=v)\d+')
if [ "${NODE_VER:-0}" -lt 20 ]; then
  echo "ERROR: Node 20+ required, found Node ${NODE_VER:-unknown}"
  exit 1
fi

echo ""
echo "Copying .env.example files..."
for dir in backend frontend admin-panel; do
  if [ ! -f "$dir/.env.development" ] && [ -f "$dir/.env.example" ]; then
    cp "$dir/.env.example" "$dir/.env.development"
    echo "  Created $dir/.env.development"
  else
    echo "  Skipped $dir/.env.development (already exists)"
  fi
done

echo ""
bash scripts/generate-keys.sh

echo ""
echo "Starting Docker services (postgres + redis + backend + frontend + admin)..."
docker compose up -d

echo ""
echo "Waiting for backend to be healthy..."
for i in $(seq 1 40); do
  if curl -sf http://localhost:8080/actuator/health &>/dev/null; then
    echo "  Backend is healthy"
    break
  fi
  if [ "$i" -eq 40 ]; then
    echo "ERROR: Backend did not start within 2 minutes. Check: docker compose logs backend"
    exit 1
  fi
  printf "."
  sleep 3
done

echo ""
bash scripts/seed-data.sh

echo ""
echo "=== Setup Complete ==="
echo ""
echo "  Student App : http://localhost:5173"
echo "  Admin Panel : http://localhost:5174"
echo "  Backend API : http://localhost:8080"
echo "  Swagger UI  : http://localhost:8080/swagger-ui.html"
echo ""
echo "  Admin login    : admin@naplanprep.com.au / Admin123!"
echo "  Test student 1 : student1@test.com / Admin123!"
echo "  Test student 2 : student2@test.com / Admin123!"
