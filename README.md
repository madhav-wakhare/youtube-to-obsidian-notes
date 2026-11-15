# youtube-to-obsidian-notes

A [Claude Code](https://claude.com/claude-code) skill that turns a **YouTube video or playlist** (or a pasted transcript) into **structured Obsidian study notes** — made for understanding and revising, not for skimming.

For each video it creates a folder with:

- **Sub-notes per topic** that keep the original explanation (cleaned-up transcript), with a highlighted line after each paragraph:
  `==🔵 Meaning: the same idea in short, simple sentences==` (Simplified Technical English)
- A **Main learning** callout at the top, a **Key learnings** box and collapsible **Self-test** questions at the end
- **Screenshots of the video's diagrams**, each with a clickable `▶ m:ss` timestamp link
- A **chapter overview** note: one-breath summary, sub-note table, story diagram, top learnings, numbers, transcript fixes

…and for a playlist: a **playlist index** (chapters, running learnings, formulas, search tips) and a whole-playlist **revision summary** (cheat sheets + one self-test question per chapter).

## Example note

```markdown
## Attention never amortizes

![[llm-inf-ch7-0290.png]]
*▶ [4:50](https://www.youtube.com/watch?v=...&t=290s)*

Suppose the batch does stay full. There is still **a ceiling**, from the one thing in the
forward pass **no two requests share**. The weights are identical for every request.
**A KV cache is the opposite**: every request carries **its own** keys and values…

==🔵 Meaning: All users share the weights, but each user has a private KV cache.
Attention must read each cache separately, so batching does not help attention.==
```

## Install

```bash
git clone https://github.com/<you>/youtube-to-obsidian-notes ~/.claude/skills/youtube-to-obsidian-notes
```

Then, in Claude Code, ask for example:

- "Add this playlist to my Obsidian vault: <playlist URL>"
- "Do the same for the next video"
- "Add screenshots from the video to these notes"
- "Make a revision summary note for the whole playlist"

or call it directly with `/youtube-to-obsidian-notes`.

### Requirements

- `yt-dlp` and `ffmpeg` (`brew install yt-dlp ffmpeg`) — for the video, captions and screenshots
- An Obsidian vault. Tell Claude the path, or set `OBSIDIAN_VAULT=/path/to/vault`
- Optional: the `simplified-technical-english` skill — used to check the 🔵 Meaning lines (`scripts/check_meaning_ste.sh` skips the check if it is missing)
- Optional: Claude Code's built-in browser — the fallback for transcripts when YouTube rate-limits caption downloads (`HTTP Error 429`)

## What's inside

```
SKILL.md                     the workflow Claude follows
references/conventions.md    vault rules, naming, frontmatter, image format, transcript cleanup, lessons learned
references/templates.md      layouts for sub-note, chapter overview, playlist index, revision summary
scripts/make_sheets.sh       download a video and build contact sheets (tile time = 200·sheet + 40·row + 10·col s)
scripts/extract_frames.sh    save chosen frames as <prefix>-<seconds>.png into the vault's images folder
scripts/preview.sh           tile candidate frames to check for faded / mid-animation shots
scripts/vtt_to_text.py       turn YouTube auto-captions into timestamped text
scripts/expand_images.py     replace {{img N}} placeholders with embed + timestamp link; report unused/missing frames
scripts/check_links.py       find wikilinks that don't resolve to a note or attachment
scripts/check_meaning_ste.sh check the 🔵 Meaning lines against Simplified Technical English
```

## Rules the skill follows

- Never commits or pushes your vault (works with obsidian-git auto-backup)
- Never deletes notes — marks replaced ones `status: outdated`
- Links point to note filenames, not aliases
- Deletes downloaded videos when done

## License

MIT
