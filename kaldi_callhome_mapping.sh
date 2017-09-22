#!/bin/bash

# /disk/scratch/s1444673/zero/corpora/callhome_orig/LDC96T17/transcrp/
# kaldi/

mkdir $2;
for C in $(cd mapping; ls callhome*); do
  # echo "## CAT $C"
  echo "{" > $2/$C.json
  for F in $(cat mapping/$C | cut -d' ' -f1 | uniq ); do
    # echo "## FILE $F"
    cat $1/$F.txt |
    grep -v ";;MM" | grep -v "file;unicode" |
    # awk -F" " '{ printf("%d %s %s-%s-%06d-%06d %.2f %.2f\n", NR, substr($1, 0,length($1)-4), substr($1, 0,length($1)-4),($2 == "0" ? "A" : "B"), int($3*100), int($4*100), $3, $4) }'
    awk -F" " '{ printf("\"%s_%d\": {\"seg_name\":\"%s-%s-%06d-%06d\", \"start\":%.2f, \"end\":%.2f},\n", "'"$F"'", NR, "'"$F"'",($3 == "A:" ? "A" : "B"), int($1*100), int($2*100), $1, $2) }'
  done > $2/$C.json_temp
  sed '$ s/,$//' $2/$C.json_temp >> $2/$C.json
  echo "}" >> $2/$C.json
  rm $2/$C.json_temp
done