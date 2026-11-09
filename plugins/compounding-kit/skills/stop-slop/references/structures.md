# Structural Patterns to Avoid

## LinkedIn template markers (added 2026-07-14, research: $WORKSPACE/guides/linkedin-ai-marker-reichweite-research-2026-07.md)

The classic AI-post shape LinkedIn's generic-post classifier and readers both recognize. No single marker is a failure; flag the CLUSTERING of 3+ in one post.

- Hook line + emoji-bulleted list + closing engagement question (the full formula)
- Emoji as structural bullet markers (one per line) instead of occasional personality
- Generic closing question ("Was meint ihr?", "Agree?") → replace with a question only this post could ask
- Perfectly parallel bullets (same length, same grammar) → vary structure or prose
- Inline pointer emojis (👉, 🤔) marking where to feel something

**Fix:** Keep the exemplar register (ich-Erfahrung, one concrete detail nobody else has, varied sentence lengths, specific closing question).

## German formulaic section & closing headers (added 2026-07-22, owner feedback)

Canned headers that mark auto-generated German content. The tic is reaching for the SAME framing label in every piece; readers pattern-match it as machine-written. Flag any of these used verbatim as a heading:

- `Was du diese Woche tun kannst` / `Was du jetzt tun kannst` — formulaic action-CTA header
- `Die ehrliche Frage` / `Die eigentliche Frage` / `Die wahre Frage` — formulaic framing header
- `Was wirklich bleibt` / `Was wirklich zählt` / `Was wirklich wichtig ist` / any `Was wirklich …` — "wirklich" emphasis-inflation header
- `Was bedeutet das für dich?` as a canned closing label

**Fix:** Name the actual thing in the header, drawn from this post's own content, never from a fixed menu. `Was du diese Woche tun kannst` → `Deine erste Kronjuwel-Inventur`. `Die ehrliche Frage` → ask the question directly in prose, no header. `Was wirklich bleibt` → drop `wirklich` and say what bleibt. Two posts should not share a closing header.

**Exception, brand content structure (added 2026-10-24):** if a brand's fixed content structure prescribes binding block names that stay identical across a series (for example the second brand spine, `05 Marketing/ai-operating-system/01-content-struktur.md`, with "Was du tun kannst"), the structure wins. The tic is reaching into a default menu, not a deliberately set recurring block name. Then only check that the block name comes from the structure, and do not flag it; everything else still applies.

## Binary contrasts
State the point directly — drop the negation setup.

| Pattern | Problem |
|---------|---------|
| "Not because X. Because Y." | Telegraphed reversal |
| "The answer isn't X. It's Y." | Predictable pivot |
| "It's not this. It's that." | Mechanical contrast |
| "not just X but also Y" | Additive hedge |
| "stops being X and starts being Y" | False transformation arc |
| "The question isn't X. It's Y." | Rhetorical misdirection |

**Fix:** State Y directly. Drop the negation.

## Negative listing
Listing what something is *not* before revealing what it *is*.

- "Not a X... Not a Y... A Z."
- "It wasn't X. It wasn't Y. It was Z."

**Fix:** State Z. The reader doesn't need the runway.

## Dramatic fragmentation
Fragments used for emphasis — manufactured profundity.

- "[Noun]. That's it. That's the [thing]."
- "X. And Y. And Z." (staccato drama)
- "This unlocks something. [Word]."

**Fix:** Write complete sentences. Trust the content.

## Rhetorical setups
Announce insight instead of delivering it.

- "What if [reframe]?"
- "Here's what I mean:"
- "Think about it:"
- "And that's okay."

**Fix:** Make the point. Let readers draw conclusions.

## Colon reveals (added 2026-07-23, source: petergyang/no-ai-slop)
Noun phrase + colon + dramatic reveal, often lowercase for effect. Manufactured
punchline mechanics.

- "One thing changed everything: focus."
- "The real problem: nobody reads it."
- German: "Das eigentliche Problem: niemand liest es."

**Fix:** Rewrite as a plain sentence with standard capitalization. "Focus changed
everything." A colon after a full sentence introducing a genuine list or example
is fine; the tic is the dramatic-reveal shape.

## Fake-profound kickers (added 2026-07-23, source: petergyang/no-ai-slop)
A final "deep" line that turns the point into a cute metaphor or mic-drop.

- "In the end, the best firewall is trust."
- "Because security isn't a product. It's a habit." (also a binary contrast)
- Closing one-liners that metaphorize the whole piece

**Fix:** Delete the kicker, don't rewrite it into a better metaphor. End on the
last concrete point, takeaway, or next action.

