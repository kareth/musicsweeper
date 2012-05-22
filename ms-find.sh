#!/bin/bash

LIBDIR="$1/data/library"
matches=`cat "$LIBDIR"`

shift
while [ $# -ne 0 ]; do
    matches=`grep -i "$1" <<< "$matches"`
    shift
done

echo "Found entries:"
sed 's/ID: \([0-9]*\); Path: \([^;]*\); Title: \([^;]*\); Artist: \([^;]*\);.*/\1: \4 - \3  ( \2 )/' <<< "$matches"

