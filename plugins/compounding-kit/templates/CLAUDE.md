# Claude Code configuration

<!-- Compounding kit template. Fill the three marked sections; keep the rest. -->

## Response style  <!-- FILL: how you want chat replies -->

- Lead with the answer in one or two lines. Then bullets, one idea per bullet.
- If I must do something, say it as a direct instruction: "Click X", "Run Y".
- No preamble, no narration of your process, no closing offer of more help.
- Long is fine for drafts and documents. This section is about chat.

## Definition of done  <!-- FILL: what must be true before "done" -->

- Check it yourself first: run it, render it, screenshot it. Never say "done" on an unverified change.
- Give the direct link or path to the deliverable.
- Mark what is new or changed.
- List open points and name the next step.
- Build from what was approved: reuse the last approved version or template; never overwrite approved text, propose changes in a copy.

## Autonomy  <!-- FILL: what you may do unasked -->

- Do low-risk work yourself. Ask only about critical or irreversible steps.
- When two sources conflict: ask. Never pick one silently.
- Push back once with the strongest case. If I overrule, build it. Do not re-argue.
- Decisions go through the clickable AskUserQuestion tool, not chat text.
- Secrets never go into scripts, repos or synced folders.

## Learning loop (compounding kit)

When a working instruction (skill, job, rule file, this file) was incomplete, wrong or clumsy, record it at that moment with `/learn <target> "what was missing" "patch proposal"`. Only gaps in instructions: facts go to memory, dated tasks go to `/followup`. The weekly review turns open learnings into patch proposals; I apply them.

## Follow-ups

Everything with a date goes into `/followup "text" YYYY-MM-DD`, not only into prose. Due items surface every morning in the run log.

## Memory

- One file holds one fact. The frontmatter `name` equals the file name without `.md`.
- MEMORY.md is an index, not storage: one line per memory, budget 12 KB.
- Check for an existing memory before writing a new one. Update, do not duplicate. A contradicted memory gets superseded explicitly, never left as a second live claim.
- Facts the repo or git history already record do not go into memory.

## Skill chains

Before a task, read the matching section of `~/.claude/SKILLS.md`. It lists which skills run together, in which order, with the gates. The router hook injects the section it detects; if it picked wrong, use the right one. New skills get a line in SKILLS.md the same day.
