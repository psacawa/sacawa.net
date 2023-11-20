---
title: "nasm Notatki"
description: "Zgromadzone notatki o assemblerze nasm"
date: 2023-11-20
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

## Ucieczki w Stylu C

Aby użyć '\n' jako koniec linii, trzeba otoczyć go backtikami, czyli

```nasm
section .data
  fmt db `hello %s\n\0`
```

## Adresowanie względem Licznika programu

```nasm
mov rax, [rel 0x1000]
```

## Stos

### Zmienne Lokalne

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
