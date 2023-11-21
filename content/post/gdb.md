---
title_pl: "gdb Notatki"
title: "gdb Notes"
description: "Zgromadzone notatki o gdb"
date: 2023-11-05
tags: ["pl", "gdb", "c++", "c", "gcc"]
categories: ["Notes"]
---

# Gdbserver

Podstawowe użycie dla aplikacji z we/wy na terminal:

```
# tty1
gdbserver :1337 ./mojebin
# tty2
gdb ./mojebin
> target extended-remote :1337
> continue
```

Aby móc ponownie uruchomić proces serwera z klienta

```
> target extended-remote :1337
# zamias
> target remote :1337
```

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
