#!/usr/bin/env bash
set -euo pipefail

docker compose -f "$(dirname "$0")/compose.yaml" up -d --build
