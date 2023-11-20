---
title: "Winapi Notatki"
description: "Zgromadzone notatki o Windowsie"
date: 2023-11-20
tags: ["pl", "winapi", "c++"]
categories: ["Notes"]
---

Uruchomienie procesu:

```cpp
PROCESS_INFORMATION processInformation;
STARTUPINFO startupInfo;
ZeroMemory(&processInformation, sizeof(PROCESS_INFORMATION));
ZeroMemory(&startupInfo, sizeof(STARTUPINFO));
BOOL creationResult = CreateProcessA(NULL, cmdline, NULL, NULL, FALSE, NORMAL_PRIORITY_CLASS, NULL, NULL, &startupInfo, &processInformation);
```

Wątki:

```cpp
DWORD threadMain(LPVOID udata) {
  printf("%s\n", __PRETTY_FUNCTION__);
  WaitForSingleObject(GetCurrentThread(), 1000);
  return 0;
}

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, PSTR lpCmdLine,
                   int nCmdShow) {
  DWORD lpThreadId;
  HANDLE thread = CreateThread(NULL, 0, threadMain, NULL, 0, &lpThreadId);
  WaitForSingleObject(thread, INFINITE);
  printf("%d joined\n", lpThreadId);
  return 0;
}
```
