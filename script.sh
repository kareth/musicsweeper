#!/bin/bash

count=0;

print_files(){
  for file in $1/*
  do
    if [ -d "$file" ]
    then
      #echo "katalog: $file"
      print_files "$file"
    else
      #echo "plik: $file"
      count=$(( $count + 1 ))
      ./echoprint-codegen "$file" 50 50 > tmp1
      grep -Po '"code":".*?[^\\]"' tmp1 > tmp2
      awk '{print substr($0,9)}' tmp2 > tmp1
      awk '{print substr($0, 0, length($0) - 1)}' tmp1 > tmp2
      code=`cat tmp2`
      #echo "$code"
      curl "http://developer.echonest.com/api/v4/song/identify?api_key=N6E4NIOVYMTHNDM8J&code=$code"
    fi
  done
}

print_files "$1"
echo "ilosc znalezionych plikow: $count"
