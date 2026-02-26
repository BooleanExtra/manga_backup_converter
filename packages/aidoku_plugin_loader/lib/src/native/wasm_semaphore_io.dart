// ignore_for_file: avoid_private_typedef_functions, prefer_constructors_over_static_methods, use_late_for_private_fields_and_variables
import 'dart:ffi' as ffi;
import 'dart:io';

import 'package:ffi/ffi.dart' show calloc;

// ---------------------------------------------------------------------------
// Platform selector
// ---------------------------------------------------------------------------

enum _SemPlatform { windows, gcd, posix }

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

// ---------------------------------------------------------------------------
// GCD (Grand Central Dispatch) typedefs — macOS / iOS
// ---------------------------------------------------------------------------

typedef _DispatchSemaphoreCreateC = ffi.Pointer<ffi.Void> Function(ffi.IntPtr);
typedef _DispatchSemaphoreCreateDart = ffi.Pointer<ffi.Void> Function(int);

typedef _DispatchSemaphoreWaitC = ffi.IntPtr Function(ffi.Pointer<ffi.Void>, ffi.Uint64);
typedef _DispatchSemaphoreWaitDart = int Function(ffi.Pointer<ffi.Void>, int);

typedef _DispatchSemaphoreSignalC = ffi.IntPtr Function(ffi.Pointer<ffi.Void>);
typedef _DispatchSemaphoreSignalDart = int Function(ffi.Pointer<ffi.Void>);

typedef _DispatchReleaseC = ffi.Void Function(ffi.Pointer<ffi.Void>);
typedef _DispatchReleaseDart = void Function(ffi.Pointer<ffi.Void>);

/// `DISPATCH_TIME_FOREVER` — wait indefinitely.
const int _dispatchTimeForever = -1; // ~0ULL

/// Platform-specific semaphore for blocking the WASM isolate thread while
/// the main isolate handles async operations (HTTP, sleep).
///
/// Native (POSIX): backed by `sem_init` / `sem_wait` / `sem_post`.
/// Native (Windows): backed by `CreateSemaphoreA` / `WaitForSingleObject`.
/// Native (macOS/iOS): backed by GCD `dispatch_semaphore_*`.
class WasmSemaphore {
  WasmSemaphore._(this._ptr, this._platform);

  final ffi.Pointer<ffi.Void> _ptr;
  final _SemPlatform _platform;

  /// Pointer address — safe to pass as an int across isolate boundaries.
  int get address => _ptr.address;

  // ---------------------------------------------------------------------------
  // Cached lookup results (avoid re-lookup on every call)
  // ---------------------------------------------------------------------------

  // POSIX
  static _SemInitDart? _semInit;
  static _SemWaitDart? _semWait;
  static _SemPostDart? _semPost;
  static _SemDestroyDart? _semDestroy;

  // Windows
  static _CreateSemaphoreDart? _createSemaphore;
  static _WaitForSingleObjectDart? _waitForSingleObject;
  static _ReleaseSemaphoreDart? _releaseSemaphore;
  static _CloseHandleDart? _closeHandle;

  // GCD (macOS / iOS)
  static _DispatchSemaphoreCreateDart? _dispatchSemaphoreCreate;
  static _DispatchSemaphoreWaitDart? _dispatchSemaphoreWait;
  static _DispatchSemaphoreSignalDart? _dispatchSemaphoreSignal;
  static _DispatchReleaseDart? _dispatchRelease;

  static _SemPlatform? _detectedPlatform;
  static bool _initialized = false;

