#!/usr/bin/env bash
set -euo pipefail

MINIO_ALIAS="${MINIO_ALIAS:-minio-local}"
MINIO_URL="${MINIO_URL:-http://minio:9000}"
BUCKET="${TF_STATE_BUCKET:-terraform-state}"

mc alias set "$MINIO_ALIAS" "$MINIO_URL"     "$AWS_ACCESS_KEY_ID" "$AWS_SECRET_ACCESS_KEY"
mc mb --ignore-existing "$MINIO_ALIAS/$BUCKET"
mc version enable "$MINIO_ALIAS/$BUCKET"

echo "✅ Bucket '$BUCKET' ready with versioning enabled."
