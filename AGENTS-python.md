# AGENTS.md — Repository Guidelines

## Scope and Precedence

This file defines repository-specific rules for this project.

Follow this order:
1. Direct user instructions
2. More specific `AGENTS.md` files in subdirectories
3. This file
4. Global `AGENTS.md`

When in doubt, prefer the existing repository structure, conventions, and tooling.

## Project Context

Target Python version: `<python-version>`
Package/environment manager: `<uv | poetry | pip-tools | pip | hatch | other>`

Primary commands:
- Lint: `<command>`
- Format: `<command>`
- Tests: `<command>`
- Type check: `<command>`
- Full verification: `<command>`

Key paths and docs:
- Main package/app: `<path>`
- Tests: `<path>`
- Config: `<path>`
- Documentation to keep updated: `README.md`, `ARCHITECTURE.md`

## Working Rules

Read the relevant modules, tests, configuration, and docs before editing.
Keep changes narrow and task-focused.
When behavior changes, update tests and documentation in the same change set.
When requirements are ambiguous, choose the safest reasonable interpretation and state the assumption.
If touching generated code, only edit the source-of-truth inputs unless the repository explicitly expects direct edits.

## Python Style

Follow the repository's configured formatter, linter, and type checker.
Follow PEP 8 unless repository tooling or conventions differ.
Prefer clear, idiomatic Python over clever or highly abstract code.

## Typing and Data Modeling

Add type hints on public functions, methods, and interfaces.
Add internal type hints where they materially improve readability or correctness.
Prefer modern built-in generic types when supported by the target Python version.
Prefer structured models such as `dataclass`, `TypedDict`, or explicit domain models over raw unstructured dictionaries when the data has a stable shape.
Prefer `dataclass` for state or configuration objects when it improves clarity.

## Imports

Keep imports at the top of the file unless a delayed import is justified by optional dependencies, cycles, or performance.
Group imports as standard library, third-party, then local modules.
Do not use wildcard imports.
Follow the repository's existing import style for local modules, whether absolute or relative.

## Functions and Design

Prefer small, composable functions with one clear responsibility.
Prefer explicit return values over hidden side effects.
Use guard clauses and early returns to reduce indentation and nesting.
Avoid deep nesting; split complex logic into smaller focused functions.
Use names that communicate intent clearly.
Prefer module-level private helpers over nested helper functions when that improves clarity, reuse, or testability.
Apply SOLID principles when they improve design clarity; do not force class abstractions where simple functions suffice.
Prefer straightforward designs over abstract indirection.
Avoid duplication, but do not extract abstractions prematurely.
Add docstrings to public APIs and to non-obvious logic where they help future readers.
Use the docstring style already established in the repository. If none exists, use `<Google | NumPy | reST>` consistently.

## Paths, Files, and I/O

Prefer `pathlib.Path` over `os.path` in new code unless the surrounding code uses a different convention.
Validate filesystem assumptions and user-provided paths.
Validate external inputs at boundaries such as CLI entry points, HTTP handlers, file parsing, environment variables, and database reads.
Use context managers for files and resource lifecycles.
When correctness matters, use safe file replacement patterns and avoid partial writes.

## Error Handling

Prefer explicit exceptions over silent failures.
Catch specific exceptions and add context when re-raising.
Use custom exception types for domain-specific failures when they improve clarity.
Do not suppress failures with broad handlers like `except Exception: pass`.

## Logging

Use `logging` rather than `print()` for runtime behavior unless this is a CLI intentionally writing user-facing output.
Use structured logging if the project supports it.
Log at appropriate levels.
Do not log secrets, credentials, tokens, or payloads that may contain sensitive data.

## Testing

Write code that is easy to test. Avoid hidden global state.
Prefer dependency injection or explicit seams where practical.
Prefer deterministic tests. Avoid time-based sleeps and unseeded randomness unless unavoidable.
Use fixtures or helpers for repeatable setup where they improve clarity.
Test contracts and externally visible behavior rather than implementation details.
Add or update tests whenever behavior changes.
If bug fixing, add or update a regression test when practical.

## Project-Specific Consistency Rules

<!-- Replace or remove the examples below to match this repository. -->

Keep these files or systems in sync when relevant:
- `<config file>` and `<env var handling module>`
- `<API schema>` and `<implementation>`
- `<CLI docs>` and `<CLI behavior>`

Avoid editing these generated paths directly unless required:
- `<generated path>`

Follow these architectural boundaries:
- `<example: routes call services; services do not import web layer>`
- `<example: domain code must not depend on CLI/UI modules>`

## Change Checklist

After any code, config, or CLI behavior change, update the relevant documentation (`README.md`, `ARCHITECTURE.md`).
Before finishing, run the lint, test, and type check commands defined in Project Context.
Run full verification before merge when practical. If skipped, state why.
If a change is breaking or user-visible, add a short migration note in the documentation.
Remove dead code, deprecated flags, and outdated docs in the touched area as part of the same change set when practical.
For schema or stored-data changes, include migration, integrity, rollback, and recovery considerations.

