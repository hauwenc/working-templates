<!-- template-version: 2026-03-19-v3 -->
<!-- source: ~/python-organized/working-templates/CLAUDE-template.md -->
# Claude Code — Project Instructions

Read `AGENTS.md` for full project conventions and rules.
Read `~/python-organized/working-templates/preferences.md` for user working style and preferences.
At the start of every session, read `STATUS.md` to pick up context from previous sessions.

# Worktree awareness
If the working directory path contains `.claude/worktrees/`, you are in a git worktree.
The main working tree's STATUS.md has the latest project context.
To find it: `git worktree list` — the first entry is the main tree.
Read STATUS.md from the main tree, not the worktree copy.

# Template sync
Project files derived from templates carry two HTML comments at the top:
- `<!-- template-version: YYYY-MM-DD-vN -->` — the version when this file was last synced
- `<!-- source: ~/python-organized/working-templates/<template-file>.md -->` — the source template

## Enforcement (must run at session start)
Spawn a subagent to check template versions. The subagent should:
- Find all project files with `<!-- source: ... -->` comments
- Compare each file's `template-version` against its source template's version
- Return a short summary: either "all templates up to date" or a list of stale files with local vs template versions

If any files are stale, warn the user before proceeding.

## When modifying templates
When you update a template in `~/python-organized/working-templates/`, you MUST bump its `template-version`.
- Same day as the current version: increment vN (e.g., `2026-03-19-v1` → `2026-03-19-v2`)
- Different day: reset to v1 with the new date (e.g., `2026-03-19-v3` → `2026-03-20-v1`)
