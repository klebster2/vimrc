#!/bin/bash

curl -s -o ~/.vim_runtime/rhymezone_wordlist \
    "https://api.rhymezone.com/words?max=600&nonorm=1&k=rz_wke&rel_wke=$1"

cat ~/.vim_runtime/rhymezone_wordlist | jq '.[].word' \
     | sed -r 's/\"([a-z]+):(.+):(.+)(.*):(.*)"/\5\t\2\t\3\t\4/g' \
     | sed 's/\\//g' > ~/.vim_runtime/rhymezone_wordlist_pretty
