#!/bin/bash

set -x
[ ! -z $OPEN_AI_N_COMPLETIONS ] || OPEN_AI_N_COMPLETIONS=1
[ ! -z $OPEN_AI_MAX_TOKENS ] || OPEN_AI_MAX_TOKENS=100

conf=`printf '{
  "prompt": "%s",
  "max_tokens": %d,
  "temperature": 0.9,
  "top_p": 1,
  "n": %d,
  "stream": false,
  "logprobs": null,
  "stop": null
}' "$(cat $(dirname .)/apis/gpt/prompt | python -c "import sys; print('\\\\\n'.join(sys.stdin.read().split('\n')))")" \
   "$OPEN_AI_MAX_TOKENS" \
   "$OPEN_AI_N_COMPLETIONS" `

#conf=`printf '{
#  "prompt": "%s",
#  "max_tokens": %d,
#  "temperature": 0.9,
#  "top_p": 1,
#  "n": %d,
#  "stream": false,
#  "logprobs": null,
#  "stop": null
#}' "$1" \
#   "$OPEN_AI_MAX_TOKENS" \
#   "$OPEN_AI_N_COMPLETIONS" `

curl "https://api.openai.com/v1/engines/davinci/completions" \
  -X POST \
  -H "Authorization: Bearer ${OPEN_AI_KEY}" \
  -H 'Content-Type: application/json' \
  -d "$conf"

