---
title_pl: "ssh Notatki"
title: "ssh Notes"
description: "Zgromadzone notatki o ssh"
date: 2023-11-14
tags: ["pl", "ssh", "linux", "shell"]
categories: ["Notes"]
---

# ssh

Usunąć publiczny klucz serwera z pliku `known_hosts` kiedy ów się zmienia:

```
ssh-keygen -f "/home/psacawa/.ssh/known_hosts" -R "gitlab.sacawa.net"
```

# ~/.ssh/config

Dwa możliwe typy bloków konfiguracji:

```
Match user ubuntu Host gitlab.sacawa.net
  Port 22

Host 192.168.0.157
  Hostname android
  Port 2222
```

Konfiguracja działa na zasadzie "pierwszy wygrywa", więc stawiamy ustawienia specificzne dla poszczególnych domen na początku, ustawienia domyślne na dole.
