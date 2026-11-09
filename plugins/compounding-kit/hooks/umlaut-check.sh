#!/usr/bin/env bash
# PostToolUse hook (Write|Edit): German text written with ae/oe/ue instead of real umlauts.
# Harmless for non-German content: it only fires on a list of German words.
in=$(cat); f=$(echo "$in" | jq -r '.tool_input.file_path // ""')
case "$f" in *.md|*.html|*.txt) ;; *) exit 0;; esac
hits=$(echo "$in" | jq -r '(.tool_input.content // .tool_input.new_string // "")' | grep -oiwE 'fuer|ueber|koennen|muessen|waere|wuerde|moeglich|naechste[nrs]?|spaeter|aenderung(en)?|loesung(en)?|geschaeft|haeufig|pruefen|zurueck|frueher|gegenueber|natuerlich|taeglich|waehrend' | sort -u | head -8 | tr '\n' ' ')
[ -z "$hits" ] && exit 0
jq -n --arg c "Umlaut check: $f has ae/oe/ue spellings ($hits). German text uses real umlauts. Fix unless code, URL or slug." '{hookSpecificOutput:{hookEventName:"PostToolUse",additionalContext:$c}}'
