---
title_pl: "Notatki bez Kategorii"
title: "Miscellaneous Notes"
subtitle: ""
description: "notatki bez kategorii"
date: 2024-02-08
tags: ["pl"]
categories: ["Notes"]
---

Śćiągnąć ścieżkę dźwiękową z Youtube, porządkując pliki względem kolejności:

```
youtube-dl -x -o "%(playlist_index)s - %(title)s.%(ext)s" "https://www.youtube.com/watch?v=xyz&list=abc"
```
