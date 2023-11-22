---
title_pl: "gnu make Notatki"
title: "gnu make Notes"
description: "Zgromadzone notatki o Gnumake"
date: 2023-07-12
tags: ["pl", "make", "gnu", "c"]
categories: ["Notes"]
---

## Wskazówki

Statyczne reguły, czyli specjalizacja regułu dla Poszczególne celów:

```make
libc_targets = ptr xmm-demo

$(libc_targets): %: %.o
	ld -dynamic-linker=/lib64/ld-linux-x86-64.so.2 $< -lc -o $@
```
