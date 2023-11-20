---
title: "Git Notatki"
description: "Zgromadzone notatki o Git"
date: 2023-11-20
tags: ["git"]
categories: ["Notes"]
---

## git clean

wymuś(f) usunięcie wszytkich nieśledzonych(x) plików w repo, łącznie z katalogami(d), oprócz jednego(e)

```
git clean -f -x -d -e build
```

## Podmoduły (submodules)

status ignorując podmoduły

```
git status --ignore-submodules
```
