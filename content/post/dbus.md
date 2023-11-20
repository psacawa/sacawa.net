---
title: "Dbus Notatki"
description: "Zgromadzone notatki o Dbus"
date: 2023-11-20
tags: ["pl", "dbus", "linux"]
categories: ["Notes"]
---

Aby uzyskać dostęp do magistrali dostępności uruchomiony przez `at-spi-bus-launcher`, trzeba podać opcę `--address` do `busctl` następująco:

`busctl --address=unix:path=/run/user/1000/at-spi/bus_0`
