---
title: "Linux Kernel Notes"
description: "Notatki o Jądrze Linux"
date: 2023-07-14
tags: ["pl", "kernel", "linux"]
categories: ["Notes"]
---

# Zarządzanie Pamięcią

VMA procesów przestrzeni użytkownika [0]:

- sama binaria `0x00005500_00000000-0x00005700_00000000` (rzekomo 2 TB, ale empirycznie dowodzone że zakres wynosi 1 TB)
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

## set\*uid

Procesowi uprzywilejowanemu wolno dowolne zmiany. Procesowi nieuprzywilejowanemu wolno tylko zmienić `ruid`, `euid`, oraz `suid` na obecne wartości którekolwiek z tych trzech. Zatem po suid root


```
> ruid: 1000  euid: 0     suid: 0
seteuid(1000);
> ruid: 1000  euid: 1000  suid: 0
setresuid(0, 0, 0);
> ruid: 0     euid: 0     suid: 0
```

działa mimo że `euid!=0`.

Jeśli proces nie jest uprzywilejowany, to `setuid` jest jednoznaczne z `seteuid`. Jeśli jest uprzywilejowany, to ustawia `ruid`, `euid`, oraz `suid`. Po suid root:


```
> ruid: 1000  euid: 0     suid: 0
seteuid(1000);
> ruid: 1000  euid: 1000  suid: 0
setuid(0);
> ruid: 1000  euid: 0     suid: 0
```

Dla wywołań `setreuid` oraz `setresuid`, wynik jest pomyślny tylko jeśli *wszystkie* identyfikatory były ustawione. Jeśli tylko niektóre zmiany są dozwolone, żadna nie zajdzie, a wartość zwracania będzie `-1`.
 
# Kwalifikacje (ang. _Credentials_)

Definicja: *Proces uprzywilejowany* to proces z `euid=0`.

Po uruchomienie program suid posiadanie przez `uid=0`:

```
ruid: 1000  euid: 0     suid: 0
```

Stamtąd `setuid(0)` daje `ruid=0`. Porzucamy na stałe przywileje poprzez `setuid(1000)` (by porzucić je na stałe, trzeba być uprzywilejowanym).

`fsuid` jest ustawiany gdykolwiek `euid` jest zmienione. `setfsuid` ustawia go bez zmiany `euid`. Jest rozszerzeniem Linuka.

# Przestrzenie Nazw (ang. *namespaces* )

## Ogólne

Z powłoki: `unshare`, `nsenter`, `lsns`. Interfejs systemu: `unshare`, `setns`, `clone`.

## Przestrzenie nazw Użytkkowników (PNU, ang. *user namespace*)

Domyślnie po wywołaniu systemowego `unshare` w nowej przestrzeni nazw użytkkowników, mamy `ruid=euid=suid=65534 (nobody)`. Aby zostać superużytkownikime w podrzedznej PNU, można wywołać `unshare -Ur sh`, co wywołuje `newuidmap`.

Odwzorowania id użytkkowników z jednej PNU na drugi jest zawarte w `/proc/<pid>/uid_map`. Format składa się z wierszy mający postać

```
<początek zakresu w PNU> <początek zakresu poza PNU> <długość zakresu>
```
Zatem  `0 1000 1` znaczy `root` w PNU jest naprawdę `uid=1000`, a poza tym, bez zmian w identyfikatorach użytkkowników. Natomiast `0 0 4294967295` znaczy odwzorowania tożsamościowe z uid w PNU na PNU drugiego. Ten plik jest początkowo pusty, i można zapisać **raz** by stworzyć odwzorowanie.

n.b. jest to odwzorowania z PNU tego procesu do PNU procesu czytającego. Zatem wynikia różnią się w zależności od procesu wywołującego `open("/proc/<pid>/uid_map", ...)`, który to plik jest globalnie czytelny. Nawet niekoniecznie którakolwiek z PNU musi być nadrzędny nad drugim!

# Przypisy

[0] https://github.com/nick0ve/how-to-bypass-aslr-on-linux-x86_64
