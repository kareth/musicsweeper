#!/bin/bash

GIT=/usr/bin/git

BINDIR=`dirname $0`

if [ -x "$BINDIR/ms-$1.sh" ]; then
  ARGS="$2 $3 $4 $5 $6 $7 $8 $9"
  exec "$BINDIR/ms-$1.sh" $ARGS
else
  echo "ms: wrong command."
  echo "ms: use 'ms help' to see help."
  exit 1
fi
