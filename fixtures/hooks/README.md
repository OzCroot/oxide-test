# Hook demo

Run `scripts/hooks.sh on`, then edit a file here and commit.

- `clean.txt`: passes.
- `slow.txt`: pre-commit prints for five seconds.
- `fixme.txt`: add `FIXME` and pre-commit fails.
- Use a message like `oops` and commit-msg fails.
