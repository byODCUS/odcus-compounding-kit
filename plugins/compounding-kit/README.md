# compounding-kit

Plugin part of the ODCUS compounding kit (MIT). Install: `/plugin install compounding-kit --marketplace byODCUS/odcus-compounding-kit` (see the repository README), then say "set up the compounding kit" in a Claude Code session.

- `hooks/hooks.json` wires two hooks: the learning-loop reminder at session start and the learning-loop check after each Skill call.
- `scripts/` are plain bash + python3, no dependencies beyond `jq` and `claude`. All state goes to `$COMPOUNDING_HOME` (default `~/.compounding`).
- `templates/` are copied by `scripts/setup.sh` only where no file exists.
