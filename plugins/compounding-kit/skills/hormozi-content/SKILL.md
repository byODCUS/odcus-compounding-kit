---
name: hormozi-content
version: 1.1.0
description: Review or create content with the Hormozi frame, split by format. Time-boxed formats (presentations, pitches, webinars, sales calls, offers, service-page copy) teach what is possible and why, never step-by-step. Content (blog, LinkedIn, newsletter, whitepaper, video) gives why first, then the how with a real self-done example. Modes review and create.
allowed-tools:
  - Read
  - Write
  - Edit
  - Grep
  - Glob
  - AskUserQuestion
---

# Hormozi Framework Skill

You apply one principle, split by format. Read the **Scope** section of `references/framework.md` first, then decide the format:

- **Time-boxed formats** (presentation, keynote, webinar, pitch, sales call, offer, sales copy on a service page): **teach what's possible and why it works. Never teach how to do it.** Everything below about violations applies.
- **Content** (blog, LinkedIn, newsletter, whitepaper, video, toolbox): **why first, then show the how**, with a real example we did ourselves. Here the violations flip: missing how, vague how ("man könnte"), steps we never ran, or how without why are the failures. Step lists are allowed.

Read `references/framework.md` before running either mode.

## Modes

**Review mode** (default): audit existing content, flag violations, rewrite offending sections, score.

**Create mode**: generate content on a given topic using the framework from the start.

If the user pastes content or provides a file path → review mode.
If the user gives a topic, angle, or brief → create mode.

---

## Review mode process

1. Read `references/framework.md`
2. Scan the content for violations (see framework for the three failure patterns)
3. Flag each violation with a one-line label
4. Rewrite flagged sections by format: time-boxed formats get what/why framing (no step-by-step); content gets why first, then the real how from a self-done example
5. Score across 4 dimensions (see below)
6. Return: flagged original → rewritten version → score → change list

### What counts as a violation (time-boxed formats)

- Step-by-step instructions ("here's what to do: step 1, step 2...")
- Numbered lists of tactical actions
- "Here's how to..." constructions
- Tool-specific walkthroughs (click here, go to X, set Y to Z)
- Advice that only applies to someone ready to execute right now
- Anything that tells the reader what to do rather than shifting how they see the problem

### What counts as a violation (content)

- No how at all: the reader finishes and cannot do anything differently this week
- Vague how: "man könnte", "es lohnt sich zu prüfen", no actual wording, prompt or order
- How without why: steps first, mechanism missing
- Steps nobody here ever ran, or a tool that was not tested
- Steps that need company systems or other people, presented as if one person could do them alone
- Our own setup shown too deep: job, tool or agent names, schedule times, file paths, hosts, credentials, internal prompts word for word. High level is wanted (building blocks, how they connect, rules, dated incidents); see framework.md Scope

### What does NOT count as a violation (time-boxed formats)

- Examples and proof ("here's what happened when a client changed this...")
- Before/after contrasts showing outcomes
- Explaining the mechanism behind why something works
- Naming the problem specifically
- A soft CTA at the end

---

## Create mode process

1. Read `references/framework.md`
2. Ask (if not clear): what is the topic, who is the audience, what channel (LinkedIn / blog / pitch / newsletter)?
3. Identify the specific problem or belief the piece should shift
4. Structure the piece using: problem → what's possible → why it works → proof/example → soft CTA
5. Time-boxed formats: never include steps, numbered lists of actions, or how-to walkthroughs. Content: after the why, show the how concretely (wording, prompt, order, time), from a real example
6. Return the draft

## Final step before showing (mandatory, runs unasked)

Rule source: your brand rules, section "Before finalizing".

1. Before you show any draft to the user, run `/substance-check`, then `/stop-slop`. Do not wait to be asked. Fix what they flag.
2. Report both scores in one line, for example: `Substance: 5/5 pass · Stop-slop: 42/50`.
3. External videos, posts and articles are a reference only. Build the argument from your knowledge base (your qmd collections) and our own thinking. Never retell one source.
4. Keep your market's focus (ours: Swiss and European). Drop deadlines or rules that only apply elsewhere.

---

## Scoring (review mode only)

| Dimension | What it measures | 1–10 |
|-----------|-----------------|------|
| **Perspective shift** | Does it change how the reader sees the problem, not just inform them? | |
| **Why depth** | Does it explain the mechanism — why something works — not just that it works? | |
| **Proof specificity** | Does it use concrete examples, before/after, or results instead of assertions? | |
| **Zero execution** (time-boxed) / **Usable how** (content) | Time-boxed: zero step-by-step, any how-to caps at 6. Content: can the reader do it this week, alone, from what is written? Vague or missing how caps at 6. | |

Flag below 28/40.

### Kurzformate (Hero-Leads, Meta-Descriptions, Navigationstexte)

Bei Copy unter ~25 Wörtern können "Why depth" und "Proof specificity" strukturell
nicht punkten, dort ist kein Platz für Mechanismus oder Beweis. Diese zwei
Dimensionen als N/A markieren, nicht niedrig scoren. Gewertet werden nur
"Perspective shift" und "Zero execution", Skala 20, Flag unter 14.

Gilt für Hero-Leads, Sub-Headlines, Meta-Descriptions, Navigations- und
Button-Texte, Karten-Teaser. Nicht für LinkedIn-Posts oder Abstracts.

---

## Output format

**Review mode:**
```
[Flagged violations — label each]

[Rewritten version]

---
Score: XX/40
- Perspective shift: X/10
- Why depth: X/10
- Proof specificity: X/10
- Zero execution: X/10

Changes: [3–5 bullets on what was rewritten and why]
```

**Create mode:**
```
[Draft content]
```
No score needed in create mode — the framework is the brief.

---

## Gotchas

- **Format decides the rule.** Ask or infer the format first. A blog post with a five-step how is correct; the same five steps on a pitch slide are a violation.
- **CTAs are not violations.** "Talk to us if you want this implemented" is selling the how. That's the goal.
- **Proof is not how-to.** Showing a before/after result is fine. Walking through how to replicate it step by step is not.
- **One mechanism is allowed.** Explaining *why* weak hooks kill ads is not the same as teaching someone to write a hook. Keep the explanation at the level of understanding, not execution.
- **Channel matters for create mode.** LinkedIn posts are shorter and more direct. Blog posts can go deeper on the why. Pitches need harder proof. Ask if unclear.
- **German content:** The same principle applies in German. "So geht's:" followed by numbered steps is a violation regardless of language.
- **Scoring is honest.** If there are 4 step-by-step sections, the zero-execution score is 2/10. Don't soften it.
