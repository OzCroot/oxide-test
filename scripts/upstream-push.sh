#!/usr/bin/env bash
# Push new commits to a branch of `origin` as if a teammate had made them.
#
#   scripts/upstream-push.sh <branch> [count]
#
# Works from a second clone at ../oxide-test-pusher. Run it from ../oxide-test-local to stay offline.
ARGS=("$@")
source "$(dirname "$0")/common.sh"

branch="${1:-}"
count="${2:-1}"
if [ -z "$branch" ]; then
  sed -n '2,6p' "$0" | sed 's/^# \{0,1\}//'
  exit 1
fi

url="$(git remote get-url origin)"
pusher="$ROOT/../oxide-test-pusher"
if [ ! -d "$pusher/.git" ]; then
  git clone -q "$url" "$pusher"
fi

slug="${branch//\//-}"
(
  cd "$pusher"
  git fetch -q origin
  git checkout -q -B "$branch" "origin/$branch"
  mkdir -p fixtures/sync
  for i in $(seq 1 "$count"); do
    echo "upstream commit $(date +%H:%M:%S)" >> "fixtures/sync/upstream-$slug.txt"
    git add -A
    git -c user.name="Upstream Bot" -c user.email="upstream@example.com" \
      commit -q -m "chore(sync): upstream commit $i of $count"
  done
  git push -q origin "$branch"
)
echo "Pushed $count commit(s) to origin/$branch."
