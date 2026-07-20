<!-- template-version: 2026-07-20-v1 -->
<!-- source: /media/max/data/working-templates/WORKFLOW-template.md -->
# Development Process

The meta-level rules for *how* work moves from idea to shipped change:
plan it, review the plan, implement with adversarial checks, keep an
audit trail, commit cleanly. These are process defaults — they sit
above the code-style rules in `AGENTS.md` and apply regardless of
language or domain.

Paths below (`docs/plans/`, `STATUS.md`, `docs/BACKLOG.md`, …) are the
recommended conventions; a project may relocate them, but should keep
the *shape* — a plan file per non-trivial change, a single in-flight
status doc, an append-only backlog.

## 1. Pick the workflow first

| Situation | Workflow |
|---|---|
| Trivial, mechanical, reversible edit | Just do it — verify, then commit |
| Non-trivial production change (feature, refactor, bug class) | **Planning workflow** (§4), run as coordinator + agent fleet (§2) |
| Validating an idea quickly, often discarded or rewritten | **Fast POC workflow** (§5) |

A POC is **not** a shortcut for production work. If a POC proves out,
stop and promote it to a full plan before hardening it.

## 2. Execution model — coordinator + agent fleet

**Default for any non-trivial, multi-step task** (a feature, a multi-file
change, a research→implement effort, a review→fix sweep, a migration): the
main session acts as a **coordinator / project manager**, not the hands-on
implementer. It **delegates** reading, code-writing, command-running,
research, and doc edits to subagents (the Agent tool for one-offs, the
Workflow tool for fan-out/pipelines) and keeps for itself: decomposition,
planning, orchestration, judgement calls, reviewing agent output,
committing, and talking to the user. Read only enough (STATUS, the plan,
agent reports) to orchestrate — delegate the heavy reading.

**Do the work directly instead for:** conversational answers, a single
trivial edit, a quick lookup, small policy/doc edits where the judgement
*is* the work, or when the user says "just do it yourself." Don't spin up
a fleet for a two-line fix. Scale the agent count to the task.

**The pipeline** (adapt depth to size; each stage is delegated):

1. **Understand** — fan out parallel read-only explorer agents over the
   relevant surfaces → structured maps; synthesise.
2. **Plan** — delegate the plan doc (§4); run a **multi-lens adversarial
   plan review** (agents briefed to attack, not validate); fold
   must-fixes; iterate. **Any plan touching UI templates, static JS/CSS,
   or a user-facing flow MUST include a `ui-ux-critic` agent** (visual
   consistency + interaction ergonomics + copy quality) before locking —
   not just "design-heavy" work.
3. **Implement, phase by phase** — a reusable **phase-runner** Workflow
   per phase: *implement + tests → independent adversarial diff-review →
   fold must-fixes → re-verify → append the plan's Implementation log*.
   UI-touching phases add the `ui-ux-critic` agent to the diff-review,
   briefed with rendered screenshots (§9). Phases that share files run
   **sequentially** (avoid worktree conflicts); split a broad sweep into
   batches so each diff + review stays reviewable. Commit each phase once
   green + reviewed.
4. **Close** — integration verification, STATUS/plan/BACKLOG updates.

**Model routing for subagents** (the `model` opt on Agent / Workflow
calls) — route by judgement density, not habit. Tier names current as of
2026-07; adjust as the model lineup evolves:

| Task shape | Model |
|---|---|
| Plan authoring, adversarial plan/diff review, UX critique, ambiguous judgement calls, design synthesis | `fable` |
| Implementation, test-writing, multi-file mechanical edits, e2e runs | `opus` |
| Pure mechanical sweeps — grep-and-summarize, format checks, bulk file reads | `sonnet` |

Forcing `fable` everywhere burns quota for no gain; `opus` is the
implementation workhorse, `fable` goes where the judgement is.

**Non-negotiables (why the pattern exists):**

