---
title: "gpg Notatki"
description: "Zgromadzone notatki o gpg"
date: 2023-11-20
tags: ["pl", "gpg", "cryptography"]
categories: ["Notes"]
---

# Powłoka gpg

`gpg --edit-key ${ID_LUB_UID_KLUCZA}`

Ważniejsze polecenia:

- `key $n`: Wybierz podklucz `n` (zostanie oznaczone gwiazdką)
- `expire`: zmień termin wygaśnięcia klucza

# Klucze

## Odcisk Palców Identyfikatory Klucza (ang. Fingerprint & Key id)

Odcisk palców ma długość `20 bajtów`

```
> gpg --list-key --keyid-format long xyz@fake.com
pub   rsa3072/E0ED4C0442476AEC 2021-06-17 [SC]
      89B21156B48C11140A2B27C8E0ED4C0442476AEC
uid          [   absolutne   ] psacawa <xyz@fake.com>
sub   rsa3072/41215F8465B266F2 2021-06-17 [E]
```

Id. klucza to ostatnie 8 bajtów (w przypadku `--keyid-format long`) lub 4 bajtow (w przypadku `--keyid-format short`) odciska _jedynie w przypadku klucza nadrzędnego_ (ang. master key, `pub/sec`). W przypadku podklucza `sub` aby wyświetlić id. klucza trzeba ręcznie podać opcję `--keyid-format long`.

Program terminala `file` odkryje klucz publicznego użyty do szyfrowania danych. Jest to długi identyfikator klucza:

```
> file xyz.gpg
xyz.gpg: PGP RSA encrypted session key - keyid: 41215F84 65B266F2 RSA (Encrypt or Sign) 3072b .
```

## Uchwyt Klucza (ang. keygrip)

N.b. Uchwyt klucza nie jest tym samym co odcisk klucza, mimo że tez liczy sobie 20 bajtów. Jest reprezentacją klucza niezależne od użytego protokołu (`gpg` lub `ssh`) [0]. Z tego powodu jest używany przez `gpg-agent` w trybie podszywania się pod `ssh-agent`.

## Wywołania

Zrzuć klucze powiązane z _głównym kluczem_ kontrolujący podklucz `0xDEADBEEF`:
`gpg --export-secret-subkeys 0xDEADBEEF`

Zrzuć tylko podklucz `0xDEADBEEF`:
`gpg --export-secret-subkeys 0xDEADBEEF!`

# Skorowidz

Typy klucza:

```
sec: 'SECret key'
ssb: 'Secret SuBkey'
pub: 'PUBlic key'
sub: 'public SUBkey'
```

```
ssb#: nie używalny podklucz
```

Użycie klucza

```
E: encryption
S: signing
C: certification
A: authentication
```

# gpg-agent

Tryb obsługi klientów `ssh`: `gpg-agent --enable-ssh-support`.

Prywatne klucze przechowane w `$GNUPGHOME/private-keys-v1.d/`. Te z ssh są tekstowe. Aby zmusić `gpg-agent` aby o nich zapomniał, można usunąć **ostrożnie!**.

<!-- TODO 10/11/20 psacawa: ssb# ? -->
<!-- TODO 10/11/20 psacawa:--export-secret-subkey makes unusable?  -->

- [0] https://blog.djoproject.net/2020/05/03/main-differences-between-a-gnupg-fingerprint-a-ssh-fingerprint-and-a-keygrip/
