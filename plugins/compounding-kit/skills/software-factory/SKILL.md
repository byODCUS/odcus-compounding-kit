---
name: software-factory
description: Build software feature by feature with a reviewed agent loop (spec-writer, builder, parallel security/UX/UI/code reviewers, approver, merge or hand-off to the user). Use for "software factory", "factory", "/factory", "run the next job", "set up a factory for <project>", or any app built in merge-gated steps. Not for one-line fixes, content or non-code work.
---

# Software Factory

You are the orchestrator. You never write the spec, code, reviews or decisions
yourself. Agents do the work, each writes exactly one file, and you move each
job along, keep its `job.json` current, merge, and report in short lines.

```
feature → spec-writer → builder → [security, ux, ui, code] → WAIT FOR ALL
                           ▲                                      │
                           └──── any CHANGES: resume builder ◄────┤
                                                                  ▼ all PASS
                                     merge to main ◄─ APPROVE ─ approver ─ ESCALATE → ask the user
```

`S = ~/.claude/skills/software-factory` below.

## How this differs from the original (learned the hard way)

- **No separate `claude -p` process.** Launching a headless Claude to run the
  loop is blocked by the auto-mode safety check. Run the loop from the current
  session.
- **Project agents usually don't load.** `.claude/agents/` in a repo only load
  when the session started in that repo. So spawn `general-purpose` agents and
  tell each one to read its role file (prompt templates below). This works in
  any session.
- **Native apps have no dev server or browser.** Use the `native-mac` templates:
  views are rendered to PNG by a snapshot target and reviewers read the PNGs.
  Use the `web` templates (agent-browser, dev server, ports) for websites.
- **Escalations go to the user as one question** with options and a
  recommendation. The answer is the human approval: merge, or write
  `rework-<k>.md` with exactly what they chose and resume.
- Builders and reviewers must not launch apps, type into real terminals, change
  system/agent settings, or write outside repo/worktree/job folder/temp dirs.
  Put these as hard rules in the repo's `AGENTS.md` and repeat the risky ones in
  the agent prompt for jobs that touch them.

- **Polish rules ride along.** `references/design/` holds two vendored rule
  sets (Emil Kowalski's design engineering, Jakub Krehel's better-ui). The
  reviewer-ui and builder roles read them for motion, press states, radii and
  shadows. Brand files still win. See `references/design/SOURCE.md`.

## Set up a project

1. Repo with a `main` branch and a first commit. Outside OneDrive (git in
   OneDrive breaks). Default location `~/projects/<name>`.
2. Copy the role files: `cp -R $S/templates/<web|native-mac>/agents <repo>/.claude/agents`,
   and `cp $S/templates/common/dashboard.html <repo>/factory/`.
3. Write `<repo>/AGENTS.md`: what the project is, layout, data contracts,
   exact build/test/lint commands, how to look at the UI, fresh-checkout setup,
   and hard rules. Agents carry nothing repo-specific; everything comes from here.
4. Add `/factory/jobs/` to `.gitignore`. Write `factory/backlog.md` with one
   `- [ ]` line per feature, sized so one builder can finish it in one go.
5. For native apps: a scaffold that already builds, a test target, and a
   snapshot executable that renders every view in a catalog to
   `<name>-light.png` / `<name>-dark.png`. Verify it renders before job 1.
6. Tailor the approver's ESCALATE list to the project (money, auth, deploy,
   settings outside the repo, permissions, anything typing into terminals).
7. Commit. Optional dashboard: `cd factory && python3 -m http.server 8765`,
   then http://localhost:8765/dashboard.html.

## Quality rules every job carries

Put these in each spec and in the reviewer prompts (the user sent the first one 4 times):

- **Function tests at each build step**, not only at the end. Every job runs and
  passes the real feature tests before it goes to review.
- **Every list the user manages supports edit, remove and finish** (mark done).
  A list with only "add" is not done.