- **Every code change is verified AND reviewed by an *independent*
  adversarial agent** — never the implementer reviewing itself. This loop
  routinely catches real defects the implementer's own green tests miss;
  treat a clean self-report as unverified until the adversarial pass
  confirms it.
- **Subagent briefs carry the conduct contract** — every Agent / Workflow
  stage prompt restates §3 plus the step's success criteria. A rule the
  brief omits does not bind the subagent.
- **Drive autonomously between checkpoints** ("go all the way unless you
  need me"), but surface genuine product/design decisions to the user.
- **Recover, don't restart** when a delegated workflow dies mid-run:
  inspect the partial state + journal, finish the failed stage by hand
  (verify → review → commit), don't blindly re-run.

## 3. Agent conduct — four principles

Binding for the coordinator AND every subagent (see the brief rule in §2):

1. **Think before coding.** Surface assumptions and trade-offs explicitly.
   When a requirement is ambiguous, present the competing interpretations —
   don't silently pick one. Push back when a simpler approach exists. If
   confused, stop and name what's unclear instead of guessing.
2. **Simplicity first.** Minimum code that solves the problem. No
   speculative features, abstractions for single-use code, unrequested
   configurability, or error handling for impossible scenarios. If 200
   lines could be 50, rewrite.
3. **Surgical changes.** Every changed line traces to the request. Don't
   "improve" adjacent code, comments, or formatting; match existing style.
   Remove only the orphans YOUR change created (now-unused imports /
   variables / functions); pre-existing dead code gets mentioned, never
   deleted unasked.
4. **Goal-driven execution.** Define verifiable success criteria before
   starting ("write a failing test, make it pass" beats "fix the bug"),
   state step → verify pairs for multi-step work, loop until verified, and
   report the verification honestly.

## 4. Planning workflow

Execution shape follows §2 — "implement" throughout this section means
*delegate to an implementer subagent/workflow*; the coordinator
decomposes, reviews agent output, and commits.

For any non-trivial implementation (`/plan`, `/feature`, `/task`, or a
substantial change):

1. **Write the plan to a file** — `docs/plans/plan-YYYY-MM-DD-<title-slug>.md`
   (see §6 for naming) — and reference it from `STATUS.md`. Plans live
   in the repo, not just in chat, so they survive across sessions. Set
   the header **`Status: New`** (§6).
2. **Present the plan and WAIT for review.** Do **not** start
   implementing.
3. **Discuss and adjust** the plan based on feedback.
4. **Spawn an adversarial reviewer** to review the plan for gaps and
   risks. Brief it that its job is to *push back, not validate*.
5. **Incorporate the feedback** into the plan file. If must-fix issues
   remain or the design shifts substantially, **re-spawn the reviewer**.
   Iterate until either no must-fix issues remain or the residual risks
   are explicitly accepted in the plan.
6. **Only then implement** — flip the plan header
   **`Status: New → Working`** in the same turn you start.

Do not exit plan mode and immediately start coding. Surface concerns at
every stage.

### Per-step adversarial review during implementation

For each phase/step of the plan:

1. **Implement** the step (delegated to an implementer subagent — the
   coordinator does not write the code itself).
2. **Verify** — run the smallest meaningful check (targeted tests +
   focused re-run).
3. **Spawn an adversarial agent** to review the diff against the plan:
   *did this step do what the plan said? did it introduce new defects?*
   Pass it the changed files and the relevant plan section.
4. **Incorporate** the feedback — revise the code, OR revise the plan if
   the step exposed a real design gap — and re-verify if non-trivial.
5. **Update the plan's `## Implementation log` in the same turn** — don't
   wait to be asked. Capture: files changed, tests added (count + path),
   verification result, the review's must-fixes that were incorporated.
6. **Only then move to the next phase.**

This applies even to "obvious" steps — the cost of one adversarial pass
is small next to a wrong cutover that has to be rolled back.

**The plan stays the source of truth across the whole arc.** Any time
the design shifts (a reviewer caught a defect, a decision changed a
trade-off), update the plan in the *same turn*. If you're about to
commit without an updated plan section, stop and update first. When the
whole arc ships/merges, flip the plan header **`Status: Working → Done`**
in that same turn.

## 5. Fast POC workflow (`/poc`)

A faster pipeline for **proof-of-concept work** — validating an idea, not
shipping production code. Use when the user invokes `/poc <description>`
or says "do this as a POC".

1. **Scan for ambiguities** — only the ones that change the *shape* of
   the POC (which dataset, which of two real designs, which API to stub),
   not nits.
2. **One batched question, then go.** If there are real ambiguities, ask
   them **all at once up front**, then proceed autonomously. If there are
   none, skip this. Don't ask follow-ups mid-implementation unless the
   user invited it.
3. **Write a short plan file** (`docs/plans/plan-YYYY-MM-DD-<title-slug>.md`)
   with only these sections:
   - **Goal** — one paragraph: what this POC proves or disproves.
   - **Approach** — ≤10 bullets of the changes.
   - **Assumptions** — judgment calls made in step 2.
   - **Verification** — the *one* smallest check that says it works.
   - **Out of scope** — what it explicitly is NOT trying to do, so the
     review pass doesn't flag those as gaps.

   Skip the adversarial *pre-review* of the plan — it's a record, not a
   gate.
4. **Implement in one pass** — no per-step review, drive to a working
   end-to-end shape. Delegation per §2 still applies — an implementer
   subagent does the code work for anything beyond a trivial diff.
5. **Run the verification** named in the plan.
6. **One adversarial review pass on the final diff.** Brief the reviewer:
   this is a POC — flag *real* defects only (happy-path correctness bugs,
   misleading results, scope overshoot beyond the Approach). Do **not**
   flag missing tests/docs/hardening or edge cases the "Out of scope"
   section already excludes.
7. **Triage:** must-fix (correctness, misleading results, scope creep) →
   fix and re-verify. Nice-to-have → log under `## Follow-ups if promoted`
   in the plan; don't fix it in this POC.
8. **Update the plan's Implementation log** — files changed, verification
   result, what was fixed vs. deferred.
9. **Report back** in one short paragraph: what it proved/disproved, what
   to look at, what was deferred.

**`/poc` does NOT:** wait for plan approval before implementing, run
per-step review, aim for production-grade tests/docs, or commit (the user
commits). It never skips the plan file or the final review pass — those
two are the irreducible audit trail.

**Mid-POC override:** default is autonomous, but if the user says "ask me
as you go" / "stop at each step", switch to the standard workflow's
interaction shape (still skipping the plan pre-review).

## 6. Plan & document naming

- **Plans:** `docs/plans/plan-YYYY-MM-DD-<title-slug>.md`.
  `<title-slug>` is short kebab-case describing the work
  (`hybrid-pipeline`, `nx04-resweep`) — **not** a sequence number.
  - *Why title, not `-NNN`:* sequence numbers collide across concurrent
    worktrees, force renames at merge, and don't help reference a plan by
    name. Titles disambiguate naturally and stay stable.
  - Same-day plans are disambiguated by title; if two share a date *and*
    slug, append a qualifier (`-v2`, `-followup`), not a number.
- **Every plan header carries a `Status:` line**, exactly one of:

  | Status | Meaning |
  |---|---|
  | **New** | Drafted, not started — awaiting review / go-ahead. |
  | **Working** | Implementation in progress (≥1 phase started). |
  | **Done** | Shipped + merged; the plan's Implementation log is the archive. |

  The executing agent keeps it current **in the same turn as the state
  change**: `New` at creation, `New → Working` when implementation
  begins, `Working → Done` when the work ships/merges. This is the single
  status signal — don't invent per-plan variants (`DRAFT`/`IMPLEMENTED`/…).
- **Benchmarks:** `docs/benchmark/performance-YYYY-MM-DD.md`.
- Reference plan files from `STATUS.md` so the next session can find them.

## 7. Audit-trail docs

The institutional memory that lets the next session — or a future you —
skip re-deriving what's already known. Keep these current *in the same
turn* as the work; their value decays fast once context fades.

| Doc | Holds | Lifetime |
|---|---|---|
| `STATUS.md` | **In-flight work only** — a resume handoff, not a changelog | Pruned continuously |
| Plan `## Implementation log` | Per-phase audit trail — the **primary archive** of shipped work | Permanent (the plan file) |
| `docs/BACKLOG.md` | Follow-ups, known issues, deferred items | Delete entries when they ship |
| `docs/regression-files.md` | Append-only log of inputs/cases that surfaced bugs, by version | Append-only |
| `docs/review-playbook.md` | Reviewer reflexes: symptom → likely cause → quick check → fix paths | Mark `[CLOSED]`, don't delete |
| `docs/review-lessons.md` | Self-corrections — a proposed fix that was wrong, so it isn't re-proposed | Append-only |

Conventions:

- **`STATUS.md` is for in-flight state, not completed work.** Copying
  shipped work into it is what makes it balloon and rot. Completed work
  lives in the plan's Implementation log, git messages, and the docs the
  work itself updated. Trust the archive.
- **`BACKLOG.md`** is grouped by topic; append at the top of a section
  with an `Added: YYYY-MM-DD` tag. When an item gets seriously scoped,
  promote it to `docs/backlog/<slug>.md` and leave a one-line pointer.
  When it ships, **delete** it — git history preserves it; don't
  accumulate strikethrough cruft.
- The **regression / playbook / lessons** trio applies to any project with
  a pipeline that processes open-ended inputs. Skip them for a project
  that has no such surface, but adopt them the moment "we've broken our
  heads on this before" starts to recur.

## 8. AI-first decision lens (LLM step vs deterministic code)

When a sub-problem is **open-world judgement** (input space unbounded,
"the next case always looks different", correctness needs
*interpretation*), an LLM step with guardrails is often the *smaller, more
general* change than an unbounded rule forest — it degrades gracefully on
the unseen edge case instead of failing hard and triggering the next
patch.

Read that narrowly. It does **not** generalize to bounded problems.

| Use deterministic code | Reach for LLM judgement (with guardrails) |
|---|---|
| Input space bounded & enumerable | Input space open / "next one looks different" |
| One stable rule, no judgement | Many branches / exceptions / competing signals |
| Correctness mechanically checkable | Correctness needs reading + interpretation |
| Arithmetic, schema coercion, normalising a closed set | Format-variant extraction, routing under ambiguity, multi-signal matching |

**Tie-breaker for the middle ground.** If you can cheaply write a
post-hoc checker for the output, prefer deterministic code — a mechanical
checker existing is a stronger signal than how the value is produced.

**Smell test.** If you've patched the same function 3+ times for a new
edge case, stop adding branches — that's the signal to replace the rule
with an LLM step (or widen an existing one).

**Guardrails are non-negotiable** — "AI-first" does *not* mean "trust the
model." Every LLM decision surface ships with:

- **Bounded output** — schema / structured output; an allowlist of fields
  it may touch.
- **Tools for values, not free generation** — emit values via tools so the
  model can't hallucinate digits.
- **Abstain over guess** — ambiguity routes to a flag / `needs_review`,
  never a silent guess. Surface judgement calls; don't hide them.
- **Verification pass** — an adversarial reviewer and/or a cheap
  deterministic scoreboard checks output against source/ground truth.
- **Push-back loop** — when the model is wrong, reject and re-ask *with the
  error*, and record the correction so the next run doesn't repeat it.
- **Versioning** — bump a prompt-version on any behaviour change so runs
  stay separable and rollback-able.
- **Audit trail** — persist what the model did so failures are
  reconstructable.

**When NOT to reach for AI.** Deterministic code still wins for bounded,
checkable, judgement-free work. Don't wrap an LLM around a problem a
five-line function solves — that's over-engineering. And mind running
cost: an LLM step costs money and seconds and is non-reproducible
run-to-run — never put one in a hot loop or per-row path without a cost +
latency budget. The test is **judgement and open-endedness, not novelty.**

## 9. UI changes — browser verification

**Any change to UI templates, JS, or CSS MUST land with a browser-level
e2e test (Playwright) that exercises the change in a real browser.**
Server-side render checks (test-client + HTML grep) are necessary but NOT
sufficient: they miss dialog behaviour, `prompt`/`confirm` flows,
click-handler wiring, CSS visibility, DOM-scrape logic the JS relies on,
and anything that only manifests in a real layout engine. Curl-level or
test-client smoke is never the sole UI verification — treat it as the
storage-layer check; the browser-side check is the contract.

**Visual verification (REQUIRED, in addition to e2e):** before declaring
a UI change done, drive the real app with Playwright, capture screenshots
of every changed surface, and inspect them; pass the screenshot paths to
the `ui-ux-critic` review brief (§2). E2e green is necessary, not
sufficient — a passing suite can hide a visually broken layout.

Conventions (adapt paths per project):

- E2e tests live in their own dir (e.g. `tests/e2e/`), excluded from the
  default unit-test run, invoked explicitly.
- When asserting "X is gone from the page", prefer a zero-count locator
  assertion over text-grep — it catches both removal and CSS-hide.
- When a UI surface has a JS-only branch (e.g. a `confirm()` bypass →
  re-POST with a flag), the e2e test must drive that branch
  (`page.on('dialog', …)`) and assert the downstream state.
- If a UI surface can't be reached from the e2e harness (e.g. it needs a
  live API key), say so explicitly in the commit/PR — don't claim the UI
  is verified by server-side checks alone.

