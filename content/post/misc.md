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

## youtube-dl

Śćiągnąć ścieżkę dźwiękową z Youtube, porządkując pliki względem kolejności:

```
youtube-dl -x -o "%(playlist_index)s - %(title)s.%(ext)s" "https://www.youtube.com/watch?v=xyz&list=abc"
```

Wypisz formaty z identyfikatorami i ściągnij wybrana rozdzielczość:

```
youtube-dl --list-formats https://www.youtube.com/watch?v=xyz
youtube-dl -f $id https://www.youtube.com/watch?v=xyz
```

Ściągnąć tylko napisy: [[1]][ref1]:

```
youtube-dl --all-subs --skip-download https://www.youtube.com/watch?v=xyz
```

Ściągnąć tylko autogenerowane napisy:

```
youtube-dl --sub-lang ru --write-auto-sub --skip-download https://www.youtube.com/watch?v=xyz
```

# Referencje

- [How to download only subtitles of videos using youtube-dl][ref1]

[ref1]:https://superuser.com/questions/927523/how-to-download-only-subtitles-of-videos-using-youtube-dl "https://superuser.com/questions/927523/how-to-download-only-subtitles-of-videos-using-youtube-dl"
