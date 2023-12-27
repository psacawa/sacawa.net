---
title_pl: "nasm Notatki"
title: "nasm Notes"
description: "Zgromadzone notatki o assemblerze nasm"
date: 2023-07-11
tags: ["pl", "nasm", "assembly", "x86"]
categories: ["Notes"]
---

# NASM

## Hello World

```nasm
section .data
  mygreeting db "hello world!"
  len equ $ - mygreeting

section .text
global _start
_start:

  mov rax, 1 ; write
  mov rdi, 1 ; stdout
  mov rsi, mygreeting
  mov rdx, len
  syscall

  mov rax, 60 ; exit amd64
  mov rdi, 0
  syscall

```

## Makra

Wyrównanie (ang. *alignment*) wskaźnika stosu:

```nasm
; align to resolution (%1)
%macro ALIGN_STACK 1 
  ; align
  mov rdi, %1
  sub rdi, 1
  not rdi
  and rsp, rdi
%endmacro
```

## Wskazówki

### Ucieczki w Stylu C

Aby użyć '\n' jako koniec linii, trzeba otoczyć go backtikami, czyli

```nasm
section .data
  fmt db `hello %s\n\0`
```

### Adresowanie względem Licznika programu

```nasm
mov rax, [rel 0x1000]
```

### Stos

#### Zmienne Lokalne

Najpierw trzeba zdefiniować macro lokalne dla kontekstu `%$localsize` określający rozmiar ramy stosu:

```nasm
some_func:
  %push start_ctx
  %assign %$localsize 0x40
  %local i:DWORD

  enter %$localsize, 0
  // push $rbp; $rsp := $rbp - %$localsize;
  mov DWORD [i], 0xdeadbeef
  leave
  %pop
```

### Wskaźniki

Zamiast e.g.

```asm
add rax,QWORD PTR fs:0x0
```

w składni nasm mamy

```nasm
add rax,QWORD [fs:0x0]
```

