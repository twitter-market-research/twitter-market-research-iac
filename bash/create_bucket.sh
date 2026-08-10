#!/usr/bin/env bash

# This script creates a Google Cloud Storage bucket with the specified parameters.
# This script is idempotent, meaning it can be run multiple times without causing errors or creating duplicate resources.
# Usage: ./create_bucket.sh

set -euo pipefail

# ------- Parameters -------
BUCKET_NAME=${BUCKET_NAME:-"my-bucket-$(date +%s)"}
PROJECT_ID=${PROJECT_ID:?PROJECT_ID is required}
LOCATION=${LOCATION:-"US"}

# ---------- Create the bucket ----------

echo "==> Project: ${PROJECT_ID}"
echo "==> Bucket : gs://${BUCKET_NAME}"
echo "==> Location: ${LOCATION}"

if gcloud storage buckets describe "gs://${BUCKET_NAME}" --project="${PROJECT_ID}" &>/dev/null; then
    echo "Bucket already exists. Skipping creation"
else
    echo "Creating bucket..."
    gcloud storage buckets create "gs://${BUCKET_NAME}" \
        --project="${PROJECT_ID}" \
        --default-storage-class=STANDARD \
        --location=${LOCATION} \
        --uniform-bucket-level-access \
        --public-access-prevention
fi

# Versioning
echo "Enabling versioning..."
gcloud storage buckets update "gs://${BUCKET_NAME}" \
    --project="${PROJECT_ID}" \
    --versioning

echo "Bucket ${BUCKET_NAME} created successfully."