Save the current session's progress so the next session (after /compact)
can resume cleanly by typing `status`.

This is the LAST command to run before /compact. After /save, the
in-flight state is fully persisted to STATUS.md + the active plan +
relevant docs, then committed and (from a worktree) fast-forward
merged into main, so the conversation can be summarized without losing
the resume thread.

## Guiding principle

**STATUS.md is for IN-FLIGHT work only.** It is a resume document, not
a project changelog. Completed work lives in:

- the active plan's `## Implementation log` (per-phase audit trail —
  the **primary archive**)
- git commit messages (the "why" of each shipped change)
- project docs updated by the work itself (regression-files.md,
  review-playbook.md, BACKLOG.md, runbooks, ADRs)

Copying completed work into STATUS.md is what makes the file balloon
and rot. Trust the archive.

## What /save updates

### 1. STATUS.md (project root) — in-flight handoff

Merge with the existing file; don't overwrite unrelated content.
Sections (in this order; create missing ones, keep extras the project
defines):

```markdown
# Project Status

## Last Updated

<today's ISO date>. <One-sentence current-state summary mentioning
the active plan / branch / blocker if any.>

## In Progress

- What's mid-flight. Include file paths, branch name, plan reference,
  test count delta, and explicit next-step pointer.
- If multiple threads are live, list each as its own bullet / subsection.
- Do NOT include narrative recaps of shipped phases — those belong in
  the plan's Implementation log. Reference the plan instead.

## Blocked

- Anything waiting on user input, external API, third-party fix,
  or a decision call.

## Next

- The single most concrete next step a future session should take.
- If unclear, list 2-3 options the user can choose from.

## Open Tasks

Serialized TaskList state — one entry per line. Persistence handoff
for the in-session task tracker so it survives compaction.
Format:

    - [in_progress] #<id> — <subject>
    - [pending]     #<id> — <subject>

Omit completed and deleted tasks. Sort: in_progress first, then
pending by ID.

## Recently shipped (≤7 days)

One line per shipped thread — pointers, not summaries. Format:

    - YYYY-MM-DD — <plan slug or subject> — commits <sha…sha>. See <plan path>.

Drop entries older than ~7 days. Aim for ≤10 entries. The plan +
git history are the archive, not this section.

## Files dirty (uncommitted)

List uncommitted files grouped by add/modify/delete so the next
session knows the state of the working tree without re-running
`git status`. Skip if working tree is clean.
```

**When a thread ships during this session:**

1. Confirm the plan's `## Implementation log` has the full per-phase
   detail (files changed, tests, adversarial-review outcomes, what
   shipped vs. deferred).
2. Add a one-line entry to STATUS.md's `## Recently shipped`.
3. **Delete the thread's narrative from `## In Progress`** AND any
   detailed-history blocks it spawned (e.g. `### Plan-NNN — what's
   live`, `### What shipped (this session)`, `### Phase-N closing
   artefacts`). They were resume context while in flight; once shipped,
   the plan log is the archive.

If you find yourself preserving detail in STATUS.md "in case it's
useful later" — it isn't. That's what the plan file is for.

**Size guideline:** target STATUS.md under ~500 lines / ~8k tokens.
If it's larger, prune `## Recently shipped` and old narrative blocks
before saving.

### 2. Active plan file (if any)

If the session was working under a plan at
`docs/plans/plan-YYYY-MM-DD-NNN.md` (or the project's plan convention),
append to its `## Implementation log` an entry covering this session:
files changed, tests added/passed (count + paths), adversarial-review
outcomes if any, pending must-fixes, and the immediate next step.

The plan is the source of truth across the plan's whole arc. Don't
let it lag behind by even one phase. This is also where any detail
being removed from STATUS.md should be promoted to first — never
delete from STATUS without confirming the plan log captures it.

### 3. Other docs touched by this session

Update in the SAME save, not "later":

- `docs/regression-files.md` (or project equivalent) — append entries
  for any file IDs that drove a fix this session.
- `docs/review-playbook.md` (or project equivalent) — add or close
  reflex / diagnostic entries.
- `docs/BACKLOG.md` — append follow-ups discovered this session;
  remove items that shipped.

If the project has additional convention docs (architecture notes,
runbooks, ADRs), update those too when relevant.

### 4. Commit — always

/save always finishes by committing the session's work. (This reverses
the earlier "documentation-only" rule — /save now always commits and
merges.) Do it as the final write step, after the STATUS.md / plan /
doc updates above:

1. **Stage specifically.** `git add <path> …` for the docs updated in
   steps 1–3 plus the session's code changes — never `git add -A` when
   unrelated dirty files are present.
2. **Guard before committing.** `git diff --cached --stat`; refuse
   anything under `data/`, `var/`, `reports/`, or `.env*` (customer
   PII / live DB / secrets). Unstage and surface it rather than commit.
3. **Message.** Multi-line HEREDOC following the project's git
   convention: imperative subject ≤70 chars, then a body explaining
   *why* (Why / What / Verify), a `Refs:` line to the plan / STATUS.md,
   and the `Co-Authored-By:` footer for the running model. One cohesive
   commit per scope — split if the tree holds unrelated units.
4. **Never** `--amend` a commit already in `git log`, `--no-verify`, or
   `--force`. If a pre-commit hook fails, fix the cause. Don't knowingly
   commit a broken tree — if verification fails, fix it or stage
   selectively, and say so in the /save output.

### 5. Merge — always

After the commit, land the work on `main`:

- **Main mode** (cwd is the main checkout — `git rev-parse
  --git-common-dir` equals `--git-dir`): the commit is already on the
  working branch; there is nothing to merge. Skip this step.
- **Worktree mode** (the two git-dirs differ): fast-forward the branch
  into main:
  1. Rebase the branch onto the current main (`git rebase main`),
     resolving conflicts — STATUS.md is the usual one; take main's
     newer copy and re-apply this session's narrow entries.
  2. Re-run the smallest verification on the rebased tree.
  3. `git -C <main-repo-path> merge --ff-only <branch>` — linear
     history, no merge commit. If `--ff-only` refuses, main advanced
     mid-merge: rebase again, never `--force`.
- **Never `git push`.** No remote is assumed; pushing is always a
  separate, explicit request — this includes `git push --force`.

## Output

After /save, print a concise summary:

- Files updated this turn (STATUS.md, plan, docs).
- Commit SHA + one-line subject.
- Merge result: worktree mode → the `--ff-only` merge into main (main's
  new HEAD); main mode → "commit only, nothing to merge". Never a push.
- Open-task count persisted.
- STATUS.md size (lines / approximate tokens) — if it's over the
  ~500-line / ~8k-token target, flag it.
- A one-line reminder: `Safe to /compact. After compact, type "status" to resume.`

## After /compact, the user types `status` (or runs /status)

The next session should:
1. Read STATUS.md first (per the project's CLAUDE.md convention).
2. Reconcile the persisted `## Open Tasks` section with the live
   TaskList. If the TaskList is empty / stale, re-create entries via
   TaskCreate from the saved list.
3. Read the active plan file's most recent Implementation-log entry.
4. Report a concise resume summary: where we left off, the next step,
   any open blockers.
5. Wait for direction. Do NOT auto-start work.
