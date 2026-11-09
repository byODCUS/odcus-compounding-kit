# compounding-kit

Plugin part of the ODCUS compounding kit (MIT). Install: `/plugin install compounding-kit --marketplace aiffective-yhi/odcus-compounding-kit` (see the repository README), then say "set up the compounding kit" in a Claude Code session.

- `hooks/hooks.json` wires five hooks: learning-loop reminder (SessionStart), skill router and taste interview (UserPromptSubmit), learning-loop check after each Skill call and umlaut check after Write/Edit (PostToolUse).
- `scripts/` are plain bash + python3, no dependencies beyond `jq` and `claude`. All state goes to `$COMPOUNDING_HOME` (default `~/.compounding`).
- `templates/` are copied by `scripts/setup.sh` only where no file exists.
