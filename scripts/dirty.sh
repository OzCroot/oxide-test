#!/usr/bin/env bash
# Put the working tree into a state a branch cannot hold.
#
#   scripts/dirty.sh hunks       four unstaged hunks in one file, one of them staged (staging/multi-hunk only)
#   scripts/dirty.sh mixed       staged, unstaged and untracked changes plus a stash (any branch)
#   scripts/dirty.sh whitespace  re-indent a file so only whitespace changes (any branch)
#   scripts/dirty.sh stashes     three stashes (any branch)
#   scripts/dirty.sh clean       discard all changes and untracked files (asks first; --yes skips)
ARGS=("$@")
source "$(dirname "$0")/common.sh"

scenario="${1:-}"

case "$scenario" in
  hunks)
    patch_dir="fixtures/staging"
    if [ ! -f "$patch_dir/hunks.patch" ]; then
      echo "Check out staging/multi-hunk first." >&2
      exit 1
    fi
    require_clean
    git apply "$patch_dir/hunks.patch"
    git apply --cached "$patch_dir/hunks-first.patch"
    echo "Done. Open fixtures/staging/report.ts: four hunks, the first one staged."
    ;;

  mixed)
    require_clean
    echo "- a note that goes into the stash" >> docs/notes.md
    git stash push -q -m "demo stash" -- docs/notes.md
    echo "// staged change" >> src/hello.ts
    git add src/hello.ts
    echo "// unstaged change" >> src/lib/math.ts
    echo "an untracked file" > untracked-demo.txt
    echo "Done. One staged file, one unstaged file, one untracked file and one stash."
    ;;

  whitespace)
    require_clean
    sed -i 's/^  /    /' src/lib/strings.ts
    echo "Done. src/lib/strings.ts changed only in indentation."
    ;;

  stashes)
    require_clean
    for n in 1 2 3; do
      echo "- stash note $n" >> docs/notes.md
      git stash push -q -m "demo stash $n" -- docs/notes.md
    done
    echo "Done. Three stashes."
    ;;

  clean)
    if confirm "Discard ALL changes and untracked files in $ROOT?"; then
      git reset -q --hard
      git clean -fdq
      echo "Done. The working tree is clean. Stashes are untouched."
    else
      echo "Nothing changed."
    fi
    ;;

  *)
    sed -n '2,9p' "$0" | sed 's/^# \{0,1\}//'
    exit 1
    ;;
esac