## Interpretive metadiscourse (added 2026-08-14, source: petergyang/no-ai-slop)
Lines that step outside the subject to tell the reader what to notice or how much weight to give it, instead of demonstrating it.

- "This distinction matters."
- "As you can see..."
- "That last part matters more than it sounds."
- "The key point is..." / redundant "In other words,"
- German: "Und genau das ist der Punkt." / "Das ist wichtiger, als es klingt."

**Fix:** If the point is already clear, delete the aside. Otherwise replace it with the fact or example that makes the point on its own.

## False agency
AI avoids naming actors by giving inanimate things human verbs.

- "a complaint becomes a fix" → "the team fixed it"
- "the decision emerges" → "we decided"
- "the data tells us" → "the data shows X; I concluded Y"
- "the market rewards" → "buyers pay for"
- "the culture shifts" → "people changed behavior"

**Fix:** Name the human. If no specific person fits, use "you."

## Narrator-from-a-distance
Floating above the scene instead of putting the reader in it.

- "Nobody designed this."
- "This happens because..."
- "People tend to..."

**Fix:** Put the reader in the room. Use "you" or name a specific person.

## Passive voice
Hides the actor and drains energy.

- "X was created" → name who created it
- "Mistakes were made" → name who made them
- "The decision was reached" → name who decided

**Fix:** Find the actor. Put them at the front.

## Weak sentence starters

- Sentences starting with What / When / Where / Which / Who / Why / How
- Paragraphs starting with "So"
- Sentences starting with "Look,"

**Fix:** Lead with the subject or the verb.

## Rhythm problems

- Three-item lists → use two or one
- Every paragraph ends punchily → vary endings
- Em dashes (—) → remove entirely, use commas or periods
- Staccato fragmentation → don't stack short punchy sentences
- "Not always. Not perfectly." → hedging disguised as reassurance

## Lazy word patterns

- Sweeping absolutes: every, always, never, everyone, everybody, nobody
- All adverbs: -ly words, "really," "just," "literally," "genuinely," "honestly," "simply," "actually"

## Syntax-level patterns (added 2026-08-03, owner directive)

These operate below the phrase level: the sentence and paragraph machinery itself
gives the text away, even when every word passes the lists above.

### Anaphora (incl. negative anaphora)
Consecutive sentences or clauses opening with the same word or frame. The
negative form ("No X. No Y. No Z.") is the most common AI shape.

- "No setup. No config. No excuses."
- "We tested it. We measured it. We shipped it."
- German: "Kein Budget. Keine Zeit. Keine Ausrede."

**Fix:** Keep one instance, rewrite the rest with different openings, or merge
into one plain sentence. Zero tolerance for the "No X. No Y." stack; this
supersedes the earlier 2-3-per-piece allowance for negative parallelisms.

### Parallel sentence structures within a paragraph
Two or more sentences in the same paragraph built on the same grammatical
skeleton (same length, same clause order, same rhythm). Perfectly parallel
bullets are flagged above; this is the prose version.

**Fix:** Break the symmetry. Vary clause order, length, and where the subject
sits. One sentence can start with the object, one can be a plain short claim.

### Paragraph pinning
A short dramatic sentence pinned to the end (or start) of a paragraph to "land"
it. Related: every paragraph ending punchily (see Rhythm problems). The tic is
the standalone landing sentence itself, not just its frequency.

- "…and that changed how we work. Completely."
- "That's the whole model."
- German: "Mehr braucht es nicht."

**Fix:** End on the last piece of content, not on a beat. If the paragraph
needs the sentence for information, fold it into the previous sentence.

### Parataxis stacking
Short main clauses strung together without connectives, for rhythm rather than
meaning (the sentence-level cousin of dramatic fragmentation above).

- "We looked at the logs. We found the entry. We knew."

**Fix:** Subordinate or connect where the logic actually connects: "When we
found the entry in the logs, we knew." Keep one short sentence where it carries
real weight, not three in a row.

### Stacked noun phrases
Nouns modifying nouns modifying nouns until the verb disappears.

- "security awareness training program rollout plan"
- German: "Informationssicherheits-Massnahmen-Umsetzungsplanung"

**Fix:** Break into a verb-forward clause: "the plan for rolling out the
training." Two stacked nouns are fine; three or more get rewritten.

### Nominalization
Verbs and adjectives frozen into abstract nouns, draining the actor and the
action. The German chain form is already flagged under German structural
checks; this is the general rule, both languages.

- "the implementation of the assessment" → "we assessed"
- "die Durchführung der Überprüfung erfolgt" → "wir überprüfen"

**Fix:** Find the buried verb, give it a subject, rewrite verb-forward.

