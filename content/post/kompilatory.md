---
title_pl: "Notatki o Kompilatorach"
title: "Compiler Notes"
subtitle: "Collected Compiler Notes"
description: "Opis"
date: 2024-04-29
image: ""
tags: ["pl", "c", "c++", "compilers"]
categories: ["Notes"]
---

# Teoria

Aho, Lem, Sethi, Ullman. 3 Wydanie.

# Narzędzia

## bison

- Stosuj `%define api.value.type variant` zamiast `union` dla aplikacji C++. 
- `%verbose` tworzy pliki `.output` wyjaśniające stany parsera.
- `%locations` potrzebne do zdefiniowania `YYLTYPE` jeśli symbole `@n` nie odnoszono się do nich jawnie .

### Pułapki 

Zasady gramatyki bez określonej akcji (np.  `expr: subexpr`)  ma domyślną akcję `{ $$ = $1; }`, skutkując błędem jeśli typy nie pasują do siebie. Skutkuje to ostrzeżeniem niby:

```
parser.y:36.5-8: ostrzeżenie: konflikt typu w domyślnej akcji: <char *> != <> [-Wother]
```

## flex

Trzeba dodać albo `%option noyywrap` albo definicję `int yywrap () {return 1; }` żeby się skompilowało.

