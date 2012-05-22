#!/bin/bash

# TODO do not allow to use semicolons

dir="$1"
id="$2"
tag="$3"
LIBDIR="$dir/data/library"

piece=`grep "ID: $id;" < "$LIBDIR"`

if [ ! -n "$piece" ]; then
  echo "No music with that id."
  echo "Run ms --help or try finding song by ms find <song_name>"
else
  old_tags=`sed 's/.*; Tags: \([^;]*\);.*/\1/' <<< "$piece"`
  tag_exists=`sed "s/.* \($tag\).*//" <<< "$piece"`
  if [ -n "$tag_exists" ]; then
    # Not yet tagged
    sed -i '' -e "s/ID: $id; \(.*\); Tags: \([^;]*\);/ID: $id; \1; Tags: $old_tags $tag;/g" "$LIBDIR"
    song_presenter=`sed 's/ID: \([0-9]*\); Path: \([^;]*\); Title: \([^;]*\); Artist: \([^;]*\);.*/\1: \4 - \3  ( \2 )/' <<< "$piece"`
    echo "The tag $tag was succesfully attached to the song:"
    echo "$song_presenter"
    echo "All the tags for this song for now: $old_tags $tag"
  else
    # Already tagged
    echo "This tag is already applied to this song. All tags for this song: $tags"
  fi
fi
