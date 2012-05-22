#!/bin/bash

count=0;
DIR=`pwd`
LIBDIR="$DIR/data/library"

initialize_library(){
  id_counter=`wc -l < "$LIBDIR"`
  id_counter=$(($id_counter))
  for file in $1/*.mp3; do
    if [ -d "$file" ]; then
      initialize_library "$file"
    else
      entries=`grep "$file" < "$LIBDIR"`

      if [ ! -n "$entries" ]; then
        echo "ADD - $file"
        tags=`id3v2 -R "$file"`
        title=`grep "TIT2" <<< "$tags" | sed 's/.*: \(.*\)/\1/'`
        artist=`grep "TPE1" <<< "$tags" | sed 's/.*: \(.*\)/\1/'`
        echo "ID: $id_counter; Path: $file; Title: $title; Artist: $artist; Score: 0; Tags: ;" >> "$LIBDIR"
        id_counter=$(($id_counter+1))
      else
        echo "SKIP - $file"
      fi
    fi
  done
}

create_data_folder(){
  if [ -d "$DIR/data" ]; then
    echo "SKIP - data folder"
  else
    echo "CREATE - data folder"
    mkdir "$DIR/data"
  fi
}

create_data_folder
initialize_library $DIR
