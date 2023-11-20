#!/usr/bin/env bash

if [[ $# < 2 ]]; then
  echo "./new_post.sh \"<nazwa wpisu>\"" >/dev/stderr
  exit 1
fi

shish_case_name=${1//[ _]/-}
echo $shish_case_name

hugo new "content/post/$(date +%F)-${shish_case_name}.md"
