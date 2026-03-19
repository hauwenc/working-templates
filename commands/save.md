Save the current session's progress to STATUS.md in the project root.

Write or update STATUS.md with the following format:

```markdown
# Project Status

## Last Updated
<today's date in ISO format> by agent

## Completed
- <items completed in this session and still relevant as context>

## In Progress
- <items currently being worked on>

## Blocked
- <anything waiting on user input or external dependency>

## Next
- <what should be done next>
```

If STATUS.md already exists, read it first and merge — keep relevant prior context, update completed/in-progress items based on this session's work, and remove stale entries.

Keep it concise — this is a handoff document for the next session, not a changelog.
