#!/usr/bin/env bash
# Runs all test suites and prints a summary.
set -euo pipefail

PASS=0
FAIL=0

run_step() {
  local name="$1"
  local cmd="$2"
  echo ""
  echo "--- $name ---"
  if eval "$cmd"; then
    PASS=$((PASS + 1))
    echo "  PASSED: $name"
  else
    FAIL=$((FAIL + 1))
    echo "  FAILED: $name"
  fi
}

echo "=== NAPLANPrep Test Suite ==="

run_step "Backend unit + integration tests" \
  "cd backend && ./mvnw verify -B && cd .."

run_step "Frontend lint" \
  "cd frontend && npm run lint && cd .."

run_step "Frontend type-check" \
  "cd frontend && npm run type-check && cd .."

run_step "Frontend tests (with coverage)" \
  "cd frontend && npm test -- --coverage --run && cd .."

run_step "Admin panel lint" \
  "cd admin-panel && npm run lint && cd .."

run_step "Admin panel type-check" \
  "cd admin-panel && npm run type-check && cd .."

run_step "Admin panel tests" \
  "cd admin-panel && npm test -- --run && cd .."

echo ""
echo "=== Test Summary ==="
echo "  Passed : $PASS"
echo "  Failed : $FAIL"
echo ""

if [ "$FAIL" -gt 0 ]; then
  echo "One or more test suites failed — see output above."
  exit 1
fi

echo "All tests passed."
