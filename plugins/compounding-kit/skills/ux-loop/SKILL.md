---
name: ux-loop
description: Iterative usability loop for a local web app. The ux-tester agent drives the app with Playwright as the target persona and reports ranked issues, this session fixes them, repeat until ship-ready. Use for "test the app", "usability loop", "ux loop", "run the tester", "is this usable". App, personas and tasks come from the caller.
---

# UX loop

## Parameters (ask if missing, never assume)

- **Tester agent:** default `ux-tester` (this plugin). A project with its own tester agent uses that one.
- **App:** URL or start command (`file://` path, `npm run dev`, local server).
- **Personas and task list:** passed to the tester in the prompt. Several personas are allowed; report per persona.
- **Report dir:** `$SCRATCH/roundN/`. `$SCRATCH` is the project's own report folder if it has one (for example `reports/` in the repo), otherwise a folder in the session scratchpad, last fallback `/tmp/ux-loop-<app-slug>`.

Two roles. Never merge them into one agent.

- **Tester** = `Agent(subagent_type: "ux-tester")`. Fresh context every round, read-only on the app, writes only to `$SCRATCH/roundN/`.
- **Improver** = the main session. Fixes issues, keeps the "Keep" list intact, re-runs.

## Round protocol

1. Rollback point: if the app is a git repo, commit the current state (`git commit`, no push) and note the hash. Otherwise `mkdir -p $SCRATCH/roundN && cp -r <app> $SCRATCH/roundN/snapshot`.
2. Launch the tester with: app URL, files it may read, report dir, round number, persona, task list, and the previous round's report path (so it can confirm fixes and note regressions). It must run the full task list every round; do not narrow it.
3. When the report arrives: fix every P1 and P2. Fix P3s only when cheap. Do not add features the tester did not ask for. After fixing, run a headless smoke test (no page errors, two or three tasks scripted) before the next round.
4. Stop when **two consecutive rounds** report `SHIP-READY: yes` and no new P2 for **every persona**, or after round 6.

## Report to the user

One line per round: `R1 62 → R2 80 → R3 91`. Then the top changes as bullets. Then open P3s. Nothing else.
