---
title: "C++ Notatki"
description: "Zgromadzone notatki o C++"
date: 2023-11-20
tags: ["c++"]
categories: ["Notes"]
---
# Wszytko Wirtualne

## Wirtualna Baza

Odnosi się do wirtualnego dziedziczenia `class B: virtual A {...}` nie zaś do wirtualnych funckji. W hierarchii dziedziczenia, konstruktory są wywoływane w kolejności przechodzenie w głąb. W przypadku dzedziczenia z wirtualnych baz, te są konstruowane w pierwszyej kolejności.

## Podchwytliwe Rzeczy

### Niezdefiniowane odniesienie do Wirtualnej Tablicy

```
/usr/bin/ld: CMakeFiles/demo.dir/demo.cpp.o: in function `Counter::Counter()':
demo.cpp:(.text._ZN7CounterC2Ev[_ZN7CounterC5Ev]+0xf): undefined reference to `vtable for Counter'
/usr/bin/ld: CMakeFiles/demo.dir/demo.cpp.o: in function `StepCounter::StepCounter(int)':
demo.cpp:(.text._ZN11StepCounterC2Ei[_ZN11StepCounterC5Ei]+0x22): undefined reference to `vtable for StepCounter'
```

Błąd konsolidatora. Kompilator nie narzeka. Standard wymaga definicji wszystkich wirtualnych nieabstrakcyjnych metod, które są zdefiniowane. Zwykle ten błąd wynika z deklaracji destruktorów bez odpowiedniej definicji. [0]

[0] https://gcc.gnu.org/faq.html#vtables

### Konstructor kopiujący a przypisanie z przenoszeniem

```
C c1;
C c2 = c1 # konstruktor kopiujący
C c3;
c3 = c1 # przypisanie
```

### Domyślne argumenty dla konstruktora

Zwykle uważamy domyślne argumenty metod jako część implementacji, zatem definicji. Jednak, dla konstruktorów, obecność domyślnych argumentów zmienia ich klasyfikację względem bycia domyślnymi konstruktorami, a zatem ta informacja musi być włączona w deklarację, w nagłowku. Zatem:

```cpp
# foo.h
class Foo {
  Foo(int n = 0);
  void method(int n);
}
# foo.cpp
Foo(int n) {}
void Foo::method(int n = 0) {}
```

## Incjalizacja

- domyślna incjalizacja
- bezpośrednia incjalizacja
- zagregowana incjalizacja
- incjalizacja przez kopię
- incjalizacja przez listę
- incjalizacja przez przenoszenie

# Nazwane Wymagania

- DefaultConstructible
- MoveConstructible
- CopyConstructible

# Klasy

Metody klas mogą mieć cv-kwalifikatory, które wpływają na typ metody, a co za tym idzie, biorą udział w rozwiązywaniu przeciążeń funkcji.

Statyczne członki muszą być zdefiniowane poza deklaracją klasy.

# Referencje

_Referencja przekierująca_ (ang. forwarding) to to parametr funckji którego typ to r-wartość referencja do paramteru szablonowego bez cv-klawifikacji. Może być przekierowana przez `std::forward` przesunięcie bez kopiowania.

# Wątki (ang. Threads)

Aby podawać struktury jako argumenty przez referencję do procedur wątków, trzeba je owijać w `std::ref`:

```cpp
struct Box {
  int num_things;
};

void transfer(Box &from, Box &to, int num) {
  ...
}

int main () {
  Box acc1(100);
  Box acc2(50);
  std::thread t1(transfer, std::ref(acc1), std::ref(acc2), 10);
  std::thread t2(transfer, std::ref(acc2), std::ref(acc1), 5);
  ...
}
```

# ABI

## Konstructory Globalnych Instancji Klas

Ekperymentując z `clang++` (dla `g++` jest podobnie), stwórz globalną klasę: `map<string, string> m` w `main.cpp`. Wtedy mamy następujące wyjście powłoki:

```
> readelf -x .init_array main

Hex dump of section '.init_array':
  0x00007d80 f0250000 00000000 00260000 00000000 .%.......&......
  0x00007d90 00250000 00000000                   .%......
```

Tę wartości są adresami pewnych symboli:

```
> readelf -s main
...
    26: 0000000000002500    16 FUNC    LOCAL  DEFAULT   15 _GLOBAL__sub_I_main.cpp
...
    33: 00000000000025f0     0 FUNC    LOCAL  DEFAULT   15 frame_dummy
...
   133: 0000000000002600    27 FUNC    GLOBAL DEFAULT   15 _Z6myinitv
...
```

Pierwszy z tych adresów jest adresem pewnej symboli `_GLOBAL__sub_I_main.cpp` którą dotyczy konstruktorów. Zrzut kodu maszynowego:

```
> objdump --disassemble=_GLOBAL__sub_I_main.cpp main
...
0000000000002500 <_GLOBAL__sub_I_main.cpp>:
    2500:       55                      push   rbp
    2501:       48 89 e5                mov    rbp,rsp
    2504:       e8 67 fd ff ff          call   2270 <__cxx_global_var_init>
    2509:       e8 92 fd ff ff          call   22a0 <__cxx_global_var_init.1>
    250e:       5d                      pop    rbp
    250f:       c3                      ret
```

`__cxx_global_var_init` i `__cxx_global_var_init.1` konstruują globalne obiekty (`iostream` etc.)

Drugi adres `0x2600` był konstruktorem `__attribute__((constructor))`... Trzeci `0x250f` natomiast adresem małej funckji która nie jest do konća rozumiana:

```
> objdump --disassemble=frame_dummy main
...
0000000000002580 <frame_dummy>:
    2580:       f3 0f 1e fa             endbr64
    2584:       e9 77 ff ff ff          jmp    2500 <register_tm_clones>
```

Wniosek: w konstruktorach typu `__attribute__((constructor))`, globalne zmienne które są klasami nie są gotowe.

# Inferencja Typów (auto/decltype)

## decltype

Wskaźnik do funkcji z `decltype`:

```
int square(int x) { return x * x; }
...
decltype(square) *square_ptr = square;
int nine =  square_ptr(3);
```

## STl

### Biblioteka Algorytmów `<algorithm>`

#### Filtrowanie z `copy`, `copy_if` etc.

Wektor docelowy nie będzie rozszerzony dynamicznie. Albo upewni się zę jest wystarczająco miejsca, albo użyj `std::back_inserter` (`<iterator>`):

```c++
vector<int> in = {1,2,3,4,5};
vector<int> out;
std::copy_if(in.begin(), in.end(), std::back_inserter(out), [](int x) { return x % 2;});
```

<!-- TODO 14/08/20 psacawa: finish this -->

# ABI Itanium

## Generowany Kod

Wszytkie jest jakoby rozszerzien interfejsu wywołania SysV amd64, czyli np. mamy parametry w rejestrach `rdi`, `rsi`, `rdx`, `rcx`, `r8`, `r9`, potem na stosie. Wartość zwrotna w `rax`. Metody mają ukryty pierwszy parametr, którym jest wskaźnik `this` w `rdi`. Konstructory i destruktory nie mają wartości zwrotnej (`void`). Pierwszy (ukryty) parametr konstruktora to adres gdzie ma być skonstruowane obiekt.
