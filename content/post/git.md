---
title_pl: "Git Notatki"
title: "Git Notes"
description: "Zgromadzone notatki o Git"
date: 2023-07-31
tags: ["pl", "git"]
categories: ["Notes"]
---

# git commit

`git commit --date=$data` ustawia datę autora. Aby natomiast ustawić datę rewizji, używamy następujące polecienie:

```
GIT_COMMITER_DATE=$data git commit
```

`$data` musi mieć *pełny* format ISO-8601. Obecny moment w tej postaci można uzyskać przez

```
date -u +%Y-%m-%dT%H:%M:%S%Z
```

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

Zakres czasowe rewizji (można):

```
git log '@{2 month ago}..@'
```
