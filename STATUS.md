# Project Status

## Last Updated
2026-06-24 by agent — added WORKFLOW-template.md (development process)

## Completed
- WORKFLOW-template.md: development process, extracted from songyu-product-search CLAUDE.md
  (project-specifics stripped). Covers: pick-the-workflow table; planning workflow
  (plan→review→adversarial→implement with per-step review + Implementation log); fast POC
  workflow (/poc); plan & doc naming (title-slug not NNN); audit-trail docs
  (STATUS/plan-log/BACKLOG/regression-files/review-playbook/review-lessons); AI-first
  decision lens (LLM vs deterministic + guardrails); git discipline (commit cadence,
  Why/What/Verify message, never-without-permission); worktree discipline.
  Wired into CLAUDE-template.md (read-on-session-start pointer) and README.md (table row).
- AGENTS-python.md: full template with src/ layout, uv, hatchling, relative imports, mypy strict (optional per-project), ruff, pytest
- AGENTS-global.md: language-agnostic engineering defaults
- ARCHITECTURE-template.md: comprehensive architecture doc template
- README-python.md: project README template with uv, src/ layout, dev commands
- CLAUDE-template.md: auto-loads AGENTS.md and STATUS.md on session start
- commands/save.md: /save slash command for progress tracking
- README.md: repo overview with setup instructions for new machines
- Progress tracking system: auto-save after tasks, auto-load on session start, /save fallback

## Design Decisions (context for future revisions)
- **uv over pip**: faster, handles venv automatically, uv run replaces .venv/bin/ prefixes
- **hatchling over setuptools**: uv's preferred build backend, simpler config
- **src/ layout over flat**: user preference, better for pip-installable packages, namespace isolation
- **Relative imports**: required by src/ layout (from .constants import X)
- **Makefile over justfile/tox**: universal, no extra install, good enough for single-user projects
- **Strict mypy**: enforced per-project in pyproject.toml, not in template (template keeps it optional)
- **Tests required for new code**: not optional, regression tests mandatory on bug fixes
- **No data in git**: agents must ask before committing data files
- **SSH for git remotes**: not HTTPS, not gh auth
- **Not all projects have remotes**: don't assume GitHub, only set up when asked
- **/save as global command**: ~/.claude/commands/ so it works across all projects and existing sessions
- **WORKFLOW-template.md as a separate file** (not folded into AGENTS-global.md): keeps the
  global defaults focused on code-level rules; the process layer is its own concern and is
  referenced from CLAUDE-template.md. User chose this over folding-in or both.
- **AI-first decision lens included but generalized**: kept the deterministic-vs-LLM table,
  smell test, and guardrails; dropped songyu-specific examples (extraction pipeline, IMPA,
  specific file IDs/prompt versions).

## In Progress
- Nothing currently in progress

## Next
- Consider /init-project slash command to automate project bootstrapping
- Consider /check-agents slash command to verify repo AGENTS.md against template
