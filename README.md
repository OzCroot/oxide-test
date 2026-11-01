# oxide-test

A demo repository for testing [Oxide Git](https://github.com/OzCroot/oxide-git), a desktop Git client for the bare repo and worktree workflow.

## Purpose

Oxide Git has many features that only appear in specific repository states: multi-hunk diffs, merge conflicts, Git LFS pointers, failing hooks, a history of thousands of commits, images, and more. Building each state by hand for every manual check is slow.

This repository holds those states ready made. **Each branch tests one feature.** Check the branch out (or open it in its own worktree), do what the table says, and compare with what you should see.

Everything here is fake. The code does nothing useful, the authors use `example.com` addresses, and the LFS pointers point at objects that do not exist.

## How to use it

**As a Worktree Project** (the main workflow): in Oxide Git choose *Create Project* and enter `https://github.com/OzCroot/oxide-test.git`. Oxide Git clones it bare and lets you add a worktree per branch.

**As a Standard Project**: run `git clone https://github.com/OzCroot/oxide-test.git`, then *Open Repository*. This is the state *Convert to Worktree Project* starts from.

**Offline, with a remote you can change**: run `scripts/local-remote.sh`, then open `../oxide-test-local`. See [Scripts](#scripts).

A branch holds only committed state. Uncommitted changes, stashes and remote changes come from the [scripts](#scripts), and the tables say when a test needs one.

## Branches

There are 37 test branches besides `master`. Branch names use `area/case`, so the sidebar's folder grouping gets a workout too. Each branch changes only its own `fixtures/<area>/` folder, so merging branches does not collide by accident. The two `conflict/*` branches collide on purpose.

### Branch list

| Branch | What it holds | Try this | You should see |
|---|---|---|---|
| `develop` | 3 commits ahead of `master`. | Select `develop` in the sidebar. | History lists 3 commits above `master`'s tip. |
| `feature/login-form` | One commit. | Open the Branches section. | `feature/` is a group. The three `feature/` branches sit under it, and `ui/` nests inside. |
| `feature/ui/nested-button` | One commit, a two-level name. | Add a worktree for it with the pattern `{project}/{branch}`. | The preview path keeps the slashes as folders. |
| `feature/ui/forms/date-picker` | One commit, a three-level name. | Create a branch and click the prefix chips. | `feature/`, `fix/` and `chore/` show. `hotfix/` shows only after you add it in Settings > Git > Branches. |
| `fix/null-pointer` | One commit. | Look at the `fix/` group. | One branch in the group. |
| `chore/deps-bump` | One commit. | Look at the `chore/` group. | One branch in the group. |
| `hotfix/1.0.1` | One commit. | Look at the list. | A `hotfix/` group with one branch. |
| `release/1.0` | Forked at `v1.0.0`, so it is behind `master`. | Set protected branches to `release/*`, check it out, and stage a change. | An amber banner warns you are on a protected branch. |
| `release/2.0` | One release commit on `master`. | With `release/*` protected, delete `release/2.0`. | A locked confirm, with no "don't ask again" and no link to settings. |
| `feature/a-very-long-branch-name-that-should-be-truncated-in-the-sidebar-and-still-readable-in-a-tooltip` | One commit, a 100-character name. | Look at the sidebar and the branch picker. | The name is cut off with an ellipsis and a tooltip shows the full name. |
| `scratch/merged` | Already merged into `master` (a merge commit is in history). | Delete it. | A plain delete works with no force step. |
| `scratch/unmerged` | A commit that is not on `master`. | Delete it. | Git refuses a normal delete because the branch is not merged. See what the app offers. |

### Merge

| Branch | What it holds | Try this | You should see |
|---|---|---|---|
| `merge/clean-a` | Edits the top of `src/lib/math.ts`. | Check out `merge/clean-a` and merge `merge/clean-b`. | The merge succeeds with no conflict. The toast offers **Delete branch**. |
| `merge/clean-b` | Edits the bottom of `src/lib/math.ts`. | Merge it into `merge/clean-a`. | Git combines both edits in one file. |
| `merge/fast-forward` | 2 commits ahead of `master`. | Check out `master` and merge `merge/fast-forward`. | A fast-forward: no merge commit, `master` moves to the tip. |

### Conflicts

| Branch | What it holds | Try this | You should see |
|---|---|---|---|
| `conflict/ours` | Edits the same lines as `conflict/theirs`, deletes `old.txt`, renames `rename-me.txt`, adds `new-file.txt`, and recolours `logo.png`. | Check out `conflict/ours` and merge `conflict/theirs`. | The conflict panel lists the conflicted files: three content conflicts (one is the binary image), add/add, delete/modify and rename/rename. Try **Open in merge tool** and **Abort**. |
| `conflict/theirs` | The other side of every conflict above. | Use it as the branch to merge, or to rebase or cherry-pick later. | The same conflicts, seen from the other side. |

### Diff viewer

| Branch | What it holds | Try this | You should see |
|---|---|---|---|
| `diff/whitespace` | Re-indent, trailing spaces and tab/space changes, plus one real edit. | Open the last commit's file. Set Settings > Diff > Ignore whitespace to **All whitespace**. | Only the real edit stays in the diff. |
| `diff/word-level` | Lines where one word changed, and replaced blocks. | Open the last commit's file. Toggle **Word-level highlighting**. | Only the changed word has the stronger colour. With the setting off the marks go. |
| `diff/syntax` | Edits in rs, ts, py, go, json, yaml, md, css, html, sh, c and sql, with `# comment`, `#include`, `--` and a block comment. | Open each file's diff. Switch the app between light and dark. | Keywords are coloured and the colours follow the theme. A `# comment` line is a comment, not code. |
| `diff/long-lines` | A 5,000-character line and tab-indented code. | Open the diff. Change Word wrap, Tab width and Show whitespace. | The line wraps or scrolls, tabs change width, and spaces show as `·` and tabs as `→`. |
| `diff/context` | A 300-line file with seven edits 40 lines apart. | Open the diff. Set Context lines to 3, then 10, then Full file. | Seven hunks, then still seven, then one hunk. |
| `diff/large` | A 6,000-line file and a 1.2 MB file, rewritten in full. | Open each file's diff. | "Diff is large" with a **Load anyway** button. Lower the threshold to see the line limit act. |
| `diff/images` | A PNG changed (new size), a PNG added, a PNG deleted, a JPEG and a GIF changed. | Open each image's diff. Switch between Side by side, Swipe and Onion skin. | Both versions show, with sizes. An added image shows "Did not exist", a deleted one "Deleted". |
| `diff/binary` | A non-image binary file changed. | Open the diff. | "Binary file changed". |
| `diff/eof-and-endings` | A file with no newline at the end, a CRLF file turned LF, and mixed line endings. | Open each diff. | The `\ No newline at end of file` marker shows as a plain line after the last line. The CRLF file shows every line changed. |
| `diff/rename-and-mode` | A rename with edits, an exec-bit change, an added file and a deleted file. | Open the commit. | Status letters R, M, A and D. The mode-only change shows "No changes". |

### Git LFS

| Branch | What it holds | Try this | You should see |
|---|---|---|---|
| `lfs/pointers` | A root `.gitattributes` with `filter=lfs` and hand-written pointer files. One pointer changes, one is added, one deleted. | Open the branch with Git LFS support on **Auto**. | Pointer files carry an **LFS** badge. Their diff shows the short object id and size, not the raw text. |
| `lfs/attributes-only` | A root `.gitattributes` with LFS rules and no LFS files. | Open it on **Auto**, then on **Off**. | Auto detects LFS. With `git-lfs` missing a notice offers an install link. Off hides it all. |

### Commit authoring

| Branch | What it holds | Try this | You should see |
|---|---|---|---|
| `hooks/failing` | `.githooks/` with a failing `pre-commit`, a strict `commit-msg` and a slow check. | Run `scripts/hooks.sh on`. Commit a file that contains `FIXME`, then one with the message `oops`. | A hook result panel names the hook and exit code and shows its output without colour codes. |

### History

| Branch | What it holds | Try this | You should see |
|---|---|---|---|
| `history/graph` | Parallel lanes, merges and an octopus merge. | Open the history list. | The graph shows several lanes that join again. |
| `history/long` | 2,200 tiny commits on top of `master`. | Scroll to the end. Click the `root` tag. | The list stays smooth. The tag is past the 2,000-commit cap, so the app cannot reveal it. |
| `history/authors` | 40 commits by 10 author identities, dates from 2019 to 2026. One name has two emails, and one identity is a bot. | Change Author display, Date format and the Gravatar setting. | Names or initials change, dates follow the format, avatars stay off until you consent. |
| `history/messages` | Very long subject, multi-paragraph bodies, emoji, trailers and conventional types. | Select each commit. | The detail pane wraps long text and keeps paragraphs and trailers. |

### Files

| Branch | What it holds | Try this | You should see |
|---|---|---|---|
| `files/tree-and-names` | 80 files in deep folders, with spaces, unicode and a leading dash in names. | Open the commit's file list and the Working Changes tree. | Folders group and collapse. Every name shows as written, with no quote marks or escapes. |

### Staging

| Branch | What it holds | Try this | You should see |
|---|---|---|---|
| `staging/multi-hunk` | A 120-line file and a block file, with patches in `fixtures/staging/`. | Run `scripts/dirty.sh hunks`. Open `report.ts` under Unstaged changes. | Four hunks, one already staged. Try **Stage hunk**, line checkboxes, **Unstage hunk** and **Discard hunk**. |

### Sync

| Branch | What it holds | Try this | You should see |
|---|---|---|---|
| `sync/playground` | One commit. The target for `scripts/upstream-push.sh`. | Run `scripts/local-remote.sh`, open `../oxide-test-local`, set Auto-fetch to 5 minutes, then run `scripts/upstream-push.sh sync/playground`. | Within the interval the branch shows **new** and the new commits. |

## Tags

| Tag | What it is |
|---|---|
| `v0.1.0` | lightweight, on the fifth commit of `master` |
| `v1.0.0` | annotated, multi-line message |
| `v1.1.0-rc.1` | annotated, on `master`'s tip |
| `graph-only` | a commit reachable only from `history/graph` |
| `root` | the first commit of `history/long`, past the 2,000-commit cap |

## Scripts

All scripts live in `scripts/`, refuse to run outside this repository, and ask before anything destructive.

| Script | What it does | Tests that need it |
|---|---|---|
| `dirty.sh hunks` | Four unstaged hunks in `fixtures/staging/report.ts`, the first one staged. Needs `staging/multi-hunk`. | Selective staging |
| `dirty.sh mixed` | A staged, an unstaged and an untracked change, plus a stash. Any branch. | Convert to Worktree Project, stashes, working changes |
| `dirty.sh whitespace` | Re-indents `src/lib/strings.ts`. | Ignore whitespace on a working diff |
| `dirty.sh stashes` | Three stashes. | Stash list, apply, pop, drop |
| `dirty.sh clean` | Discards all changes and untracked files. Asks first. | Reset between tests |
| `local-remote.sh` | Builds `../oxide-test-remote.git` and a clone, `../oxide-test-local`. | Everything in Sync, offline |
| `upstream-push.sh <branch> [n]` | Pushes `n` commits to `origin/<branch>` from a second clone. | Auto-fetch, the **new** badge, notifications |
| `sync-scenarios.sh behind\|ahead\|diverged <branch>` | Puts a branch in that tracking state. | Pull strategies, ahead/behind, force push |
| `hooks.sh on\|off` | Sets `core.hooksPath` to the committed `.githooks`. | Hook failure panel |

## Resetting

- Discard local changes: `scripts/dirty.sh clean`.
- Start a sync test from scratch: `scripts/local-remote.sh --force`.
- Turn the hooks off: `scripts/hooks.sh off`.
- Everything else is committed, so `git checkout <branch>` is a known state.

## Caveats

- **LFS objects do not exist.** The pointer files on `lfs/*` are valid but point at nothing, so `git lfs fetch` fails. That is expected. If `git-lfs` is installed, check those branches out with `GIT_LFS_SKIP_SMUDGE=1`.
- **The hooks are off** until you run `scripts/hooks.sh on`.
- **Authors are fake.** Avatars use `example.com` addresses, so Gravatar finds nothing.
- **`history/long` is big in commits, small in bytes.** The first push of 2,200 commits takes a moment.
- **Dates are fixed**, apart from `history/authors`, which spans 2019 to 2026. Relative dates such as "2 days ago" age as time passes.

## Publishing this repository

```sh
git push -u origin --all
git push origin --tags
```

