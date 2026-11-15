#!/bin/bash
# Usage: extract_frames.sh <video.mp4> <images_dir> <prefix> <t1> <t2> ...
# Saves full-size frames as <images_dir>/<prefix>-<tttt>.png (t in seconds, 4 digits).
set -e
V="$1"; OUT="$2"; P="$3"; shift 3
mkdir -p "$OUT"
for t in "$@"; do
  ffmpeg -loglevel error -y -ss "$t" -i "$V" -frames:v 1 "$OUT/$P-$(printf %04d "$t").png"
done
ls "$OUT"/"$P"-*.png | wc -l | xargs echo "frames with prefix $P:"
du -ch "$OUT"/"$P"-*.png | tail -1
