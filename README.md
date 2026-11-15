<div align="center">

# 🎬 → 🗒️ YouTube To Obsidian Notes

**Turn any YouTube video or playlist into deep, revision-ready Obsidian study notes — with the original explanation, plain-English meanings, diagrams, and self-tests.**

A [Claude Code](https://claude.com/claude-code) skill. One sentence in, a structured knowledge base out.

[![Claude Code Skill](https://img.shields.io/badge/Claude%20Code-Skill-D97757?logo=anthropic&logoColor=white)](https://docs.claude.com/en/docs/claude-code/skills)
[![Obsidian](https://img.shields.io/badge/Obsidian-Notes-7C3AED?logo=obsidian&logoColor=white)](https://obsidian.md)
[![YouTube](https://img.shields.io/badge/YouTube-Playlists-FF0000?logo=youtube&logoColor=white)](https://youtube.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Stars](https://img.shields.io/github/stars/madhav-wakhare/youtube-to-obsidian-notes?style=social)](https://github.com/madhav-wakhare/youtube-to-obsidian-notes/stargazers)

[Why](#-why) · [What you get](#-what-you-get) · [Install](#-install) · [Usage](#-usage) · [How it works](#%EF%B8%8F-how-it-works) · [Example](#-example) · [FAQ](#-faq)

</div>

---

## 💡 Why

Most "video to notes" tools give you a **summary**. Summaries are great for deciding whether to watch — and useless for actually **learning** the material.

This skill does the opposite. It keeps the speaker's full reasoning, then adds a layer that helps you **understand it and remember it**:

```markdown
The model loads each layer's weights once and uses them for every token in the prompt.
For a 2,000-token prompt, every byte pulled from memory does ~2,000 operations.

==🔵 Meaning: The chip loads the weights one time and uses them for all prompt tokens.
Many tokens share the data cost.==
```

Read the original. Read the meaning. Check yourself. Revise later in minutes.

---

## ✨ What you get

| | Feature | |
|---|---|---|
| 📂 | **One folder per video**, split into topic sub-notes (one per YouTube chapter) | not one giant wall of text |
| 📖 | **Original explanation kept** — cleaned transcript, author's examples and numbers | nothing important lost |
| 🔵 | **`Meaning` line after every paragraph** in Simplified Technical English | understand on first read |
| 🖼️ | **Screenshots of the video's diagrams**, each with a clickable `▶ m:ss` timestamp | jump back to the exact moment |
| 🎯 | **Main learning** callout on top, **Key learnings** ⭐ box at the end | the "so what" in 10 seconds |
| ❓ | **Self-test questions** as collapsible callouts | active recall built in |
| 🗺️ | **Chapter overview** — one-breath summary, story diagram, top 10, numbers table | see the whole video at a glance |
| 📚 | **Playlist index** — chapters, running list of learnings, formulas, search tips | a course map in your vault |
| ⚡ | **Revision summary** for the whole playlist — cards, cheat sheets, quick quiz | exam-style review in one page |
| 🔧 | **Transcript fixes** — auto-caption errors corrected and listed | names and numbers you can trust |
| 🔗 | **Wikilinks** to earlier chapters and your existing notes, all validated | a connected graph, not orphans |

---

## 🚀 Install

```bash
# 1. Install the skill
git clone https://github.com/madhav-wakhare/youtube-to-obsidian-notes ~/.claude/skills/youtube-to-obsidian-notes

# 2. Install the tools it uses for video, captions and screenshots
brew install yt-dlp ffmpeg        # macOS
# sudo apt install ffmpeg && pipx install yt-dlp   # Linux
```

Optional:
- Set your vault once: `export OBSIDIAN_VAULT="$HOME/path/to/vault"` (or just tell Claude the path).
- Install a [Simplified Technical English](https://www.asd-ste100.org) skill named `simplified-technical-english` to auto-check the 🔵 Meaning lines.

To update later: `git -C ~/.claude/skills/youtube-to-obsidian-notes pull`

---

## 🧑‍💻 Usage

Open Claude Code and just ask. The skill triggers on its own:

```text
Add this playlist to my Obsidian vault under "AI": https://youtube.com/playlist?list=...
```
```text
Do the same for the next video
```
```text
Do the same for videos 7, 8 and 9
```
```text
Add screenshots from the video to these notes
```
```text
Make a revision summary note for the whole playlist
```

Or call it directly: `/youtube-to-obsidian-notes <url>`

You can also **paste a transcript** instead of a URL.

---

## ⚙️ How it works

```text
 YouTube URL / transcript
          │
          ▼
 1. List videos ─────────── yt-dlp --flat-playlist
 2. Get transcript ──────── pasted · yt-dlp captions · YouTube transcript panel (fallback)
 3. Contact sheets ──────── frame every 10 s → 4×5 grids (exact timestamps)
 4. Pick diagrams ───────── Claude reads the sheets, keeps complete diagrams only
 5. Plan sub-notes ──────── one per YouTube chapter
 6. Write notes ─────────── original text + 🔵 Meaning + learnings + self-test
 7. Embed screenshots ───── {{img 130}} → image + ▶ 2:10 timestamp link
 8. Update indexes ──────── chapter overview · playlist index · subject index
 9. Verify ──────────────── link check · STE check · every frame used
10. Clean up ────────────── delete the downloaded video
```

### Output structure

```text
<Vault>/
├── images/
│   ├── llm-inf-ch1-0130.png
│   └── …
└── AI-inference/
    └── 06 Engineering Behind LLM Inference/
        ├── LLM Inference from First Principles - Playlist Index.md
        ├── LLM Inference - Revision Summary.md
        ├── 01 The Memory Wall/
        │   ├── 01 The Memory Wall.md                ← chapter overview
        │   ├── 1.1 What LLM Inference Is.md         ← sub-notes
        │   ├── 1.2 The 30 ms Puzzle.md
        │   └── …
        └── 02 Inside the GPU/
            └── …
```

---

## 📝 Example

A real sub-note produced by the skill (shortened). Full note: [`examples/sample-sub-note.md`](examples/sample-sub-note.md).

```markdown
# 1.5 Prefill vs Decode — Same Bytes, Different Work

> [!summary] Main learning
> Prefill and decode move the **same bytes** (the full model) on each forward pass.
> Prefill uses them for **~2,000 tokens** at once; decode for **1**. Decode is not slow
> because the model is big — it is slow because it has **no tokens to share the cost**.

[▶ Watch 10:29](https://youtube.com/watch?v=…&t=629s) · Previous: [[1.4 …]] · Next: [[1.6 …]]

## The common wrong guess

![[llm-inf-ch1-0805.png]]
*▶ [13:25](https://youtube.com/watch?v=…&t=805s)*

A natural first guess is that decode is slow because the model is large, and that guess
is correct in a way that misses the deeper point. The model is **exactly the same size**
in both phases…

==🔵 Meaning: The same data moved across the bus does more or less work, depending on the phase.==

> [!important] Key learnings
> - ⭐ Decode is slow **not because the model is big**, but because **one token pays the full cost**.

> [!question]- Why is "decode is slow because the model is big" only half true?
> The model is the same size in prefill, and prefill is fast per token…
```

---

## 🗂️ What's inside

| File | Purpose |
|---|---|
| [`SKILL.md`](SKILL.md) | The workflow Claude follows, step by step |
| [`references/templates.md`](references/templates.md) | Layouts for sub-note, chapter overview, playlist index, revision summary |
| [`references/conventions.md`](references/conventions.md) | Vault rules, naming, frontmatter, image format, transcript cleanup, lessons learned |
| [`scripts/make_sheets.sh`](scripts/make_sheets.sh) | Download a video and build contact sheets |
| [`scripts/extract_frames.sh`](scripts/extract_frames.sh) | Save chosen frames as `<prefix>-<seconds>.png` |
| [`scripts/preview.sh`](scripts/preview.sh) | Tile candidate frames to reject faded / mid-animation shots |
| [`scripts/vtt_to_text.py`](scripts/vtt_to_text.py) | Turn YouTube auto-captions into timestamped text |
| [`scripts/expand_images.py`](scripts/expand_images.py) | Replace `{{img N}}` with embed + timestamp; report unused/missing frames |
| [`scripts/check_links.py`](scripts/check_links.py) | Find wikilinks that don't resolve |
| [`scripts/check_meaning_ste.sh`](scripts/check_meaning_ste.sh) | Check 🔵 Meaning lines against Simplified Technical English |

---

## 🛡️ Safe by design

- ✅ **Never commits or pushes your vault** — plays nicely with obsidian-git auto-backup
- ✅ **Never deletes notes** — replaced notes are marked `status: outdated`
- ✅ **Links use filenames**, never aliases, and every link is validated
- ✅ **Deletes downloaded videos** when done; screenshots are small PNGs
- ✅ **Asks before installing** anything

---

## ❓ FAQ

<details>
<summary><b>Does it work without a playlist?</b></summary>

Yes — a single video URL or a pasted transcript works. A playlist just adds the index and revision summary.
</details>

<details>
<summary><b>YouTube blocks caption downloads (HTTP 429). What happens?</b></summary>

The skill falls back to reading the transcript from YouTube's own transcript panel in Claude Code's built-in browser. If that's not available, it asks you to paste the transcript.
</details>

<details>
<summary><b>Does it work with non-technical videos?</b></summary>

Yes. It was built on a 9-part technical course, but the structure — original text, meaning line, learnings, self-test — works for any lecture, talk, or course.
</details>

<details>
<summary><b>How much disk space do screenshots take?</b></summary>

Roughly 10–35 MB per 30-minute video (2–3 diagrams per minute at 720p).
</details>

<details>
<summary><b>Can I change the note style?</b></summary>

Yes. Edit [`references/templates.md`](references/templates.md) and [`references/conventions.md`](references/conventions.md) — Claude follows them exactly.
</details>

---

## 🤝 Contributing

Issues and pull requests are welcome — new templates, better frame selection, Windows support, other note apps (Logseq, Notion).

If this skill helped you learn something, **please ⭐ the repo** so others can find it.

## 📄 License

[MIT](LICENSE) © madhav-wakhare
