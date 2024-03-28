---
title_pl: "SQL Notatki"
title: "SQL Notes"
description: "Zgromadzone notatki o SQL"
date: 2023-08-08
tags: ["pl", "sql", "postgres", "sqlite"]
categories: ["Notes"]
---

# SQL

## PostgreSQL

Eksport danych z `psql` jako CSV:

```
\copy kawiarnie TO '/home/psacawa/scratch/cpp-tmp/kawiarnie.csv' with (format 'csv')
```

## SQLite

Import danych z pliku CSV (trzeba ręcznie stworzyć tabelę):

```sql
create table kawiarnie (id integer  not null, nazwa text  not null,  opis text  not null
.mode csv
.import ./kawiarnie.csv kawiarnie
```

Względny czasy. E.g. wczoraj:

```sql
select date('now', '-1 day');
```

## Przykłady

### Stwórz kopię tablicy

```sql
CREATE TABLE onan_copy as select * from onan;
```
