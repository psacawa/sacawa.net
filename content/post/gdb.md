---
title_pl: "gdb Notatki"
title: "gdb Notes"
description: "Zgromadzone notatki o gdb"
date: 2023-11-05
tags: ["pl", "gdb", "c++", "c", "gcc"]
categories: ["Notes"]
---

# Gdbserver

# Wskazówki

## Nagrywanie i Wykonanie Nagrania Wstecz z rr

```sh
rr record ./target arg1 arg2
rr replay #uruchamia gdb
```

w powłowe `gdb`: `reverse-next`, `reverse-step`, etc.

Uruchomić plik wykonywalny z argumentami:

`gdb --args ./bin argv1 argv2`

Zatrzymaj się bezpośrednio przed `main` w programach wiazanych z `libc.so`

`break __libc_start_main_impl`

Wykonuj wiele wstępnych poleceń. dzięki ogólnemu upośledzeniu umysłowemu autorów `gdb --ex`, `--exec`, etc. działają inaczej

```
gdb \
  -ex "set environment LD_PRELOAD=./build/libtetradactyl-qt.so" \
  -ex "dashboard threads -output /dev/null" \
  ./build/calc-demo/calculator
```
