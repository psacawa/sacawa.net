---
title: "bpftrace Notatki"
description: "Zgromadzone notatki o bptrace"
date: 2023-11-20
tags: ["pl", "bpftrace", "kernel", "linux"]
categories: ["Notes"]
---

# Tracepoints

## Wywołania Systemowe

Nazwy parametrów można odnaleźć w plikach jak `/sys/kernel/debug/tracing/events/syscalls/sys_enter_open/format`

Zatrzymaj e.g. wywołania `sleep` po to by ich debugować, ale tylko pierwszy:

```
bpftrace --unsafe -e '
BEGIN {
  @on = 1;
}
uprobe:libc:__libc_start_main
/comm == "sleep" && @on == 1 /
{
  print(probe); signal("TSTP"); @on = 0
  }'
```
