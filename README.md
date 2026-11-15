# YouTube to Obsidian Notes

**A Claude Code skill that turns YouTube videos and playlists into Obsidian study notes you can learn from and revise.**

Give it a video, a playlist or a transcript. It writes the notes into your Obsidian vault: one folder per video, split into topic notes, with screenshots of the video's diagrams and a link back to the exact moment in the video.

Most video-to-notes tools write a summary. A summary helps you decide whether to watch, but it does not help you learn. These notes keep the speaker's full explanation, and after each paragraph they add one line that says the same idea in simple words. Each note ends with its key learnings and a few questions to test yourself.

## How a note looks

```markdown
The model loads each layer's weights from memory once, and uses that single transfer for
every token in the prompt. For a 2,000-token prompt, each byte does about 2,000 operations.

==🔵 Meaning: The chip loads the weights one time and uses them for all prompt tokens.
Many tokens share the data cost.==
```

A full example is in [`examples/sample-sub-note.md`](examples/sample-sub-note.md). Open it in Obsidian to see the callouts.

## What it writes

| Note | One per | What is in it |
| --- | --- | --- |
| Sub-note | topic in a video | Main learning, the original text with a Meaning line after each paragraph, screenshots with timestamps, key learnings, self-test questions |
| Chapter overview | video | The whole video in one paragraph, a table of its sub-notes, a diagram of the argument, the top ten learnings, numbers to remember, transcript fixes |
| Playlist index | playlist | Chapters and their status, a running list of learnings, formulas, searches that collect every key learning or question |
| Revision summary | playlist | One page for the whole playlist: a card per chapter, the top twenty learnings, cheat sheets, one question per chapter |

```
<vault>/
  images/                                   screenshots, one file per diagram
  AI-inference/
    06 Engineering Behind LLM Inference/    one folder per playlist
      … - Playlist Index.md
      … - Revision Summary.md
      01 The Memory Wall/                   one folder per video
        01 The Memory Wall.md               chapter overview
        1.1 What LLM Inference Is.md        sub-notes
        1.2 The 30 ms Puzzle.md
```

## Features

- **Keeps the original explanation.** The transcript is cleaned up, but the speaker's reasoning, examples and numbers stay. A 30-minute video becomes several sub-notes, not one short summary.
- **Says it again in simple words.** After each paragraph, a Meaning line repeats the idea in short sentences that follow [Simplified Technical English](https://www.asd-ste100.org): active voice, one idea per sentence, at most 25 words.
- **Puts the learnings first.** Each sub-note starts with its main learning and ends with a key-learnings box and self-test questions that stay hidden until you open them.
- **Adds the diagrams.** It takes a frame every 10 seconds, keeps only the frames that show a complete diagram, chart or table, and places each one next to the text it explains, with a timestamp link.
- **Fixes the captions.** Auto-captions get names, products and numbers wrong. The skill corrects them and lists every fix in the chapter overview.
- **Links everything.** Notes link to the previous and next note, to earlier chapters and to notes already in your vault. Every link is checked before the work is done.
- **Leaves your vault safe.** It never commits or pushes, never deletes a note (a replaced note is marked outdated), deletes the downloaded video when it is done, and asks before it installs anything.

## Install

You need [Claude Code](https://claude.com/claude-code), [yt-dlp](https://github.com/yt-dlp/yt-dlp) and [ffmpeg](https://ffmpeg.org).

```bash
git clone https://github.com/madhav-wakhare/youtube-to-obsidian-notes ~/.claude/skills/youtube-to-obsidian-notes
brew install yt-dlp ffmpeg
```

On Linux, install ffmpeg with your package manager and yt-dlp with `pipx install yt-dlp`.

To update:

```bash
git -C ~/.claude/skills/youtube-to-obsidian-notes pull
```

## Use

Ask Claude Code in plain words. The skill starts on its own.

| You say | What happens |
| --- | --- |
| "Add this playlist to my Obsidian vault under AI: `<url>`" | Creates the playlist folder and index, then writes the first video |
| "Do the same for the next video" | Writes the next video and updates the indexes |
| "Do the same for videos 7, 8 and 9" | Downloads all three, then writes them one by one |
| "Here is the transcript: …" | Uses your transcript instead of downloading captions |
| "Add screenshots from the video to these notes" | Adds diagrams to notes that already exist |
| "Make a revision summary for the whole playlist" | Writes the one-page revision note |

You can also run `/youtube-to-obsidian-notes <url>`.

## Configuration

| Setting | Default | Meaning |
| --- | --- | --- |
| Vault path | asked on first use | Tell Claude the path, or set `OBSIDIAN_VAULT=/path/to/vault` |
| Attachment folder | from `.obsidian/app.json`, else `images/` | Where screenshots go |
| Screenshot names | `<playlist>-ch<N>-<seconds>.png` | For example `llm-inf-ch3-0130.png` |
| Meaning-line check | on if available | Uses a `simplified-technical-english` skill if one is installed |

To change the note layout, edit [`references/templates.md`](references/templates.md). To change the rules for naming, tags and images, edit [`references/conventions.md`](references/conventions.md). Claude follows both files.

## How it works

1. **List the videos** in the playlist with yt-dlp.
2. **Get the transcript.** It uses your pasted text, or YouTube's captions through yt-dlp. When YouTube refuses caption downloads (`HTTP Error 429`), it reads the transcript panel on the video page in Claude Code's browser.
3. **Make contact sheets.** One frame every 10 seconds, in grids of 4 by 5, so each tile maps to an exact second.
4. **Pick the diagrams** from the sheets and save them at full size.
5. **Plan the sub-notes** from the video's own chapter list.
6. **Write the notes**, with placeholders where screenshots go.
7. **Insert the screenshots.** A script turns each placeholder into the image and its timestamp link, and reports frames that are unused or missing.
8. **Update the indexes.**
9. **Check the work.** Every link resolves, every Meaning line passes the language check, every screenshot is used.
10. **Clean up.** Delete the downloaded video.

## Files

| Path | Purpose |
| --- | --- |
| `SKILL.md` | The workflow Claude follows |
| `references/templates.md` | Layouts for each note type |
| `references/conventions.md` | Vault rules, naming, frontmatter, transcript fixes, lessons learned |
| `scripts/make_sheets.sh` | Download a video and build contact sheets |
| `scripts/extract_frames.sh` | Save chosen frames into the vault |
| `scripts/preview.sh` | Tile candidate frames for a second look |
| `scripts/vtt_to_text.py` | Turn auto-captions into timestamped text |
| `scripts/expand_images.py` | Insert screenshots, report unused or missing frames |
| `scripts/check_links.py` | Find links that do not resolve |
| `scripts/check_meaning_ste.sh` | Check Meaning lines against Simplified Technical English |
| `examples/sample-sub-note.md` | One finished sub-note |

The scripts need bash, Python 3 and ffmpeg. They take absolute paths and change nothing outside the folders you pass to them.

## Why I built it

I am learning inference engineering from long technical playlists. Summaries did not stay with me, and writing full notes by hand took longer than the videos. I built this skill to keep the depth of the original, make each idea easy to read, and give me something I can revise in minutes. It was built and tested on a nine-part course of about four hours, and the same structure works for any lecture, talk or course.

## License

[MIT](LICENSE)
