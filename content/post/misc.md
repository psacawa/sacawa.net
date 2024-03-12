---
title_pl: "Notatki bez Kategorii"
title: "Miscellaneous Notes"
subtitle: ""
description: "notatki bez kategorii"
date: 2024-02-08
tags: ["pl"]
categories: ["Notes"]
---

## ffmpeg

Przekonwertuj `[60, 60 + 2)` sek. z mp4 na gif. `-f gif` jawnie deklaruje typ celowy.

```
ffmpeg -ss 60.0 -t 2.0 -i calculator-recording.mp4 calculator-recording.gif
```

Długóść ścieżki dźwiękowej/wideo:

```
ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 input.mp4
```

## Różne

Śćiągnąć ścieżkę dźwiękową z Youtube, porządkując pliki względem kolejności:

```
youtube-dl -x -o "%(playlist_index)s - %(title)s.%(ext)s" "https://www.youtube.com/watch?v=xyz&list=abc"
```


