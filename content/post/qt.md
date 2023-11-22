---
title_pl: "Qt Notatki"
title: "Qt Notes"
description: "Zgromadzone notatki o Qt"
date: 2023-11-20
tags: ["pl", "qt", "c++", "gui"]
categories: ["Notes"]
---

## Widżety

### Układ (ang. Layout)

Z jakiejś przyczyny(sygnały), niektóre wywołania zmiany układu nie działaja.

```c++
button->setLayout(layout); \\ błąd: puste okno
layout->addWidget(button); \\ działa
```

## Okna

### Typ okna (ang. window type)

Jest parę podstawowych wartości dla `QWidget::windowType() == QWidget::windowFlags() & Qt::WindowType_Mask`:

- `Qt::Widget`: zwykły widżet który ma rodzica
- `Qt::Window`: widżet który jest oknem `w->isWindow() := w->windowType() & Qt::Window`. Nie musi być sierotą, ale tak zwykle jest.
- `Qt::Dialog`: okno które będzie dekorowane jak dialog `QDialog`. `QMenu`
- `Qt::Popup`: okno które będzie dekorowane jak dialog `QDialog`. Nie do końca muśi być sięrotą.
- `Qt::Tool`: pasek narzędzi `QToolBar` odłączone od menu staje się takim oknem.
- `Qt::ToolTip`: ...
- `Qt::SubWindow`: dla MDI

Pozostałe wartości są mało ważne. Ważnym punktem jest to że okna nie do końca muśi być sięrotami, ale mogą nimi być.

### Aktywność

<!-- TODO 25/09/20 psacawa: finish this -->

### Widoczność

Są dwa właściwości które należy odróżnić: `visible` i `hidden`. `isHidden` pociąga za sobą `!isVisible`, ale choćby dzieci niewidocznych widżetów mają jednocześnie `isHidden` i `isVisible`.

Domyślinie widżet są widoczne. Metody `show`, `hide` są namiastkami `setVisible`. W większośći przpdadkow...

<!-- TODO 17/09/20 psacawa: finish this -->

## Obiekty QObject

Jest błędem stworzyć przed stworzeniem aplikacji. [Dlaczego?]

### Sygnały i Gniadza (ang. Slots)

#### Połączenia

Każde wywowłanie `QObject::connect` może przyjąć opcjonalny parametr `Qt::ConnectionType type`, który ma domyślną wartość `Qt::AutoConnection`.

W przypadku bezpośrednich połączeń `Qt::DirectConnection`, gniadza podłączone do wyemitwonych sygnałów są wykonywane synchronicznie w wątku nadawcy sygnału.

W przypadku `Qt::QueuedConnection`, gniazdo jest kolejkowane w pętli zdarzeń wątku odbiorcy sygnału (również kiedy jest to watęk nadawcy). W miejscu wyemitowania sygnału, gniazda nie są wykonane.

Domyślny przypadek `Qt::AutoConnection` zachowuje się jak `DirectConnection` jeśli nadawca i odbiorca należą do jednego wątku, inaczej zachowanie jest identyczne jak połączenie kolejkowane.

Pseudokluczowe słowo jest implementowane w preprocesorze jako no-op `#define emit`, zatem następujące są równoważne:

```c++
emit foo();
foo();
```

W przypadku ogólnych połączeń, jak kompilator zapobiega synchroniczne wykonanie gniazdek na miejscu emitowania sygnału, które przecież w świetle wyższego, jest zwykłym wywołaniem funkcji? Kompilator meta-obiektu zmienia deklaracje signału następująco:

```c++
# probe.h
...
signals:
    void objectDestroyed(QObject *obj);
...

# moc_probe.cpp
// SIGNAL 3
void GammaRay::Probe::objectDestroyed(QObject * _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 3, _a);
}

```

`QMetaObject::activate` jest odpowiedzialne za wywołania gniazda lub kolejkujowanie sygnału w zależności od typu połączenia.

#### Postacie Wywołania `connect`

