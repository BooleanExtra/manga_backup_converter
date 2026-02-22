import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:meta/meta.dart';

// ---------------------------------------------------------------------------
// ANSI helpers
// ---------------------------------------------------------------------------

void hideCursor() => stdout.write('\x1b[?25l');
void showCursor() => stdout.write('\x1b[?25h');
void clearLine() => stdout.write('\x1b[2K\r');
void moveCursorUp(int n) {
  if (n > 0) stdout.write('\x1b[${n}A');
}
void clearDown() => stdout.write('\x1b[J');

String bold(String text) => '\x1b[1m$text\x1b[22m';
String dim(String text) => '\x1b[2m$text\x1b[22m';
String italic(String text) => '\x1b[3m$text\x1b[23m';
String yellow(String text) => '\x1b[33m$text\x1b[39m';
String green(String text) => '\x1b[32m$text\x1b[39m';
String cyan(String text) => '\x1b[36m$text\x1b[39m';

/// OSC 8 terminal hyperlink.
String hyperlink(String text, String url) =>
    '\x1b]8;;$url\x1b\\$text\x1b]8;;\x1b\\';

/// Strips ANSI escape sequences for length calculation.
int visibleLength(String text) =>
    text.replaceAll(RegExp(r'\x1b\][^\x1b]*\x1b\\|\x1b\[[0-9;]*[a-zA-Z]'), '').length;

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
      } else if (currentLine.length + 1 + word.length <= width) {
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
/// The result is cached after the first successful check — a terminal that
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
/// `stdin` is a single-subscription stream — once a subscription is cancelled,
/// calling `listen` again throws "Stream has already been listened to".
/// Wrapping it in `asBroadcastStream` allows independent subscribe/cancel
/// cycles across multiple [KeyInput] instances (parent / child screens).
Stream<List<int>>? _stdinBroadcast;
Stream<List<int>> get _broadcastStdin =>
    _stdinBroadcast ??= stdin.asBroadcastStream();

class KeyInput {
  KeyInput() : _inputStream = null;

  /// Test-only constructor that uses [inputStream] instead of stdin.
  @visibleForTesting
  KeyInput.withStream(Stream<List<int>> inputStream)
      : _inputStream = inputStream;

  final Stream<List<int>>? _inputStream;
  final _controller = StreamController<KeyEvent>();
  StreamSubscription<List<int>>? _sub;

  // Buffer for reassembling escape sequences split across multiple reads
  // (common on MSYS/mintty where ESC [ B may arrive as [0x1b] then [0x5b, 0x42]).
  List<int> _escBuffer = [];
  Timer? _escTimer;

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
    try {
      stdin.echoMode = false;
      stdin.lineMode = false;
    } on StdinException {
      // Already in raw mode from a parent screen.
    }
    _sub = _broadcastStdin.listen(_parseBytes);
  }

  /// Releases the stdin subscription without closing the event stream.
  /// Call [start] again to re-subscribe after a child screen returns.
  Future<void> suspend() async {
    _escTimer?.cancel();
    _escTimer = null;
    _escBuffer = [];
    await _sub?.cancel();
    _sub = null;
  }

  void dispose() {
    _escTimer?.cancel();
    _escTimer = null;
    if (_escBuffer.isNotEmpty) {
      _processBytes(_escBuffer);
      _escBuffer = [];
    }
    _sub?.cancel();
    _controller.close();
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
      switch (bytes[0]) {
        case 0x0d:
          _controller.add(Enter());
        case 0x1b:
          _controller.add(Escape());
        case 0x20:
          _controller.add(Space());
        case 0x7f:
          _controller.add(Backspace());
        default:
          if (bytes[0] >= 0x20 && bytes[0] < 0x7f) {
            _controller.add(CharKey(String.fromCharCode(bytes[0])));
          }
      }
      return;
    }

    // Multi-byte UTF-8 printable characters.
    if (bytes.isNotEmpty && bytes[0] != 0x1b) {
      try {
        final char = String.fromCharCodes(bytes);
        if (char.isNotEmpty) _controller.add(CharKey(char));
      } on FormatException {
        // Ignore unrecognised sequences.
      }
    }
  }
}

// ---------------------------------------------------------------------------
// Screen region — flicker-free re-rendering
// ---------------------------------------------------------------------------

class ScreenRegion {
  int _renderedLines = 0;

  void render(List<String> lines) {
    final int width = terminalWidth;
    if (_renderedLines > 0) {
      moveCursorUp(_renderedLines);
    }
    clearDown();
    for (final line in lines) {
      stdout.writeln(truncate(line, width));
    }
    _renderedLines = lines.length;
  }

  void clear() {
    if (_renderedLines > 0) {
      moveCursorUp(_renderedLines);
      clearDown();
      _renderedLines = 0;
    }
  }
}

// ---------------------------------------------------------------------------
// SIGINT safety — restores terminal state on Ctrl+C
// ---------------------------------------------------------------------------

StreamSubscription<ProcessSignal>? _sigintSub;

/// Installs a handler that restores cursor and terminal mode on SIGINT.
/// Call [removeSigintHandler] when done with the interactive UI.
void installSigintHandler() {
  _sigintSub = ProcessSignal.sigint.watch().listen((_) {
    showCursor();
    try {
      stdin.echoMode = true;
      stdin.lineMode = true;
    } on StdinException {
      // Already restored.
    }
    exit(130); // Standard SIGINT exit code.
  });
}

void removeSigintHandler() {
  _sigintSub?.cancel();
  _sigintSub = null;
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Terminal width, falling back to 80 if not available.
int get terminalWidth {
  try {
    return stdout.terminalColumns;
  } on StdoutException {
    return 80;
  }
}

/// Truncates [text] to [maxWidth] visible columns, appending "…" if needed.
String truncate(String text, int maxWidth) {
  if (maxWidth <= 0) return '';
  if (visibleLength(text) <= maxWidth) return text;
  // Strip ANSI for safe truncation, then re-truncate.
  final String plain = text.replaceAll(RegExp(r'\x1b\][^\x1b]*\x1b\\|\x1b\[[0-9;]*[a-zA-Z]'), '');
  if (plain.length <= maxWidth) return text;
  return '${plain.substring(0, max(0, maxWidth - 1))}…';
}