## Project Initialization

When setting up a new project, create all of the following before writing application code:

### Documentation

- Generate `README.md` from the template at `~/python-organized/working-templates/README-python.md`.
- Generate `ARCHITECTURE.md` from the template at `~/python-organized/working-templates/ARCHITECTURE-template.md`.

### Test Structure

Create a `tests/` directory with proper separation:

```
tests/
├── conftest.py          # Shared fixtures (e.g., temp dirs, DB connections, mock data)
├── unit/                # Fast, isolated tests — no I/O, no external deps
│   ├── __init__.py
│   └── test_<module>.py # One test file per module (test_constants.py, test_db.py, etc.)
└── integration/         # Tests that hit real resources (DB, filesystem, subprocesses)
    ├── __init__.py
    └── test_<workflow>.py
```

- `conftest.py`: shared fixtures such as in-memory DB connections, temp directories, sample data.
- `unit/`: pure logic tests. Mock or stub external dependencies. Must run fast with no side effects.
- `integration/`: tests that exercise real I/O — database writes, file operations, subprocess calls. May be slower.
- Add at least one smoke test per module at initialization so the test pipeline has something to run.
- Configure pytest in `pyproject.toml`:

```toml
[tool.pytest.ini_options]
testpaths = ["tests"]
markers = [
    "integration: tests that use real I/O (DB, filesystem, subprocesses)",
]
```

### Checklist Pipeline (Makefile)

Create a `Makefile` with these targets:

```makefile
.PHONY: help lint format format-check typecheck test check setup clean

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

lint: ## Run linter (ruff)
	.venv/bin/ruff check .

format: ## Run formatter (ruff)
	.venv/bin/ruff format .

format-check: ## Check formatting without changes
	.venv/bin/ruff format --check .

typecheck: ## Run type checker (mypy)
	.venv/bin/mypy --ignore-missing-imports <source files or package>

test: ## Run tests
	.venv/bin/python -m pytest tests/ -v

check: ## Run full checklist: lint + format-check + typecheck + test
	@echo "═══════════════════════════════════════════════"
	@echo "  Running checklist pipeline"
	@echo "═══════════════════════════════════════════════"
	@echo ""
	@echo "── [1/4] Lint ──────────────────────────────────"
	@.venv/bin/ruff check . && echo "  ✓ Lint passed" || (echo "  ✗ Lint FAILED" && exit 1)
	@echo ""
	@echo "── [2/4] Format ────────────────────────────────"
	@.venv/bin/ruff format --check . && echo "  ✓ Format passed" || (echo "  ✗ Format FAILED" && exit 1)
	@echo ""
	@echo "── [3/4] Type check ────────────────────────────"
	@.venv/bin/mypy --ignore-missing-imports <source files or package> && echo "  ✓ Type check passed" || (echo "  ✗ Type check FAILED" && exit 1)
	@echo ""
	@echo "── [4/4] Tests ─────────────────────────────────"
	@if [ -d tests ] && [ "$$(find tests -name '*.py' | head -1)" ]; then \
		.venv/bin/python -m pytest tests/ -v && echo "  ✓ Tests passed" || (echo "  ✗ Tests FAILED" && exit 1); \
	else \
		echo "  ⊘ No tests found (tests/ empty or missing)"; \
	fi
	@echo ""
	@echo "═══════════════════════════════════════════════"
	@echo "  ✓ Checklist complete"
	@echo "═══════════════════════════════════════════════"

setup: ## Install dev dependencies (ruff, mypy, pytest)
	.venv/bin/pip install ruff mypy pytest

clean: ## Remove caches and build artifacts
	find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name .mypy_cache -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name .ruff_cache -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name .pytest_cache -exec rm -rf {} + 2>/dev/null || true
```

Replace `<source files or package>` with the actual source paths (e.g., `*.py`, `src/`).

### Initialization Order

1. Create `pyproject.toml` with project metadata, dependencies, and pytest config.
3. Create `Makefile` with the checklist pipeline above.
4. Create `tests/` directory structure with `conftest.py` and at least one smoke test.
5. Run `make setup` to install dev tools.
6. Run `make check` to verify everything passes.
7. Generate `ARCHITECTURE.md` and `README.md` from templates.
8. Generate `AGENTS.md` from this template and fill in project-specific values.

## Notes for Agents

Do not guess project commands if they are defined in `Makefile`, `pyproject.toml`, `justfile`, CI config, or repo docs. Read and use the repository's actual commands.
If repository rules conflict with generic Python preferences, repository rules win.
If a task requires changes across multiple files, present the full set of changes rather than partial updates.
When pushing to a remote, use SSH URLs (`git@github.com:<user>/<repo>.git`), not HTTPS. If github.com is not in `~/.ssh/known_hosts`, add it with `ssh-keyscan github.com >> ~/.ssh/known_hosts 2>/dev/null`.
