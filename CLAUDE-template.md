# Claude Code — Project Instructions

Read `AGENTS.md` for full project conventions and rules.
Read `~/python-organized/working-templates/preferences.md` for user working style and preferences.
At the start of every session, read `STATUS.md` to pick up context from previous sessions.

# Worktree awareness
If the working directory path contains `.claude/worktrees/`, you are in a git worktree.
The main working tree's STATUS.md has the latest project context.
To find it: `git worktree list` — the first entry is the main tree.
Read STATUS.md from the main tree, not the worktree copy.
