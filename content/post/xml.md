---
title_pl: "Notatki i XML/Xpath"
title: "Notes on XML/Xpath"
subtitle: ""
description: "Notatki i XML/Xpath"
date: 2024-02-10
image: ""
tags: ["pl", "xml",  "xpath"]
categories: ["Notes"]
---

# XML

<!-- TODO 10/02/20 psacawa: finish this -->

# Xpath

## Przykłady

Przeszukiwanie pierwszej kolumny tablicy. Odpowiednik `div:first-child` z CSS:

```
xmllint --html --xpath '//table//tr/td[1]/a/@href'  index.html
```

# xmllint

Też HTML:

```
xmllint --html --xpath $wzor $plik
```
