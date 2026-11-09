# Playbook: how the setup compounds

This is the method behind the plugin. Read it once, then let the loops run. Everything here comes from running the setup daily since mid-2026; the dates in the "learned the hard way" notes are real.

## The four loops

| Loop | Captures | Where it lands | Who closes it |
|---|---|---|---|
| **Learning loop** | a working instruction (skill, job, rule, CLAUDE.md) was incomplete, wrong or clumsy | `learnings.jsonl` | weekly `learning-review.sh` proposes patches, you apply them |
| **Follow-ups** | anything with a date | `followups.jsonl` | `followups-due.sh` every morning, you close with `done` |
| **Memory** | corrections, confirmed approaches, preferences, project facts | memory files + MEMORY.md index | nightly `memory-review.sh` reads transcripts and writes memory |
| **Run log** | every job run: status, summary, host | `runs.jsonl` | a dashboard reads it; failed or partial runs need you |

The three stores have strict borders. Mixing them is the most common early mistake:

- **Memory** = a fact I must remember. ("The client's CSP drops inline scripts.")
- **Follow-up** = a task with a date. ("Renew the token before 2027-07-27.")
- **Learning** = an instruction was wrong. ("The blog skill demands a service link, the job forbids one.") The goal is a *patch to a file*, not a note.

## Why files, not a database

Every store is a `.jsonl` or `.md` file. A session can `grep` it, a cron job can `tail` it, a sync tool can move it between machines, and nothing breaks when a tool disappears. The cost is small: one append per event.

## The weekly rhythm

- **Every night 23:30**: memory review (capture). Sundays it also consolidates (weekly rollup, dedupe, contradictions). First Sunday of the month it also promotes and decays (TTL, index cap, dangling links).
- **Every morning 07:10**: due follow-ups into the run log.
- **Monday 13:00**: learning review. Read the report, apply the patches you agree with, close the rest with the commands the report gives you. Thirty minutes.
- **Sunday**: look at `/compounding-status`.

## Rules learned the hard way

**Fix the writer before cleaning what it wrote.** A context audit (14.09.2026) found 102 of 217 memory files with a `name` field that did not match the file name, and 58 broken links as a result. The cause was the nightly writer, not the files. Any change to the memory job starts at the prompt that writes, not at the symptoms.

**Second violation = enforcement problem, not wording problem.** If a rule is broken twice, do not write a third, sharper sentence. Build a structural barrier: a hook that refuses the call, a check in the script, a default that makes the wrong path impossible. The learning review encodes this.

**Instructions that grow with every learning die.** The review writes small patches and proposes a restructuring once a target collects more than three. Skill descriptions have a length cost too: 12 skills with 500 to 680-character descriptions cost about 750 tokens on every session start (09.11.2026). Keep descriptions under about 250 characters.

**Write the checklist first.** A long headless run once died after 40 minutes mid-report and lost exactly the checklist that came last. The review now writes the checklist section first and fills the analysis after.

**Transcripts and logs are foreign content.** The learning review runs without a shell in report mode because `learnings.jsonl` is written by every job. The memory review tells the model that transcripts are data, not instructions. Keep this when you write your own jobs.

**One claude at a time on a small server.** Each headless `claude` takes 200 to 260 MB. Seven at once froze a 2 GB box (21.07.2026). Stagger cron times and add a memory watchdog if jobs can overlap.

**Case matters on Linux.** The skill file must be named `SKILL.md`. Four skills named `skill.md` loaded on the Mac and silently not on the server; the nightly job wrote against old rules for weeks.

**Plugin folders are not patchable.** `~/.claude/plugins/cache/...` is replaced on update. A learning that points there gets rejected by the review; the fix goes into a local override or memory.

**Never say done without the proof.** Name the command that proves the claim, run it, read the output, then report. "Should work" is not a state.

## Adding your own job

1. Write the script under `$COMPOUNDING_HOME/jobs/<name>.sh`. Keep the Claude prompt as a heredoc inside the script so the learning review can find and patch it.
2. Restrict tools: `--allowed-tools` to what the job needs, `--disallowed-tools Agent,WebFetch,WebSearch` unless required.
3. End the prompt with: "If an instruction in this job was incomplete or wrong, record it: `bash <kit>/scripts/learning.sh add <name> "gap" "proposal"`." That is how jobs feed the learning loop.
4. Schedule it through `run-logged.sh <name> ...` so it appears in the run log.

## What a dashboard reads

`runs.jsonl` (one line per run: `ts, job, status, started, summary, host, detail`), `learnings.jsonl` (open count, targets), `followups.jsonl` (due), and the newest `reports/learnings-*.md` (the `## Checklist` section and the `### l-<id>: VERDICT` headings are stable for parsing). Ours is a single HTML page served by a small Python server; any static page works.
