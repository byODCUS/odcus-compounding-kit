# ODCUS compounding kit

A Claude Code plugin plus playbook that makes a Claude setup **compound**: every session, every job and every correction leaves something behind that the next one uses. Built and run daily at ODCUS AG since mid-2026. MIT licensed.

## What compounds, and how

```
 session / job runs
       │
       ├─ gap in an instruction ──► learnings.jsonl ──► weekly review ──► patch to the skill / job / rule
       ├─ something with a date ──► followups.jsonl ──► surfaces every morning
       ├─ user correction, fact ──► memory files ◄──── nightly memory review of transcripts
       ├─ run result ────────────► runs.jsonl ───────► one feed for a dashboard
       └─ task class ◄──────────── router hook injects the SKILLS.md chain for it
```

Five loops, one store (`~/.compounding`), no server required for the first four. Details in [docs/playbook.md](docs/playbook.md).

## Install

```bash
claude plugin marketplace add aiffective-yhi/odcus-compounding-kit
claude plugin install compounding-kit@odcus
```

Or in one step inside a Claude Code session (Claude Code 2.1.275 or later):

```
/plugin install compounding-kit --marketplace aiffective-yhi/odcus-compounding-kit
```


Then in a Claude Code session: **"set up the compounding kit"**. The `compounding-setup` skill runs `scripts/setup.sh`, fills `~/.claude/CLAUDE.md` and `~/.claude/SKILLS.md` from the templates (never overwriting yours), finds your memory folder, and prints the cron lines. Two things stay manual by design: the headless token (`claude setup-token`) and the crontab.

Requirements: Claude Code, `jq`, `python3`, `git`. Jobs need a machine that is on at night (a CHF 6/month VPS does it; see [docs/jobs.md](docs/jobs.md)).

## What is in the plugin

| Part | Files | Purpose |
|---|---|---|
| Hooks | `hooks/` | learning-loop reminder at session start and after every skill; skill router; taste interview; umlaut check (German) |
| Scripts | `scripts/` | `learning.sh`, `followup.sh`, `log-run.sh`, `run-logged.sh`, `followups-due.sh`, `learning-review.sh`, `memory-review.sh`, `setup.sh`, `human-review` |
| Commands | `/learn`, `/followup`, `/compounding-status` | the loops from the prompt |
| Skills | `stop-slop`, `substance-check`, `hormozi-content`, `content-interview`, `content-strategy`, `evaluate-resource`, `first-principles`, `human-review`, `software-factory`, `ux-loop`, `compounding-setup`, plus three from Addy Osmani (MIT) | the quality gates and methods the chains call |
| Agents | `ux-tester` | blind usability tester for `ux-loop` |
| Templates | `templates/` | CLAUDE.md, SKILLS.md, router rules, MEMORY.md and memory examples, crontab, launchd |

## What is not in it, on purpose

- **Brand files, voice guides, client data.** The skills reference `$WORKSPACE/...` placeholders; point them at your own files in CLAUDE.md.
- **Memory contents.** Memory is personal. The kit ships the conventions and the review job, not our notes.
- **Business jobs** (blog publishing, CRM sync, finance). They are specific to our stack. `docs/jobs.md` shows the pattern they all follow so you can write your own in an afternoon.
- **Third-party skills we use** (SEO suite, design skills, video). They have their own install sources: [THIRD-PARTY.md](THIRD-PARTY.md).

## Docs

- [docs/playbook.md](docs/playbook.md): the method, the weekly rhythm, the rules we learned the hard way
- [docs/jobs.md](docs/jobs.md): headless `claude -p` jobs, auth, server sizing, safety
- [docs/memory.md](docs/memory.md): memory conventions and the review modes
- [docs/skill-chains.md](docs/skill-chains.md): writing SKILLS.md, the router, measuring adherence

## Updating

`claude plugin update compounding-kit@odcus`. Your `~/.claude/CLAUDE.md`, `SKILLS.md`, router rules and `~/.compounding` store are yours; updates never touch them.

MIT licence (see LICENSE). Third-party parts keep their own licences (see THIRD-PARTY.md). Security notes: SECURITY.md.
