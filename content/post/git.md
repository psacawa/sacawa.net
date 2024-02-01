---
title_pl: "Git Notatki"
title: "Git Notes"
description: "Zgromadzone notatki o Git"
date: 2023-07-31
tags: ["pl", "git"]
categories: ["Notes"]
---

# git clean

wymuś(f) usunięcie wszytkich nieśledzonych(x) plików w repo, łącznie z katalogami(d), oprócz jednego(e)

```
git clean -f -x -d -e build
```

# Podmoduły (submodules)

status ignorując podmoduły

```
git status --ignore-submodules
```

# Specyfikacja Rewizji

Diff jednego pliku jednej rewizji (specyfikować zakres składający się z jednej rewizji):

```
git diff '79e9e048^!' README.md
```

Wyszukiwanie rewizja na podstawie wyrażenia regularnego:

```
git show --name-only ":/^regex$"
```
