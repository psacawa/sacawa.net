---
title_pl: "ELF Notatki"
title: "ELF Notes"
description: "Zgromadzone notatki o formacie binarnym ELF"
date: 2023-06-27
tags: ["pl", "elf", "reversing", "linux"]
categories: ["Notes"]
---

# ELF

## Sekcje w ELFach

- .plt
- .plt.got
- .plt.sec
- .got
- .got.plt

### .plt

Tablica wiązania procedur. Wraz z wariantami, zawiera fragmenty kodu jak

```asm
bnd jmp QWORD PTR [rip+0x2f75]        # 3fd0 <puts@GLIBC_2.2.5>
```

które te adresy wskazują na GOT, gdzie albo będzie prawdziwy adres celu, lub w przypadku funkcji z leniywm wiązaniem która jest po raz pierwszy wywołana, funkcja rozwiązująca odniesienie.

### .got

Pierwsze trzy zapisy są specjalne:

0. qword przesunięcie do sekcji PT_DYNAMIC
1. "Obj_Entry used to indicate the current component # set by ld.so" wg. [0]. Obserwowano wartość 0.
2. `_rtld_bind_start` ustawione przez ld.so . Obserwowano wartość 0.

Dalej mamy zapisy wobec których mamy relokację R_X86_64_JUMP_SLOT

### .got.plt

Nie mylić z `.plt.got`. Ta część PLT zawiera adresy rozwiązanych symboli funkcji. Wstępnie zawiera adres *drugiej* instrukcji odpowiadającego wpisu w `.plt` (w przypadku braku PIE) lub przesunięcia wskazujące an nie(PIE).

### .plt.got

Rutyny PLT kiedy używane jest chętne (nieleniwe) wiązanie, jak w przypadku flag Konsolidatora `ld -z now`.

### .plt.sec

<!-- TODO 27/06/20 psacawa: finish this -->

## Relokacje

Zwykle mamy relokacja (przeniesiena) z składnikami (ang. addends). Zatem wszystko "rela" zamiast "rel". W plikach obiektowych przenoszalnych mamy .rela.$sekcja. Konsolidator statyczny /bin/ld ich zastostuje. Natomiast w plikach uruchamialnych mamy .rela.plt oraz .rela.dyn

<!-- TODO 27/06/20 psacawa: Jakie mają znaczenia? -->

Struktura Elf_Rela ma atrybuty:

- przesunięcie: przesunięcie w komponencie gdzie relokacja zostanie przeprowadzona
- informacja: zawiera dwa dane, mianowicie
  - pozycja w tablicy symboli wzgledęm którego przenoszenie zostanie przeprowadzone. Jeśli wartość symboli w wchodzi w rachunek, będzie 0.
  - typ przeniesienia (udokumentowane w psABI). Patrz niżej.
- Składnik do sumy, jeśli typ przenoszenia nie używa ich, wartość jest 0.

### Ważniejsze typy Przenoszeń na x64

- R_X86_64_JUMP_SLOT - generowane w przypadku wywołań do bibliotek współdzielonych
- R_X86_64_JUMP_SLOT - generowane w przypadku wywołań do bibliotek współdzielonych

## Informacje do debugowanie (DWARF)

Składa się listy zapisów informacji debugowania z okresloną etykietką `DW_TAG_*` które opisują pewien element źródłowego programu, i które maja zestaw powiązanych atrybutów `DW_AT_*` które są ich charakterystykami. N.b. etykietka `DW_TAG_*` opisuje typ elementu syntaktycznego, natomiast `DW_AT_type` opisuje typ z punktu widzenia systemu typów programu. Zatem: `typedef MojeInt int;` wyprodukuje `DW_TAG_typedef` z `DW_AT_name="MojeInt"`, `DW_AT_type=int` (nie testowane).

To wszystko jest zapisane w segentach pliku ELF `.debug_*`

<!-- TODO 03/08/20 psacawa: opisz sekcje  `.debug_*` -->

## Przpisy

- [0] https://maskray.me/blog/2021-09-19-all-about-procedure-linkage-table
