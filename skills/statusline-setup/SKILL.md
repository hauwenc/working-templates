---
name: statusline-setup
description: This skill should be used when the user asks to "set up the status line", "configure statusline", "install status line", or wants to configure the Claude Code status line display on a new machine.
---

# Status Line Setup

Install and configure a Claude Code status line that displays session info with color-coded indicators.

## What It Shows

- `user@host` — current user and hostname (green)
- `[HH:MM:SS]` — current time (blue)
- `[cwd]` — working directory with `~` shortening (white)
- `[branch]` / `[branch *]` — git branch with dirty indicator (yellow, red asterisk)
- `[ctx:N%]` — context window usage (green/yellow/red)
- `[tok:N]` — cumulative session tokens (cyan)
- `[5h:N%]` — 5-hour rate limit usage (green/yellow/red)
- `[7d:N%]` — 7-day rate limit usage (green/yellow/red)

Color thresholds: green < 50%, yellow 50-80%, red > 80%.

## Prerequisites

- `jq` must be installed (`brew install jq` / `apt install jq` / `choco install jq` / `winget install jqlang.jq`)
- `git` for branch display (optional, gracefully skipped if unavailable)

## Installation Steps

1. Copy the bundled script to `~/.claude/statusline-command.sh`:

```bash
cp "$(dirname "$0")/scripts/statusline-command.sh" ~/.claude/statusline-command.sh
chmod +x ~/.claude/statusline-command.sh
```

Since the `cp` path above is illustrative, locate the script bundled with this skill at `scripts/statusline-command.sh` and copy its contents to `~/.claude/statusline-command.sh`. Make the file executable on Linux/macOS (`chmod +x`).

2. Add the `statusLine` setting to `~/.claude/settings.json`, merging with any existing content — do not overwrite:

```json
{
  "statusLine": {
    "type": "command",
    "command": "bash ~/.claude/statusline-command.sh"
  }
}
```

On Windows, use the full path with forward slashes or escaped backslashes depending on shell.

3. Verify `jq` is available by running `jq --version`. If missing, prompt the user to install it for their platform.

4. Confirm setup is complete. The status line takes effect on the next Claude Code prompt.

## Cross-Platform Notes

- The script uses `${USER:-${USERNAME:-$(whoami)}}` for portable username detection (Linux/macOS use `$USER`, Windows Git Bash uses `$USERNAME`).
- Hostname is resolved via `${HOSTNAME%%.*}` with a fallback to `hostname | cut -d. -f1`.
- `date +%H:%M:%S` works across all platforms with GNU or BSD date.
- ANSI color codes work in all supported Claude Code terminals.

## Bundled Resources

- **`scripts/statusline-command.sh`** — the status line script to install
