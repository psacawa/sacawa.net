---
title_pl: "ZSH Notatki"
title: "ZSH Notes"
description: "Zgromadzone notatki o ZSH"
date: 2023-07-26
tags: ["pl", "shell", "zsh", "linux"]
categories: ["Notes"]
---

# ZSH

## Uzypełnienia

### `_arguments`

Specyfikacje opjci jak `-f[force]:opis:` oczekuje parametr do argumentu, ale nie daje uzupełnienia. Opcja bez parametru opisujemy przez `-f[force]`. Zatem

```zsh
_arguments \
  '-f[force]' \
  '1: :_files' \
```

poprawnie uzupełnia `foo -f ^I` oraz `foo ^I`.

### Inne

Znaajdź opcję w liście argumentów `$words` i upewnij się że ma powiązany argument

```zsh
local -i idx=${words[(I)-B]}
if ((idx > 0 && idx + 1 <= $#words )); then
  cachefile="${words[((idx+1))]}/CMakeCache.txt"
  ...
fi
```
