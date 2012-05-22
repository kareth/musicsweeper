#!/bin/bash

count=0;
DIR=`pwd`
BINDIR=`dirname $0`

repair_files(){
  for file in "$1"/*
  do
    if [ -d "$file" ]
    then
      repair_files "$file"
    elif [[ $file == *.mp3 ]]; then
      count=$(( $count + 1 ))
      hashcode=`"$BINDIR"/codegen.Darwin "$file" 10 30`
      response=`curl -s -F "api_key=DMEE6FFUDMWAMAVZH" -F "query=$hashcode" "http://developer.echonest.com/api/v4/song/identify"`
      any=`grep 'songs": \[{' <<< "$response"`
      if [ ! -n "$any" ]; then
        file_name=`basename "$file"`
        echo -e "\033[38;5;197mNot found\033[39m - $file_name"
      else
        # get artist and song title based on the json recieved
        title=`sed 's/.*songs": \[.*title": "\([^"]*\)", .*artist_name": "\([^"]*\).*/\1/' <<< "$response"`
        artist=`sed 's/.*songs": \[.*title": "\([^"]*\)", .*artist_name": "\([^"]*\).*/\2/' <<< "$response"`
        FILEDIR=`dirname "$file"`

        # setting ID3 tags
        id3v2 --TIT2 "$title" "$file"
        id3v2 --TPE1 "$artist" "$file"

        echo -e "\033[38;5;148mSuccess!\033[39m - $title - $artist"
        mv "$file" "$FILEDIR/$artist - $title.mp3"
      fi
    fi
  done
}

repair_files "$DIR"
