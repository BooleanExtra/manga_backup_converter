import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

int? _savedMode;

/// Enables ENABLE_VIRTUAL_TERMINAL_INPUT on the Windows console stdin handle.
///
/// This is required for arrow keys, escape, and other ANSI sequences to be
/// delivered as VT byte sequences through stdin when lineMode is false.
/// Without this flag, ReadConsole does not produce any bytes for arrow keys.
void enableVirtualTerminalInput() {
  if (!Platform.isWindows) return;
  try {
    final int handle = GetStdHandle(STD_INPUT_HANDLE);
    if (handle == INVALID_HANDLE_VALUE) return;

    final Pointer<Uint32> pMode = calloc<Uint32>();
    try {
      if (GetConsoleMode(handle, pMode) == FALSE) return;
      _savedMode = pMode.value;
      SetConsoleMode(
        handle,
        pMode.value | ENABLE_VIRTUAL_TERMINAL_INPUT,
      );
    } finally {
      calloc.free(pMode);
    }
  } on Object {
    // Robustness: if win32 APIs aren't available, silently continue.
  }
}

/// Restores the original console mode saved by [enableVirtualTerminalInput].
void restoreConsoleMode() {
  if (!Platform.isWindows) return;
  final int? saved = _savedMode;
  if (saved == null) return;
  try {
    final int handle = GetStdHandle(STD_INPUT_HANDLE);
    if (handle != INVALID_HANDLE_VALUE) {
      SetConsoleMode(handle, saved);
    }
    _savedMode = null;
  } on Object {
    // Robustness: silently continue.
  }
}
