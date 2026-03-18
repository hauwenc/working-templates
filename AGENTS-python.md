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
- Documentation to keep updated: `<path>`

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

After any code, config, or CLI behavior change, update the relevant documentation.
Before finishing, run the lint, test, and type check commands defined in Project Context.
Run full verification before merge when practical. If skipped, state why.
If a change is breaking or user-visible, add a short migration note in the documentation.
Remove dead code, deprecated flags, and outdated docs in the touched area as part of the same change set when practical.
For schema or stored-data changes, include migration, integrity, rollback, and recovery considerations.

## Notes for Agents

Do not guess project commands if they are defined in `Makefile`, `pyproject.toml`, `justfile`, CI config, or repo docs. Read and use the repository's actual commands.
If repository rules conflict with generic Python preferences, repository rules win.
If a task requires changes across multiple files, present the full set of changes rather than partial updates.
