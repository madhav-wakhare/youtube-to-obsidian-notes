#!/bin/bash
# Usage: check_meaning_ste.sh <folder-or-file> [...]
# Runs the Simplified Technical English checker on all "==🔵 Meaning: ...==" lines and prints only ERRORS.
# Find a flagged line with: grep -rn "Meaning.*<words>" <folder>
STE=~/.claude/skills/simplified-technical-english/scripts/ste_check.py
[ -f "$STE" ] || { echo "STE checker not found at $STE (skip, check by hand)"; exit 0; }
TMP=$(mktemp)
for t in "$@"; do
  if [ -d "$t" ]; then grep -h "🔵 Meaning" "$t"/*.md; else grep -h "🔵 Meaning" "$t"; fi
done | sed 's/==🔵 Meaning: //; s/==$//; s/\[\[[^]]*\]\]/the note/g' | awk '{print; print ""}' > "$TMP"
python3 "$STE" --mode descriptive --no-vocab "$TMP" | grep -E "ERROR|Result" | sed "s#$TMP:##"
rm "$TMP"
