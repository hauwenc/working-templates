<!-- template-version: 2026-06-24-v1 -->
<!-- source: /media/max/data/working-templates/CLAUDE-template.md -->
# Claude Code — Project Instructions

@./AGENTS.md
Read `/media/max/data/working-templates/preferences.md` for user working style and preferences.
Read `/media/max/data/working-templates/WORKFLOW-template.md` for the development process — how
work moves from idea to shipped change (planning workflow, `/poc`, per-step adversarial
review, plan/audit-trail docs, AI-first decision lens, git discipline, worktrees).
At the start of every session, read `STATUS.md` to pick up context from previous sessions.

# Worktree awareness
If the working directory path contains `.claude/worktrees/`, you are in a git worktree.
The main working tree's STATUS.md has the latest project context.
To find it: `git worktree list` — the first entry is the main tree.
Read STATUS.md from the main tree, not the worktree copy.

# Template sync
Project files derived from templates carry two HTML comments at the top:
- `<!-- template-version: YYYY-MM-DD-vN -->` — the version when this file was last synced
- `<!-- source: /media/max/data/working-templates/<template-file>.md -->` — the source template

## Enforcement (must run at session start)
Spawn a subagent to check template versions. The subagent should:
- Find all project files with `<!-- source: ... -->` comments
- Compare each file's `template-version` against its source template's version
- Return a short summary: either "all templates up to date" or a list of stale files with local vs template versions

If any files are stale, warn the user before proceeding.

# Claude Code settings
When bootstrapping a new project, copy `/media/max/data/working-templates/config/settings.json` to `.claude/settings.json`.
This provides a `UserPromptSubmit` hook that reminds the agent to read `STATUS.md` at session start.

## When modifying templates
When you update a template in `/media/max/data/working-templates/`, you MUST bump its `template-version`.
- Same day as the current version: increment vN (e.g., `2026-03-19-v1` → `2026-03-19-v2`)
- Different day: reset to v1 with the new date (e.g., `2026-03-19-v3` → `2026-03-20-v1`)

# Planning and status tracking
When entering plan mode or designing an implementation approach, you MUST:
1. Write the plan to `STATUS.md` under a `## Current Plan` section before starting work
   - Include the goal, approach, key decisions, and open questions
2. Update `STATUS.md` after each meaningful milestone (e.g., task completed, blocker hit, approach changed)
   - Don't wait until the end — update as you go so the file always reflects current state
3. When a plan changes mid-session, update the plan in `STATUS.md` with the new direction and why it changed

This ensures continuity across sessions — if the conversation is interrupted or a new session starts, `STATUS.md` has everything needed to resume.
