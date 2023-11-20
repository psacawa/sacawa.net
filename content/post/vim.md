---
title: "Vim Notatki"
description: "Zgromadzone notatki o (neo)?vim"
date: 2023-11-20
tags: ["pl", "vim"]
categories: ["Notes"]
---

# (Neo)Vim

## VimScript

Opcje jako zmienne: `let b:ft = &ft`

<!-- TODO 20/08/20 psacawa: finish this -->

## Wtyczki

### Ultisnips

Urywki (ang. snippets) z użyciem zastąpienia tekstu. Składnia `${<tab_stop_no/regular_expression/replacement/options}`. Pełne informacje w pomocniku Ultisnips pod hasłem `UltiSnips-transformations`. Patrz niżej przykład:

```
snippet qD "qDebug() << ..." b
q${2/.+/C/}Debug($2) << ${1:${VISUAL:"hallo"}};
endsnippet
```

Opcje dla urywków są opisane w podrozdziale `UltiSnips-transformations`. Najważnejsze to:

- `b`: Ekspansja jedynie na Poczatku wiersza
- `r`: wyrażenie regularne
- `w`: (z ang. word boundary) Pozwala na ekspansję kiedy `<tab>` jest poprzedzony dowolną granicą słowa. Domyślnie jest to dozwolone przy poprzedzającym odstęp.
- `i`: (z ang. in word) ekspansja wewnątrz słów
- `A` automatyczna ekspansja

## Autopolecenia i Autogroupy (ang. autocommand/autogroup)

````
augroup AutoZapisPlikGrupa
  autocmd TextChanged,InsertLeave * if &buftype == "" | write | endif
augroup END
```
By usunąć grupę, trzeba najpierw ręcznie usunąć autopolecenie w nim zawarte:

```
autocmd! AutoZapisPlikGrupa TextChanged,InsertLeave
augroup! AutoZapisPlikGrupa
```
````