- **Full screen width on desktop, and check mobile.** No narrow centred column
  for work screens. The UI reviewer looks at both sizes.
- **Test any user guide against the real running app** before it goes to
  the user or a client. Every step in the guide must work as written.
- **Docs before memory, root cause before patch.** Spec-writer and builder
  check framework APIs in the official docs (source-driven-development).
  Builder fixes failures at the root (debugging-and-error-recovery).
  The full skill chain for software work is in `~/.claude/SKILLS.md`.

## Run a job

From the repo root on `main`:

1. **Create:** `$S/scripts/newjob.sh <NNN-slug>` claims the next backlog item
   (or pass the feature text as 2nd arg), writes `job.json`, and creates the
   worktree `../<repo>-factory/<NNN-slug>` on `factory/<NNN-slug>`. Run the
   fresh-checkout setup there (e.g. `swift build`).
2. **Spec:** spawn spec-writer (opus). Check `spec.md` exists. Read its
   Assumptions; product decisions there are what the approver will escalate.
3. **Build:** `setstate.py job.json stage=build`, spawn builder (opus). First
   line of `build.md` must be `STATUS: READY` (else go to Escalate).
4. **Review round N:** `setstate.py job.json stage=review round=N reviews=pending`,
   `mkdir round-N`, then spawn all four reviewers **in one message**:
   security (opus), ux/ui/code (sonnet). As each finishes, read the first line
   of its file and record it (`setstate.py job.json ux=PASS`).
5. **Decide:** all PASS → approver. Any CHANGES and fewer than 2 resumes used →
   `stage=build`, resume the same builder via SendMessage pointing at
   `round-N/`, then back to step 4 with N+1. No resumes left → Escalate.
6. **Approve:** `stage=approve`, spawn approver (opus). APPROVE → Merge.
   ESCALATE → Escalate. If the job touches auth, money, data migrations,
   deploys or anything hard to undo, run one doubt cycle first
   (`~/.claude/skills/doubt-driven-development/SKILL.md`) from this session:
   a fresh agent tries to disprove the diff against spec.md. A real finding →
   back to step 3 as a rework.
7. **Merge:** main checkout clean (backlog.md exempt) and on `main`, then
   `git merge --no-ff factory/<id>`, `git worktree remove`, `git branch -d`,
   `stage=merged`, run the tests on main. Never push.
8. **Escalate:** `stage=needs-human`, read `decision.md` "For the human", ask
   the user one question with options and a recommendation. On "rework": write
   `rework-<k>.md` (the user's choice, concrete), `stage=build`, spawn a fresh builder
   with the rework prompt, then review again. On "approve": merge.

Independent jobs may run in parallel (one worktree each). Tell each spec-writer
which files the other job owns so they don't collide; the approver's
`git merge-tree` check catches the rest.

## Prompt templates

Every agent prompt starts with its role file and the job paths:

```
You are the `<role>` agent of a software factory. Your full role instructions
are in <repo>/.claude/agents/<role>.md (ignore its YAML frontmatter). Read that
file first and follow it exactly. Write only the one file it names.

Job folder: <repo>/factory/jobs/<id>/. Worktree: <worktree>. Branch: factory/<id>.
```

Then one of:
- spec-writer: `Feature: <verbatim>` plus context (what's merged, what runs in
  parallel, facts to verify read-only).
- builder: `Build round 1.` or `Rework: read rework-<k>.md and address it, then
  update build.md for round N+1.` plus the commit trailer lines from the
  session's attribution reminder.
- reviewers: `Review round N.` (+ for security: what to attack in this job).
- approver: `Final round: N.`

End every prompt with "Reply with one line: ..." so results stay small. Never
read agent transcript files; read the job files instead.

## Reporting to the user

One short status line per transition, in the user's chat style (plain words, no
jargon). When a job ends: merged or waiting on the user, and why. Snapshots worth
showing: read one PNG yourself and describe it in one line.
