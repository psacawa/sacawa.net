---
title: "Skrypty powłoki `[ba|z]sh` /inne Notatki"
description: "Ogólne notatki o powłoce oraz przykłądy"
date: 2023-11-20
tags: ["shell", "linux"]
categories: ["Notes"]
---
## /bin/getopt

Przykład:

```sh
TEMP=$(getopt -o 'r:o:' --long 'required-parameter:required-parameter::' -n 'ProcessLoadedLib.sh' -- "$@")

if [ $? -ne 0 ]; then
	echo 'Terminating...' >&2
	exit 1
fi

eval set -- "$TEMP"
unset TEMP

while true; do
  case $1 in
    '-r'|'--required-parameter')
      VALUE="$2"
      shift 2
      continue
      ;;
    *)
      break
      ;;
  esac
done

for remaining_arg; do
  echo $remaining_arg
done

```

W opisie opcji, pojedynczy dwukropek oznacza obowiązkowy parametr, podwójny oznacza opcjonalny parametr.