Wskaźniki do metod QObjectów:

```c++
QObject::connect(button, &QPushButton::clicked, app &QApplication::quit);
```

Do "funktora", łącznie z domknięciem:

```c++
QObject::connect(button, &QPushButton::clicked, foo_func);
QObject::connect(button, &QPushButton::clicked, []() { ... });
```

Z łancucha do łancucha:

```c++
QObject::connect(button, SIGNAL("clicked"), app, SLOT("quit"));
```

Możliwe też połączenie sygnału do sygnału.

### Uwagi Dotyczące Użycia Sygnałow

Wskaźniki do `QObject`ów trzeba ręcznie schwycić przez wartość `[=] {...}` a nie przez referencję.

`QObject::sender()` pozwala uzyskać dostęp do nadawcy z gniazda. Może być używany z domknięciami pod warunkiem że schwycimy `this`[5]. Patrz przykład:

```c++
# "this" to dowolny(?) QObject
auto handler = [this] { qInfo() << this->sender() << this->sender()->parent(); };
QShortcut *aShortcut = new QShortcut(QKeySequence(Qt::Key_A), this);
connect(aShortcut, &QShortcut::activated, this, handler);
```

`QObject::connect` nie jest bezpiecznym interfejsem z perspektywy typów.

<!-- TODO 13/08/20 psacawa: wytłumacz -->

#### Implementacja

<!-- TODO 21/08/20 psacawa: uwagi dotyczące wdrażania własnego QObiektu ze sygnałami/gniazdami -->

Sygnały muszą zwracać `void`, natomiast gniazda mogą mieć wartości zwracania. Są porzucone chyba że gniazdo zostało wywolane[6].

Deklaracje sygnałów są poprzedone makrem `signals:` -> `Q_SIGNALS` -> `public ...` co czyni je publicznymi metodami QObiektu. Od Qt5, nie ma chronionych (ang. protected) lub prywatnych sygnałow. Gniadza notomiast mogą być publiczne, chronione, lub prywatne: pisz e.g. `protected slots:`.

Jest jednak pojęcie "prwyatnych sygnałow" którę zasługuje na wzmiankę, jednak jest to trochę inne. Sygnały zadlekarowane z ostatnim argumentem `QPivateSignal`. E.g. w `QProcess` mamy:

```c++
Q_SIGNALS:
  void readyReadStandardOutput(QPrivateSignal);
```

Te metody są, jak zwykle, publicznymi metodami klasy do których można podpiąć gniazda, jednak tylko ta klasa może je emitować. Czyli, nie wolno ich emitować z klas dziedziczonych po `QProcess` (nie będziesz mógł konstruować `QPrivateSignal`, który jest naprawdę prwyatny).

Sygnały nie mogą byc wirtualne. Nie byłoby z tego pożytku. Kompilator jednak to zaakceptuje ostrzeżeniem:

```c++

AutoMoc: /home/psacawa/scratch/QT/tmp/counter.h:25:1: warning: Signals cannot be declared virtual

```

Gniadza mogą być być wirtualne i jest to idiomatyczne. Patrz e.g. `virtual void QWidget::setVisible(bool)`.

Sygnały oraz gniazda mogą mieć domyślne argumenty. Jednak aby z nich korzystać z nowym, bezpieczniejszą składnią `connect`, należy pośrzedniczyć pomiędzy sygnałem a gniazdem domknięciem[7]:

```c++
signals:
    void valueChanged(float value);
...

public slots:
    void onValueChanged(float value, int defaultArg = 123);
....

connect(this, &MyClass::valueChanged, [this](float value){ onValueChanged(value); });

```

### Meta-obiekty

`CMake` jest wystarczająco sprytne by kompilować kod metaobiektów naszych QObjectów w oddzielnych jednostkach translacji, pod dwoma warunkami:

