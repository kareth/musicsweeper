#!/bin/bash


# TODO i can change the score to any string;

dir=$1;
id=$2
score=$3
LIBDIR="$dir/data/library"

piece=`grep "ID: $id;" < "$LIBDIR"`

if [ ! -n "$piece" ]; then
  echo "No music with that id"
  echo "Run ms --help or try finding song by ms find <song_name>"
else
  old_score=`sed 's/.*; Score: \([0-9]*\);.*/\1/' <<< "$piece"`

  sed -i '' -e "s/ID: $id; \(.*\); Score: \([0-9]*\); \(.*\)/ID: $id; \1; Score: $score; \3/g" "$LIBDIR"

  print=`sed 's/ID: \([0-9]*\); Path: \([^;]*\); Title: \([^;]*\); Artist: \([^;]*\);.*/\1: \4 - \3  ( \2 )/' <<< "$piece"`
  echo "Changed score from $old_score to $score in song:"
  echo "$print"
fi

