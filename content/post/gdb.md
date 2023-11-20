---
title: "gdb Notatki"
description: "Zgromadzone notatki o gdb"
date: 2023-11-20
tags: ["gdb", "c++", "c", "gcc"]
categories: ["Notes"]
---
# Nagrywanie i Wykonanie Nagrania Wstecz z rr

```sh
rr record ./target arg1 arg2
rr replay #uruchamia gdb
```

w powłowe `gdb`: `reverse-next`,  `reverse-step`, etc.
