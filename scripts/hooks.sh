#!/usr/bin/env bash
# Turn the committed hooks on or off for this clone (the hooks exist on hooks/failing).
#
#   scripts/hooks.sh on|off
ARGS=("$@")
source "$(dirname "$0")/common.sh"

case "${1:-}" in
  on)
    if [ ! -d .githooks ]; then
      echo "Check out hooks/failing first." >&2
      exit 1
    fi
    git config core.hooksPath .githooks
    echo "Hooks on: core.hooksPath = .githooks"
    ;;
  off)
    git config --unset core.hooksPath || true
    echo "Hooks off."
    ;;
  *)
    sed -n '2,5p' "$0" | sed 's/^# \{0,1\}//'
    exit 1
    ;;
esac
