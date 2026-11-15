# Note templates

Replace `<…>`. Keep the section order. Every `{{img N}}` becomes a screenshot block.

---

## 1. Sub-note — `N.M <Topic>.md`

````markdown
---
tags: [<subject>, playlist/<slug>, ch<N>-<slug>, <topic>]
aliases: [<natural search names>]
type: video-notes
status: current
date: <YYYY-MM-DD>
chapter: <N>
part: <M>
source: "https://www.youtube.com/watch?v=<id>&t=<s>s"
---

# N.M <Topic>

> [!summary] Main learning
> <3–6 sentences: the whole sub-note's argument with the key numbers in bold. Someone who reads only this should know the point.>

[▶ Watch m:ss](https://www.youtube.com/watch?v=<id>&t=<s>s) · Chapter: [[NN <Video Title>]] · Previous: [[N.(M-1) …]] · Next: [[N.(M+1) …]]

---

## <Section heading — one idea>

{{img 130}}

<Original explanation from the video, cleaned up. Key terms and numbers in **bold**.>

==🔵 Meaning: <same idea in short, simple STE sentences>==

<optional table / ```text formula / → [[link to earlier chapter or vault note]]>

## <Next section>

{{img 150}}

<…>

==🔵 Meaning: <…>==

---

> [!important] Key learnings
> - <4–7 bullets, terse, numbers kept>
> - ⭐ <the most important 1–3 marked with a star>
> - See also [[<existing vault note>]].

## Self-test

> [!question]- <question 1>
> <answer>

> [!question]- <question 2>
> <answer>
````

Guidelines: 3–7 sections; 3–6 self-test questions; one Meaning line per paragraph or per tight group.

---

## 2. Chapter overview — `NN <Video Title>.md`

````markdown
---
tags: [<subject>, playlist/<slug>, ch<N>-<slug>, moc]
aliases: [Ch<N> <Title>, <Title> Chapter, <Title> video]
type: index
status: current
date: <YYYY-MM-DD>
chapter: <N>
source: "https://www.youtube.com/watch?v=<id>&list=<playlist id>&index=<N>"
---

# NN <Video Title>

> [!summary] The chapter in one breath
> <one dense paragraph covering every sub-note in order, key numbers bold>

**Video:** [<full YouTube title>](<url>) (<minutes> min) · Playlist: [[<Playlist> - Playlist Index]] · Previous chapter: [[<NN-1 …>]]

## How to read these notes

Each sub-note keeps the **original explanation from the video** (cleaned up), and after each paragraph there is a highlighted line:

==🔵 Meaning: the same idea in simple words.==

At the end of each sub-note: a **Key learnings** box and **Self-test** questions (click to open).

## Sub-notes (in video order)

| # | Note | Time | Main learning |
|---|---|---|---|
| N.1 | [[N.1 …]] | 0:00 | <one line, key phrase bold> |

(For long videos, split the table into Part A / Part B headings.)

## The story in one picture

```text
<vertical flow diagram of the chapter's argument>
```

## Top 10 learnings of the chapter

> [!important] Remember these
> 1. ⭐ <…>
> …

## Numbers to remember

| Number | Value |
|---|---|

## Transcript fixes

The auto-transcript had some errors. These notes use the correct terms:
- "<wrong>" → **<right>**

## Related (existing vault notes)

- [[<links>]]
````

---

## 3. Playlist index — `<Playlist> - Playlist Index.md`

Sections: summary callout · `[!tip] Quick revision` (link to revision summary, once it exists) · `## How to revise` (open chapter note → sub-notes → Meaning lines → Key learnings → Self-test) · `## Chapters` table (`# | Note (n sub-notes) | One-line recall | Status`) · `## Running list of learnings` (numbered, each ends with `(Ch N)`) · `## Formulas to remember` table (`Formula | Example`) · `## Search tips` (`tag:#playlist/<slug>`, `"[!important]"`, `"🔵 Meaning"`, `"[!question]"`, one `tag:#chN-…` per chapter) · `## Related`.

Subject index: add a `## <n>. Playlist — "<name>"` section with a table `Note | One-line recall` — one row for the playlist index, the revision summary, and each chapter.

---

## 4. Revision summary — `<Playlist> - Revision Summary.md`

````markdown
---
tags: [<subject>, playlist/<slug>, revision, summary]
aliases: [<Playlist> Revision, <Playlist> Cheat Sheet]
type: summary
status: current
date: <YYYY-MM-DD>
source: "<playlist url>"
---

# <Playlist> — Revision Summary

> [!summary] The whole playlist in one breath
> <one paragraph: the core problem, then what each chapter adds, ending with the goal>

**How to use this note:** … Playlist: [[… Playlist Index]]

## The one idea
> [!important] <core principle>
==🔵 Meaning: …==
| Lever | Techniques | Chapter |

## The story in one picture
```text
1  <CHAPTER>   <one-line gist>
          │
2  …
```

## Chapter cards
### 1 · <Title> → [[01 …]]
> [!summary] Main learning
> <3–5 sentences>
- <2–3 key points>
==🔵 Meaning: …==
(repeat per chapter)

## Top 20 learnings to remember
> [!important] Revise these
> 1. ⭐ …

## Formulas cheat sheet
| Formula | Example |

## Numbers cheat sheet
| Thing | Number |

## Quick self-test (one per chapter)
> [!question]- 1 · …
> …

## Where to go deeper
- Full chapter notes: [[01 …]] · [[02 …]] …
- Search queries for key learnings and self-tests
````
