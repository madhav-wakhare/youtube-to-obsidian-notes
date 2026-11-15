---
name: youtube-to-obsidian-notes
description: Turns a YouTube video or playlist (or a pasted transcript) into structured Obsidian study notes in the user's own style — one folder per video, sub-notes that keep the original explanation with a highlighted "🔵 Meaning" line in simple words after each paragraph, key-learnings boxes, self-test questions, and screenshots of the video's diagrams with clickable timestamps — plus chapter overviews, a playlist index, and a whole-playlist revision summary. Use when the user asks to add a YouTube video/playlist/lecture/course to Obsidian, make notes from a video or transcript, "do the same for the next video", add screenshots from a video to notes, or make a revision summary of a playlist.
---

# YouTube → Obsidian Notes

Make study notes from a YouTube video or playlist in the user's personal style, inside their Obsidian vault.
The user wants to **understand the original content and revise it later**, not read a short summary.

Before writing anything, read:
- `references/conventions.md` — vault rules, file naming, frontmatter, tags, what never to do.
- `references/templates.md` — exact layout of every note type (sub-note, chapter overview, playlist index, revision summary).

Helper scripts are in `scripts/` next to this file. In the commands below, `$SKILL` means this skill's folder (e.g. `~/.claude/skills/youtube-to-obsidian-notes`). Run them with `bash` / `python3 -I` and absolute paths.

---

## The style the user wants (most important)

The first version of this workflow was rejected for being **too condensed**. The user's own example style is:

```markdown
<original paragraph from the video, cleaned up, key terms in bold>

==🔵 Meaning: <the same idea in 1–3 short, simple sentences>==
```

