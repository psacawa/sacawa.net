---
title_pl: "ZSH Notatki"
title: "ZSH Notes"
description: "Zgromadzone notatki o ZSH"
date: 2023-07-26
tags: ["pl", "shell", "zsh", "linux"]
categories: ["Notes"]
---
## Tablice i Tablice Asocjacyjne

### Zwykłe Tablicy

```zsh
arr=(a b)
print -l $arr # a\nb
print -l "$arr" # a b
print -l "${(@)arr}" # a\nb
print -l "${arr[@]}" # a\nb
```

Operacje binarne na listach:

```zsh
# cześć współna dwóch list
${arr2:*arr1}
# różnica  dwóch list
${arr2:|arr1}
# zastrzeżenia: https://unix.stackexchange.com/questions/104837/intersection-of-two-arrays-in-bash
```

Filtrowanie tablic:

```zsh
Odfiltruj wzór glob od tablicy
path=(${path:#*pyenv*})
# filtruj wzór glob od tablicy
local_path=(${(M)path:#/usr/local*})
```

Rozdzielić wyjście polecenia do tablicy przez LF, repesktując odstępy:

```
IFS=$'\n' files=($(fd -d1))
# lub
files=("${(f)$(fd -tf)}")
```


Rozdziel uwzględniając gramatyka powłoki (tj. usuwając zbędne odstępy)

```
pids=("${(zf)$(ps -A o sid=)}")
```

Stosując ekspansję na tablic szeregowo, nie wmieszamy konwersję do łańcucha. Zatem

```zsh
echo ${(F)${cmds%*-15}#llvm-*} | wyst
# zamiast
echo ${${(F)cmds%*-15}#llvm-*} | wyst
```



### Tablice asocjacyjne

```zsh
typeset -A assoc assoc2
assoc=([ax]=1 [b]=2 [cx]=3 [d]=21 [2]=e)

# wybieranie kluczy/wartości
echo $assoc[(i)*x] # cx
echo $assoc[(I)*x] # cx ax
echo $assoc[(r)2] # 2
echo $assoc[(R)2*] # 2 21

# preciwobraz wartości
echo ${(k)assoc[(R)1]} # ax
echo ${(k)assoc[(R)*1]} # ax d

# ostatni wygrywa
echo ${(kv)assoc[(RI)2]} # 2 e

# iteracja nad tablicą, cudzysłowie oraz @ niezbędne
for k v in "${(@kv)assoc}"; do echo $k $v; done

# splątąć dwa listy do tablicy asocjacyjnej
typeset -A assoc # istotne
assoc=("${(@)arr1:^arr2}")

# "e" znaczy "exact", czyli pasowanie wzoru bez globowania
# czyli, sprawdź obecność argumentu w tablicy
foo () { if (($@[(Ie)-B])); then echo found; else; echo not found; fi }
```

## Globowanie

Filtrować listę przez wzorzec glob:

```
ls -d ${(R)fpath:#/usr/share*}
```

Globowanie plików wykonywalnych na `$path`

```
echo {^~path}/*(*)
```

Pochodzenie wszystkich plików wykonywalnych pasujących do globu:

```zsh
dpkg -S ${^~path}/*virt*(*N:A)| sort
```

Filtrowanie globa za pomocą dowolnego warunku:

```zsh
ls /usr/bin/*(e:'file $REPLY | grep python >/dev/null':)
```


glob na tablicę:

```
arr=(${:-/sys/module/*})
```

Glob nieuwzględniający wielkość liter. Niektóre kwalifikatory muszą wyprzedzać część wzorca

```
wl **/(#i)*txt
```

Kwalifikatory globów tylko na koniec globu. Przykład ekskluzji z kwalifikacją:

```
ls /usr/share/systemtap/tapset/**/*~*.stp(.)
```


## Uzypełnienia

### `_arguments`

Specyfikacje opjci jak `-f[force]:opis:` oczekuje parametr do argumentu, ale nie daje uzupełnienia. Opcja bez parametru opisujemy przez `-f[force]`. Zatem

```zsh
_arguments \
  '-f[force]' \
  '1: :_files' \
```

poprawnie uzupełnia `foo -f ^I` oraz `foo ^I`.


Szupełnienie pliki pasujące do globa:

```
_foo () { _arguments '-p[port]:port:_path_files -g /dev/\*\(%c\)' }
```


### Inne

Znaajdź opcję w liście argumentów `$words` i upewnij się że ma powiązany argument

```zsh
local -i idx=${words[(I)-B]}
if ((idx > 0 && idx + 1 <= $#words )); then
  cachefile="${words[((idx+1))]}/CMakeCache.txt"
  ...
fi
```

Zarządzanie deskryptorami plików:

```zsh
exec {myfd} < ./file
while read -u ${myfd} line; do # też read line <&${myfd};
    echo ${LINE}
done
exec {myfd}<&-
```

Przekierować jedynie stderr przez potokę:

```
LD_DEBUG=all =ls 2>&1 >&- >/dev/null | less
# w odróznieniu od basha, następujące nie działą
LD_DEBUG=all =ls 2>&1 >/dev/null | less
```

Liczby szesnastkowe - printf nalezy do libc:

```
echo $'\x41'
printf "%d" 0x41
```

