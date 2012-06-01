#!/bin/bash

# TODO do not allow to use semicolons

basedir=`pwd`
if [ "$1" == "-d" ]; then
  shift
  newdir="$basedir/$1"
  DIR="$newdir"
  echo "$DIR"
  shift
fi

create_playlists_folder(){
  if [ ! -d "$DIR/playlists" ]; then
    mkdir "$DIR/playlists"
    echo -e "\033[38;5;148mPlaylists folder crated!\033[39m"
  fi
}
create_playlists_folder

LIBDIR="$DIR/data/library"
matches=`cat "$LIBDIR"`

time_now=$(date +"_%m_%d_%Y_%H_%M_%S")
filename="playlist$time_now.m3u"
fail="0"

while [ $# -ne 0 ]; do
  if [ "$1" == "-S" ]; then
    shift
    matches=`grep "Score: [$1-9];" <<< "$matches"`
  elif [ "$1" == "-s" ]; then
    shift
    matches=`grep "Score: [0-$1];" <<< "$matches"`
  elif [ "$1" == "-t" ]; then
    shift
    matches=`grep -i "Tags:.* $1 .*;" <<< "$matches"`
  elif [ "$1" == "-a" ]; then
    shift
    matches=`grep -i "$1" <<< "$matches"`
  elif [ "$1" == "-m" ]; then
    shift
    filename="$1.m3u"
  else
    echo -e "\033[38;5;197mError - invalid opiton: $1\033[39m"
    fail="1"
  fi
  shift
done

if [ "$fail" == "1" ]; then
  echo -e "\n\033[38;5;197mErrors prohibited to create playlist\033[39m"
  exit 1
fi

if [ ! -n "$matches" ]; then
  echo -e "\033[38;5;197mNo songs found matching given criteria\033[39m"
else
  file_list=`sed "s/.*Path: \([^;]*\);.*/\1/" <<< "$matches"`
  song_presenter=`sed 's/.*Title: \([^;]*\); Artist: \([^;]*\);.*/\2 - \1/' <<< "$matches"`
  songs_counter=`wc -l <<< "$matches"`
  songs_counter=$(($songs_counter))
  echo -e "\033[38;5;148mPlaylist created!\033[39m"
  echo "$songs_counter Songs:"
  echo "$song_presenter"

  echo -e "#EXTM3U\n$file_list" > "$DIR/playlists/$filename"

  echo -e "\033[38;5;148mPlaylist saved as: /playlists/$filename \033[39m"
fi
