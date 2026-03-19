# Claude Code — Project Instructions

This repo contains project templates for bootstrapping Python repositories.

Read `preferences.md` for user working style and preferences.
Read `STATUS.md` to pick up context from previous sessions — it includes design decisions and rationale behind each template choice.

When modifying templates, keep all templates consistent with each other (e.g., if changing from pip to uv, update AGENTS-python.md, README-python.md, and the Makefile template).

# Template versioning
Every template file carries a `<!-- template-version: YYYY-MM-DD-vN -->` comment at the top.
When you modify a template's content, you MUST bump its version:
- Same day as the current version: increment vN (e.g., `2026-03-19-v1` → `2026-03-19-v2`)
- Different day: reset to v1 with the new date (e.g., `2026-03-19-v3` → `2026-03-20-v1`)

Do not skip this — downstream projects compare their local version against the template version at session start. A stale template version means projects won't know they need to update.

Push changes via SSH: `git@github.com:hauwenc/working-templates.git`
