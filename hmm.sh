#!/bin/bash

for C in $(cd mapping; ls fisher*); do
  if [ $C == 'fisher_train' ]
  then
    echo "## CAT $C"
    for F in $(cat mapping/$C | cut -d' ' -f1 | uniq); do
      # echo "## NOT FILE $F"
      if [ $F == '20050908_182943_22_fsp' ]
      then
        echo "## FILE $F"
        cat $1/data/transcripts/$F.tdf |
        grep -v ";;MM" | grep -v "file;unicode" |
        # awk -F" " '{ print ($2 == "0" ? "A" : "B"),$3=int($3*100),$4=int($4*100) }' > $F.map
        awk -F" " '{ printf("%s-%s-%06d-%06d\n", substr($1, 0,length($1)-4),($2 == "0" ? "A" : "B"),$3=int($3*100),$4=int($4*100)) }' > $F.map
      fi
    done
  fi
done