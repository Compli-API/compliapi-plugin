#!/bin/bash
# Emits the Authorization header only when a token is configured. The API
# rejects a present-but-invalid bearer (so typo'd keys can't silently fall
# through to pay-per-call), which means "no token" must mean NO header —
# tokenless requests then work via x402 pay-per-call, and tools/list is free.
TOKEN="${COMPLIAPI_API_TOKEN:-}"
if [ -z "$TOKEN" ] && [ -f "$HOME/.compliapi/token" ]; then
  TOKEN=$(cat "$HOME/.compliapi/token")
fi
TOKEN=$(printf '%s' "$TOKEN" | tr -d '[:space:]')
if [ -n "$TOKEN" ]; then
  printf '{"Authorization": "Bearer %s"}' "$TOKEN"
else
  printf '{}'
fi