  static void _ensureInitialized() {
    if (_initialized) return;
    _initialized = true;
    if (Platform.isWindows) {
      _detectedPlatform = _SemPlatform.windows;
      final lib = ffi.DynamicLibrary.open('kernel32.dll');
      _createSemaphore = lib.lookupFunction<_CreateSemaphoreC, _CreateSemaphoreDart>('CreateSemaphoreA');
      _waitForSingleObject = lib.lookupFunction<_WaitForSingleObjectC, _WaitForSingleObjectDart>('WaitForSingleObject');
      _releaseSemaphore = lib.lookupFunction<_ReleaseSemaphoreC, _ReleaseSemaphoreDart>('ReleaseSemaphore');
      _closeHandle = lib.lookupFunction<_CloseHandleC, _CloseHandleDart>('CloseHandle');
    } else if (Platform.isMacOS || Platform.isIOS) {
      _detectedPlatform = _SemPlatform.gcd;
      final lib = ffi.DynamicLibrary.process();
      _dispatchSemaphoreCreate =
          lib.lookupFunction<_DispatchSemaphoreCreateC, _DispatchSemaphoreCreateDart>('dispatch_semaphore_create');
      _dispatchSemaphoreWait =
          lib.lookupFunction<_DispatchSemaphoreWaitC, _DispatchSemaphoreWaitDart>('dispatch_semaphore_wait');
      _dispatchSemaphoreSignal =
          lib.lookupFunction<_DispatchSemaphoreSignalC, _DispatchSemaphoreSignalDart>('dispatch_semaphore_signal');
      _dispatchRelease = lib.lookupFunction<_DispatchReleaseC, _DispatchReleaseDart>('dispatch_release');
    } else {
      _detectedPlatform = _SemPlatform.posix;
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
    switch (_detectedPlatform!) {
      case _SemPlatform.windows:
        final ffi.Pointer<ffi.Void> handle = _createSemaphore!(ffi.nullptr, 0, 1, ffi.nullptr);
        return WasmSemaphore._(handle, _SemPlatform.windows);
      case _SemPlatform.gcd:
        final ffi.Pointer<ffi.Void> sem = _dispatchSemaphoreCreate!(0);
        if (sem == ffi.nullptr) {
          throw StateError('dispatch_semaphore_create returned null');
        }
        return WasmSemaphore._(sem, _SemPlatform.gcd);
      case _SemPlatform.posix:
        // 64 bytes is large enough for sem_t on all supported Unix platforms.
        final ffi.Pointer<ffi.Void> sem = calloc<ffi.Uint8>(64).cast<ffi.Void>();
        final int rc = _semInit!(sem, 0 /* pshared=thread */, 0 /* initial=blocked */);
        if (rc != 0) {
          calloc.free(sem.cast<ffi.Uint8>());
          throw StateError('sem_init failed (rc=$rc)');
        }
        return WasmSemaphore._(sem, _SemPlatform.posix);
    }
  }

  /// Reconstruct a semaphore from its native address.
  /// Safe to call from any isolate.
  static WasmSemaphore fromAddress(int address) {
    _ensureInitialized();
    return WasmSemaphore._(
      ffi.Pointer<ffi.Void>.fromAddress(address),
      _detectedPlatform!,
    );
  }

  /// Block the calling thread until [signal] is called.
  void wait() {
    switch (_platform) {
      case _SemPlatform.windows:
        const infinite = 0xFFFFFFFF;
        _waitForSingleObject!(_ptr, infinite);
      case _SemPlatform.gcd:
        _dispatchSemaphoreWait!(_ptr, _dispatchTimeForever);
      case _SemPlatform.posix:
        _semWait!(_ptr);
    }
  }

  /// Wake one waiting thread.
  void signal() {
    switch (_platform) {
      case _SemPlatform.windows:
        _releaseSemaphore!(_ptr, 1, ffi.nullptr);
      case _SemPlatform.gcd:
        _dispatchSemaphoreSignal!(_ptr);
      case _SemPlatform.posix:
        _semPost!(_ptr);
    }
  }

  /// Release native resources.
  void dispose() {
    switch (_platform) {
      case _SemPlatform.windows:
        _closeHandle!(_ptr);
      case _SemPlatform.gcd:
        _dispatchRelease!(_ptr);
      case _SemPlatform.posix:
        _semDestroy!(_ptr);
        calloc.free(_ptr.cast<ffi.Uint8>());
    }
  }
}
