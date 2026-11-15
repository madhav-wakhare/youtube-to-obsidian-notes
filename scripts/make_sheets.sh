#!/bin/bash
# Usage: make_sheets.sh <video_id> <scratch_dir> [step_seconds=10]
# Downloads the 720p video to <scratch_dir>/v.mp4 and builds contact sheets
# <scratch_dir>/sheetNN.png (4 cols x 5 rows, one tile every <step> seconds).
# Tile time = NN*20*step + row*4*step + col*step  (default: 200*NN + 40*row + 10*col).
set -e
ID="$1"; S="$2"; STEP="${3:-10}"
[ -z "$ID" ] || [ -z "$S" ] && { echo "usage: $0 <video_id> <scratch_dir> [step]"; exit 1; }
mkdir -p "$S/th"
if [ ! -f "$S/v.mp4" ]; then
  yt-dlp -q -f "bv*[height<=720][ext=mp4]" -o "$S/v.mp4" "https://www.youtube.com/watch?v=$ID"
fi
DUR=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$S/v.mp4" | cut -d. -f1)
i=0
for t in $(seq 0 "$STEP" "$DUR"); do
  ffmpeg -loglevel error -y -ss "$t" -i "$S/v.mp4" -frames:v 1 -vf scale=384:-1 "$S/th/$(printf %04d $i).png"
  i=$((i+1))
done
n=0
while [ $((n*20)) -lt $i ]; do
  ffmpeg -loglevel error -y -start_number $((n*20)) -i "$S/th/%04d.png" -frames:v 1 -vf tile=4x5 "$S/sheet$(printf %02d $n).png"
  n=$((n+1))
done
echo "duration=${DUR}s thumbnails=$i sheets=$n step=${STEP}s"
echo "tile time = $((20*STEP))*sheet + $((4*STEP))*row + ${STEP}*col"