1. Opcja `CMAKE_AUTOMOC` jest włączona (nie `AUTOMOC`!) Jęśli ten warunekn ie będzie spełnione, objawi się to słynnym ostrzeżeniem o niegenerowaniu symboli dla wirtualnej tablicy. n.b. Też może to oznaczyć że plik źródłowy nie został podany do `add_executable()`.

2. Każdy `QObject` jest kompilowany we własnej jednostce translacji. Inaczj widnieje taki oto błąd:

```
AutoMoc error
-------------
"SRC:/kawiarnie.cpp"
contains a "Q_OBJECT" macro, but does not include "kawiarnie.moc"!
Consider to
  - add #include "kawiarnie.moc"
  - enable SKIP_AUTOMOC for this file
```

#### Przetwarzanie celów AUTOMOC w CMake

Patrz [8]. Podczas konfiguracji dla danego celu `x` CMake, zbieramy listę plików nagłówkowych do przetwarzania. Są to:

- pliki źródłowe celu jawnie zadlekarowane
- `<źródło>.h` oraz `<źródło>_p.h` dla każdego `<źródło>.cpp` pośród plików źródłowych.

<!-- TODO 29/08/20 psacawa: dokończ opis -->

_Uwaga_: `moc` zdaje się przetwarzać pliki źrodłowe oraz nagłówkowe pod warunkiem że zawierają hasło `#include "<...>.moc"` oraz zawierają jakiekolwiek wzorce z `AUTOMOC_MACRO_NAMES`, czyli `Q_OBJECT;Q_GADGET;Q_NAMESPACE;Q_NAMESPACE_EXPORT`. Jednak jeśli w jednostce translacji będzie e.g. `Q_NAMESPACE` a zabraknie `Q_OBJECT`, to `moc` będzie narzekać o braku QObiektu...

<!-- TODO 29/08/20 psacawa: opisz sposób organizacja plików nagłówkowych -->

Patrz [3,4].

## Zdarzenia (QEvent)

Przesyłane do odbiorników poprzew wywowłanie `virtual void event(QEvent *e)`. Podklasy `QWidget` zwykle wybierają te podklasy `QEvent` (przez `event->type()`) które chcą zjeść (jak kliknięcnie w nieaktywny przycisk), niekoniecznie je obsługując. W przeciwnym razie, oddelegują zdarzenie do klasy rodzica. Dopiero `QWidget::event` wywołuje poszczególne procedury obsługi `mouseMoveEvent`, `mouseButtonPress`.

Przed tym jak stają się `QEvent`ami, zdarzenia są `QWindowSystemInterfacePrivate::WindowSystemEvent`. Pierwszy argument `receiver` jest wybierany z `QGuiApplicationPrivate::processWindowSystemEvent` oraz powiązanie podrutyny, e.g. `processKeyEvent`. Zawsze(?) jest to albo jakaś podklasa `QWindow` lub `QCoreApplication`. Tu też są tworzenie odpowiednie podklasy `QEvent`, e.g. `QKeyEvent` (patrz ślad stosu).

Gdzie indziej są one generowane? W `QGuiApplication`, `QApplication` generuje się pewne zdarzenia typowe dla GUI. (wyszukaj `sendEvent|postEvent`). Przykłady: menu kontekstowe, okna MDI, menedżery gestów, `QEvent::ReadOnlyChange`, `QMoveEvent` , etc.

Aby przechwycić zdarzenia, wygodnie jest dziedziczyć `QGuiApplication` następująco:

```c++
class MyApplication : public QApplication {
  Q_OBJECT
public:
  using QApplication::QApplication;
  virtual ~MyApplication() {}
  bool notify(QObject *obj, QEvent *e) override {
    QKeyEvent *kev = dynamic_cast<QKeyEvent *>(e);
    if (kev != nullptr) {
      qInfo() << e << obj;
    }
    return QApplication::notify(obj, e);
  }
}
```

### Filtry Zdarzeń

