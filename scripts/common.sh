#!/usr/bin/env bash
# Shared checks for the oxide-test helper scripts. Sourced, not run.
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || {
  echo "Run this inside the oxide-test repository." >&2
  exit 1
}
if [ "$(head -n 1 "$ROOT/README.md" 2>/dev/null)" != "# oxide-test" ]; then
  echo "This is not the oxide-test repository: $ROOT" >&2
  exit 1
fi
cd "$ROOT"

# Ask before a destructive step. `--yes` anywhere in the arguments skips the question.
confirm() {
  local prompt="$1"
  for a in "${ARGS[@]:-}"; do [ "$a" = "--yes" ] && return 0; done
  read -r -p "$prompt [y/N] " reply
  [ "$reply" = "y" ] || [ "$reply" = "Y" ]
}

require_clean() {
  if [ -n "$(git status --porcelain)" ]; then
    echo "The working tree has changes. Run: scripts/dirty.sh clean" >&2
    exit 1
  fi
}

current_branch() {
  git symbolic-ref --short HEAD
}
