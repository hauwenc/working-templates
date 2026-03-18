# AGENTS.md — Global Engineering Defaults

## Scope and Precedence

These are default instructions for all projects.

Follow this order:
1. Direct user instructions
2. Repository or subdirectory `AGENTS.md`
3. Project documentation and configured tooling
4. This file

When the codebase already has established conventions, follow them unless there is a clear reason not to.

## Working Style

Read the relevant code, tests, docs, and configuration before making changes.
Make the smallest change that fully solves the problem.
Do not refactor unrelated code unless it is necessary for correctness, safety, maintainability, or to support the requested change.
State assumptions clearly when requirements are ambiguous.
Preserve existing behavior unless the task explicitly requires changing it.
Prefer low-risk, reversible changes when practical.

## General Principles

Prefer simplicity over cleverness.
Prefer readability and maintainability over brevity.
Avoid premature abstraction. A small amount of duplication is often better than the wrong abstraction.
Fail clearly. Surface errors near their source instead of hiding them.
Optimize only when there is evidence that performance matters.
Do not over-engineer for hypothetical future needs.
Apply sound design principles when they improve clarity and maintainability; do not force abstractions or indirection where a simple solution is sufficient.

## Code Quality

Match the style and structure of the surrounding code.
Use names that communicate intent clearly.
Keep functions, classes, and modules focused on a clear responsibility.
Avoid deep nesting and unnecessarily complex control flow.
Prefer explicit behavior over hidden side effects.
Use comments sparingly and mainly to explain why, not what.

## Error Handling

Handle errors where meaningful recovery, cleanup, or translation can occur.
Use specific error types rather than broad catch-alls.
Provide actionable error messages with enough context to support debugging.
Do not silently ignore errors unless that behavior is intentional and documented.
Validate untrusted or external inputs at system boundaries.

## Security and Safety

Never commit secrets, credentials, private keys, or tokens.
Do not log secrets or sensitive data.
Treat external input, files, network data, environment variables, and user input as untrusted.
Prefer least-privilege access and safe defaults.
Be cautious with destructive or irreversible operations.

## Dependencies

Prefer existing project dependencies or standard library solutions unless a new dependency is clearly justified.
Add dependencies only when the value outweighs the maintenance, security, and complexity cost.
Keep the dependency surface area as small as practical.

## Testing and Verification

Test behavior and externally visible contracts rather than implementation details.
Keep tests deterministic and independent where practical.
Add or update tests when behavior changes.
Run the smallest meaningful verification available for the change.
If verification is skipped or incomplete, say so clearly and explain why.

## Compatibility

Assume backward compatibility matters unless told otherwise.
If a change is breaking, make it explicit and document the migration path.

## Documentation

Update documentation when behavior, configuration, interfaces, or workflows change.

## Change Hygiene

Keep changes focused and cohesive.
Do not mix unrelated refactors with behavioral changes unless necessary.
Do not revert or overwrite user changes you did not make unless explicitly asked.
