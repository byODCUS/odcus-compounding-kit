---
name: human-review
description: Open an HTML or Markdown file in the browser so the user can edit the text directly and leave comments on specific parts, then send all their edits and comments back to you. Use after writing or updating any HTML or Markdown file the user will read — specs, plans, reports, newsletter drafts, landing pages, slide decks.
---

# human-review

The user reviews your HTML or Markdown in a real browser: they fix small things
by typing, select anything to comment on it, and send you the whole batch at once.

Markdown files open rendered. Their quotes and edits reference the rendered text,
and the file itself is never touched — apply every change to the Markdown source,
keeping its formatting syntax.

## The loop

1. Write or update the HTML or Markdown file.
2. Open it for the user:

   ```sh
   human-review path/to/file.html
   ```

3. Wait for feedback. This blocks until they hit Send, or the timeout passes:

   ```sh
   human-review poll path/to/file.html --timeout 600
   ```

   Keep this command in the foreground. Do not end your turn while it is waiting.
   If your shell returns a process or session handle, keep waiting on that handle
   until the command exits. If it prints `{"status":"timeout"}`, no feedback has
   arrived yet — run the same poll command again to keep waiting. Feedback is
   saved even if a poll dies, so nothing is ever lost.

4. Apply what comes back, then wait again. `--ack` clears the batch you just handled:

   ```sh
   human-review poll path/to/file.html --ack --timeout 600
   ```

Repeat 3–4 until the user says they are done.

## When it comes back: apply everything, then account for it

Real incident (23.10.2026): "many changes i did manually on the page were not implemented".
So after every batch:

1. Diff the returned edits against the version you sent. Every `edits` entry is a
   change they made by hand.
2. Apply every inline copy edit word for word (the `after` text, unchanged), to the
   file and to its source. Then apply every comment.
3. List each edit and each comment as **applied** or **skipped**, with a one-line
   reason for every skip. Nothing may vanish without a line in this list.

## Open it on your own

After each revision of a quote, offer or other client document, open human-review
without being asked. Do not wait for the user to request it.

Not sure whether feedback is already waiting — say, at the start of a new turn?
This answers instantly without blocking:

```sh
human-review status path/to/file.html
```

It prints `{"status": "feedback-waiting"}` when a batch is ready for a poll,
plus counts of unsent comments and edits still in the browser.

## What you get

One batch covers every page the user visited, grouped by file.

```json
{
  "status": "feedback",
  "pages": [
    {
      "file": "/abs/path/to/page.html",
      "comments": [
        { "id": "c_1", "kind": "selection", "quote": "the exact text they selected",
          "anchor": { "prefix": "...", "quote": "...", "suffix": "..." },
          "feedback": "what they want changed" }
      ],
      "edits": [
        { "label": "Problem body", "kind": "edited",
          "before": "the original wording",
          "after": "their exact new wording" }
      ]
    }
  ],
  "overall_note": "feedback not tied to any one page"
}
```

## Rules

- **`edits` are changes the user already made.** `after` is their exact wording —
  carry it across verbatim and never revert it. If the HTML was generated from
  something else (MDX, Markdown, a template), apply `after` to the **source** too,
  or their fix disappears on the next build.
- Find each comment by its `quote`; that exact string is in the file.
- `kind: "element"` points at a whole block, so `quote` is its label, not body text.
- Fix every page in `pages`, not just the first.
- Pages whose `file` is not the path you polled belong to another session: report them to the user and never `--ack` them.
- **Protect unsent edits.** When you open the page, tell the user to hit Send after
  every few edits. Never save or regenerate the file while the user is editing: save
  only after a batch arrived. Before any save, run `human-review status` and do not
  save while it shows unsent comments or edits. The browser keeps a draft copy in
  localStorage and restores it after a reload (since 2026-10-24), but a draft whose
  text block changed in the meantime only comes back as an edit, not in the page.
- **Do not write a reply.** There is no chat. The user sees your work when the page
  reloads, which happens on its own the moment you save the file.

## Better edit labels (optional)

Name the sections you author and the user's edit list uses your names instead of
guessing from the DOM:

```html
<p data-block="Problem body">…</p>
<div data-container="Metrics callout">…</div>
```

`data-block` names a region for the edit list. `data-container` also makes the block
clickable as a comment target.
