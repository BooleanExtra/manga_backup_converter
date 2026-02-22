import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:characters/characters.dart';
import 'package:mangabackupconverter_cli/src/commands/win_console_stub.dart'
    if (dart.library.ffi) 'package:mangabackupconverter_cli/src/commands/win_console_native.dart';
import 'package:meta/meta.dart';

// ---------------------------------------------------------------------------
// ANSI helpers (pure functions — no I/O dependency)
// ---------------------------------------------------------------------------

String bold(String text) => '\x1b[1m$text\x1b[22m';
String dim(String text) => '\x1b[2m$text\x1b[22m';
String italic(String text) => '\x1b[3m$text\x1b[23m';
String yellow(String text) => '\x1b[33m$text\x1b[39m';
String green(String text) => '\x1b[32m$text\x1b[39m';
String cyan(String text) => '\x1b[36m$text\x1b[39m';

/// OSC 8 terminal hyperlink.
String hyperlink(String text, String url) => '\x1b]8;;$url\x1b\\$text\x1b]8;;\x1b\\';

final _ansiRe = RegExp(r'\x1b\][^\x1b]*\x1b\\|\x1b\[[0-9;]*[a-zA-Z]');

/// Whether a Unicode code point occupies two terminal columns.
bool _isDoubleWidth(int rune) {
  return (rune >= 0x1100 && rune <= 0x115F) ||
      (rune >= 0x2E80 && rune <= 0x303E) ||
      (rune >= 0x3040 && rune <= 0x33BF) ||
      (rune >= 0x3400 && rune <= 0x4DBF) ||
      (rune >= 0x4E00 && rune <= 0x9FFF) ||
      (rune >= 0xA000 && rune <= 0xA4CF) ||
      (rune >= 0xAC00 && rune <= 0xD7AF) ||
      (rune >= 0xF900 && rune <= 0xFAFF) ||
      (rune >= 0xFE30 && rune <= 0xFE6F) ||
      (rune >= 0xFF01 && rune <= 0xFF60) ||
      (rune >= 0xFFE0 && rune <= 0xFFE6) ||
      (rune >= 0x1F300 && rune <= 0x1F9FF) ||
      (rune >= 0x20000 && rune <= 0x2FA1F);
}

/// Computes the terminal display width of [text], accounting for double-width
/// CJK / fullwidth characters and stripping ANSI escapes.
int displayWidth(String text) {
  final String plain = text.replaceAll(_ansiRe, '');
  var w = 0;
  for (final String g in plain.characters) {
    w += _isDoubleWidth(g.runes.first) ? 2 : 1;
  }
  return w;
}

/// Visible column count of [text] (ANSI-stripped, CJK-aware).
int visibleLength(String text) => displayWidth(text);

/// Word-wraps [text] to [width] columns, respecting existing newlines.
List<String> wordWrap(String text, int width) {
  final lines = <String>[];
  for (final String paragraph in text.split('\n')) {
    if (paragraph.isEmpty) {
      lines.add('');
      continue;
    }
    final List<String> words = paragraph.split(' ');
    var currentLine = StringBuffer();
    for (final word in words) {
      if (currentLine.isEmpty) {
        currentLine.write(word);
      } else if (displayWidth(currentLine.toString()) + 1 + displayWidth(word) <= width) {
        currentLine.write(' $word');
      } else {
        lines.add(currentLine.toString());
        currentLine = StringBuffer(word);
      }
    }
    if (currentLine.isNotEmpty) lines.add(currentLine.toString());
  }
  return lines;
}

/// Truncates [text] to [maxWidth] visible columns, appending "…" if needed.
String truncate(String text, int maxWidth) {
  if (maxWidth <= 0) return '';
  if (displayWidth(text) <= maxWidth) return text;
  final String plain = text.replaceAll(_ansiRe, '');
  final buf = StringBuffer();
  var w = 0;
  for (final String g in plain.characters) {
    final gw = _isDoubleWidth(g.runes.first) ? 2 : 1;
    if (w + gw > maxWidth - 1) break;
    buf.write(g);
    w += gw;
  }
  buf.write('…');
  return buf.toString();
}

// ---------------------------------------------------------------------------
// Spinner
// ---------------------------------------------------------------------------

class Spinner {
  static const _frames = ['⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏'];
  int _index = 0;

  String get frame => _frames[_index++ % _frames.length];

  Timer? _timer;

  void start(void Function() onTick) {
    _timer = Timer.periodic(const Duration(milliseconds: 80), (_) => onTick());
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }
}

// ---------------------------------------------------------------------------
// Key input
// ---------------------------------------------------------------------------

sealed class KeyEvent {}

class ArrowUp extends KeyEvent {}

class ArrowDown extends KeyEvent {}

class Enter extends KeyEvent {}

class Escape extends KeyEvent {}

class Space extends KeyEvent {}

class Backspace extends KeyEvent {}

class CharKey extends KeyEvent {
  CharKey(this.char);
  final String char;
}

