#!/bin/bash
echo $0

curl -s -o $(dirname $(realpath $0))/rhymezone_wordlist \
    "https://api.rhymezone.com/words?max=600&nonorm=1&k=rz_wke&rel_wke=$1"

cat $(dirname -- $(realpath $0))/rhymezone_wordlist | jq '.[].word' \
     | sed -r 's/\"([a-z]+):(.+):(.+)(.*):(.*)"/\5\t\2\t\3/g' \
     | sed -re 's/\\//g; s/<\/?b>/*/g' > $(dirname -- $(realpath $0))/rhymezone_wordlist.elp

$HOME/.vim_runtime/assistive-writing-apis/ngrams.sh 2 \
    < <(awk -F $"\t" '{print$1}' $(dirname -- $(realpath $0))/rhymezone_wordlist.elp| sed -re "s/[^A-Za-z \*\']//g; s/(.*)/\L\1/") \
    | grep -v 1 | sort -rnk1 > $HOME/.vim_runtime/assistive-writing-apis/ngrams2.elp &

$HOME/.vim_runtime/assistive-writing-apis/ngrams.sh 3 \
    < <(awk -F $"\t" '{print$1}' $(dirname -- $(realpath $0))/rhymezone_wordlist.elp | sed -re "s/[^A-Za-z \*\']//g; s/(.*)/\L\1/") \
    | grep -v 1 | sort -rnk1 > $HOME/.vim_runtime/assistive-writing-apis/ngrams3.elp &

wait
