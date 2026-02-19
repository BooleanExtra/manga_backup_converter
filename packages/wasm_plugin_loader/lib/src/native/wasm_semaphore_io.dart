// ignore_for_file: avoid_private_typedef_functions, prefer_constructors_over_static_methods, use_late_for_private_fields_and_variables
import 'dart:ffi' as ffi;
import 'dart:io';

import 'package:ffi/ffi.dart' show calloc;

// ---------------------------------------------------------------------------
// POSIX typedefs
// ---------------------------------------------------------------------------

typedef _SemInitC = ffi.Int Function(ffi.Pointer<ffi.Void>, ffi.Int, ffi.UnsignedInt);
typedef _SemInitDart = int Function(ffi.Pointer<ffi.Void>, int, int);

typedef _SemWaitC = ffi.Int Function(ffi.Pointer<ffi.Void>);
typedef _SemWaitDart = int Function(ffi.Pointer<ffi.Void>);

typedef _SemPostC = ffi.Int Function(ffi.Pointer<ffi.Void>);
typedef _SemPostDart = int Function(ffi.Pointer<ffi.Void>);

typedef _SemDestroyC = ffi.Int Function(ffi.Pointer<ffi.Void>);
typedef _SemDestroyDart = int Function(ffi.Pointer<ffi.Void>);

// ---------------------------------------------------------------------------
// Windows typedefs
// ---------------------------------------------------------------------------

typedef _CreateSemaphoreC =
    ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Int32, ffi.Pointer<ffi.Void>);
typedef _CreateSemaphoreDart = ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void>, int, int, ffi.Pointer<ffi.Void>);

typedef _WaitForSingleObjectC = ffi.Uint32 Function(ffi.Pointer<ffi.Void>, ffi.Uint32);
typedef _WaitForSingleObjectDart = int Function(ffi.Pointer<ffi.Void>, int);

typedef _ReleaseSemaphoreC = ffi.Int32 Function(ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Pointer<ffi.Int32>);
typedef _ReleaseSemaphoreDart = int Function(ffi.Pointer<ffi.Void>, int, ffi.Pointer<ffi.Int32>);

typedef _CloseHandleC = ffi.Int32 Function(ffi.Pointer<ffi.Void>);
typedef _CloseHandleDart = int Function(ffi.Pointer<ffi.Void>);

/// Platform-specific semaphore for blocking the WASM isolate thread while
/// the main isolate handles async operations (HTTP, sleep).
///
/// Native (POSIX): backed by `sem_init` / `sem_wait` / `sem_post`.
/// Native (Windows): backed by `CreateSemaphoreA` / `WaitForSingleObject`.
class WasmSemaphore {
  WasmSemaphore._(this._ptr, this._isWindows);

  final ffi.Pointer<ffi.Void> _ptr;
  final bool _isWindows;

  /// Pointer address — safe to pass as an int across isolate boundaries.
  int get address => _ptr.address;

  // ---------------------------------------------------------------------------
  // Cached lookup results (avoid re-lookup on every call)
  // ---------------------------------------------------------------------------

  static _SemInitDart? _semInit;
  static _SemWaitDart? _semWait;
  static _SemPostDart? _semPost;
  static _SemDestroyDart? _semDestroy;

  static _CreateSemaphoreDart? _createSemaphore;
  static _WaitForSingleObjectDart? _waitForSingleObject;
  static _ReleaseSemaphoreDart? _releaseSemaphore;
  static _CloseHandleDart? _closeHandle;

  static bool _initialized = false;

  static void _ensureInitialized() {
    if (_initialized) return;
    _initialized = true;
    if (Platform.isWindows) {
      final lib = ffi.DynamicLibrary.open('kernel32.dll');
      _createSemaphore = lib.lookupFunction<_CreateSemaphoreC, _CreateSemaphoreDart>('CreateSemaphoreA');
      _waitForSingleObject = lib.lookupFunction<_WaitForSingleObjectC, _WaitForSingleObjectDart>('WaitForSingleObject');
      _releaseSemaphore = lib.lookupFunction<_ReleaseSemaphoreC, _ReleaseSemaphoreDart>('ReleaseSemaphore');
      _closeHandle = lib.lookupFunction<_CloseHandleC, _CloseHandleDart>('CloseHandle');
    } else {
      final lib = ffi.DynamicLibrary.process();
      _semInit = lib.lookupFunction<_SemInitC, _SemInitDart>('sem_init');
      _semWait = lib.lookupFunction<_SemWaitC, _SemWaitDart>('sem_wait');
      _semPost = lib.lookupFunction<_SemPostC, _SemPostDart>('sem_post');
      _semDestroy = lib.lookupFunction<_SemDestroyC, _SemDestroyDart>('sem_destroy');
    }
  }

  /// Create a new semaphore (initial value = 0 / blocked).
  static WasmSemaphore create() {
    _ensureInitialized();
    if (Platform.isWindows) {
      final handle = _createSemaphore!(ffi.nullptr, 0, 1, ffi.nullptr);
      return WasmSemaphore._(handle, true);
    } else {
      // 64 bytes is large enough for sem_t on all supported Unix platforms.
      final sem = calloc<ffi.Uint8>(64).cast<ffi.Void>();
      _semInit!(sem, 0 /* pshared=thread */, 0 /* initial=blocked */);
      return WasmSemaphore._(sem, false);
    }
  }

  /// Reconstruct a semaphore from its native address.
  /// Safe to call from any isolate.
  static WasmSemaphore fromAddress(int address) {
    _ensureInitialized();
    return WasmSemaphore._(
      ffi.Pointer<ffi.Void>.fromAddress(address),
      Platform.isWindows,
    );
  }

  /// Block the calling thread until [signal] is called.
  void wait() {
    if (_isWindows) {
      const infinite = 0xFFFFFFFF;
      _waitForSingleObject!(_ptr, infinite);
    } else {
      _semWait!(_ptr);
    }
  }

  /// Wake one waiting thread.
  void signal() {
    if (_isWindows) {
      _releaseSemaphore!(_ptr, 1, ffi.nullptr);
    } else {
      _semPost!(_ptr);
    }
  }

  /// Release native resources.
  void dispose() {
    if (_isWindows) {
      _closeHandle!(_ptr);
    } else {
      _semDestroy!(_ptr);
      calloc.free(_ptr.cast<ffi.Uint8>());
    }
  }
}