/// Whether stdin is attached to a fully functional interactive terminal.
///
/// Checks both `hasTerminal` and that raw mode actually works, since some
/// environments (e.g. MSYS on Windows) report `hasTerminal = true` but
/// fail on `echoMode=`.
///
/// The result is cached after the first successful check -- a terminal that
/// was available once won't disappear mid-session, and on MSYS/Windows the
/// probe can fail after a previous stdin subscription has been cancelled.
bool? _hasTerminalCached;
bool get hasTerminal {
  if (_hasTerminalCached ?? false) return true;
  try {
    if (!stdin.hasTerminal) return false;
    // Probe that raw mode actually works.
    final bool saved = stdin.echoMode;
    stdin.echoMode = saved;
    _hasTerminalCached = true;
    return true;
  } on StdinException {
    return false;
  }
}

/// Lazily-initialized broadcast wrapper around `stdin`.
///
/// `stdin` is a single-subscription stream -- once a subscription is cancelled,
/// calling `listen` again throws "Stream has already been listened to".
/// Wrapping it in `asBroadcastStream` allows independent subscribe/cancel
/// cycles across multiple [KeyInput] instances (parent / child screens).
Stream<List<int>>? _stdinBroadcast;
Stream<List<int>> get _broadcastStdin => _stdinBroadcast ??= stdin.asBroadcastStream();

class KeyInput {
  KeyInput() : _inputStream = null;

  /// Test-only constructor that uses [inputStream] instead of stdin.
  @visibleForTesting
  KeyInput.withStream(Stream<List<int>> inputStream) : _inputStream = inputStream;

  final Stream<List<int>>? _inputStream;
  final _controller = StreamController<KeyEvent>.broadcast();
  StreamSubscription<List<int>>? _sub;

  // Buffer for reassembling escape sequences split across multiple reads
  // (common on MSYS/mintty where ESC [ B may arrive as [0x1b] then [0x5b, 0x42]).
  List<int> _escBuffer = [];
  Timer? _escTimer;

  // Buffer for reassembling multi-byte UTF-8 sequences split across reads
  // (e.g. Korean 격 = 3 bytes [0xEA, 0xB2, 0xA9] may arrive in separate chunks).
  List<int> _utf8Buffer = [];
  Timer? _utf8Timer;

  Stream<KeyEvent> get stream => _controller.stream;

  void start() {
    if (_inputStream != null) {
      _sub = _inputStream.listen(_parseBytes);
      return;
    }
    if (!hasTerminal) {
      throw StateError(
        'Interactive terminal required. Use --non-interactive or pipe to a TTY.',
      );
    }
    enableVirtualTerminalInput();
    try {
      stdin.echoMode = false;
      stdin.lineMode = false;
    } on StdinException {
      // Already in raw mode from a parent screen.
    }
    _sub = _broadcastStdin.listen(_parseBytes);
  }

  void dispose() {
    _escTimer?.cancel();
    _escTimer = null;
    if (_escBuffer.isNotEmpty) {
      _processBytes(_escBuffer);
      _escBuffer = [];
    }
    _utf8Timer?.cancel();
    _utf8Timer = null;
    _decodeAndEmitUtf8();
    _sub?.cancel();
    _controller.close();
    restoreConsoleMode();
    try {
      stdin.echoMode = true;
      stdin.lineMode = true;
    } on StdinException {
      // Terminal may already be restored.
    }
  }

  void _parseBytes(List<int> bytes) {
    if (_controller.isClosed) return;

    _escTimer?.cancel();
    _escTimer = null;

    // Prepend any buffered escape prefix.
    final List<int> combined;
    if (_escBuffer.isNotEmpty) {
      combined = [..._escBuffer, ...bytes];
      _escBuffer = [];
    } else {
      combined = bytes;
    }

    // Buffer partial escape sequences and wait for more bytes.
    if (combined.length == 1 && combined[0] == 0x1b) {
      _escBuffer = combined.toList();
      _escTimer = Timer(const Duration(milliseconds: 50), _flushEscBuffer);
      return;
    }
    if (combined.length == 2 && combined[0] == 0x1b && combined[1] == 0x5b) {
      _escBuffer = combined.toList();
      _escTimer = Timer(const Duration(milliseconds: 50), _flushEscBuffer);
      return;
    }

    _processBytes(combined);
  }

  void _flushEscBuffer() {
    if (_escBuffer.isNotEmpty) {
      final List<int> flushed = _escBuffer;
      _escBuffer = [];
      _processBytes(flushed);
    }
  }

