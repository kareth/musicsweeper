#!/bin/bash

count=0;

print_files(){
  for file in $1/*
  do
    if [ -d "$file" ]
    then
      echo "katalog: $file"
      print_files "$file"
    else
      echo "plik: $file"
      count=$(( $count + 1 ))
    fi
  done
}

print_files "$1"
echo "ilosc znalezionych plikow: $count"
