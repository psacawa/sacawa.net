---
title_pl: "C Notatki"
title: "C Notes"
description: "Zgromadzone notatki o C"
date: 2023-08-29
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

```c
#define STR_HELPER(x) #x
#define STR(x) STR_HELPER(x)
```

E.g. `const char file[] = STR_HELPER(__FILE__);` będzie `__FILE__`, ale `const char file[] = STR(__FILE__);` będzie nazwą pliku (otoczone cudzysłowiami, co jest nieuniknione).

# Język C

## Włączony (ang. inlined) Język Asemblera

Ogólny schemat to `asm(kod : wyjście : wejście )`. W[ey]jście ma postać `ograniczenie (zmienna)`, e.g. `=r(dest)`.

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

```c
int src = 1;
int dst;

asm("mov %0, %1 \n"
    "add %0, 1\n"
    : "=r"(dst)
    : "r"(src));

printf("%d\n", dst);
```

Przykład z opcją _clobber_ (`"cc"` znaczy że `EFLAGS` jest nadpisane). Bitskan argumentu:

```c
uint32_t mask = strtoul(argv[1], NULL, 10);
uint32_t idx;
asm("bsfl %[aMask], %[aIndex]"
    : [aIndex] "=r"(idx)
    : [aMask] "r"(mask)
    : "cc");
printf("%d\n", idx);
```

Ograniczenia wyjścia `a` `b` `c` `d` `D` `S` wskazują na wyjście odpowiednio w rejestrzach `rax` `rbx` `rcx` `rdx` `rdi` `rsi`. E.g. `rdtsc` zapisuję wyjście jako `edx:eax`:

```c
static u64 rdtscp(void)
{
    u32 hi, lo;
    asm volatile (
        "rdtscp"
        : "=d"(hi), "=a"(lo)
        :
        : "cx", "memory"
    );
    return (u64)hi<<32 | lo;
}
```

Bariera Kompilacji (ang. ^compiler barrier^ ) - Uniemożliwia zmiany kolejności instrukcji:

```c
#define COMPILER_BARRIER() asm volatile("" ::: "memory")
```

# Środowisko Wykowawcze (ang. Runtime Environment)

Sterta jest generowana w sposób leniwy w GNU. `sbrk(0)` wskazuje na jej koniec(górę).

# libc

## stdio

### v?[sdf]?n?printf

Format `%[m$][flagi][szerokość][precyzja][długość][kowersja]`.

Opcjonalne `m$`pozwala określić z którego parametru będzie brany argument.

#### Flagi

- `#`: alternatywny format
- `0`: wypełnić zerami z lewej strony

#### Szerokość Pola

Liczba wiekszą niz zero określająca minimalna szerokość pola, albo `*` (szerokość określona przez nasępny parametr) lub `*m$` (przez `m`-ty parametr)

#### Precyzja

Format: `.m` określa dokładność do `m` miejsc za przecinkiem. `*` i `*m$` tez akceptowane

#### Modyfikator Długości

- `l`: `long`
- `z`: `size_t`/`ssize_t`
- `h`: `short`
- `hh`: `char`/`signed char`

#### Konwersja

- `d`: dziesiątkowy
- `u`: dziesiątkowy bez znaku
- `x`: szesnastkowy
- `p`: wskaźnik
- `f`: zmiennoprzecinkowe
- `s`: łańcuch

#### Przykłady

```c
for (int i = 0; i != argc; ++i)
  printf("%1$s at %1$p\n", argv[i]);
```
