---
title_pl: "pwntools Notatki"
title: "pwntools Notes"
description: "Zgromadzone notatki o pwntools"
date: 2024-01-29
tags: ["pl", "x86", "python", "hacking"]
categories: ["Notes"]
draft: true
---

# ROP

Przykłady:

```py
from pwn import *
my_rop = ROP('./mybin')
my_elf = ELF('./mybin')
my_rop(rax=0xdeadbeef, rdi=1234)
my_rop.call(my_elf.symbols['plt.func'], [b'arg1', b'arg2'])
my_rop.raw(b'raw8byte')

print(my_rop.dump())
code = my_rop.chain()

from pwnlib.util.iters import pad, take
rbp_offset = 0x20
payload = bytes(take(rbp_offset, pad(code, ord('A'))))
```