Są one przesyłane przez `QApplicationPrivate::notify_helper`. Należy zwrócić uwagę na to że filtry przyłączone do instancji `QCoreApplication` zostaną uruchomonione dla _każdego_ zdarzenia bez wyjątku, nie tylko te przesyłane do tej instancji. Filtry globalne (od aplikacji) zostają uruchomonione przed filtrami na innych QObiektach. Zdarzenia wysłane do aplikacji samej jako specjalny przypadek są uruchomonione tylko raz.

Aby było jasne, są trzy odbrędne pojęcia o zdarzeniach:

- "Filtrowane" przez jakiś `eventFilter` (wartość zwrotna `true`)
- "Akceptowane" (też ang. _consumed_) przez widżet (wywołał `ev->accept()`). Domyślnie zdarzenia są akceptowane, ale choćby `ShortcutOverride` są domyślnie konstruowane jako ignorowane.
- "Uświadomione" (ang. _notified_), czyli wartość zwrotna `QApplication::notify` oraz `QApplication::sendEvent`.

To właśnie `QApplication::notify` implementuje bąbelkowanie zdarzeń z celu wzgórz. W skrócie, dla każdego napotkanego widżetu, wywołuje `notify_helper`, które zwraca (zdarzenie filtrowane przez ten widżet || zdarzenie akceptowane przez ten widżet). Jeśli ta wartość jest `true` tą wartość jest zwrócona z `notify`. W przeciwnym razie, to kontynuujemy wzgórz. Zatem zdarzenie jest uświadomiona jeśli którekolwiek wywołanie `notify_helper` zwróciło `true`.

### QKeyEvent

Przykład z naciśnięcia klawiszy:

```
QKeyEvent(ShortcutOverride, Key_F, text="f") QWidgetWindow(0x561d36673460, name = "MyMainWindowClassWindow")
QKeyEvent(ShortcutOverride, Key_F, text="f") MyPushButton(0x561d366611f0)
QKeyEvent(KeyPress, Key_F, text="f") QWidgetWindow(0x561d36673460, name = "MyMainWindowClassWindow")
QKeyEvent(KeyPress, Key_F, text="f") MyPushButton(0x561d366611f0)
QKeyEvent(KeyRelease, Key_F, text="f") QWidgetWindow(0x561d36673460, name = "MyMainWindowClassWindow")
QKeyEvent(KeyRelease, Key_F, text="f") MyPushButton(0x561d366611f0)
```

`ShortcutOverride` jest generowane po to by pozwolić widżetow przechwycić pewne zdarzenia klawiszowe które w przeciwnym razie wyzwoliłyby skrótów by je zaakctować w pierwszej kolejności. Zdarzenie wycelowane w `QWindow` są generowane w `QGuiApplicationPrivate::processKeyEvent`: okno można przechwycić zdarzenia.

### Przykłady śladów stosu dostarczeń zdarzeń

Wciśnięcie klawiszy dostarca zdarzenie do widżetu ze skupieniem (`QPushButton`).

```
- [0] QPushButton::keyPressEvent(QKeyEvent*)+0 at widgets/widgets/qpushbutton.cpp:420
- [1] QWidget::event(QEvent*)+603 at widgets/kernel/qwidget.cpp:9006
- [2] QAbstractButton::event(QEvent*)+199 at widgets/widgets/qabstractbutton.cpp:931
- [3] QPushButton::event(QEvent*)+51 at widgets/widgets/qpushbutton.cpp:683
- [4] QApplicationPrivate::notify_helper(QObject*, QEvent*)+141 at widgets/kernel/qapplication.cpp:3287
- [5] QApplication::notify(QObject*, QEvent*)+1149 at widgets/kernel/qapplication.cpp:2715
- [6] QCoreApplication::notifyInternal2(QObject*, QEvent*)+202 at corelib/kernel/qcoreapplication.cpp:1121
- [7] QCoreApplication::forwardEvent(QObject*, QEvent*, QEvent*)+36 at corelib/kernel/qcoreapplication.cpp:1136
- [8] QWidgetWindow::handleKeyEvent(QKeyEvent*)+91 at widgets/kernel/qwidgetwindow.cpp:669
- [9] QWidgetWindow::event(QEvent*)+352 at widgets/kernel/qwidgetwindow.cpp:234
```

