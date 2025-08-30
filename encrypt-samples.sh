#!/usr/bin/env bash

# Purpose: Optionally encrypt sample pages with Staticrypt during Netlify builds.
# Behavior: No-op unless ENABLE_ENCRYPT=1 and STATICRYPT_PASSWORD is set.
# Safety: Always exits 0 so it never fails the build.

set -u

log() { printf "[encrypt-samples] %s\n" "$*"; }

# Toggle checks
if [ "${ENABLE_ENCRYPT:-0}" != "1" ]; then
  log "Skipping encryption (ENABLE_ENCRYPT != 1)."
  exit 0
fi

if [ -z "${STATICRYPT_PASSWORD:-}" ]; then
  log "Skipping encryption (STATICRYPT_PASSWORD is empty)."
  exit 0
fi

# Ensure staticrypt is available; try to install if missing.
if ! command -v staticrypt >/dev/null 2>&1; then
  log "staticrypt not found; attempting to install (npm install -g staticrypt)."
  if ! npm install -g staticrypt >/dev/null 2>&1; then
    log "Warning: failed to install staticrypt; skipping encryption."
    exit 0
  fi
fi

# Encrypt known sample pages if they exist.
encrypt_one() {
  local src="$1"; shift
  local dir
  dir="$(dirname "$src")"
  if [ -f "$src" ]; then
    log "Encrypting: $src"
    if staticrypt "$src" --password "$STATICRYPT_PASSWORD" -m "Enter the password to view this page." --short -d "$dir" >"$dir/encrypt.log" 2>&1; then
      if [ -f "$dir/index_encrypted.html" ]; then
        mv "$dir/index_encrypted.html" "$dir/index.html" || true
      fi
      log "Encrypted: $src"
    else
      log "Warning: encryption failed for $src (see $dir/encrypt.log)."
    fi
  fi
}

encrypt_one "./public/docs/writing_samples/index.html"
encrypt_one "./public/docs/writing_samples/rn_samples/index.html"
encrypt_one "./public/docs/writing_samples/technical_guides/index.html"

log "Done."
exit 0

