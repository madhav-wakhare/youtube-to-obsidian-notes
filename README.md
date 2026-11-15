# youtube-to-obsidian-notes

A [Claude Code](https://claude.com/claude-code) skill that turns YouTube videos and playlists into Obsidian study notes.

For each video you get:

- Sub-notes that keep the original explanation, with a simple-English line after each paragraph: `==🔵 Meaning: …==`
- Key learnings and self-test questions in every note
- Screenshots of the video's diagrams with `▶ m:ss` timestamp links
- A chapter overview, a playlist index, and a revision summary

## Install

```bash
git clone https://github.com/madhav-wakhare/youtube-to-obsidian-notes ~/.claude/skills/youtube-to-obsidian-notes
brew install yt-dlp ffmpeg
```

## Use

In Claude Code:

- "Add this playlist to my Obsidian vault: `<url>`"
- "Do the same for the next video"
- "Make a revision summary for the whole playlist"

Or run `/youtube-to-obsidian-notes`. Give the vault path once, or set `OBSIDIAN_VAULT`.

## License

MIT
