---
title: "jq Notes"
description: "Collected Notes on jq"
date: 2023-11-21
tags: ["jq", "shell"]
categories: ["Notes"]
---

## Wskazówki

Usunięcie przedrostka z obiektu:

```jq
jq '.[]|(.file|= ltrimstr("../"))' compile_commands.json
```

Rozdziel `.command` na odstępy, przypisz do `.arguments`:

```jq
jq 'map  ((.command | split(" ")) as $args | .arguments |= $args | del (.command))' compile_commands.json
```

Filtruj na obecnosc `/SHARED/` w argumentach, potem weź `arument ~ /MODULE/`

```
jq '.[]|select(.arguments|any(test("SHARED"))) | .arguments|.[] | (select(test ("MODULE")))'`
```

Rekurencja + wybieranie poszczególnych wartości:

```
recurse(.nodes[])? | {id, app_id}`
```

Interpolacja łańcuchów:

```
rabin2 -j -S build/main | jq '.sections|sort_by(.size)|.[]|select(.name|test("debug")) | "\(.size) \(.name) " '
```
