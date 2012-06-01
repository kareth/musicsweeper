#!/bin/bash

basedir=`pwd`
if [ "$1" == "-d" ]; then
  shift
  newdir="$basedir/$1"
  DIR="$newdir"
  echo "$DIR"
  shift
fi

LIBDIR="$DIR/data/library"

create_data_folder(){
  if [ ! -d "$DIR/data" ]; then
    mkdir "$DIR/data"
    echo -e "\033[38;5;148mData folder crated!\033[39m"
  fi
  if [ ! -e "$DIR/data/library" ]; then
    touch "$DIR/data/library"
    echo -e "\033[38;5;148mLibrary crated!\033[39m"
  fi
}

create_data_folder

id_counter=`wc -l < "$LIBDIR"`
id_counter=$(($id_counter))

initialize_library(){
  for file in "$1"/*; do
    if [ -d "$file" ]; then
      initialize_library "$file"
    elif [[ $file == *.mp3 ]]; then
      entries=`grep -F "$file" < "$LIBDIR"`
      if [ ! -n "$entries" ]; then
        echo -e "\033[38;5;148mSong added!\033[39m - $title - $artist"
        tags=`id3v2 -R "$file"`
        title=`grep "TIT2" <<< "$tags" | sed 's/.*: \(.*\)/\1/'`
        artist=`grep "TPE1" <<< "$tags" | sed 's/.*: \(.*\)/\1/'`
        echo "ID: $id_counter; Path: $file; Title: $title; Artist: $artist; Score: 0; Tags: ;" >> "$LIBDIR"
        id_counter=$(($id_counter+1))
      else
        filename=`basename "$file"`
        echo -e "\033[38;5;136mSong skipped\033[39m - $filename"
      fi
    fi
  done
}


initialize_library $DIR
