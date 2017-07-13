#!/bin/bash

mkdir $2;
for C in $(cd mapping; ls fisher*); do
  echo "## CAT $C"
  for F in $(cat mapping/$C | cut -d' ' -f1 | uniq ); do
    echo "## FILE $F"
    cat $1/data/transcripts/$F.tdf |
    grep -v ";;MM" | grep -v "file;unicode" |
    awk -F" " '{ printf("%d %s-%s-%06d-%06d\n", NR, substr($1, 0,length($1)-4),($2 == "0" ? "A" : "B"),$3=int($3*100),$4=int($4*100)) }'
    done > $2/$C.map
done