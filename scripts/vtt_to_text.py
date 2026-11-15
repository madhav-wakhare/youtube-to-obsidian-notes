"""Usage: python3 -I vtt_to_text.py <file.vtt> [bucket_seconds=30]
Prints the auto-caption text as one paragraph per time bucket: "[m:ss] text ..."."""
import re, sys
path = sys.argv[1]; step = int(sys.argv[2]) if len(sys.argv) > 2 else 30
t = None; bucket = -1; out = []
for line in open(path, encoding="utf-8").read().split("\n"):
    m = re.match(r"(\d+):(\d+):(\d+)\.\d+ -->", line)
    if m:
        t = int(m[1]) * 3600 + int(m[2]) * 60 + int(m[3]); continue
    if not line.strip() or "<" not in line or t is None:
        continue  # rolling auto-captions: only lines with <c> timing tags are new text
    txt = re.sub(r"<[^>]+>", "", line).strip()
    if t // step != bucket:
        bucket = t // step; out.append(f"\n[{t//60}:{t%60:02d}] ")
    out.append(txt + " ")
print("".join(out))
