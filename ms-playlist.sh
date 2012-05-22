#!/bin/bash

# TODO do not allow to use semicolons

dir=$1

LIBDIR="$1/data/library"
matches=`cat "$LIBDIR"`
filename="untitled_playlist.m3u"
fail="0"

if [ -d "$dir/playlists" ]; then
  echo "SKIP - playlists folder"
else
  echo "CREATE - playlists folder"
  mkdir "$dir/playlists"
fi


shift
while [ $# -ne 0 ]; do
  if [ "$1" == "-S" ]; then
    shift
    matches=`grep "Score: [$1-9];" <<< "$matches"`
  elif [ "$1" == "-s" ]; then
    shift
    matches=`grep "Score: [0-$1];" <<< "$matches"`
  elif [ "$1" == "-t" ]; then
    shift
    matches=`grep "Tags:.*$1.*;" <<< "$matches"`
  elif [ "$1" == "-m" ]; then
    shift
    filename="$1.m3u"
  else
    echo "Invalid option: $1"
    fail="1"
  fi
  shift
done

if [ "$fail" == "0" ]; then

  echo "$matches"
  file_list=`sed "s/.*Path: \([^;]*\);.*/..\/\1/" <<< "$matches"`
  BINDIR=`dirname "$dir"`
  echo "$BINDIR"
  echo "$file_list"
  echo -e "#EXTM3U\n$file_list" > "$BINDIR/$dir/playlists/$filename"
fi

