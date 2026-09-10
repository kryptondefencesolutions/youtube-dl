#!/bin/bash

if $youtubedl_extract_audio; then
  echo ''; echo "$(date '+%Y-%m-%d %H:%M:%S') - extracting audio"
  find '/downloads' -type f ! -iname '*.part' \( -iname '*.mp4' -o -iname '*.mkv' -o -iname '*.webm' -o -iname '*.mov' -o -iname '*.avi' -o -iname '*.m4v' \) -print0 |
  while IFS= read -r -d '' video_file; do
    relative_path="${video_file#/downloads/}"
    audio_file="/audio/${relative_path%.*}.mp3"
    if [ ! -f "$audio_file" ]; then
      mkdir -p "$(dirname "$audio_file")"
      ffmpeg -y -i "$video_file" -vn -acodec libmp3lame -q:a 2 "$audio_file" < /dev/null > /dev/null 2>&1
    fi
  done
fi

if $youtubedl_move_completed; then
  echo ''; echo "$(date '+%Y-%m-%d %H:%M:%S') - moving completed downloads"
  find '/downloads' -mindepth 1 -type f ! -iname '*.part' ! -iname '.youtubedl-*' -print0 |
  while IFS= read -r -d '' file; do
    relative_path="${file#/downloads/}"
    dest_file="/completed/${relative_path}"
    mkdir -p "$(dirname "$dest_file")"
    mv -f "$file" "$dest_file"
  done
  find '/downloads' -mindepth 1 -type d -empty -delete
fi
