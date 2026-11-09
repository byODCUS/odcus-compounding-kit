# ODCUS compounding kit

A Claude Code plugin plus playbook that makes a Claude setup **compound**: every session, every job and every correction leaves something behind that the next one uses. Built and run daily at ODCUS. MIT licensed.

## What compounds, and how

```
 session / job runs
       │
       ├─ gap in an instruction ──► learnings.jsonl ──► weekly review ──► patch to the skill / job / rule
       ├─ something with a date ──► followups.jsonl ──► surfaces every morning
       ├─ user correction, fact ──► memory files ◄──── nightly memory review of transcripts
       └─ run result ────────────► runs.jsonl ───────► one feed for a dashboard
```

Four loops, one store (`~/.compounding`), no server required for the first three. Details in [docs/playbook.md](docs/playbook.md).

## Install

```bash
claude plugin marketplace add byODCUS/odcus-compounding-kit
claude plugin install compounding-kit@odcus
```

Or in one step inside a Claude Code session (Claude Code 2.1.275 or later):

```
/plugin install compounding-kit --marketplace byODCUS/odcus-compounding-kit
```

Then in a Claude Code session: **"set up the compounding kit"**. The `compounding-setup` skill runs `scripts/setup.sh`, fills `~/.claude/CLAUDE.md` from the template (never overwriting yours), finds your memory folder, and prints the cron lines. Two things stay manual by design: the headless token (`claude setup-token`) and the crontab.

## Dependencies

- **Required:** Claude Code, `jq`, `python3`, `git`, and cron or launchd for the scheduled loops.
- **No other skills or plugins.** The kit does not use a search engine (such as `qmd`), a vector store, MCP servers or third-party skills. Memory is plain Markdown files that Claude Code already loads; the loops are `.jsonl` files and shell scripts.
- **Optional, not included:** the `context-engineering` plugin, whose rubrics we use for a weekly audit described in [docs/jobs.md](docs/jobs.md).

Jobs need a machine that is on at night (a CHF 6/month VPS does it; see [docs/jobs.md](docs/jobs.md)).

## What is in the plugin

| Part | Files | Purpose |
|---|---|---|
| Hooks | `hooks/` | learning-loop reminder at session start and after every skill call |
| Scripts | `scripts/` | `learning.sh`, `followup.sh`, `log-run.sh`, `run-logged.sh`, `followups-due.sh`, `learning-review.sh`, `memory-review.sh`, `setup.sh` |
| Commands | `/learn`, `/followup`, `/compounding-status` | the loops from the prompt |
| Skill | `compounding-setup` | guided first-time setup |
| Templates | `templates/` | CLAUDE.md, MEMORY.md and memory examples, crontab, launchd |

About 180 tokens of always-on context, plus one hook line at session start.

## What is not in it, on purpose

- **Our skills, agents and brand files.** This kit is the memory and feedback machinery only. Which skills you run it with is your call.
- **Memory contents.** Memory is personal. The kit ships the conventions and the review job, not our notes.
- **Business jobs** (blog publishing, CRM sync, finance). `docs/jobs.md` shows the pattern they all follow so you can write your own in an afternoon.

## Docs

- [docs/playbook.md](docs/playbook.md): the method, the weekly rhythm, the rules we learned the hard way
- [docs/jobs.md](docs/jobs.md): headless `claude -p` jobs, auth, server sizing, safety
- [docs/memory.md](docs/memory.md): memory conventions and the review modes

## Updating

`claude plugin update compounding-kit@odcus`. Your `~/.claude/CLAUDE.md` and `~/.compounding` store are yours; updates never touch them.

MIT licence (see LICENSE). Security notes: SECURITY.md.
