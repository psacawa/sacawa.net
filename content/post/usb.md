---
title: "USB Notatki"
description: "Zgromadzone notatki o USB"
date: 2023-11-20
tags: ["pl", "usb", "kernel"]
categories: ["Notes"]
---

# USB

## Architektura Logiczna

Są magistrale (busy), na których mamy urządzenia. Na każdym magistrale jest ich maksymalnie 127 (adresowane przez siedem bitów, a urządzenie 0 służy konfiguracji). Każde urządzenie może mieć do 32 (?) końcówek, zwane też potokami.

Urządzenie ma konfiguracje, konfiguracje mają interfejsy, interfejsy mają końcówki.

Ścieżki urządzeń USB w sysfs są oparte o "porty": ich położenie prawdziwe to

```
/sys/devices/pci0000:00/0000:00:14.0/usb1/1-5/1-5:1.0
```

Aż do `usb*`, tylko odnajdujemy położenie na niby-PCI magistrale upozorowanym na chipseci (mostku północnym) Intel. Potem, mamy e.g. `usb1/1-5/1-5:1.0`. "1" do magistrala (mamy zwykle więcej niż jeden) "0" określa port (zamiast liczba urządzenia) co wydają się być aspektem implementacji USB poszczególnym dla Linuksa. Pozostałe liczby to liczby konfiguracji "1", oraz interfejsów "0". We tym przpadku jest to hub USB 2.0. A zatem:

```
/sys/devices/pci0000:00/0000:00:14.0/usb${BUS}/${BUS}-${URZADZENIE}/${BUS}-${URZADZENIE}:${KONFIGURACJA}.${INTERFEJS}
```

TODO 14/07/20 psacawa: uzupełnij sysfs opis
TODO 14/07/20 psacawa: porty w sensie `libusb_get_port_numbers` to co?
