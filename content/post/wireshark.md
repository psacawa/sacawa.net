---
title: "wireshark Notatki"
description: "Zgromadzone notatki o wireshark"
date: 2023-11-20
tags: ["pl", "networking", "sysadmin", "wireshark"]
categories: ["Notes"]
---

## Wireshark

## Tshark

Filtrowanie z linii poleceń z pliku:

```
tshark -r eg.pcapng -Y "http.host == example.com"
```

Notabene trzeba odróżnić filtry ebpf podane opcją `-f` od filtrów wyświetlenia wireshark/tshark podane opcją `-Y`.
