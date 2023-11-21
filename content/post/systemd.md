---
title_pl: "systemd Notatki"
title: "systemd Notes"
description: "Zgromadzone notatki o systemd"
date: 2023-11-20
tags: ["pl", "systemd", "linux", "sysadmin"]
categories: ["Notes"]
---

# systemctl

Uaktualnij środowisko z którym jednostki zostaną uruchowmione:

```
# Uaktualnij tylko instancję systemd --user obecnego użytkownika
systemctl --user import-environment DISPLAY WAYLAND_DISPLAY SWAYSOCK

# Uaktualnij środowisko sesji dbus-daemon użytkownika (patrz też opcję --systemd)
dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK
```
