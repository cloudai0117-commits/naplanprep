#!/usr/bin/env bash
# Generates RSA key pair for JWT signing.
# Keys are gitignored — back them up securely (e.g. Railway/Vercel secrets, password manager).
set -euo pipefail

KEYS_DIR="backend/src/main/resources/keys"
mkdir -p "$KEYS_DIR"

if [ -f "$KEYS_DIR/private.pem" ]; then
  echo "Keys already exist at $KEYS_DIR — skipping."
  exit 0
fi

echo "Generating 2048-bit RSA key pair for JWT signing..."
openssl genpkey -algorithm RSA -out "$KEYS_DIR/private.pem" -pkeyopt rsa_keygen_bits:2048
openssl rsa -pubout -in "$KEYS_DIR/private.pem" -out "$KEYS_DIR/public.pem"
chmod 600 "$KEYS_DIR/private.pem"

echo "Keys generated:"
echo "  Private key: $KEYS_DIR/private.pem"
echo "  Public key:  $KEYS_DIR/public.pem"
echo ""
echo "IMPORTANT: These files are gitignored. Store private.pem in a secure vault."
