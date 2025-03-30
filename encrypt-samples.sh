#!/bin/bash

set -e

echo "Running Staticrypt encryption for writing samples..."

encrypt() {
  local TARGET_PATH="$1"
  local PAGE_NAME="$2"

  if [ -f "$TARGET_PATH/index.html" ]; then
    echo "Encrypting $PAGE_NAME"
    staticrypt "$TARGET_PATH/index.html" --password "$STATICRYPT_PASSWORD" \
      -m "Enter the password to view this page." --short -d "$TARGET_PATH"

    mv "$TARGET_PATH/index_encrypted.html" "$TARGET_PATH/index.html" || echo "Failed to rename encrypted file"
  else
    echo "No index.html found for $PAGE_NAME"
  fi
}

encrypt "./public/docs/writing_samples" "writing_samples"
encrypt "./public/docs/writing_samples/rn_samples" "rn_samples"
encrypt "./public/docs/writing_samples/technical_guides" "technical_guides"

echo "Encryption complete."