Ślad stosu przed `QApplication::notify` dla `KeyPressEvent` na platformie `xcb`:

```backtrace
#0  QApplication::notify (this, receiver, e) at widgets/kernel/qapplication.cpp:2572
#1  QCoreApplication::notifyInternal2 (receiver, event) at corelib/kernel/qcoreapplication.cpp:1118
#2  QCoreApplication::sendSpontaneousEvent (receiver, event) at corelib/kernel/qcoreapplication.cpp:1550
#3  QGuiApplicationPrivate::processKeyEvent (e) at gui/kernel/qguiapplication.cpp:2425
#4  QGuiApplicationPrivate::processWindowSystemEvent (e) at gui/kernel/qguiapplication.cpp:2054
#5  QWindowSystemHelper<QWindowSystemInterface::SynchronousDelivery>::handleEvent<QWindowSystemInterfacePrivate::KeyEvent, QWindow*, unsigned long, QEvent::Type, int, QFlags<Qt::KeyboardModifier>, unsigned int, unsigned int, unsigned int, QString, bool, unsigned short> () at gui/kernel/qwindowsysteminterface.cpp:105
#6  handleWindowSystemEvent<QWindowSystemInterfacePrivate::KeyEvent, QWindowSystemInterface::SynchronousDelivery, QWindow*, unsigned long, QEvent::Type, int, QFlags<Qt::KeyboardModifier>, unsigned int, unsigned int, unsigned int, QString, bool, unsigned short> () at gui/kernel/qwindowsysteminterface.cpp:138
#7  QWindowSystemInterface::handleShortcutEvent (window, timestamp, keyCode, modifiers, nativeScanCode, nativeVirtualKey, nativeModifiers, text, autorepeat, count) at gui/kernel/qwindowsysteminterface.cpp:458
#8  QGuiApplicationPrivate::processKeyEvent (e) at gui/kernel/qguiapplication.cpp:2406
#9  QGuiApplicationPrivate::processWindowSystemEvent (e) at gui/kernel/qguiapplication.cpp:2054
#10 QWindowSystemInterface::sendWindowSystemEvents (flags) at gui/kernel/qwindowsysteminterface.cpp:1094
#11 xcbSourceDispatch (source) at plugins/platforms/xcb/qxcbeventdispatcher.cpp:57
#12 g_main_dispatch (context) at ../glib/gmain.c:3476
#13 g_main_context_dispatch_unlocked (context) at ../glib/gmain.c:4286
#14 _unlocked (context, block, dispatch, self) at ../glib/gmain.c:4351
#15 g_main_context_iteration (context, may_block) at ../glib/gmain.c:4416
#16 QEventDispatcherGlib::processEvents (this, flags) at corelib/kernel/qeventdispatcher_glib.cpp:393
#17 QXcbGlibEventDispatcher::processEvents (this, flags) at plugins/platforms/xcb/qxcbeventdispatcher.cpp:96
#18 QEventLoop::processEvents (this, flags, flags@entry) at corelib/kernel/qeventloop.cpp:100
#19 QEventLoop::exec (this, flags) at corelib/global/qflags.h:34
#20 QCoreApplication::exec () at corelib/global/qflags.h:74
#21 QGuiApplication::exec () at gui/kernel/qguiapplication.cpp:1908
#22 QApplication::exec () at widgets/kernel/qapplication.cpp:2566
#23 main (argc, argv) at /home/psacawa/scratch/QT/tmp/main.cpp:69
```

### Skróty: QKeyEvent oraz QShortcutEvent

Tworzenie skrótu `QShortcut` powoduje dodanie go globalnej prywatnej tablicy `QShortcutMap` (patrz `src/gui/kernel/qshortcutmap.cpp`), którego zadaniem jest przetzymywanie obecny stan wieloklawiszowych skrótów oraz decydowanie czy zmienić dany `QKeyEvent` otzymany z platformy w `QShortcutEvent`. Robi to swoich metodach `tryShortcut`, `dispatchEvent`. Interfejs (wyłącznie statyczna klasa) `QWindowSystemInterface` z metodą `handleShortcutEvent` ma z tym też do czyniena.

