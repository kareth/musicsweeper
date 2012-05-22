#!/bin/bash

# TODO do not allow to use semicolons

DIR=`pwd`
id="$1"
tag="$2"
LIBDIR="$DIR/data/library"

piece=`grep "ID: $id;" < "$LIBDIR"`

if [ ! -n "$piece" ]; then
  echo "No music with that id."
  echo "Run ms --help or try finding song by ms find <song_name>"
else
  old_tags=`sed 's/.*; Tags: \([^;]*\);.*/\1/' <<< "$piece"`
  tag_exists=`sed "s/.* \($tag\).*//" <<< "$piece"`
  if [ -n "$tag_exists" ]; then
    # Not yet tagged
    sed -i '' -e "s/ID: $id; \(.*\); Tags: \([^;]*\);/ID: $id; \1; Tags: $old_tags $tag ;/g" "$LIBDIR"
    song_presenter=`sed 's/ID: \([0-9]*\); Path: \([^;]*\); Title: \([^;]*\); Artist: \([^;]*\);.*/\4 - \3  ( \2 )/' <<< "$piece"`
    echo -e "\033[38;5;148mSuccess!\033[39m"
    echo "Song: $song_presenter"
    echo -e "Tags:\033[38;5;136m$old_tags\033[39m \033[38;5;148m$tag\033[39m"
  else
    # Already tagged
    echo "This tag is already applied to this song. All tags for this song: $tags"
  fi
fi
