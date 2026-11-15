# Vault conventions and user preferences

These come from the author's own use of the skill (an LLM-inference playlist, 9 videos) and from the mistakes made on the way. Follow all of them. Paths and folder names below are **examples** — adapt them to the user's vault.

## Hard rules (never break)

- **Do not commit or push.** The vault uses the obsidian-git auto-backup ("Leave for auto-backup").
- **Do not delete notes.** If a note is replaced, set `status: outdated` (or add a "not in use" callout) and link to the new note.
- **Links point to note filenames**, not aliases: `[[1.8 The KV Cache]]`, never `[[KV Cache from first principles]]`. Check every link with `scripts/check_links.py`.
- **Attachments go in `images/`** at the vault root (`attachmentFolderPath: images`).
- **Note filenames are unique in the vault** — always prefix sub-notes with the chapter number (`3.4 …`).
- Ask before installing software (`brew install yt-dlp ffmpeg`) or downloading large files the first time; later videos in the same job do not need a new ask.
- Delete downloaded videos when done. Never `rm` with a relative path or glob after `cd` (the safety check blocks it) — use absolute paths.

## Vault layout (example)

```
<vault>/
├── images/                                   ← all screenshots
├── AI-inference/
│   ├── AI Inference Index.md                 ← subject index (MOC)
│   └── 06 Engineering Behind LLM Inference/  ← one numbered folder per playlist
│       ├── <Playlist> - Playlist Index.md
│       ├── <Playlist> - Revision Summary.md
│       ├── Move Less Data or Do More Work per Byte.md   (example of a cross-chapter idea note)
│       ├── 01 The Memory Wall/
│       │   ├── 01 The Memory Wall.md         ← chapter overview (type: index)
│       │   ├── 1.1 What LLM Inference Is.md  ← sub-notes (type: video-notes)
│       │   └── …
│       └── 02 Inside the GPU/ …
```
For a new subject or playlist, mirror this: `<Subject>/<NN Playlist Name>/<NN Video Title>/`.

## Frontmatter

Sub-note:
```yaml
---
tags: [ai, inference, playlist/<playlist-slug>, ch<N>-<chapter-slug>, <topic>, <topic>]
aliases: [<2–6 natural names people would search>]
type: video-notes
status: current
date: <YYYY-MM-DD today>
chapter: <N>
part: <M>
source: "https://www.youtube.com/watch?v=<id>&t=<start seconds>s"
---
```
Chapter overview: `type: index`, tags include `moc`, no `part`, `source` = watch URL with `&list=<playlist id>&index=<N>`.
Playlist index: `type: index`, `status: in-progress` until all chapters are done, then `current`.
Revision summary: `type: summary`, tags include `revision, summary`.

Tag examples used so far: `playlist/llm-inference-first-principles`, `ch1-memory-wall`, `ch2-inside-the-gpu`, `ch3-kernels-and-memory`, `ch4-quantization`, `ch5-parallelism`, `ch6-mixture-of-experts`, `ch7-serving`, `ch8-speculative-long-context`, `ch9-whole-stack`.

## Image embed format

Right under the heading it illustrates (before the paragraph):
```markdown
![[llm-inf-ch3-0130.png]]
*▶ [2:10](https://www.youtube.com/watch?v=<id>&t=130s)*
```
While writing, use the placeholder `{{img 130}}`; `scripts/expand_images.py` turns it into the block above.
Filename: `<prefix>-<seconds as 4 digits>.png`, e.g. `llm-inf-ch3-0130.png`. Two images in a row are fine for a two-step animation.

## Navigation line (under the summary callout of every sub-note)

```markdown
[▶ Watch 2:47](https://www.youtube.com/watch?v=<id>&t=167s) · Chapter: [[03 Kernels and Memory]] · Previous: [[3.1 …]] · Next: [[3.3 …]]
```

## Transcript cleanup

- Auto-captions are full of errors. Fix them in the notes and list them in the chapter overview under `## Transcript fixes` as `"wrong" → **right**`.
- Typical errors seen: "bite" → byte, "HPM" → HBM, "cash" → cache, "tab" → TB/s, "multipprocessors" → multiprocessors, misspelt names (Tri Dao, Dettmers, Frantar, Shazeer, Geva, Zhou, Holtzman), product names (vLLM, SGLang, DeepEP, CuTe-DSL, cuDNN, MT-Bench, Kimi, Qwen3, Mooncake, DistServe, Splitwise, RhymeRL, Manus), numbers that lost a decimal ("$19" → $1.09, "7" → $0.07). When a number looks wrong, check it against the video's own maths or description.
- Remove `[music]`, filler words and repeated starts. Keep the author's examples, numbers and "this is the key point" emphasis.
- The YouTube description often lists chapters and references — use the chapter list to split sub-notes and the references to get names right.

## Writing style

- Original text: clean, bold the key terms and numbers, keep the author's voice ("we", "here is the key observation").
- Meaning lines: Simplified Technical English. Approved replacements that worked: "is limited by X" → "X sets the speed"; "must be rounded" → "the GPU must round"; "has used" → "used"; "is running" → "runs"; "should/would/may" → "can/must/will" or rewrite; semicolon → two sentences; sentences > 25 words → split.
- Use `⭐` only on the 1–3 most important learnings in a box.
- Tables for comparisons, ```text blocks for formulas and pipelines.

## Tools behaviour learned

- zsh does not split unquoted variables: use a literal list in `for t in 10 20 30; do` (not `T="10 20"; for t in $T`).
- After a python/sed script changes a note, the `Edit` tool needs a fresh `Read`; prefer `sed -i ''` or a python `assert old in s; s.replace(...)` for small edits.
- `get_page_text` output over the limit is saved to a JSON file `[{type, text}]`; parse it with `python3 -I`.
- The fork/other sessions may add notes (e.g. `Move Less Data or Do More Work per Byte.md`); read the playlist index before editing it and link new notes where relevant.
