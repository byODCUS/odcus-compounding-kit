# Skill chains: SKILLS.md and the router

## The problem it solves

With more than about twenty skills, the model stops picking the right one, and picks none on a bad day. A chain file says, per task class, which skills run in which order and what gate must pass between them. A hook injects the matching section into the prompt, so the harness decides, not the model's memory.

## SKILLS.md

Start from `templates/SKILLS.md`. Seven numbered sections; the router rules point at the numbers, so keep them even if a section is empty for you.

Per section:

1. Steps in order, each naming a skill in backticks.
2. **Gates**: "Gate: X passes" between steps that must not be skipped. The truth gate (`substance-check`) always runs before the style gate (`stop-slop`); the order matters because style edits can introduce claims.
3. Skills marked `/name` are user-only (the skill has `disable-model-invocation`). The user types them; the chain tells the model not to.
4. An **Overlaps** table at the end: "use this one, not that one". It is the single most useful part when several installed skills do similar things.
5. A **Sources** list: where each third-party skill came from and when it was copied.

Universal gate for every chain: verify before "done". Name the command that proves the claim, run it, read the output.

## The router hook

`hooks/skill-router.sh` runs on every prompt:

- Lower-cases the prompt, skips slash commands, relayed agent messages and prompts under four words.
- Matches `~/.claude/skill-router.rules` (`class|section|regex`), at most two classes per prompt, in file order.
- Injects the matching SKILLS.md section once per session and class (a cache folder under `$COMPOUNDING_HOME/cache/skill-router`).
- Logs `ts, session, classes` to `cache/skill-router/log.jsonl`. Never the prompt text.

Add your own product, client and project names to the rules. The defaults are generic English and German vocabulary.

## Measuring adherence

The router log says which class each session was routed to. The transcripts say which skills actually ran. Comparing the two per week gives an adherence number per chain: routed as "content", did `substance-check` and `stop-slop` run? Ours is a 140-line Python script that reads tool names only; it is not in this kit because it depends on our dashboard, but the two inputs are standard.

Two more weekly checks worth having:

- **Skills without a chain line.** `ls ~/.claude/skills` against the names in SKILLS.md. A skill no chain names is either new (add it) or dead (archive it, do not delete; we keep unused skills on purpose).
- **Drift between machines.** Hash the SKILL.md files on the workstation and the server; report differences.

## Writing or patching a skill

- Description under about 250 characters. It is loaded into every session.
- Name the trigger phrases in the description, in the user's languages.
- One SKILL.md, references in a `references/` folder, scripts in `scripts/`. The file is `SKILL.md`, capitals.
- When a skill changes because of a learning, the patch is small. Three patches on one skill is the signal to restructure.
- Test a patch with a pressure scenario before and after (the superpowers `writing-skills` method): a prompt where the model would skip the rule. If it still skips, the rule has an enforcement problem; add a hook or a check instead of a sentence.
