---
title_pl: "Konsolidator dynamiczny glibc ld.so Notatki"
title: "glibc Notes"
description: "Zgromadzone notatki o konsolidatorze dynamicznym oraz libc w środowisku GNU"
date: 2023-08-17
tags: ["pl", "linux", "gnu", "ld.so", "glibc"]
categories: ["Notes"]
---

# Konsolidator dynamiczny ld-linux.so

## Konfiguracja

### Przedładowanie (ang. preload)

Wypisanie struktury `link_map` dla programu hello z `dl_iterate_phdr`:

```
(glówna mapa wiązania)
linux-vdso.so.1
/lib/x86_64-linux-gnu/libc.so.6
/lib64/ld-linux-x86-64.so.2
```

Jeśli mamy `dlopen("libfoo.so", 0)`:

```
(glówna mapa wiązania)
linux-vdso.so.1
/lib/x86_64-linux-gnu/libc.so.6
/lib64/ld-linux-x86-64.so.2
./libfoo.so
```

Z `LD_PRELOAD=./libfoo.so`:

```
(glówna mapa wiązania)
linux-vdso.so.1
./libfoo.so
/lib/x86_64-linux-gnu/libc.so.6
/lib64/ld-linux-x86-64.so.2
```

### Dynamiczne tokeny (ang. dyanmic string tokens (DST))

Używając `${ORIGIN}` w uruchomieniu procesu z `LD_PRELOAD`, katalog `${ORIGIN}` odnosi się do katalog w którym wywołany proces się znajduje. Zatem

```
LD_PRELOAD='${ORIGIN}/../lib/libtetradactyl-dynamic-probe.so' /somepath/bin/prog
```

odszukuje `/somepath/lib/libtetradactyl-dynamic-probe.so`.

_UWAGA_; Jeśli używamy `ORIGIN` w `dlopen` w obecności `LD_PRELOAD`, zdaje się przyechwytać `ORIGIN`? Działa tak ze względu na implementacje dynamicznch tokenów jak `ORIGIN`: podczas swoje działanie `dlopen` odzczytuje stos po to by podstawiać zmmienny jak `ORIGIN`. Zatem jest przyechwytamy to wywołanie w `libpreload.so`, to `dlopen` znajdzie podstawi `ORIGIN` jako pochodzenie tego przedładowanej biblioteki.

### Przestrzenie Nazw (ang. namespaces)

Przestrzenie nazw oferują lepsza forma izolacji bibliotek współdzielonych niż `RTLD_LOCAL`: biblioteki ładowane z `RTLD_LOCAL` (== 0 więc domyślną) mogą być "promowane" to `RTLD_GLOBAL` jest e.g. proces relokacji postanowi że globalne biblioteki na niej polegają poprzez `DT_NEEDED` [0]. Z przestrzeniami nazw można też osłabić `RTLD_LOCAL`, czyniąc symbole widoczne dla niektórych ODW (obiekty dynamiczne współdzielone): załaduj ich wszystkich zależnych bibliotek z `RTLD_LOCAL` (domyślne) w nową przestrzeń nazw.

Nową przestrzeń nazw można uzyskać do nich dostęp poprzez `dlmopen(LM_ID_NEWLM, plik, flaga)`. Nie mają bezpośredniego związku z przedładowaniem.

###

## Kod Źrółowy

### Makra Przeprocesora

Najważniejsze cele kompilacji glibc to `ld-linux.so` (czyli RTLD), `libc.so`, oraz `libc.a`. Posród pozostałych mamy e.g. `libpthread.*`, `libm.*` (fasada), oraz `ldconfig`.

- `MODULE_NAME`: `rtld` `libc`, `ldconfig`
- `SHARED`: zdefiniowane dla RTLD, oraz `*.so`, nie dla statycznych archiw.

### Struktury

Głowne struktury to `link_map`, `rtld_global` oraz `rtld_global_ro` [1,2].

struktury `rtld_global(_ro)?` mają po jednej instancji w pamięci ładowacza. Opisują jego stan. Warianty `rtld_local(_ro)?` to są aliasy do poprzednich zmiennych: w wiązaczu, stosujemy `rtld_local(_ro)?` , w e.g. mamy symbol niezdefiniowane `rtld_global(_ro)?`. Są zamienne. W obu przypadkach uzykamy do nich dostęp za pomocą makr `GL(atrybut)` oraz `GLRO(atrybut)`.

`rtld_global_ro` jest strukturą tylko do odczytu (po relokacji). Zawiera zatem stałe które nie zmieniają się w obliczu ładowania bibliotek przez e.g przez e.g. `dlopen`. Najważniejsze to wskażniki do implementacji procedur ładowacza (`_dl_open`, etc.).

`rtld_global` to stan ładowacza. Najważniejsze atrybuty to `struct link_namespaces _dl_ns[16]` oraz `struct link_map _dl_rtld_map`. `link_namespaces` zawiera wskaźniki do mapy głownej oraz do `libc`.

Mapy wiązań opisują po jednym obiekcie łądownym, łącznie z głownym programmem (nazywana główną mapą (ang. main map)) biblioteki współdzielone, `ld-linux.so`, oraz `vdso`.

Zakresy (ang. scopes) są opisane przez `struct r_scope_elem`. Są to po prostu listy map wiązania o określonej długości.

### Startowanie

<!-- TODO 02/09/20 psacawa: finish this -->

### Ładowanie

<!-- TODO 02/09/20 psacawa: finish this -->

# libc.so

## malloc

Rozmiar jednej areny to `0x21000`. Początek  zawiera metadane (`struct malloc_state`), a pozostałe 2MB jest determinowane przez `glibc.malloc.mmap_max` (domyślnie 2\*\*16),  co określa liczba kawałków które może alokować jedna arena.

- Próg dla `mmap`: 128KiB.
- Próg dla tcachebin: 1024 + 8. Patrz też `glibc.malloc.tcache_max`.
- Próg dla fastbin: 0xa0 na `amd64`. Patrz też parametr dostrajalny ld-linux `glibc.malloc.mxfast`.

# Przypisy

- [0] dlopen(3)
- [1] `glibc/sysdeps/generic/ldsodefs.h`
- [2] `glibc/elf/link.h`
