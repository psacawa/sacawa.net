---
title_pl: "gcov Notatki"
title: "gcov Notes"
description: "Zgromadzone notatki o gcov"
date: 2023-10-08
tags: ["pl", "gcov", "gcc", "c++", "c"]
categories: ["Notes"]
---

```
g++	-g -Wall -std=c++17 -coverage main.cpp -o main
```

produkuje plik `*.gcno`. Uruchomienie programu wynika plikiem `*.gcda`. Stąd można wywołać albo

`gcov main.cpp` lub
`lcov --capture --directory . -o main.gcda.info`

HTML generujemy przez

```
genhtml main.gcda.info -o html
```

# GCC