## 10. Git discipline

Commit lineage is documentation. Someone reading `git log` months later
should understand *why* each change exists without digging through diffs.

### When to commit

- After a logical unit of work is fully working (tests pass, manual verify
  done). **Commit small, focused units as soon as they're stable.**
- One commit per scope. A version bump is its own commit; an unrelated fix
  is a separate commit.
- Don't commit broken intermediate states. Don't batch unrelated changes.
- Mention "ready to commit" before committing so the user can redirect
  scope.

### Commit message structure

```
<imperative subject ≤70 chars>

Why: <the problem this solves; what was wrong before; the data point or
incident that triggered it>
What: <one or two sentences on the change shape, only if not obvious from
the diff>
Verify: <how it was checked — tests run, count delta, manual spot-check>

Refs: <plan path / STATUS.md / issue>
```

The **Why** matters most. The diff already explains *what*; the message
must explain *why*.

### Staging

- Stage specific files (`git add <path>`), not `git add -A`, when
  unrelated files are dirty.
- `git diff --cached --stat` before committing — reject anything sensitive
  (data, secrets, gitignored paths).

### Never without explicit permission

- `git push` (and **never** `git push --force` on a shared branch — flag
  and refuse for the main branch).
- `git reset --hard`, `git checkout .`, `git restore .`, `git clean -f` —
  destructive, lose work.
- Amending or rewriting any commit already in `git log` — prefer a **new**
  commit.
- Interactive flags (`git rebase -i`, `git add -i`) — they don't work in
  this environment.
- Skipping hooks (`--no-verify`) or signing — diagnose the underlying
  issue instead.

## 11. Worktree discipline

When a session starts in a git worktree (path like
`.claude/worktrees/<name>/`), **all file writes must target the worktree
path**, not the main repo path. The two share one on-disk repo but are
checked out on different branches — writing to the main path makes the
change invisible to the worktree branch and harder to merge.

- File edits → always the worktree absolute path.
- `Bash` → run from the worktree cwd; avoid `cd` to the main repo except
  to inspect committed state.
- **Exception:** genuinely shared state (e.g. a single gitignored database
  outside the per-worktree checkout) lives at one path regardless of
  worktree.

If you catch yourself writing to a main-repo path while a worktree is
active, port the change to the worktree and revert main, so the diff lives
on the branch where it belongs.
