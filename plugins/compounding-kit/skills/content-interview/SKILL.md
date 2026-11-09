---
name: content-interview
description: Short interview with the author before drafting content, or mining their recent work for topics. Use for "I don't know what to write about", "ich weiss nicht was ich schreiben soll", "interview me", "mine my logs", or any post, blog or newsletter not derived from published content. Not for news-reaction posts or an automated blog pipeline.
metadata:
  version: 1.2.0
---

# Content Interview

The machine does research, structure, and editing. It never invents the author's voice and never fabricates their insight. This skill covers the part only the author can do: supplying the raw material.

Two modes. **Mode A** when there is no topic yet. **Mode B** when there is.

---

## Hard rules

1. **Never draft during the interview.** Not a hook, not a line, not "here is roughly where this goes." Drafting mid-interview makes the author react to your words instead of producing their own.
2. **One question at a time.** Never batch. Never number them in the message.
3. **Interview in the output language.** If the post will be German, the interview is German. The author's words go into the raw file untranslated. Translating the answers destroys the voice, which is the whole point.
4. **Six questions maximum.** The author's time is the scarce resource. If you get what you need in three, stop at three.
5. **"enough", "stop", "genug", "reicht" ends the interview immediately.** Write the raw file with what exists and mark the gaps.
6. **Preserve the author's exact words.** The raw file quotes them verbatim. No cleanup, no paraphrase, no smoothing of half-sentences.
7. **Push back once on a vague answer. Never twice.** One retry, then mark the slot thin and move on.

---

## Mode A: mining (no topic yet)

Mine what the author already said and did. Do not brainstorm topics from thin air; that produces the generic content every author rejects.

### Check an existing mining report first

If a scheduled job already mines the author's logs and transcripts for topics (see `docs/jobs.md` for the job shape), read its latest report first.

1. If it is from the current or previous week, present those spikes and skip the mining below. Do not re-score them.
2. Only if it is missing or older than 14 days, mine the sources below yourself and say that the report was stale.

### Sources, in priority order

1. Daily logs or work notes for the last 14 days (`$WORKSPACE/operations/logs/` or wherever yours live). This is where the spikes are. Read them all before scoring.
2. The standing idea bank (`$WORKSPACE/content/ideas.md` or equivalent).
3. Optional if reachable in this session: sent and received mail of the last 14 days, CRM notes, recent project or time entries. Use the connectors your setup has; never guess at ones it does not.
4. The knowledge base (`qmd` or your search) only to check whether a spike already has depth behind it.

### What counts as a spike

Ranked by how well they perform:

- **The author's own work contradicting their own advice.** Highest value. The consultant who audits their own house and finds it dirty.
- **Something that went wrong, that the author caught and fixed.** Real failure with a real fix.
- **A decision made against the obvious choice**, especially recommending less rather than more. The "do nothing" option.
- **A number that surprised the author.** Zero downloads. Eleven days. One fake signup.
- **Something the author said to a client that they would say again in public.**

Not spikes: successful routine work, tool announcements, industry news with no personal angle, anything where the interesting part belongs to the client.

### Scoring

Score every candidate 0 to 10: point-of-view strength 25%, story potential 25%, emotional intensity 20%, lesson or framework 20%, depth of available detail 10%.

**Floor: do not present anything under 6.** Three weak options are worse than one good one.

### Exclusion check

Before presenting, confirm the spike is not already covered: the blog index, the post archive, the published newsletters. A spike that duplicates a live post is dead.

### How to present

Top three to five, each on one line: score, the spike in a sentence, and why it is the author's story rather than anyone's story. Recommend one and say why in a single line. Then wait. Do not start interviewing until the author picks.

---

## Mode B: topic given

Skip the mining. Go straight to the interview. If the topic is broad ("something about backups"), spend the first question narrowing it to one concrete situation the author lived through, not to a subtopic.

---

## The interview

Six slots. Adapt the wording every time; never send these verbatim, and never reuse the same phrasing across sessions. Each slot chases a different dimension.

1. **The moment.** Where was the author, what happened, what went through their head in the first seconds. Ask for the messy version, the one they would tell at a bar.
2. **The specifics.** Numbers, dates, the name of the system or the document. Client names never leave the room; anonymise at draft time, but collect the real detail now so the anonymised version still has weight.
3. **The counter-move.** What did the author do that most people in their position would not have done?
4. **The cost.** What did this cost: money, hours, a lost mandate, looking stupid in front of someone. This slot produces the highest-performing material. Do not skip it because it feels intrusive.
5. **The second case.** Has the same thing happened before, somewhere else? Target two to three concrete stories in total.
6. **The so-what.** A busy decision-maker reads this on Tuesday. What should be different by Friday? One concrete action, not a principle.

### Detecting a vague answer

Flag it when the answer contains "usually", "often", "one should", "it is important", "generally" (German: "meistens", "oft", "man sollte", "es ist wichtig", "grundsätzlich"), when it runs under roughly fifteen words, or when it contains no concrete noun, number, or date.

The single retry, in plain words: *"Give me the concrete case. Which situation, which number, which day?"*

If the retry also comes back vague, log the slot under Thin spots and move to the next question. Do not fight for it.

### Stop early when

- Two to three stories with real detail are on the table. Stop even at question three.
- The author says enough, stop, genug, or reicht.
- Six questions have been asked.

---

## Output: the raw file

Path: `$WORKSPACE/content/interviews/YYYY-MM-DD-<slug>.md` (or your equivalent folder).

```markdown
---
date: YYYY-MM-DD
topic: <one line>
spike_source: <log file, conversation, or "topic given by the author">
target_format: <LinkedIn | blog | newsletter | several>
status: raw
---

## Verbatim
<the author's answers, exactly as written, question by question, unedited>

## Stories
<2-3 stories, each with its concrete details: what, when, how much, what happened next>

## Quotable sentences
<the author's own sentences worth keeping intact in the draft>

## The cost
<what it cost>

## The so-what
<the concrete Tuesday-to-Friday action>

## Thin spots
<every question the author did not really answer, and every detail the draft will need but does not have>
```

**Thin spots is the anti-fabrication mechanism.** If the drafting step needs something listed there, it asks the author. It never invents a plausible number, a plausible client, or a plausible quote to fill the hole. This is where fabrication actually starts, so this is where the rule sits.

---

## Handoff to drafting

Drafting immediately after the interview is correct. Drafting *without* the raw file is what this skill exists to prevent.

The chain:

1. Raw file written and saved.
2. Draft, reading the raw file plus your voice authority note (one file that defines the register) and the format's style guide (formats and mechanics only). Quote the author's sentences where they land; do not rewrite them into cleaner prose.
3. `/substance-check`: is every claim true and verified.
4. `/stop-slop`: the style and AI-tic gate.
5. The author approves. Posts go into the scheduling tool as a **draft**, never scheduled unasked.

Repurposing a piece to another format re-reads the raw file. It does not rewrite the finished post.

---

## The learning loop

After the author edits a final draft, diff their version against yours. If the same correction appears across two or three pieces, name the pattern in one line and ask the author to confirm it. Only on confirmation, append it to the voice authority note. Never edit the voice authority without an explicit yes.

---

## What this skill must not do

- Interview the author about news where the external source is the story. Draft that directly and add the practical checks.
- Run inside an automated blog pipeline. That has a keyword strategy and a pillar rotation; it does not need the author in the loop at 06:00.
- Exceed six questions, in any mode, for any reason.
- Produce a draft, an outline, or a hook before the raw file exists.
- Invent a specific to fill a Thin spot.
