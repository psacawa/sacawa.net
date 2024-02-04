---
title_pl: "C Notatki"
title: "Kernel Notes"
description: "Zgromadzone notatki o Jądrze"
date: 2024-01-07
tags: ["pl", "linux", "c"]
categories: ["Notes"]
---

# Moduły Ładowalne (ang. loadable kernel modules)

Prosty `Makefile`:

```make
obj-m += target-lkm1.o
obj-m += target-lkm2.o

PWD := $(CURDIR)

ifeq ($(CONFIG_STATUS_CHECK_GCC),y)
CC=$(STATUS_CHECK_GCC)
ccflags-y += -fanalyzer
endif

all:
	$(MAKE) -C /lib/modules/$(shell uname -r)/build CC=$(CC) M=$(PWD) modules

clean:
	$(MAKE) -C /lib/modules/$(shell uname -r)/build CC=$(CC) M=$(PWD) clean
	$(RM) other/cat_noblock *.plist

indent:
	clang-format -i *.[ch]
	clang-format -i other/*.[ch]
```
