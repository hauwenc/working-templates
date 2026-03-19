# User Preferences

## Working Style
- Likes to compare options before deciding — present trade-offs as tables with pros/cons
- Actively revises templates based on what is learned during project work
- Workflow: discuss → update template → propagate to project → push template repo
- Prefers concise answers, not lengthy explanations

## Git
- Use SSH for remotes (`git@github.com:...`), never HTTPS or gh auth
- Not all projects have remotes — only set up when explicitly asked
- Never commit data files (databases, CSVs, logs, media) without asking

## Tooling
- Package manager: uv
- Build backend: hatchling
- Linter/formatter: ruff
- Type checker: mypy
- Test runner: pytest
- Project layout: src/ package layout
- Imports: relative within package

## Code Quality
- Strict mypy is enforced per-project, not globally in template
- New code must have unit tests
- Bug fixes must have regression tests
- No `# type: ignore` without specific error code and justification

## Communication
- Don't use gh auth — use SSH
- Don't assume projects need git remotes
- Don't add features or refactor beyond what was asked
- When unsure if something is data or code, ask before committing
