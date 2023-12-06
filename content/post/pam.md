---
title_pl: "Sudo Notatki"
title: "Sudo/PAM Notes"
description: "Zgromadzone notatki o Sudo/PAM"
date: 2023-08-29
tags: ["pl", "sudo", "pam"]
categories: ["Notes"]
---

# Sudo

## /ets/sudoers

Podstatowa struktura specyfikacji użytkownika to `<kto> <gdzie> = (<w jakiej roli>) <co>`. Zatem 

```
# użytkownik  host  rola  polecenie
%admin        ALL = (ALL) ALL
```

znaczy że użytkownicy w grupie `admin` może uruchomić dowolne polecenie na dowolnym hoście jako dowolny uid.

### Aliasy

```
Cmd_Alias EDITORS = /bin/vim, /bin/nvim
```

### Przykłady

Użycie aliasa, pozwala użytkownikowi uruchomić polecenie bez możliwości forkowania.

```
user1 ALL = NOEXEC: EDITORS
```
