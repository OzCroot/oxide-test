#!/usr/bin/env bash
# Build a local bare remote and a clone of it, so sync features can be tested offline.
#
#   scripts/local-remote.sh [--force]
#
# Creates ../oxide-test-remote.git (every branch and tag) and ../oxide-test-local (a clone).
# Open ../oxide-test-local in Oxide Git, and run the other scripts from there. GitHub stays untouched.
ARGS=("$@")
source "$(dirname "$0")/common.sh"

remote="$ROOT/../oxide-test-remote.git"
local_clone="$ROOT/../oxide-test-local"

if [ -e "$remote" ] || [ -e "$local_clone" ]; then
  if confirm "Replace $remote and $local_clone?"; then
    rm -rf "$remote" "$local_clone"
  else
    echo "Nothing changed."
    exit 1
  fi
fi

git init -q --bare "$remote"
# A clone from GitHub has branches as origin/* only, so push those as branches first.
if git for-each-ref --count=1 refs/remotes/origin | grep -q .; then
  git push -q "$remote" 'refs/remotes/origin/*:refs/heads/*' 2>/dev/null || true
fi
git push -q "$remote" 'refs/heads/*:refs/heads/*'
git push -q "$remote" --tags
git --git-dir="$remote" symbolic-ref HEAD refs/heads/master
git clone -q "$remote" "$local_clone"
echo "Done."
echo "  remote: $remote"
echo "  clone:  $local_clone"
