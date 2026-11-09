# Security

This plugin runs shell hooks on every Claude Code prompt and ships scripts that call headless `claude -p` on a schedule. Treat it like any other code you install: read `hooks/` and `scripts/` before enabling them.

Design rules the kit follows:

- Hooks never log prompt text or tool input. The router log keeps only the detected class, session id and timestamp.
- Headless jobs get a narrow tool list, with writes scoped to the folders they own (`Edit(//path/**)`); shell is opt-in per job and limited to named subcommands.
- Everything a job reads that another job or a transcript wrote is treated as untrusted content and labelled so in the prompt.
- No secrets in the repo, in hooks or in synced folders. The subscription token lives in `~/.config/compounding/claude-auth.env` with `chmod 600`.
- `human-review` binds to 127.0.0.1 on a random port and checks the Host header. The CLI holds an admin token; the reviewed page only gets a page token that can send feedback, nothing else. Relative assets are served only from the reviewed file's folder, by extension allow-list, never dotfiles. Markdown links and images allow http(s), mailto and relative URLs only. Still: review files from a project folder, not from your home directory, and treat a reviewed document as untrusted content.

Found a problem? Use GitHub's private vulnerability reporting on this repository (Security tab, "Report a vulnerability"). Do not open a public issue for it.
