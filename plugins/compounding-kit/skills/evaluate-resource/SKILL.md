---
name: evaluate-resource
description: Judge an external link, video, post, article or repo against what you already have, return ADOPT, KEEP AS REFERENCE or IGNORE, and file useful sources into the right knowledge base inbox. Use when the user sends a link with "something we can learn?", "is this useful?", "worth adopting?", "was können wir lernen", "hilft uns das", "schau dir das an".
---

# Evaluate resource

`$WORKSPACE` = your knowledge folder (set in CLAUDE.md).

## Steps

1. **Fetch and read the whole thing.** X posts and X articles: full text via fxtwitter first. Videos: get the transcript. Repos: README plus the core files. Never judge from a title or a preview.
2. **Compare with what we already have.**
   - qmd search (your qmd collections) for the topic.
   - Existing skills in `~/.claude/skills/` and `$WORKSPACE/.claude/skills/`.
   - Memory index for tools or rules that already cover it.
3. **Verdict**, one of three:
   - **ADOPT**: what exactly we take, and where it goes (skill, memory, script, offer, content idea).
   - **KEEP AS REFERENCE**: worth having in the KB, nothing to change now.
   - **IGNORE**: we already have it, it does not fit, or it is US-only hype.
   Then 3 to 5 bullets why. Name what we already have when that is the reason.
4. **File it** (ADOPT or KEEP AS REFERENCE). Save the full text as `YYYY-MM-DD_<slug>.md` with source URL, author and date in the header:
   - AI, agents, Claude, automation topics: `$WORKSPACE/knowledge-base/raw/` (picked up by `your knowledge-base ingest skill`).
   - Consulting topics (security, sales, competitors, industry): `$WORKSPACE/knowhow/raw/<articles|competitors|industry|research|clients>/` (picked up by `your know-how compile skill`).
   Check the folder's `_index.md` first so the file is not a duplicate.
5. **ADOPT that changes a skill or rule**: propose the patch, apply it only when it is low risk.

## Rules

- Never copy a source 1:1 into our content. It is a reference. We build from our KB and our own thinking, with your market's focus.
- Vendor content: take the mechanism, flag the sales conclusion.
