---
title: "Notatki o Jądrze Linux"
description: "Linux Kernel Notes"
date: 2023-07-14
tags: ["pl", "kernel", "linux"]
categories: ["Notes"]
---

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
