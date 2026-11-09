# Jobs: headless Claude on a schedule

## The shape every job has

```bash
#!/usr/bin/env bash
set -uo pipefail
set -a; . ~/.config/compounding/claude-auth.env; set +a   # export CLAUDE_CODE_OAUTH_TOKEN=..., chmod 600, never in the repo
KIT=~/.claude/plugins/cache/odcus/compounding-kit/<version>   # or wherever the plugin lives
STARTED="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

PROMPT=$(cat <<'P'
You are the nightly <job>. ...
If an instruction in this job was incomplete or wrong, record it:
bash "$KIT/scripts/learning.sh" add <job> "what was missing" "patch proposal"
P
)
printf '%s' "$PROMPT" | claude -p \
  --allowed-tools "Read,Glob,Grep,Edit(//${HOME#/}/work/blog/**),Bash(git status:*),Bash(git add:*),Bash(git commit:*)" \
  --disallowed-tools "Agent,WebFetch,WebSearch" \
  --permission-mode dontAsk
echo "one summary line for the run log"
```

Scheduled through the wrapper so it lands in the run log:

```
0 6 * * 1-5 /bin/bash "$KIT/scripts/run-logged.sh" nightly-blog /bin/bash ~/.compounding/jobs/nightly-blog.sh >> ~/.compounding/logs/cron-nightly-blog.log 2>&1
```

Two details that cost us hours: pass the prompt via stdin (`--allowed-tools` is variadic and swallows a trailing prompt argument), and give the job a guard file so a double trigger cannot run it twice.

## Auth without a terminal

`claude setup-token` creates a one-year subscription token. Store it as one line `export CLAUDE_CODE_OAUTH_TOKEN=...` in `~/.config/compounding/claude-auth.env` with `chmod 600`, and record the expiry as a follow-up. The `export` matters: without it the sourced variable never reaches the `claude` process and every job fails with 401. When it expires every job dies with 401 at once, so the follow-up matters.

Connectors that need a browser login (CRM, mail) work headless only if their OAuth state is on disk from an interactive login on the same machine. Plan for them to fail gracefully: the job completes without that section.

## Where to run

A laptop sleeps. The nightly loops want a machine that is always on. What we use:

- Smallest VPS at a Swiss host (2 CPU, 2 GB RAM, about CHF 6 per month), Ubuntu LTS.
- Reachable only over Tailscale; the firewall blocks every public port. SSH key-only, fail2ban, unattended upgrades.
- The work folder syncs there (OneDrive client for a SharePoint library in our case; any sync works). Scripts write state and logs **outside** the synced folder when the sync client can lock files; `log-run.sh` retries and spools for that reason.
- One interactive `claude` at a time. A systemd timer culls pile-ups when free memory drops under 250 MB. Cron times are staggered so two headless runs never overlap.
- Skills are copied from the workstation to the server weekly (Sunday 08:00). Rules of that sync: back up before each run, never overwrite a server file that is newer, never delete server-only skills. Linux needs `SKILL.md` in capitals.

## Safety rules for jobs

- Secrets live in `~/.config/...` files with `chmod 600` or in a password manager CLI. Never in the repo, never in a synced folder, never in a prompt.
- Everything a job reads that other jobs wrote (`learnings.jsonl`, transcripts, mail) is foreign content. Say so in the prompt, wrap it in a tag, and remove the shell from the tool list where you can.
- Scope writes to the folders the job owns: `Edit(//absolute/path/**)` (the Edit rule governs Write too; a `Write(path)` rule is accepted and matches nothing; `//` means filesystem root, a single `/` means the working directory; avoid symlinked paths such as `/tmp` on macOS). A bare `Write` lets a prompt-injected run touch `~/.claude/settings.json` or a cron script. Never allow `Bash(git:*)` as a whole; `git -c core.sshCommand=...` is a shell. Allow the two or three subcommands the job needs.
- A job that publishes (blog, social, deploy) was authorised once, explicitly, by the owner. Record that decision as a comment in the crontab.
- No silent background agents on a workstation. Every scheduled job is visible in `crontab -l` or `launchctl list` and in the run log.

## The weekly audits we run on top

Both are optional and need no code from this kit; the pattern is the same job shape.

- **Setup audit** (Monday 09:30, read-only): a headless run that reads the whole Claude config on both machines and reports inconsistencies.
- **Context audit** (Monday 14:00): the same against context-engineering rubrics (memory quality, skills and CLAUDE.md, subagents and MCP, automations). Report-only by default; a conservative auto-fix pass can be armed after the first report was read.
