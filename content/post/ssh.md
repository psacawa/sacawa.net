---
title: "ssh Notatki"
description: "Zgromadzone notatki o ssh"
date: 2023-11-20
tags: ["ssh", "linux", "shell"]
categories: ["Notes"]
---
# ssh

Usunąć publiczny klucz serwera z pliku `known_hosts` kiedy ów się zmienia:

```
ssh-keygen -f "/home/psacawa/.ssh/known_hosts" -R "gitlab.sacawa.net"
```
