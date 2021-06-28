#!/bin/bash
# Usage: ngrams N < FILE
N=$1
set --
while read line; do
  set -- $* $line
  while [[ -n ${*:$N} ]]; do
    echo ${*:1:$N} 
    shift
  done
done |
sort | uniq -c
