<!-- template-version: 2026-03-19-v1 -->
<!-- source: ~/python-organized/working-templates/README-python.md -->
# <project name>

<One or two sentences describing what the project does and the problem it solves.>

## Requirements

- Python `<version>`
- [uv](https://docs.astral.sh/uv/) (package manager)
- <system dependency> (e.g., `ffmpeg`, `redis`, `postgresql`) — if any

## Installation

```bash
cd <project-dir>
uv sync
```

## Usage

<Brief explanation of how to run the tool. Show the main entry point first, then individual commands/features with examples.>

### <Command or feature 1>

```bash
<example command>
```

<One-line explanation of what it does and any important flags.>

### <Command or feature 2>

```bash
<example command>
# With options
<example command with flags>
```

## Development

```bash
uv sync                # Install all dependencies
make check             # Run lint + format + typecheck + tests
make lint              # Lint only
make format            # Format only
make typecheck         # Type check only
make test              # Tests only
```

## Project Structure

```
<project-dir>/
├── src/
│   └── <package_name>/
│       ├── __init__.py    # <role>
│       ├── __main__.py    # python -m <package_name>
│       ├── <module>.py    # <role>
│       └── <module>.py    # <role>
├── tests/                 # Test suite
│   ├── unit/              # Unit tests
│   └── integration/       # Integration tests
├── pyproject.toml         # Project config & dependencies
├── Makefile               # Dev commands
└── ARCHITECTURE.md        # Detailed architecture docs
```

For detailed architecture, data model, design decisions, and extension points, see [ARCHITECTURE.md](ARCHITECTURE.md).
