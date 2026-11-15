"""Usage: python3 -I expand_images.py <chapter_folder> <vault> <prefix> <video_id>
Replaces {{img N}} placeholders in every .md file of <chapter_folder> with
  ![[<prefix>-NNNN.png]]
  *▶ [m:ss](https://www.youtube.com/watch?v=<id>&t=Ns)*
and reports frames in <vault>/images with that prefix that are unused, and placeholders with no file."""
import os, re, sys
folder, vault, prefix, vid = sys.argv[1:5]
def emb(m):
    t = int(m.group(1)); mm = f"{t//60}:{t%60:02d}"
    return f"![[{prefix}-{t:04d}.png]]\n*▶ [{mm}](https://www.youtube.com/watch?v={vid}&t={t}s)*"
used = set()
for f in sorted(os.listdir(folder)):
    if not f.endswith(".md"): continue
    p = os.path.join(folder, f); s = open(p, encoding="utf-8").read()
    used |= {int(x) for x in re.findall(r"\{\{img (\d+)\}\}", s)}
    used |= {int(x) for x in re.findall(re.escape(prefix) + r"-(\d{4})\.png", s)}
    new = re.sub(r"\{\{img (\d+)\}\}", emb, s)
    if new != s: open(p, "w", encoding="utf-8").write(new)
imgs = {int(f[len(prefix)+1:len(prefix)+5]) for f in os.listdir(os.path.join(vault, "images"))
        if f.startswith(prefix + "-") and f.endswith(".png")}
print("used:", len(used), "| unused frames:", sorted(imgs - used), "| missing files:", sorted(used - imgs))
