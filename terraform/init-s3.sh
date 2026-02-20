#!/bin/bash
set -e

BUCKET_NAME="ag-team-tfstate"
REGION="eu-central-1"

if ! aws s3api head-bucket --bucket "$BUCKET_NAME" &>/dev/null; then
    echo "Creating S3 backend for tfstate..."
    aws s3api create-bucket --bucket "$BUCKET_NAME" \
        --region "$REGION" \
        --create-bucket-configuration LocationConstraint="$REGION"
fi