Rules:
1. **Keep the original explanation.** Clean up the transcript (fix errors, remove filler, "[music]"), keep the author's reasoning, examples and numbers. Do not compress a 30-minute video into a page.
2. After **each** paragraph (or tight group of 2–3 paragraphs), add one `==🔵 Meaning: …==` line.
3. Write the Meaning lines in **Simplified Technical English** (~80% of the explaining text should be easy to read): short sentences (≤ 25 words), active voice, no "-ing" verbs except technical names, no should/would/may/might, no semicolons. Load the `simplified-technical-english` skill if it is available, and check with its script (see step 8).
4. **Highlight the learnings**: every sub-note starts with a `[!summary] Main learning` callout and ends with a `[!important] Key learnings` box (⭐ on the 1–3 most important) and a `## Self-test` with collapsible `[!question]-` callouts.
5. **Split a video into several sub-notes** (one per topic/YouTube chapter, ~2–5 minutes of video each) inside a folder for that video, plus one chapter overview note.
6. **Add screenshots of the video's diagrams** under the heading they illustrate, each with a clickable timestamp link.
7. Use tables, small ```text diagrams and formulas where the video uses them. Link to earlier chapters and existing vault notes with `→ [[Note Name]]`.

---

## Workflow for one video

Do the steps in order. Keep a task list. Tell the user briefly what you are doing when a step takes long.

### 0. Find the vault and the target folder
- **Vault path**: use, in order: the path the user gives → `$OBSIDIAN_VAULT` → a path saved in memory/CLAUDE.md from an earlier run → ask the user once (and offer to save it to memory). Attachments go in the vault's attachment folder (check `.obsidian/app.json` → `attachmentFolderPath`; default `images/`). If the session is not in the vault, use absolute paths.
- Look at the vault structure (`ls`) and any existing index notes for the subject (e.g. `AI-inference/AI Inference Index.md` in the example vault). Put a playlist in its own numbered subfolder under the right subject folder, one folder per video: `NN <Video Title>/`.
- Read existing related notes so you can link to them (link to **filenames**, never aliases).

### 1. Get the video list and IDs
```bash
yt-dlp --flat-playlist --print "%(playlist_index)s %(id)s %(duration)s %(title)s" "<playlist URL>"
```
(`brew install yt-dlp ffmpeg` if missing — ask first, it installs software.)

### 2. Get the transcript (in this priority)
1. **The user pasted it** → use that.
2. `yt-dlp --skip-download --write-auto-subs --sub-langs en --sub-format vtt -o "<scratch>/v" <url>` then convert with `scripts/vtt_to_text.py`.
3. **If yt-dlp returns `HTTP Error 429` (very common after the first video) → use the browser pane**, which works reliably:
   - `navigate` to the video URL, `wait` 5 s.
   - `find "more"` → click the description `button "more"` (the one near ref ~170–530, NOT "More actions").
   - `find "Show transcript"` → click the **first** `button "Show transcript"` (the second one is off-screen).
   - `wait` 3 s, then `get_page_text` with `max_chars: 150000`. The page text contains the description (with the **YouTube chapter list** — use it to split sub-notes) and the full transcript under `Chapter N: <title>` headings with timestamps.
   - Do **not** use `javascript_tool` to pull caption URLs (it gets blocked).
   - If the output is saved to a file instead of shown, parse it with `python3 -I`.
4. As a last fallback, ask the user to paste the transcript.

### 3. Download the video and make contact sheets (for screenshots)
```bash
bash $SKILL/scripts/make_sheets.sh <video_id> <scratch_dir>
```
This downloads 720p video to the scratch dir, grabs a thumbnail every 10 s, and builds `sheetNN.png` (4 columns × 5 rows = 200 s each).
**Time of a tile = 200·sheet + 40·row + 10·col seconds** (row/col from 0). Frames are taken with exact `-ss`, so these times are accurate.
For long videos, combine sheets side by side (`ffmpeg … hstack`) and read fewer, larger images.

### 4. Pick the frames
- Read every sheet. Pick frames that show **complete diagrams** (charts, labeled pipelines, key numbers, tables, formulas). Skip faded/mid-animation, title-only and blank frames.
- Aim for ~2–3 frames per minute of video, at least one per sub-note section. If unsure, extract candidates into scratch, tile them (`scripts/preview.sh`) and check before copying.
- Extract the final ones straight into the vault:
```bash
bash $SKILL/scripts/extract_frames.sh <scratch_dir>/v.mp4 <vault>/images <prefix> <t1> <t2> …
```
Prefix pattern: `<short-playlist-slug>-ch<N>` (e.g. `llm-inf-ch3`) → files `llm-inf-ch3-0130.png`.

### 5. Plan the sub-notes
- One sub-note per YouTube chapter (merge very short ones, split very long ones). Name: `N.M <Topic Title>.md` (no `:` `/` `?` in names; use ` - `).
- Assign each picked frame to the section it illustrates.

### 6. Write the notes
- Write each sub-note with the template. Put images as placeholders `{{img 130}}` (seconds) right under the heading they illustrate; the script expands them.
- Then write the chapter overview `NN <Video Title>.md` (one-breath summary, sub-note table, story diagram, Top-N learnings, numbers table, **Transcript fixes** list, Related).
- Expand placeholders and check every frame is used:
```bash
python3 -I $SKILL/scripts/expand_images.py "<chapter folder>" <vault> <prefix> <video_id>
```
It prints `unused` / `missing`. Fix both (embed unused frames or extract missing ones).

### 7. Update the indexes
- **Playlist index** (`<Playlist> - Playlist Index.md`): chapter row → `Done` with one-line recall; add numbered "Running list of learnings" (Ch N); add formulas; add `tag:#chN-<slug>` search tip.
- **Subject index** (e.g. `AI Inference Index.md`): one row per chapter in the playlist section.
- Use a small `python3 -I` script with `assert old in s` for these edits (files change on disk between turns; plain `Edit` may need a re-read).

### 8. Check and clean up
```bash
python3 -I $SKILL/scripts/check_links.py <vault> "<chapter folder>" "<index note>" …
bash $SKILL/scripts/check_meaning_ste.sh "<chapter folder>"
```
- Fix every bad link and every STE **ERROR** in Meaning lines (warnings for technical names like "Training", "Paging", "Flash-Decoding" are fine). Use `sed -i ''` for one-line fixes.
- Delete the downloaded video: `rm "<scratch_dir>/v.mp4"` (absolute path only — never `rm` with a relative glob after `cd`).
- **Do not commit.** The user's obsidian-git auto-backup saves the vault.

### 9. Report
Short closing message: folder, a table (sub-note → main learning), how the transcript was obtained, transcript fixes, screenshot count/size, index updates, "video deleted, nothing committed".

---

## Several videos in one request
Download all videos and build all sheets in one bash run first, then do steps 2–7 per chapter, then one combined index update and check. Keep the user informed between chapters.

## Revision summary for a whole playlist
When asked for a revision note, write `<Playlist> - Revision Summary.md` in the playlist folder using the template in `references/templates.md`: one-breath summary, the one core idea + lever table, story diagram, one card per chapter (main learning + 2–3 points + Meaning line + link), Top-20 learnings, formulas and numbers cheat sheets, one self-test question per chapter, links. No screenshots. Link it from the playlist index (a `[!tip] Quick revision` callout) and the subject index.

## Adding screenshots to notes that already exist
Do steps 3–4, then insert the embed block (format in `references/conventions.md`) right after the matching heading in each sub-note, and run `expand_images.py` / the unused check.
