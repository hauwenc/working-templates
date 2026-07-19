Resume a session after /compact. Read the canonical handoff document
(STATUS.md) and reconcile in-session tool state so work can continue
from exactly where /save left it.

This is the natural counterpart to /save. The user types `status`
(or runs /status) immediately after /compact; the agent reads
STATUS.md, rebuilds task state, opens the active plan, and reports
a concise resume summary.

## What /status does

### 1. Read STATUS.md

The project's CLAUDE.md typically says "read STATUS.md at the start
of every session"; /status formalises that. If STATUS.md is missing,
report so and stop — there's nothing to resume.

STATUS.md is in-flight only (per the /save contract). Look for:

- **Last Updated** — orient on the date + one-sentence summary.
- **In Progress** — what was mid-flight; this is the resume thread.
- **Blocked** — anything waiting; flag for the user.
- **Next** — the immediate next step.
- **Open Tasks** — persisted TaskList state to rebuild.
- **Recently shipped** — terse pointers, for context only. Don't
  treat these as work to resume; they're done.
- **Files dirty** — current working-tree state.

If STATUS.md has older-style narrative blocks (`### What's live`,
`### Phase-N closing artefacts`, `### Plan-NNN — what shipped`), those
are pre-archival cruft. Mention them in the resume summary so the user
can decide whether to prune them on the next /save.

### 2. Reconcile TaskList with the persisted `## Open Tasks`

TaskList state usually survives /compact natively, but the persisted
section in STATUS.md is the canonical fallback. If the live TaskList
is empty or doesn't match the persisted entries, re-create them via
TaskCreate so future TaskUpdate calls work. Match by subject when
IDs have rotated.

### 3. Read the active plan file

If `## In Progress` references a plan at
`docs/plans/plan-YYYY-MM-DD-NNN.md` (or the project convention),
read the plan's most recent `## Implementation log` entry. That's the
per-phase audit trail AND the archive of any detail that used to live
in STATUS.md while the thread was in flight — the next session needs
it to understand what shipped vs. what's pending.

### 4. Verify uncommitted state

If STATUS.md's `## Files dirty` lists uncommitted files, run
`git status --porcelain` to confirm reality matches the saved state.
Surface any drift to the user (e.g., "STATUS.md said file X was
modified, but the working tree is clean — maybe a stash or revert
happened between sessions?").

### 5. Report a concise resume summary

Print:

- One-line current-state summary (mirror STATUS.md's Last Updated).
- The active plan + phase (if any).
- The immediate next step from `## Next`.
- Open-task count (in_progress / pending).
- Any blockers to surface.
- A pruning hint if STATUS.md is over ~500 lines / ~8k tokens or
  contains pre-archival narrative blocks.

### 6. Wait for direction

Do NOT auto-start work. The user types `status` to orient; their
next message tells you what to do.

## Edge cases

- **No STATUS.md** — say so plainly, suggest running /save first
  next time, and ask the user what they're trying to resume.
- **STATUS.md is stale** (Last Updated > 7 days old) — surface the
  date; the user may want to /save fresh before continuing.
- **No active plan** — that's fine; many sessions are ad-hoc. Skip
  the plan-reading step and resume from `## In Progress` / `## Next`
  alone.
- **STATUS.md is bloated** — flag size + suggest pruning the
  pre-archival blocks on the next /save. Don't auto-prune (the user
  may want to keep something).
