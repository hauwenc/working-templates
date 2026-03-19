# <project name>

<One or two sentences describing what the project does and the problem it solves.>

## Requirements

- Python `<version>`
- <system dependency 1> (e.g., `ffmpeg`, `redis`, `postgresql`)
- <system dependency 2>

## Installation

```bash
cd <project-dir>
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
# or: pip install <package1> <package2>
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

### <Command or feature 3>

```bash
<example command>
```

## Project Structure

```
<project-dir>/
├── <entry_point>.py       # <role>
├── <module>.py            # <role>
├── <module>.py            # <role>
├── tests/                 # Test suite
├── pyproject.toml         # Project config
└── ARCHITECTURE.md        # Detailed architecture docs
```

For detailed architecture, data model, design decisions, and extension points, see [ARCHITECTURE.md](ARCHITECTURE.md).
