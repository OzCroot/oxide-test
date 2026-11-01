#!/usr/bin/env bash
# Put a branch into a tracking state, to test pull strategies and the ahead/behind display.
#
#   scripts/sync-scenarios.sh behind|ahead|diverged <branch>
#
# The branch needs an upstream. Run this from ../oxide-test-local (see local-remote.sh).
ARGS=("$@")
source "$(dirname "$0")/common.sh"

kind="${1:-}"
branch="${2:-}"
if [ -z "$kind" ] || [ -z "$branch" ]; then
  sed -n '2,6p' "$0" | sed 's/^# \{0,1\}//'
  exit 1
fi
require_clean
git checkout -q "$branch"
git rev-parse --abbrev-ref "@{upstream}" >/dev/null 2>&1 || {
  echo "$branch has no upstream. Run this from the clone that local-remote.sh made." >&2
  exit 1
}

local_commit() {
  mkdir -p fixtures/sync
  echo "local commit $(date +%H:%M:%S)" >> "fixtures/sync/local-${branch//\//-}.txt"
  git add -A
  git commit -q -m "chore(sync): local commit"
}

case "$kind" in
  ahead)    local_commit ;;
  behind)   "$(dirname "$0")/upstream-push.sh" "$branch" 1; git fetch -q origin ;;
  diverged) local_commit; "$(dirname "$0")/upstream-push.sh" "$branch" 1; git fetch -q origin ;;
  *) echo "Use behind, ahead or diverged." >&2; exit 1 ;;
esac

read -r behind ahead < <(git rev-list --left-right --count "@{upstream}...HEAD")
echo "$branch is now $ahead ahead and $behind behind its upstream."
