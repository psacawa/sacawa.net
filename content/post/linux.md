---
title: "Linux Kernel Notes"
description: "Notatki o Jądrze Linux"
date: 2023-07-14
tags: ["pl", "kernel", "linux"]
categories: ["Notes"]
---

# Zarządzanie Pamięcią

VMA procesów przestrzeni użytkownika [0]:

- sama binaria `0x00005500_00000000-0x00005700_00000000` (2 TB)
- mmapy `0x00007f00_00000000 - 0x00007fff_ffffffff`, łącznie z bibliotekami (ograniczone to góry stosu - `RLIMIT_STACK`) (1 TB)
- stos `0x00007ffc_00000000 - 0x00007fff_ffffffff`
- `0xffffffffff600000 - 0xffffffffff601000` vdso/vsyscall (pamięć jądra)

# sysfs

Aby (roz)wiązać sterownik od urządzenie, uzywamy pliki bind/unbind w systemie plików sysfs:

```sh
echo 1-3:1.0sdf | s tee /sys/bus/usb/drivers/r8188eu/unbind
```

Dodaj kombinacja id. producenta, id. produktu jako obsługiwana przez sterownik (tylko USB?):

```sh
echo 0x2001 0x331b | s tee /sys/module/8192eu/drivers/usb:rtl8192eu/new_id
```

# Wywołania Systemowe (ang. Syscalls)

## mmap

Trzeba podać dla czwartego parametru `MMAP_PRIVATE` lub `MMAP_SHARED`, e.g. `mmap(NULL, 0x4000, perm, MAP_ANON | MAP_PRIVATE, 0, 0)`. Inaczej otrzymujey `EINVAL`.

# Przypisy

[0] https://github.com/nick0ve/how-to-bypass-aslr-on-linux-x86_64
