---
name: compounding-setup
description: Install and configure the compounding kit on this machine (store, CLAUDE.md, SKILLS.md, memory folder, headless auth, cron). Use when the user says "set up the compounding kit", "install the loops", "compounding setup", or right after the plugin was installed.
---

# Compounding setup

Goal: after this skill the five loops run on this machine (learning loop, follow-ups, memory review, skill chains, run log). Do the steps in order. Verify each one before you move on; never report a step as done that you did not see succeed.

## 1. Run the setup script

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/setup.sh"
```

Read its output. Every `[todo]` line becomes a step below. It never overwrites existing files; it puts a `.template` copy next to them.

## 2. CLAUDE.md

Open `~/.claude/CLAUDE.md`. If it was just created from the template, fill the three marked sections with the user. Ask at most three questions with AskUserQuestion, one at a time:

1. Response style: how long and how technical should chat replies be?
2. Definition of done: what must be true before Claude says "done"? (Offer the template's list as the default.)
3. Autonomy: what may Claude do unasked, what always needs a question?

If a CLAUDE.md already existed, show the user the template sections that are missing from it (learning loop line, follow-up rule, memory rules, skill chains pointer) and propose them as additions. Never rewrite their text.

## 3. Memory folder

Find the memory folder Claude Code loads for the user's main project: `ls ~/.claude/projects/`. The one matching their work folder is `MEMORY_DIR`. If `MEMORY.md` there has no index yet, copy the structure from `~/.compounding/MEMORY.md.example` (headings only, no content).

## 4. Headless auth for jobs

Jobs run `claude -p` without a terminal. They need a long-lived token:

1. The user runs `claude setup-token` in their own terminal (OAuth login, cannot be done by Claude).
2. They store the result as one line `export CLAUDE_CODE_OAUTH_TOKEN=...` in `~/.config/compounding/claude-auth.env`, `chmod 600`. The `export` is required.
3. Record the expiry date (one year) as a follow-up: `followup.sh add "renew claude setup-token" <date>`.

The token never goes into a repo, a synced folder or a script.

## 5. Schedule

Show the crontab lines the setup script printed. The user picks which loops to run (recommend all four: memory review nightly, follow-ups daily, learning review weekly, plus their own jobs wrapped in run-logged.sh). They paste the lines into `crontab -e` themselves. On a Mac that sleeps, point them to `templates/launchd.example.plist` instead, or run the jobs on a small always-on server (see docs/jobs.md).

## 6. Skill chains

Open `~/.claude/SKILLS.md`. Walk through the seven sections with the user and replace the placeholders with the skills they actually have (`ls ~/.claude/skills`, plus plugin skills). Delete sections they do not need; keep the numbering, the router rules point at it. Adjust `~/.claude/skill-router.rules` only if their vocabulary differs from the defaults.

## 7. Verify

- `bash "${CLAUDE_PLUGIN_ROOT}/scripts/learning.sh" list` runs without error.
- Start a new session: the learning-loop line appears at session start.
- `MEMORY_DIR=... bash "${CLAUDE_PLUGIN_ROOT}/scripts/memory-review.sh"` runs once by hand (needs the token) and writes to the run log.
- `/compounding-status` shows the smoke-test run.

Report in five lines: what runs, what the user still has to do by hand (token, crontab), and the link to docs/playbook.md.
