---
title: "uftrace Notatki"
description: "Przykłądowe Użycia uftrace"
date: 2023-11-20
tags: ["uftrace", "linux"]
categories: ["Notes"]
---
# Przykłądy

Filtracja i argumenty dla danej funkcji (c++): `-F/--filter` śledzą stos podczas wywołania, a `-C/--called-filter` wyśwlietlają stos nad wywołaniem.

```
uftrace -FCountryListModel::headerData -ACountryListModel::headerData live build/main
```

Domyślnie `uftrace` śledzi tylko wywołania z głownej binarii. `--nest-libcall` śledzi wywołania międzybibliotekowe. E.g. sprawdź jak `libqt...` używa zmienne środowiskowe:

```
uftrace --nest-libcall live -Cgetenv -Fgetenv ./build/qt-app
```

## Integracja Cmake

```cmake
target_compile_options(binary PRIVATE -pg)
```
