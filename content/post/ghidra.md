---
title_pl: "Ghidra Notatki"
title: "Ghidra Notes"
subtitle: "Zgromadzone Ghidra Notatki"
description: "Zgromadzone Ghidra Notatki"
date: 2024-03-17
image: ""
tags: ["pl", "c", "x86", "ghidra"]
categories: ["Notes"]
---

## Symbole

Źródła `default`, `analysis`, `imported`, `user-defined`. Wbrew pozorom, ogólna funkcja odkryta podczas analizy ma źródło domyślne, ale znowu funkcja `Unwind@*` oraz rozpoznane implementacje `strchr` ze starych bibliotek itd. są oznaczone jako produkty analizy.

Typy: czym się rózni etykietka instrukcji od innych etykietek?

<!-- TODO 01/05/20 psacawa: finish this -->

## Dekompilator

Pseudomakra jak `CONCAT13(x,y)` oznaczają sklejanie  bajtów: w tym przypadku jednego bajta `x` z trzema bajtami `y`.

## Skrypty

Szablon Java:

```java
import ghidra.app.script.GhidraScript;
public class MyGhidraScript extends GhidraScript {

	@Override
	public void run() throws Exception {
		....
	}
}
```

Preskrypty są uruchamiane przed analizą, postskrypty po.

### analyzeHeadless

```
analyzeHeadless myproj myproj.gpr -process mybin.exe -preScript ghidra_basics.py
```

Własne skrypty:

```
analyzeHeadless $PROJ_DIR myproj.gpr -process mybin.exe -scriptPath  $PROJ_DIR/ghidra_scripts -preScript ghidra_basics.py 
```

Analizuj importowany plik do nie zapisując projektu:

```
analyzeHeadless . nieważne.gpr -import /bin/ls -deleteProject -postScript xyz.java
```
