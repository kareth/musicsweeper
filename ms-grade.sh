#!/bin/bash

# TODO add possibility bu grading by: "ms grade Jackson 5"

DIR=`pwd`
id="$1"
score="$2"
LIBDIR="$DIR/data/library"

piece=`grep "ID: $id;" < "$LIBDIR"`
valid_score=`grep "[0-9]" <<< "$score"`
valid_score=`sed "s/.*\([0-9]\).*/\1/" <<< "$valid_score"`

if [ ! -n "$piece" ]; then
  echo -e "\033[38;5;197mError - file with this ID doesn\'t exist\033[39m"
  echo "Run ms --help or try finding song by ms find <song_name>"
else

  if [[ ! $valid_score == $score ]]; then
    echo -e "\033[38;5;197mError - invalid score\033[39m"
    echo "Score must be a number between 0 and 9"
  else
    old_score=`sed 's/.*; Score: \([0-9]*\);.*/\1/' <<< "$piece"`

    sed -i '' -e "s/ID: $id; \(.*\); Score: \([0-9]*\); \(.*\)/ID: $id; \1; Score: $score; \3/g" "$LIBDIR"

    print=`sed 's/ID: \([0-9]*\); Path: \([^;]*\); Title: \([^;]*\); Artist: \([^;]*\);.*/\4 - \3  ( \2 )/' <<< "$piece"`

    echo -e "\033[38;5;148mScore change success!\033[39m"
    #echo -e "\033[38;5;148mScore: $old_score -> $score\033[39m"
    echo -e "Score: $old_score -> $score"
    echo "Song: $print"
  fi
fi

