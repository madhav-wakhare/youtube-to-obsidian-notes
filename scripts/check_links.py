"""Usage: python3 -I check_links.py <vault> <file-or-folder> [<file-or-folder> ...]
Reports [[wikilinks]] / ![[embeds]] that do not match a note filename or attachment in the vault."""
import os, re, sys
vault = sys.argv[1]; targets = sys.argv[2:]
names = set()
for r, _, fs in os.walk(vault):
    if "/." in r: continue
    for f in fs: names.add(f[:-3] if f.endswith(".md") else f)
files = []
for t in targets:
    if os.path.isdir(t): files += [os.path.join(t, f) for f in os.listdir(t) if f.endswith(".md")]
    else: files.append(t)
bad = [(os.path.basename(p), l) for p in files
       for l in re.findall(r"!?\[\[([^\]|#]+)", open(p, encoding="utf-8").read()) if l not in names]
print(f"checked {len(files)} files | bad links: {bad if bad else 'none'}")
