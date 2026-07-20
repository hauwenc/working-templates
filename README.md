# working-templates

Project templates for bootstrapping Python repositories with consistent structure, tooling, and AI agent conventions.

## Templates

| File | Purpose |
|---|---|
| `AGENTS-global.md` | Language-agnostic engineering defaults (all projects) |
| `AGENTS-python.md` | Python-specific project rules, initialization checklist, progress tracking |
| `ARCHITECTURE-template.md` | Architecture documentation template |
| `README-python.md` | README template |
| `CLAUDE-template.md` | Claude Code session instructions (auto-loads AGENTS.md and STATUS.md) |
| `WORKFLOW-template.md` | Development process — coordinator + agent fleet, model routing, agent conduct (four principles), planning workflow, `/poc`, per-step adversarial review, plan/audit-trail docs, AI-first decision lens, UI browser verification, git discipline, worktrees |
| `agents/ui-ux-critic.md` | Adversarial UX/UI/ergonomics critic agent — copy to a project's `.claude/agents/` and fill the placeholders; required reviewer for UI-touching plans/diffs |
| `commands/save.md` | `/save` slash command — saves session progress to STATUS.md |

## Setup on a new machine

### 1. Clone the repo

```bash
git clone git@github.com:hauwenc/working-templates.git ~/python-organized/working-templates
```

### 2. Install the `/save` command

```bash
mkdir -p ~/.claude/commands
cp ~/python-organized/working-templates/commands/save.md ~/.claude/commands/
```

This enables the `/save` slash command globally in Claude Code.

### 3. Copy the global AGENTS.md

```bash
cp ~/python-organized/working-templates/AGENTS-global.md ~/.claude/AGENTS.md
```

## Starting a new project

The `AGENTS-python.md` template includes a full initialization checklist. An agent following it will create:

1. `.gitignore`
2. `pyproject.toml` — metadata, dependencies, dev deps, pytest config (hatchling + uv)
3. `Makefile` — lint, format, typecheck, test, check (all via `uv run`)
4. `src/<package>/` — package with `__init__.py` and `__main__.py`
5. `tests/` — unit and integration dirs with conftest.py and smoke tests
6. `ARCHITECTURE.md`, `README.md`, `AGENTS.md`, `CLAUDE.md`

Tell the agent: "Initialize a new Python project called `<name>`" and it will follow the checklist.

## Stack

- **Python 3.10+**
- **uv** — package manager
- **hatchling** — build backend
- **ruff** — linter + formatter
- **mypy** — type checker
- **pytest** — test runner
- **src/ layout** — all code under `src/<package>/`