## Implementacja PIMPL

Qt używa wzorzec wskaźnika do Implementacji, np. dla widżetu `QPushButton` mamy towarzyszącą klasę `QPushButtonPrivate`. Te klasy prywatne tworzą równoległą hierarchię dziedziczenia klas względem hierarchia podklas `QObject`. Ta stategia oszczędza `malloc`i. Patrz [0] oraz [1].

Aby uzyskać dostęp do d-wskaźnika w metodach, użyj makro `Q_D(type)`. Np.:

```
void Label::setText(const String &text)
{
    Q_D(Label);
    d->text = text;
}
```

`Q_Q` jest podobne, ale daje dostęp również do metod publicznej klasy (e.g. Label) ze wskaźnika `q`.

Implementacja wygląda następująco (patrz `corelib/global/qtclasshelpermacros.h`):

```
#define Q_D(Class) Class##Private * const d = d_func()
#define Q_Q(Class) Class * const q = q_func()
```

Skupiając się na `d_func` i uprzasczając, wygladą następująco:

```c++
#define Q_DECLARE_PRIVATE(Class) \
    inline Class##Private* d_func() noexcept \
    {  \
      return reinterpret_cast<Class##Private *>(qGetPtrHelper(d_ptr)); \
    } \
```

To makro jest zamieszczone w definicji klasy. Natomiast w definicji `QObject` mamy `QScopedPointer<QObjectData> d_ptr;`. `QObjectData` to taki dziwna klasa w którym gromadzą się kapiące szczegóły implementacji różnych klas. Atrybutem przy offsecie 0 w `QObjectData` to `q_ptr` które jest właśnie przeinterpretowane jako `KlasaPrivate*`. `d_func` zwraca to przeinterpretację. `QObjectData` udostępnia `dynamicMetaObject`.

<!-- TODO 20/08/20 psacawa: opisz `QDynamicMetaObjectData` itp. -->

## Zasoby

Przykład:

```xml
<!-- resourses.qrc -->
<RCC>
  <qresource prefix="/tetradactyl">
    <file>hints.css</file>
  </qresource>
</RCC>
```

```cpp
// main.cpp
QFile hintsCss(":/tetradactyl/hints.css");
// QFile hintsCss("qrc:/tetradactyl/hints.css"); błąd
hintsCss.open(QIODevice::ReadOnly);
QString stylesheet = hintsCss.readAll();

```

## CMake

Aby używać prywatne nagłówki, należy odpowiednio skonfiguromać `CMakeLists.txt`. Trzeba wiązać z wirtualnym celem zdefiniowanym przez projekt QT który udostępnia prywatne nagłówki (patrz `cmake/QtPriHelpers.cmake`):

```cmake
add_executable(
  qt-program
  qt-program.cpp)

target_link_libraries(qt-program PRIVATE Qt6::Core)
target_link_libraries(qt-program PRIVATE Qt6::CorePrivate)
```

## QtSQL

<!-- TODO 11/08/20 psacawa: finish this -->

## QtCore

### Logowanie

`QT_LOGGING_RULES`, `QT_LOGGING_CONF` ustawiają logowanie. Gwiazdki globowanie mogą być tylko na początku/końcu kategorii.
Reguły mają postać `<kategoria>[.<poziom>]=["true"|"false"]`. Konstrukcja jak `"<kategoria>.*=false"` by wyłączyć kategorię całkowicie nie dzialają. Zamiast nich posz `<kategoria>=false`. Nie piszemy `<kategoria>=0|1`, musi być "false" lub "true". Konfiguracja poziomów nie podlega kaskadzie: `my.log.cat.info=false` nie wyłącza dla tej kategorii poziom `debug`.

