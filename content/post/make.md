---
title_pl: "gnu make Notatki"
title: "gnu make Notes"
description: "Zgromadzone notatki o Gnumake"
date: 2023-11-20
tags: ["pl", "make", "gnu", "c"]
categories: ["Notes"]
---

## Specjalizacja regułu dla poszczególne cele

"Statyczne reguły":

```make
libc_targets = ptr xmm-demo

$(libc_targets): %: %.o
	ld -dynamic-linker=/lib64/ld-linux-x86-64.so.2 $< -lc -o $@
```