### Hedging qualifiers
Qualifier padding that softens a claim the author should either make or drop.
German hedging pile-ups are flagged in phrases.md; this is the general rule.

- "somewhat," "arguably," "to some extent," "in many cases," "tends to,"
  "can potentially"
- German: "gewissermassen," "in gewisser Weise," "tendenziell," "durchaus"

**Fix:** Take the position. If the uncertainty is real, state it once,
concretely ("bei zwei von fünf Kunden war das anders"), not as fog.

### Performed enthusiasm
Excitement as performance rather than information. Adjacent to Performative
emphasis and Promotional language in phrases.md, but covers the affect itself.

- "So excited to share...", "Thrilled to announce...", exclamation marks doing
  the work of content, "amazing," "incredible" as reactions
- German: "Ich freue mich riesig...", "Grossartige Neuigkeiten!"

**Fix:** State the fact and let it carry the energy. If the news is good, the
reader will notice without being told how to feel.

### The spoken-voice test (check, not pattern)
Read the paragraph aloud, or imagine saying it to a client across the table.
Anything you would never say out loud (stacked noun phrases, nominalizations,
symmetrical sentence pairs, a dramatic landing beat) gets rewritten into the
sentence you would actually say. This test catches the patterns in this section
faster than scanning for them individually.

### The portability test (check, not pattern) (added 2026-08-14, source: petergyang/no-ai-slop)
If a sentence could move word-for-word to another person, company, country, or
product and still fit, it is probably filler. Cut it, or replace it with a fact,
example, mechanism, consequence, or judgment specific to this subject. Catches
generic filler that passes every other pattern.

---

## Wikipedia AI patterns (folded in from /humanizer, 2026-07-17)

These are the tics not already covered above. Source: Wikipedia "Signs of AI writing".

### Copula avoidance
LLMs dodge simple "is/are" with elaborate stand-ins. Put the copula back.

- "serves as / stands as / functions as / acts as [a]" → "is"
- "boasts / features / offers [a]" → "has"
- German: "fungiert als / dient als / stellt … dar" → "ist"

**Fix:** "Gallery 825 serves as the exhibition space" → "Gallery 825 is the exhibition space."

### Superficial -ing tails
A present-participle phrase tacked onto a sentence to fake depth. Almost always deletable.

- "…, highlighting/underscoring/emphasizing its importance"
- "…, ensuring a seamless experience"
- "…, reflecting/symbolizing the community's connection"
- German: "…, was die Bedeutung unterstreicht" / "…, wodurch ein nahtloses Erlebnis entsteht"

**Fix:** Cut the tail or state the fact plainly. If it carries real information, make it its own sentence.

### Synonym cycling (elegant variation)
Renaming the same thing every mention to avoid repetition (AI repetition-penalty artifact).

- "the protagonist… the main character… the central figure… the hero"
- German role-cycling: "Sicherheitschef… Sicherheitskopf… Verantwortlicher" (real prior fix, 2026-07-16)

**Fix:** Pick one term and repeat it. Repetition of the right word beats a thesaurus parade.

### False ranges
"from X to Y" where X and Y aren't endpoints of any real scale.

- "from the Big Bang to dark matter, from star birth to cosmic webs"
- German: "von der Strategie bis zur Umsetzung, von der Analyse bis zur Kultur"

**Fix:** Just list the actual items. Drop the "from…to" scaffolding.

## Formatting tics (folded in from /humanizer)

Mechanical formatting that marks machine output. Check on any markdown/CMS/LinkedIn body.

- **Curly quotes** (“ ” ‘ ’) → straight quotes (" ' ). Same for the prime/apostrophe.
- **Boldface overuse** — bolding phrases mid-paragraph for mechanical emphasis. Keep bold for genuine scannable leads only (per blog style guide), not decoration.
- **Inline-header vertical lists** — bullets that open with a bolded label then a colon ("**Performance:** …"). Rewrite as prose or plain bullets unless the style guide mandates the lead.
- **Title Case In Headings** — capitalizing every word. Use sentence case. (German capitalizes nouns anyway; the tic is capitalizing adjectives/verbs too.)
- **Emoji in headings** — decoration, not structure. Remove. (Emoji as bullet markers: see LinkedIn template markers above.)
- **Headers over tiny sections** (added 2026-07-23, source: petergyang/no-ai-slop) — a heading for every 2-3 sentences fragments prose into a fake document. Merge sections or drop the headers.
- **Prose bulletization** (added 2026-07-23, source: petergyang/no-ai-slop) — bullets carrying connected reasoning that should flow as prose. Bullets are for genuinely enumerable items, not for chopping an argument.
