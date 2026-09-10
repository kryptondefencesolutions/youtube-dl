#!/bin/bash

video_file="$1"
relative_path="${video_file#/downloads/}"

if $youtubedl_extract_audio; then
  audio_file="/audio/${relative_path%.*}.mp3"
  if [ ! -f "$audio_file" ]; then
    mkdir -p "$(dirname "$audio_file")"
    ffmpeg_output="$(ffmpeg -y -i "$video_file" -vn -acodec libmp3lame -q:a 2 "$audio_file" < /dev/null 2>&1)"
    if [ $? -ne 0 ]; then
      echo "[extract-audio] failed: $relative_path"
      echo "$ffmpeg_output" | tail -5
    else
      echo "[extract-audio] extracted: $relative_path"
    fi
  fi
fi

if $youtubedl_move_completed; then
  dest_file="/completed/${relative_path}"
  mkdir -p "$(dirname "$dest_file")"
  mv -f "$video_file" "$dest_file" && echo "[move-completed] moved: $relative_path"
  find '/downloads' -mindepth 1 -type d -empty -delete
fi
