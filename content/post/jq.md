---
title: "jq Notes"
description: "Collected Notes on jq"
date: 2023-11-21
tags: ["jq", "shell"]
categories: ["Notes"]
---

## Wskazówki

Usunięcie przedrostka z obiektu:

```
jq '.[]|(.file|= ltrimstr("../"))' compile_commands.json
```

Rozdziel `.command` na odstępy, przypisz do `.arguments`:

```
jq 'map  ((.command | split(" ")) as $args | .arguments |= $args | del (.command))' compile_commands.json
```

Filtruj na obecnosc `/SHARED/` w argumentach, potem weź `arument ~ /MODULE/`

```
jq '.[]|select(.arguments|any(test("SHARED"))) | .arguments|.[] | (select(test ("MODULE")))'`
```

Rekurencja + wybieranie poszczególnych wartości:

```jq
recurse(.nodes[])? | {id, app_id}`
```

Interpolacja łańcuchów:

```jq
rabin2 -j -S build/main | jq '.sections|sort_by(.size)|.[]|select(.name|test("debug")) | "\(.size) \(.name) " '
```

Usunęcie pewnych flag kompilatora z `compile_commands.json`:

```jq
[.[]| .arguments |= [.[]|select(test("^-(W|f|m)")|not)]]
```

Przykład użycia `with_entries`:

```jq
with_entries(select(.key != "capabilities"))
```

Generuj listę dla API REST:

```
seq 100 | jq -s '{lsit_of_strings : map(tostring)}'
```