  void _processBytes(List<int> bytes) {
    if (_controller.isClosed) return;

    if (bytes.length >= 3 && bytes[0] == 0x1b && bytes[1] == 0x5b) {
      switch (bytes[2]) {
        case 0x41:
          _controller.add(ArrowUp());
        case 0x42:
          _controller.add(ArrowDown());
      }
      return;
    }

    if (bytes.length == 1) {
      final int byte = bytes[0];
      switch (byte) {
        case 0x0d:
          _controller.add(Enter());
        case 0x1b:
          _controller.add(Escape());
        case 0x20:
          _controller.add(Space());
        case 0x08 || 0x7f:
          _controller.add(Backspace());
        default:
          if (byte >= 0x20 && byte < 0x7f) {
            _controller.add(CharKey(String.fromCharCode(byte)));
          } else if (byte >= 0x80) {
            // High byte — part of a multi-byte UTF-8 sequence.
            _bufferUtf8(bytes);
          }
      }
      return;
    }

    // Multi-byte UTF-8 printable characters.
    if (bytes.isNotEmpty && bytes[0] != 0x1b) {
      _bufferUtf8(bytes);
    }
  }

  /// Returns the expected total byte count for a UTF-8 sequence starting with
  /// [leadByte], or 0 if it is not a multi-byte lead byte.
  static int _utf8ExpectedLength(int leadByte) {
    if (leadByte & 0xE0 == 0xC0) return 2; // 110xxxxx
    if (leadByte & 0xF0 == 0xE0) return 3; // 1110xxxx (CJK lives here)
    if (leadByte & 0xF8 == 0xF0) return 4; // 11110xxx
    return 0;
  }

  void _bufferUtf8(List<int> bytes) {
    _utf8Buffer.addAll(bytes);
    _utf8Timer?.cancel();

    final int expected = _utf8ExpectedLength(_utf8Buffer.first);
    if (expected > 0 && _utf8Buffer.length < expected) {
      // Incomplete sequence — wait for more bytes.
      _utf8Timer = Timer(const Duration(milliseconds: 50), _flushUtf8Buffer);
      return;
    }

    _decodeAndEmitUtf8();
  }

  void _decodeAndEmitUtf8() {
    if (_utf8Buffer.isEmpty) return;
    _utf8Timer?.cancel();
    final List<int> bytes = _utf8Buffer;
    _utf8Buffer = [];
    try {
      final String char = utf8.decode(bytes);
      if (char.isNotEmpty) _controller.add(CharKey(char));
    } on FormatException {
      // Malformed UTF-8 — discard.
    }
  }

  void _flushUtf8Buffer() {
    if (_utf8Buffer.isNotEmpty) _decodeAndEmitUtf8();
  }
}

// ---------------------------------------------------------------------------
// TerminalContext — bundles all terminal I/O for composable screens
// ---------------------------------------------------------------------------

class TerminalContext {
  /// Production -- uses real stdin/stdout, installs SIGINT handler.
  TerminalContext() : _output = stdout, _widthOverride = null, _heightOverride = null {
    _keyInput = KeyInput();
    _keyInput.start();
    _sigintSub = ProcessSignal.sigint.watch().listen((_) {
      showCursor();
      try {
        stdin.echoMode = true;
        stdin.lineMode = true;
      } on StdinException {
        // Already restored.
      }
      exit(130);
    });
  }

  /// Test -- injected I/O, no SIGINT, no raw mode.
  @visibleForTesting
  TerminalContext.test({
    required StringSink output,
    required Stream<List<int>> inputStream,
    int width = 80,
    int height = 24,
  }) : _output = output,
       _widthOverride = width,
       _heightOverride = height {
    _keyInput = KeyInput.withStream(inputStream);
    _keyInput.start();
  }

  final StringSink _output;
  final int? _widthOverride;
  final int? _heightOverride;
  late final KeyInput _keyInput;
  StreamSubscription<ProcessSignal>? _sigintSub;

  KeyInput get keyInput => _keyInput;

  int get width {
    if (_widthOverride != null) return _widthOverride;
    try {
      return stdout.terminalColumns;
    } on StdoutException {
      return 80;
    }
  }

  int get height {
    if (_heightOverride != null) return _heightOverride;
    try {
      return stdout.terminalLines;
    } on StdoutException {
      return 24;
    }
  }

  // Terminal control (write ANSI to output sink).
  void hideCursor() => _output.write('\x1b[?25l');
  void showCursor() => _output.write('\x1b[?25h');
  void moveCursorUp(int n) {
    if (n > 0) _output.write('\x1b[${n}A');
  }

  void clearDown() => _output.write('\x1b[J');
  void write(String s) => _output.write(s);
  void writeln(String s) => _output.writeln(s);

  void dispose() {
    _keyInput.dispose();
    _sigintSub?.cancel();
    _sigintSub = null;
  }
}

// ---------------------------------------------------------------------------
// Screen region -- flicker-free re-rendering
// ---------------------------------------------------------------------------

class ScreenRegion {
  ScreenRegion(this._context);
  final TerminalContext _context;
  int _renderedLines = 0;

  void render(List<String> lines) {
    final int width = _context.width;
    if (_renderedLines > 0) {
      _context.moveCursorUp(_renderedLines);
    }
    _context.clearDown();
    for (final line in lines) {
      _context.writeln(truncate(line, width));
    }
    _renderedLines = lines.length;
  }

  void clear() {
    if (_renderedLines > 0) {
      _context.moveCursorUp(_renderedLines);
      _context.clearDown();
      _renderedLines = 0;
    }
  }
}
