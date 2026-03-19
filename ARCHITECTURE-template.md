# Architecture — <project name>

## Overview

<1-3 paragraphs describing what the system does, who uses it, and in what context. Include scale and deployment model (local CLI, web service, library, etc.). State the core problem being solved.>

## System Architecture

<ASCII diagram showing the major components and how they connect. Include:
- Entry points (CLI, API, web UI)
- Core domain modules
- Data stores
- External services or tools
- Shared/utility layers

Example format:>

```
                        ┌──────────────┐
                        │  entry point │
                        └──────┬───────┘
               ┌───────────┬───┴───┬───────────┐
               ▼           ▼       ▼           ▼
          ┌────────┐  ┌────────┐  ┌────────┐  ┌────────┐
          │module_a│  │module_b│  │module_c│  │module_d│
          └───┬────┘  └───┬────┘  └───┬────┘  └───┬────┘
              │           │           │           │
              ▼           ▼           ▼           ▼
          ┌──────────────────────────────────────────┐
          │             data store                    │
          └──────────────────────────────────────────┘
```

### Dependency Direction

<Describe which modules depend on which. Show the dependency graph or rules like "all dependencies flow downward" or "domain modules never import from the CLI layer." Explicitly list any import constraints that must hold.>

## Core Abstractions

<For each major abstraction or pattern the system uses, explain:
- What it is and what problem it solves
- How it works (with a short code example if helpful)
- What the extension story looks like

This section should make a new contributor understand the mental model of the codebase. If the project uses well-known patterns (plugin registry, middleware chain, pipeline, observer, etc.), name the pattern and explain the project-specific twist.>

### <Abstraction 1>

<Description, code example, how it fits into the overall architecture.>

### <Abstraction 2>

<Description, code example, how it fits into the overall architecture.>

## Data Model

<If the project uses a database, document the full schema here. If it uses file-based storage, document the format and directory structure. If it uses an external API as its data source, document the key entities and relationships.>

### Schema DDL

<Include the complete DDL (or equivalent) so that a reader can understand every table, column, index, and constraint. Annotate each column with a short comment explaining its purpose.>

```sql
CREATE TABLE <table_name> (
    id       INTEGER PRIMARY KEY,
    <col>    <type> NOT NULL,   -- <purpose>
    ...
);

CREATE INDEX <index_name> ON <table_name>(<col>);
```

### Design Rationale

<Explain WHY the schema is shaped this way. What alternatives were considered? What trade-offs were made? This is the most valuable part of the data model section — it captures decisions that would otherwise be lost.>

### Data Conventions

<Document any conventions for how data is stored. Timestamp formats, encoding rules, NULL semantics, enum-like text values, etc.>

## Module Responsibilities

<For each module (file, package, or service), document:>

### `<module_name>` — <one-line role>

**Role**: <What this module is responsible for. What it owns.>

**Public API**:
- `<function_or_class>` — <what it does>
- `<function_or_class>` — <what it does>

**Depends on**: <list of modules this module imports from>

**Key behavior**: <any non-obvious behavior, invariants, or constraints>

<Repeat for each module.>

## Data Flow

<Walk through the system's key workflows end-to-end. For each workflow, show what happens step by step: what the user does, which modules are involved, what data moves where, and what the output is.

Use ASCII flow diagrams, numbered steps, or both. The goal is that a reader can trace any operation through the codebase without reading every line of code.>

### Workflow 1: <name>

```
<step-by-step diagram or description>
```

### Workflow 2: <name>

```
<step-by-step diagram or description>
```

## Key Design Decisions

<For each significant architectural decision, document:
- The decision itself
- The rationale (why this choice over alternatives)
- The trade-offs accepted

This is an architecture decision record (ADR) in lightweight form. It captures institutional knowledge that would otherwise live only in the original author's head.>

### <Decision 1>

**Decision**: <what was decided>

**Rationale**: <why>

**Trade-offs**: <what was given up>

### <Decision 2>

**Decision**: <what was decided>

**Rationale**: <why>

**Trade-offs**: <what was given up>

## Extension Points

<Document how to extend the system for the most common types of changes. This section should feel like a recipe: "to add X, do steps 1-2-3." It dramatically lowers the barrier for new contributors.>

### Adding a <thing>

1. <step>
2. <step>
3. <step>

### Adding a <other thing>

1. <step>
2. <step>
3. <step>

## Performance Considerations

<Document the system's performance characteristics, bottlenecks, and optimization strategies. Include:
- Expected scale (data volume, request rate, user count)
- Known bottlenecks and how they are mitigated
- Memory usage patterns
- I/O patterns (disk, network, database)
- Caching strategies
- Any benchmarks or profiling results>

### Scale

<What the system is designed to handle. Current and expected limits.>

### Bottlenecks

<Where time is spent. What is CPU-bound, I/O-bound, memory-bound.>

### Optimization Strategies

<What has been done to improve performance. What is planned.>

## Dependencies

### External Tools

<List any external tools, services, or binaries the system requires.>

| Tool | Version | Purpose |
|---|---|---|
| `<tool>` | <version> | <what it does for this project> |

### Python Packages

<List third-party Python packages and their purpose.>

| Package | Purpose |
|---|---|
| `<package>` | <what it does for this project> |

### Runtime Requirements

<Python version, OS requirements, system libraries, environment variables, etc.>

## Future Architecture

<Document planned architectural changes, upcoming features that will require structural changes, and the expected evolution of the system. This helps future contributors understand not just where the system is, but where it is headed.>

### Planned Changes

| Change | Status | Notes |
|---|---|---|
| <description> | <planned / in progress / blocked> | <context> |

### Architectural Evolution

<Higher-level thoughts on how the system might grow: when to restructure, what thresholds trigger a redesign, what the long-term vision looks like.>
