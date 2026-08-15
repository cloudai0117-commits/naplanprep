#!/bin/sh
# Write JWT RSA keys from env vars to temp files before starting the app.
# JWT_PRIVATE_KEY and JWT_PUBLIC_KEY must be set in Railway Variables
# with the full PEM content (multiline).
# The exported JWT_PRIVATE_KEY_PATH / JWT_PUBLIC_KEY_PATH override the
# empty defaults in application-uat.yml so Spring picks up the file paths.
set -e

KEY_DIR=/tmp/jwt
mkdir -p "$KEY_DIR"

if [ -n "$JWT_PRIVATE_KEY" ]; then
  printf '%s' "$JWT_PRIVATE_KEY" > "$KEY_DIR/private.pem"
  chmod 600 "$KEY_DIR/private.pem"
  echo "[entrypoint] JWT private key written"
else
  echo "[entrypoint] WARNING: JWT_PRIVATE_KEY not set — startup will fail in uat/prod profiles"
fi

if [ -n "$JWT_PUBLIC_KEY" ]; then
  printf '%s' "$JWT_PUBLIC_KEY" > "$KEY_DIR/public.pem"
  chmod 644 "$KEY_DIR/public.pem"
  echo "[entrypoint] JWT public key written"
else
  echo "[entrypoint] WARNING: JWT_PUBLIC_KEY not set — startup will fail in uat/prod profiles"
fi

export JWT_PRIVATE_KEY_PATH="file:$KEY_DIR/private.pem"
export JWT_PUBLIC_KEY_PATH="file:$KEY_DIR/public.pem"

exec java \
  -XX:+UseContainerSupport \
  -XX:MaxRAMPercentage=75.0 \
  -Djava.security.egd=file:/dev/./urandom \
  -jar /app/app.jar