### Wielowątkowość (QThread)

Dziedziczymy `QThread` i implementujemy `run()`. Ale pamietamy o koniecznośći wywołania `QThread::exec()` (lub pośrednio `QThread::run()`) co uruchamia pętlę zdarzeń.

## QtTest

Testy muszą być prywatnymi gniadzami na klasie testa. Następujące metody mają poszczególne znaczenie, ale też _muszą być prywatnymi gniazdami_:

- `initTestCase()` uruchomonione przed pierwszym testem
- `initTestCase_data()` uruchomonione po `initTestCase` i przed pierwszym testem (tworzenie danych)
- `cleanupTestCase()` uruchomonione po ostatnim teście
- `init()` uruchomonione przed każdym testem
- `cleanup()` uruchomonione po każdym teście

- `<nazwaTestu>_data()` też będzie traktowany specjalnie w oczekiwany sposób

Aby wychwycić klasę testu, trzeba dodać następująca końcówka:

```cpp
QTEST_MAIN(BasicTest)
#include "basictest.moc"
```

### Integracja CMake

Takie makro pomaga:

```cmake
macro(add_qt_test _name)
  add_executable(${_name} ${_name}.cpp)
  add_test(NAME ${_name} COMMAND ${_name})
  target_link_libraries(${_name} PRIVATE Qt6::Test)
  target_include_directories(${_name} PRIVATE "${CMAKE_SOURCE_DIR}")
endmacro()
```

Póżniej:

```cmake
add_qt_test(somewindow)
target_link_libraries(somewindow PRIVATE Qt6::Widgets)
target_sources(somewindow PRIVATE "${CMAKE_SOURCE_DIR}/somewindow.cpp")
```

Włacz `enable_testing()` w nadrzędnym `CMakeLists.txt`, inaczej `ctest` narzeka.

## Qt Creator

Qt Creator tworzy układy (`QLayout`) przywiązane do widżetów. Nie stworzy żadne wywołania `addLayout`, tylko doda koljeny widżet, a na nim stworzy układ (`setLayout`). Aby stworzyć układu na `QMainWindow`, musisz najpierw stworzyć jakieś dziecko centralnego widżetu.

## Renderowanie

W `paintEvent`, zdefiniuj `QPainter` na stosie w ten sposób: `QPainter painter(this)` aby zostało skojarzone z obecny widżetem i automatycznie sprzątane.

### Style

Kontrolują renderowanie prymitywnych elements patrz `enum PrimitiveElement` oraz `drawPrimitiveElement`, które nieraz same w sobie stanowią widżety. Też renderują `enum ComplexControl`.

Pozwaląją też zmierzyć objetość treści `sizeFromContents(QStyle::ContentsType, ...)`

## Podchwytliwe Rzeczy

- `QWidget` definiuje wirtualny destruktor. Jego podklasy potrzebują v-tablic. Zadlekaruj i zdefiniuj destruktor.

- Jeśli dajesz `#include "moc_some_qobj.cpp"` na koniec Implementacji, upewnij się że w nagłówku `some_qobj.h` zostało użyte `#pragma once` lub wzór `#ifndef/#define`.

## Przypisy

- [0] https://wiki.qt.io/D-Pointer
- [1] https://stackoverflow.com/questions/25250171/how-to-use-the-qts-pimpl-idiom
- [2] https://www.learnqt.guide/events/working-with-events/
- [3] https://doc.qt.io/qt-6/debug.html#common-bugs
- [4] https://stackoverflow.com/questions/67080870/when-do-i-have-to-include-moc-cpp-in-qt
- [5] https://stackoverflow.com/questions/19719397/qt-slots-and-c11-lambda
- [6] https://doc.qt.io/qt-6/signalsandslots.html#slots
- [7] https://stackoverflow.com/questions/37639066/how-can-i-use-qt5-connect-on-a-slot-with-default-parameters
- [8] https://cmake.org/cmake/help/latest/prop_tgt/AUTOMOC.html
