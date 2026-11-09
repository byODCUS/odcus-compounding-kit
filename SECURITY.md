# Security

This plugin runs shell hooks on every Claude Code prompt and ships scripts that call headless `claude -p` on a schedule. Treat it like any other code you install: read `hooks/` and `scripts/` before enabling them.

Design rules the kit follows:

- Hooks never log prompt text or tool input.
- Headless jobs get a narrow tool list, with writes scoped to the folders they own (`Edit(//path/**)`); shell is opt-in per job and limited to named subcommands.
- Everything a job reads that another job or a transcript wrote is treated as untrusted content and labelled so in the prompt.
- No secrets in the repo, in hooks or in synced folders. The subscription token lives in `~/.config/compounding/claude-auth.env` with `chmod 600`.

Found a problem? Use GitHub's private vulnerability reporting on this repository (Security tab, "Report a vulnerability"). Do not open a public issue for it.
