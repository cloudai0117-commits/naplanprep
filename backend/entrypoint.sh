#!/bin/sh
# Materialise JWT RSA keys from Railway Variables (JWT_PRIVATE_KEY / JWT_PUBLIC_KEY)
# into /tmp/jwt/ before the JVM starts.
#
# Key paths are passed as Spring Boot command-line arguments (highest priority in
# Spring's property resolution — rank 1, overrides any Railway Variable regardless
# of whether it is named JWT_PRIVATE_KEY_PATH, APP_JWT_PRIVATE_KEY_PATH, or anything
# else that might have been configured previously).
set -e

KEY_DIR=/tmp/jwt
mkdir -p "$KEY_DIR"

if [ -n "$JWT_PRIVATE_KEY" ]; then
  printf '%s' "$JWT_PRIVATE_KEY" > "$KEY_DIR/private.pem"
  chmod 600 "$KEY_DIR/private.pem"
  echo "[entrypoint] JWT private key written to $KEY_DIR/private.pem"
else
  echo "[entrypoint] FAIL: JWT_PRIVATE_KEY Railway Variable is not set."
  echo "             Set it to the full PKCS#8 PEM content (multiline)."
  echo "             The application cannot start in uat/prod without it."
  exit 1
fi

if [ -n "$JWT_PUBLIC_KEY" ]; then
  printf '%s' "$JWT_PUBLIC_KEY" > "$KEY_DIR/public.pem"
  chmod 644 "$KEY_DIR/public.pem"
  echo "[entrypoint] JWT public key written to $KEY_DIR/public.pem"
else
  echo "[entrypoint] FAIL: JWT_PUBLIC_KEY Railway Variable is not set."
  exit 1
fi

echo "[entrypoint] Starting application with key paths: $KEY_DIR/{private,public}.pem"

exec java \
  -XX:+UseContainerSupport \
  -XX:MaxRAMPercentage=75.0 \
  -Djava.security.egd=file:/dev/./urandom \
  -jar /app/app.jar \
  "--app.jwt.private-key-path=file:$KEY_DIR/private.pem" \
  "--app.jwt.public-key-path=file:$KEY_DIR/public.pem"
