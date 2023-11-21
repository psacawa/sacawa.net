---
title_pl: "LLVM/Clang Notatki"
title: "LLVM/Clang Notes"
description: "Zgromadzone notatki o środowisku LLVM oraz Clang"
date: 2023-07-04
tags: ["pl", "llvm", "clang", "c++", "c"]
categories: ["Notes"]
---

# LLVM

## Kompilacja wtyczek

Wtyczki clang kompilujemy poza dystrybucją LLVM CMake'em, z następującymi instrukcjami:

```cmake
find_package(LLVM REQUIRED CONFIG)

include_directories(${LLVM_INCLUDE_DIRS})
separate_arguments(LLVM_DEFINITIONS_LIST NATIVE_COMMAND ${LLVM_DEFINITIONS})
add_definitions(${LLVM_DEFINITIONS_LIST})

include(AddLLVM)
add_llvm_library(PrintFunctionNames MODULE PrintFunctionNames.cpp PLUGIN_TOOL clang)
```

Uruchamiamy wtyczkę następująco:

`clang++ -fplugin=/home/psacawa/scratch/clang/CallSuperAttribute/build/CallSuperAttr.so -fplugin-arg-call_super_plugin-help main.cpp -o main`

# Clang

## Przełożenie polecenia z gcc

Odpowiednik `gcc -Wl,-rpath=.` (tylko jeden argument na raz):

```
clang main.c -Xlinker -rpath=. -o main
```

## Nieudokumentowane opcje clang

Są to opcje dla samego kompilatora, nie zaś dla /bin/clang++

```
clang++ -Xclang -fdump-record-layouts main.cpp -o main
clang++ -Xclang -fdump-vtable-layouts main.cpp -o main
```

Proces kompilacji (zwane potokiem):

```
clang++ -ccc-print-phases main.cpp
```

Pokąż AST:

```
clang -Xclang -ast-dump -fsyntax-only test.cc
```
