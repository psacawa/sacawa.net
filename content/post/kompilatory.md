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

Stosuj `%define api.value.type variant` zamiast `union` dla aplikacji C++.

## flex

Trzeba dodać albo `%option noyywrap` albo definicję `int yywrap () {return 1; }` żeby się skompilowało.

