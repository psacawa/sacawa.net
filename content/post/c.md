---
title: "C Notatki"
description: "Zgromadzone notatki o C"
date: 2023-11-20
tags: ["pl", "c"]
categories: ["Notes"]
---

# Preprocesor

Działanie `#include` jest definiowane przez implementacje, natomiast w praktyce mamy:

1. `#include <...>` najpierw przeszukuje katalogi wyznaczone przez argumenty `-Idir` w kolejności pojawienia się na linii poleceń, potem "standardowe katalogi systemowe".

2. `#include "..."` najpierw przeszukje _katalog obecnie przetwarzanego pliku_ a dopiero jeśli nie znaleziono pliku, zachowuje się jak pierwsza forma. N.b. szukamy w katalogu pliku gdzie występuje wywołanie inkluzji, nie zaś katalog gdzie znajduje się plik źrodłowy jednostki translacji.

Argument `-include plik` jest jednoznaczne z dopisaniem na początek plik źródłowego `#include "plik"`.

## Makra

Mamy makra funkcyjne oraz obiektowe, a obiektowe są rozwinięte w pierwszej kolejności. Aby "złańcuchować" wartość makra, `#define STR(x) #x` nie wystarczy. Użyj następną konstrukcje.

```
#define STR_HELPER(x) #x
#define STR(x) STR_HELPER(x)
```

E.g. `const char file[] = STR_HELPER(__FILE__);` będzie `__FILE__`, ale `const char file[] = STR(__FILE__);` będzie nazwą pliku (otoczone cudzysłowiami, co jest nieuniknione).

## Włączony (ang. inlined) Język Asemblera

Ogólny schemat to `asm(kod : wyjscie : wejście )`. W[ey]jście ma postać `ograniczenie (zmienna)`, e.g. `=r(dest)`.

Ograniczenia:

- `r` rejestr
- `=` nadpisane
- `+` odczytane is nadpisane

### Przykład

`dst := src; dst++` w asemblerze(GAS):

```c
int src = 1;
int dst;

asm ("mov %1, %0\n\t"
    "add $1, %0"
    : "=r" (dst)
    : "r" (src));

printf("%d\n", dst);
```

Skłądnia Intel:

```
int src = 1;
int dst;

asm("mov %0, %1 \n"
    "add %0, 1\n"
    : "=r"(dst)
    : "r"(src));

printf("%d\n", dst);
```

# Środowisko Wykowawcze (ang. Runtime Environment)

Sterta jest generowana w sposób leniwy w GNU. `sbrk(0)` wskazuje na jej koniec(górę).
