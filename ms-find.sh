#!/bin/bash

DIR=`pwd`
LIBDIR="$DIR/data/library"
matches=`cat "$LIBDIR"`

while [ $# -ne 0 ]; do
    matches=`grep -i "$1" <<< "$matches"`
    shift
done

#TODO I18n character fails due to sed...
echo "Found entries:"
sed 's/ID: \([0-9]*\); Path: \([^;]*\); Title: \([^;]*\); Artist: \([^;]*\);.*/\1: \4 - \3  ( \2 )/' <<< "$matches"
