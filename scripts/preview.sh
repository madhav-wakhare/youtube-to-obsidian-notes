#!/bin/bash
# Usage: preview.sh <out.png> <cols> <img1> <img2> ...
# Tiles candidate frames (sorted as given) into one preview image to check for faded/mid-animation frames.
set -e
OUT="$1"; C="$2"; shift 2
N=$#; R=$(( (N + C - 1) / C ))
TMP=$(mktemp -d)
i=0; for f in "$@"; do ln -s "$f" "$TMP/$(printf %04d $i).png"; i=$((i+1)); done
ffmpeg -loglevel error -y -i "$TMP/%04d.png" -frames:v 1 -vf "scale=480:-1,tile=${C}x${R}" "$OUT"
rm -r "$TMP"
echo "$OUT ($N frames, ${C}x${R}, row-major in the given order)"
