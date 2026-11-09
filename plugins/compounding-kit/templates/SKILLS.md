# Skill chains

Which skills work together, in which order, per task type. Read the chain for the task before you start. Skills in a chain run in order; a "gate" must pass before the next step. Keep the section numbers: `skill-router.rules` points at them.

Universal gate for every chain: verify before any "done". Name the command that proves the claim, run it, read the output, then report.
Skills marked `/name` are user-only: the user types them, Claude cannot start them.

## 1. Software: build an app, tool or feature

Small fix (one file, clear cause):
1. `debugging-and-error-recovery` if something is broken: reproduce, root cause, guard test.
2. `source-driven-development` when the fix uses a framework API.
3. Code review on the diff. Gate: no correctness findings.

Feature or new app:
1. No spec yet: brainstorm first, at most three questions; the user can say "just start".
2. Plan with one test per task. Gate: the user approves the plan.
3. `software-factory` runs the loop (spec, build, reviewers, approver, merge). Small plan: execute inline, test-first.
4. Risky job (auth, money, data, deploy): `doubt-driven-development` before merge.
5. Usability: `ux-loop` with the `ux-tester` agent until ship-ready.
6. Before go-live: code review, tests green, then the project's deploy step.

## 2. Website

1. <your web design skill> BUILD mode.
2. Copy: `hormozi-content` (sales-page frame), then `substance-check`, then `stop-slop`.
3. <your screen review skill>.
4. SEO: <your SEO skills>.
5. Gate: review mode passes. Preview link to the user, then live.

## 3. Client app UI

1. Brand: the client's brand files first. Never a generic style.
2. Build with the software chain (section 1).
3. Design polish: <your UI skills>.

## 4. Content: posts, blog, newsletter, whitepaper

1. No topic yet: `content-interview`. Plan a series: `content-strategy`.
2. Draft with the format skill: <your format skills>.
3. Frame: `hormozi-content` (review mode).
4. Gate 1: `substance-check` (truth). Gate 2: `stop-slop` (style). Always in this order.
5. Approval: `human-review` for inline edits, or your approval channel.

## 5. Visuals, diagrams, video, decks

- Brand files first, always.
- <your visual skills>

## 6. Sales and clients

1. Before a call: <your meeting prep skill>.
2. Quote: <your quote skill>. Copy gates: `substance-check`, `stop-slop`.

## 7. Knowledge, research, admin

- New link or repo: `evaluate-resource` first. ADOPT goes into the matching knowledge inbox.
- Hard call under uncertainty: `first-principles`, then `doubt-driven-development`.

## Overlaps: use this one, not that one

| Need | Use | Not |
|---|---|---|
| Style and AI-tic gate | stop-slop | ad-hoc "make it sound human" |
| Truth gate | substance-check | trusting the draft |
| Debugging | debugging-and-error-recovery | guess-fixes |
| Build loop with reviewers | software-factory | one agent doing everything |
| Done-claim | verification before completion | "should work" |

## Skill sources

- compounding-kit (ODCUS AG): the loops, hooks, quality gates.
- agent-skills (Addy Osmani, MIT): debugging-and-error-recovery, doubt-driven-development, source-driven-development.
