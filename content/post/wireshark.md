---
title_pl: "wireshark Notatki"
title: "wireshark Notes"
description: "Zgromadzone notatki o wireshark"
date: 2023-11-10
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

Dostosowanie wyjście do poszczególnych pól:

```
tshark -r error_reporting.pcap -T fields -e icmp.type
```
