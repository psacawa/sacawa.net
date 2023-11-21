---
title_pl_: "CMake Notatki"
title: "CMake Notes"
description: "Zgromadzone notatki o CMake"
date: 2023-11-20
tags: ["pl", "cmake", "c++"]
categories: ["Notes"]
---

### Wskazówki

Debugowanie wyszukiwanie modułów (nieudokementowana zmienna):

```
cmake -B build -DCMAKE_FIND_DEBUG_MODE=1
```

Wypisz wszystkie właściwości cmake:

```cmake
get_cmake_property(_variable_names VARIABLES)
list (SORT _variable_names)
foreach (_variable_name ${_variable_names})
    message(STATUS "${_variable_name}=${${_variableName}}")
endforeach()
```

Zapobiegaj kompilacji w katalogu z kodem źródłowym:

```cmake
if(${CMAKE_SOURCE_DIR} STREQUAL ${CMAKE_BINARY_DIR})
  message(
    FATAL_ERROR
      "In-source builds not allowed! Create a build directory and run CMake from there. "
  )
endif()
```

Kontrolowanie położenie jednego pakietu: jeśli to wywołanie `find_package` ma type modułu "find", to można kontrolować zmienną `CMAKE_MODULE_PATH`. To nie działa jeśli stosujemy tryb konfiguracji `find_package`. W tym prypadku możemy pomijąć normalną kolejność wyszukiwania poprzez zmienne `<NazwaPakietu>_ROOT`. Czyli w `CMakeLists.txt` mamy

```cmake
find_package(Qt6 REQUIRED COMPONENTS Core Gui Widgets)

```

Na linii poleceń wywołujemy:

```
cmake \
  -B build-with-local-qt-6.7  \
  -DQt6_ROOT=/usr/local/Qt-6.7.0
```

Było obserwowane że dodanie nowego pliku źródłowego do `add_executable` przyczyniło się błędu że nie można było odnaleźć symboli `main`...

# Instalacja Projektu

Instalacja: `sudo cmake --install ${build-dir}`

Można odinstalować projekt poleceniem `sudo xargs rm < ${build-dir}/install_manifest.txt`. Ostrożnie z `sudo rm`!

# Testowanie z CTest

Trzeba ręcznie wyznaczyć katalog kompilacji: `ctest --test-dir build`

Przykład z kopowaniem skryptu jako cel żeby użyć go do uruchomienia testów:

```cmake
add_custom_target(ProcessLoadedLib.sh ALL
                  COMMAND cp "${CMAKE_SOURCE_DIR}/tests/ProcessLoadedLib.sh" .)

add_test(NAME "Dynamic probe of calculator-qt5"
         COMMAND ./ProcessLoadedLib.sh --lib libtetradactyl-qt5 --
                 $<TARGET_FILE:tetradactyl> $<TARGET_FILE:calculator-qt5>)
set_tests_properties("Dynamic probe of calculator-qt5"
                     PROPERTIES LABELS "dynamic runs-gui")
```

# Poszczególne Instrukcje

## cmake_parse_arguments

Stosujemy wyłącznie formę `PARSE_ARGV`, po to by móc podawać listy `"a;b;c"` jako argumenty.

```
cmake_parse_arguments(PARSE_ARGV 0 TEST_OPT "option_arg1;option_arg2" LABELS "multi_arg1;multi_arg2")
set_tests_properties(some_test PROPERTIES LABELS "${TEST_OPT_LABELS}")
```

# PkgConfig

Przykład:

```cmake
macro(pkg_config_add_to_target _target _prefix)
  target_link_libraries(${_target} PRIVATE ${${_prefix}_LINK_LIBRARIES})
  target_link_directories(${_target} PRIVATE ${${_prefix}_LIBRARY_DIRS})
  target_include_directories(${_target} PRIVATE ${${_prefix}_INCLUDE_DIRS})
endmacro()

find_package(PkgConfig)

pkg_check_modules(GLIBMM glibmm-2.68)
pkg_config_add_to_target(mytarget GLIBMM)
```
