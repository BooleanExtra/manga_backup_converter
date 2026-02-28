import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:characters/characters.dart';
import 'package:mangabackupconverter_cli/src/commands/win_console_stub.dart'
    if (dart.library.ffi) 'package:mangabackupconverter_cli/src/commands/win_console_native.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;

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

final _linkRe = RegExp(r'\[([^\]]+)\]\(([^)]+)\)');
final _boldRe = RegExp(r'\*\*(.+?)\*\*');
final _italicRe = RegExp(r'(?<!\*)\*(?!\*)(.+?)(?<!\*)\*(?!\*)');

/// Converts common markdown syntax in a single [line] to ANSI terminal escapes.
///
/// Handles `[text](url)` → clickable green hyperlink, `**text**` → bold,
/// `*text*` → italic. Processed in that order to avoid double-processing.
String renderMarkdown(String line) {
  String result = line.replaceAllMapped(_linkRe, (Match m) {
    return hyperlink(green(m[1]!), m[2]!);
  });
  result = result.replaceAllMapped(_boldRe, (Match m) => bold(m[1]!));
  result = result.replaceAllMapped(_italicRe, (Match m) => italic(m[1]!));
  return result;
}

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

/// Returns the number of lines [text] would occupy after word wrapping to
/// [width] columns.
int wrappedLineCount(String text, int width) => wordWrap(text, width).length;

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

/// Renders a search input line with a visible block cursor at [cursorPos].
///
/// When [isFocused] is true, the character at [cursorPos] (or a trailing space
/// if the cursor is at the end) is rendered with ANSI inverse video to simulate
/// a block cursor. The result is truncated to [boxWidth] visible columns.
String renderSearchInput(String query, int cursorPos, {required bool isFocused, required int boxWidth}) {
  final focusIndicator = isFocused ? '❯ ' : '  ';
  const prefix = '⌕ ';
  final prefixStr = '$focusIndicator$prefix';
  final int prefixWidth = displayWidth(prefixStr);
  final int availableWidth = boxWidth - prefixWidth;

  if (!isFocused || availableWidth <= 0) {
    return truncate('$prefixStr$query', boxWidth);
  }

  final List<String> chars = query.characters.toList();
  final int clampedPos = cursorPos.clamp(0, chars.length);

  // Build the query with an inverse-video cursor character.
  final buf = StringBuffer(prefixStr);
  var col = 0;
  for (var i = 0; i < chars.length; i++) {
    final gw = _isDoubleWidth(chars[i].runes.first) ? 2 : 1;
    if (col + gw > availableWidth - (i == clampedPos ? 0 : 0)) {
      // Would exceed available width — truncate.
      if (i <= clampedPos) {
        // Cursor hasn't been rendered yet; show ellipsis.
        buf.write('…');
      }
      break;
    }
    if (i == clampedPos) {
      buf.write('\x1b[7m${chars[i]}\x1b[27m');
    } else {
      buf.write(chars[i]);
    }
    col += gw;
  }
  // If cursor is at the end, render an inverse space as the block cursor.
  if (clampedPos == chars.length && col < availableWidth) {
    buf.write('\x1b[7m \x1b[27m');
  }

  return buf.toString();
}

// ---------------------------------------------------------------------------
// Search input state — shared text-editing + rendering for search boxes
// ---------------------------------------------------------------------------

/// Result of [SearchInputState.tryHandleKey].
enum SearchKeyResult {
  /// Key consumed, query text changed (caller should debounce/re-filter).
  consumed,

  /// Key consumed, only cursor moved (caller should re-render).
  cursorMoved,

  /// Key not handled by search input (caller should handle it).
  ignored,
}

/// Encapsulates query text, cursor position, key handling, and search-box
/// rendering shared by the live search and extension select screens.
class SearchInputState {
  SearchInputState([String initialQuery = '']) : query = initialQuery, cursorPos = initialQuery.characters.length;

  String query;
  int cursorPos;

  /// Whether the search bar is focused. Updated automatically by
  /// [tryHandleKey] when a text-modifying key refocuses the input.
  bool focused = true;

  /// Processes a text-editing [KeyEvent] and mutates [query] / [cursorPos].
  ///
  /// Returns `true` if the query text changed (callers may want to trigger a
  /// search or re-filter), `false` if only the cursor moved or the key was
  /// not handled.
  bool handleKey(KeyEvent key) {
    switch (key) {
      case CharKey(:final char):
        final List<String> chars = query.characters.toList();
        chars.insert(cursorPos, char);
        query = chars.join();
        cursorPos++;
        return true;

      case Backspace():
        if (cursorPos > 0) {
          final List<String> chars = query.characters.toList();
          chars.removeAt(cursorPos - 1);
          query = chars.join();
          cursorPos--;
          return true;
        }
        return false;

      case Delete():
        if (cursorPos < query.characters.length) {
          final List<String> chars = query.characters.toList();
          chars.removeAt(cursorPos);
          query = chars.join();
          return true;
        }
        return false;

      case Space():
        final List<String> chars = query.characters.toList();
        chars.insert(cursorPos, ' ');
        query = chars.join();
        cursorPos++;
        return true;

      case ArrowLeft():
        if (cursorPos > 0) cursorPos--;
        return false;

      case ArrowRight():
        if (cursorPos < query.characters.length) cursorPos++;
        return false;

      case Home():
        cursorPos = 0;
        return false;

      case End():
        cursorPos = query.characters.length;
        return false;

      default:
        return false;
    }
  }

  /// Routes a key event through the search input, handling focus transitions.
  ///
  /// When [focused], all text-editing and cursor-movement keys are consumed.
  /// When unfocused, only text-modifying keys (CharKey, Backspace, Delete)
  /// trigger a refocus — Space is left to the caller for screen-specific use.
  SearchKeyResult tryHandleKey(KeyEvent key) {
    if (focused) {
      if (key is! CharKey &&
          key is! Backspace &&
          key is! Delete &&
          key is! Space &&
          key is! ArrowLeft &&
          key is! ArrowRight &&
          key is! Home &&
          key is! End) {
        return SearchKeyResult.ignored;
      }
      return handleKey(key) ? SearchKeyResult.consumed : SearchKeyResult.cursorMoved;
    }
    // Unfocused: only text-modifying keys trigger refocus.
    if (key is! CharKey && key is! Backspace && key is! Delete) {
      return SearchKeyResult.ignored;
    }
    focused = true;
    return handleKey(key) ? SearchKeyResult.consumed : SearchKeyResult.cursorMoved;
  }

  /// Renders the 3-line search box (╭─╮ │...│ ╰─╯).
  ///
  /// Uses the [focused] field to control whether the block cursor is drawn.
  /// [width] is the total available terminal width (the box occupies width-2
  /// for the outer border characters).
  List<String> renderBox({required int width}) {
    final int boxWidth = max(width - 2, 10);
    final String inputLine = renderSearchInput(
      query,
      cursorPos,
      isFocused: focused,
      boxWidth: boxWidth,
    );
    final int pad = max(0, boxWidth - displayWidth(inputLine));
    final inner = '$inputLine${' ' * pad}';
    return [
      '╭${'─' * boxWidth}╮',
      '│$inner│',
      '╰${'─' * boxWidth}╯',
    ];
  }
}

// ---------------------------------------------------------------------------
// String similarity (Dice coefficient on character bigrams)
// ---------------------------------------------------------------------------

/// Computes a normalized similarity score (0.0–1.0) between [a] and [b] using
/// the Sørensen–Dice coefficient on character bigrams. Uses grapheme clusters
/// for correct CJK / emoji handling.
double diceCoefficient(String a, String b) {
  if (a == b) return 1.0;
  final List<String> aChars = a.characters.toList();
  final List<String> bChars = b.characters.toList();
  if (aChars.length < 2 || bChars.length < 2) return 0.0;
  final aBigrams = <String>{};
  for (var i = 0; i < aChars.length - 1; i++) {
    aBigrams.add('${aChars[i]}${aChars[i + 1]}');
  }
  var matches = 0;
  for (var i = 0; i < bChars.length - 1; i++) {
    if (aBigrams.remove('${bChars[i]}${bChars[i + 1]}')) matches++;
  }
  return 2 * matches / (aChars.length - 1 + bChars.length - 1);
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

class ArrowLeft extends KeyEvent {}

class ArrowRight extends KeyEvent {}

class Home extends KeyEvent {}

class End extends KeyEvent {}

class Enter extends KeyEvent {}

class Escape extends KeyEvent {}

class Space extends KeyEvent {}

class Tab extends KeyEvent {}

class Backspace extends KeyEvent {}

class Delete extends KeyEvent {}

class ScrollUp extends KeyEvent {}

class ScrollDown extends KeyEvent {}

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
StreamSubscription<List<int>>? _stdinSub;
Stream<List<int>> get _broadcastStdin =>
    _stdinBroadcast ??= stdin.asBroadcastStream(onListen: (sub) => _stdinSub = sub);

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
    // Enable SGR extended mouse mode for scroll wheel detection.
    stdout.write('\x1b[?1000h\x1b[?1006h');
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
    // Disable mouse tracking before restoring console mode.
    if (_inputStream == null) {
      stdout.write('\x1b[?1000l\x1b[?1006l');
    }
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
    // Buffer ESC [ <digit> waiting for ~ (e.g. Delete = ESC [ 3 ~).
    if (combined.length == 3 &&
        combined[0] == 0x1b &&
        combined[1] == 0x5b &&
        combined[2] >= 0x30 &&
        combined[2] <= 0x39) {
      _escBuffer = combined.toList();
      _escTimer = Timer(const Duration(milliseconds: 50), _flushEscBuffer);
      return;
    }
    // Buffer SGR mouse sequences: ESC [ < ... (digits/semicolons) waiting for
    // M or m terminator.
    if (combined.length >= 3 && combined[0] == 0x1b && combined[1] == 0x5b && combined[2] == 0x3c) {
      // Check if the sequence has a terminator (M=0x4d or m=0x6d).
      final bool hasTerminator = combined.length > 3 && (combined.last == 0x4d || combined.last == 0x6d);
      if (!hasTerminator) {
        _escBuffer = combined.toList();
        _escTimer = Timer(const Duration(milliseconds: 50), _flushEscBuffer);
        return;
      }
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
      // SGR mouse sequences: ESC [ < button ; x ; y M/m
      if (bytes[2] == 0x3c) {
        _parseSgrMouse(bytes);
        return;
      }
      // ESC [ <digit> ~ sequences (e.g. Delete = ESC [ 3 ~).
      if (bytes.length >= 4 && bytes[3] == 0x7e) {
        switch (bytes[2]) {
          case 0x33:
            _controller.add(Delete());
        }
        return;
      }
      switch (bytes[2]) {
        case 0x41:
          _controller.add(ArrowUp());
        case 0x42:
          _controller.add(ArrowDown());
        case 0x43:
          _controller.add(ArrowRight());
        case 0x44:
          _controller.add(ArrowLeft());
        case 0x46:
          _controller.add(End());
        case 0x48:
          _controller.add(Home());
      }
      return;
    }

    if (bytes.length == 1) {
      final int byte = bytes[0];
      switch (byte) {
        case 0x09:
          _controller.add(Tab());
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

  /// Parses SGR extended mouse protocol: ESC [ < button ; x ; y M/m
  /// Only emits ScrollUp (button 64) and ScrollDown (button 65) press events.
  void _parseSgrMouse(List<int> bytes) {
    // Payload starts after ESC [ < (index 3) and ends before M/m terminator.
    if (bytes.length < 5) return;
    final int terminator = bytes.last;
    // Only handle press events (M), ignore releases (m).
    if (terminator != 0x4d) return;
    final payload = String.fromCharCodes(bytes, 3, bytes.length - 1);
    final List<String> parts = payload.split(';');
    if (parts.isEmpty) return;
    final int? button = int.tryParse(parts[0]);
    switch (button) {
      case 64:
        _controller.add(ScrollUp());
      case 65:
        _controller.add(ScrollDown());
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
    _stdinSub?.cancel();
    _stdinBroadcast = null;
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

// ---------------------------------------------------------------------------
// Path input state — text editing + Tab file path completion
// ---------------------------------------------------------------------------

/// Result of [PathInputState.handleKey].
enum PathInputResult {
  /// Key consumed, text changed (caller should re-render).
  textChanged,

  /// Key consumed, only cursor moved (caller should re-render).
  cursorMoved,

  /// Tab pressed — completion resolved (caller should re-render).
  tabCompleted,

  /// Enter pressed — user submitted the path.
  submitted,

  /// Escape pressed — user cancelled.
  cancelled,

  /// Key not handled.
  ignored,
}

/// Manages path text editing, cursor position, and Tab file-path completion.
class PathInputState {
  PathInputState([String initialText = ''])
    : _chars = initialText.characters.toList(),
      cursorPos = initialText.characters.length;

  List<String> _chars;
  int cursorPos;

  // Tab completion state.
  List<String> _completions = [];
  int _completionIndex = -1;
  bool _tabActive = false;

  /// The current text.
  String get text => _chars.join();

  set text(String value) {
    _chars = value.characters.toList();
    cursorPos = _chars.length;
    _resetCompletions();
  }

  /// Current completion candidates (empty when no Tab cycle is active).
  List<String> get completions => _tabActive ? _completions : const [];

  /// Index of the highlighted completion, or -1 if none.
  int get completionIndex => _tabActive ? _completionIndex : -1;

  /// Processes a [KeyEvent] and returns what happened.
  PathInputResult handleKey(KeyEvent key) {
    switch (key) {
      case Tab():
        return _handleTab();

      case Enter():
        _resetCompletions();
        return PathInputResult.submitted;

      case Escape():
        if (_tabActive) {
          _resetCompletions();
          return PathInputResult.textChanged;
        }
        return PathInputResult.cancelled;

      case CharKey(:final char):
        _chars.insert(cursorPos, char);
        cursorPos++;
        _resetCompletions();
        return PathInputResult.textChanged;

      case Space():
        _chars.insert(cursorPos, ' ');
        cursorPos++;
        _resetCompletions();
        return PathInputResult.textChanged;

      case Backspace():
        if (cursorPos > 0) {
          _chars.removeAt(cursorPos - 1);
          cursorPos--;
          _resetCompletions();
          return PathInputResult.textChanged;
        }
        return PathInputResult.ignored;

      case Delete():
        if (cursorPos < _chars.length) {
          _chars.removeAt(cursorPos);
          _resetCompletions();
          return PathInputResult.textChanged;
        }
        return PathInputResult.ignored;

      case ArrowUp():
        if (_tabActive && _completions.isNotEmpty) {
          _completionIndex = (_completionIndex - 1) % _completions.length;
          _applyCompletion(_completions[_completionIndex]);
          return PathInputResult.tabCompleted;
        }
        return PathInputResult.ignored;

      case ArrowDown():
        if (_tabActive && _completions.isNotEmpty) {
          _completionIndex = (_completionIndex + 1) % _completions.length;
          _applyCompletion(_completions[_completionIndex]);
          return PathInputResult.tabCompleted;
        }
        return PathInputResult.ignored;

      case ArrowLeft():
        if (cursorPos > 0) {
          cursorPos--;
          _resetCompletions();
          return PathInputResult.cursorMoved;
        }
        return PathInputResult.ignored;

      case ArrowRight():
        if (_tabActive && _completions.isNotEmpty) {
          // Accept the current completion and dismiss the list.
          _resetCompletions();
          // If accepted path is a directory, auto-trigger new Tab cycle.
          if (text.endsWith(p.separator) || text.endsWith('/')) {
            return _handleTab();
          }
          return PathInputResult.tabCompleted;
        }
        if (cursorPos < _chars.length) {
          cursorPos++;
          return PathInputResult.cursorMoved;
        }
        return PathInputResult.ignored;

      case Home():
        cursorPos = 0;
        _resetCompletions();
        return PathInputResult.cursorMoved;

      case End():
        cursorPos = _chars.length;
        _resetCompletions();
        return PathInputResult.cursorMoved;

      case ScrollUp() || ScrollDown():
        return PathInputResult.ignored;
    }
  }

  PathInputResult _handleTab() {
    if (_tabActive && _completions.isNotEmpty) {
      // Cycle to next completion.
      _completionIndex = (_completionIndex + 1) % _completions.length;
      _applyCompletion(_completions[_completionIndex]);
      return PathInputResult.tabCompleted;
    }

    // First Tab press — resolve completions.
    _completions = resolveCompletions(text);
    if (_completions.isEmpty) {
      return PathInputResult.ignored;
    }

    _tabActive = true;

    if (_completions.length == 1) {
      // Single match — complete inline.
      _completionIndex = 0;
      _applyCompletion(_completions[0]);
      _tabActive = false;
      _completions = [];
      _completionIndex = -1;
      return PathInputResult.tabCompleted;
    }

    // Multiple matches — complete longest common prefix.
    final String prefix = _longestCommonPrefix(_completions);
    if (prefix.length > text.length) {
      _applyCompletion(prefix);
    }
    _completionIndex = 0;
    return PathInputResult.tabCompleted;
  }

  void _applyCompletion(String completed) {
    _chars = completed.characters.toList();
    cursorPos = _chars.length;
  }

  void _resetCompletions() {
    _tabActive = false;
    _completions = [];
    _completionIndex = -1;
  }

  /// Resolves file system completions for [path].
  ///
  /// Exposed as a static-like method so tests can exercise it directly.
  @visibleForTesting
  static List<String> resolveCompletions(String path) {
    if (path.isEmpty) return [];

    // Expand ~ to home directory.
    var expanded = path;
    final String home = Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'] ?? '';
    if (expanded.startsWith('~')) {
      expanded = home + expanded.substring(1);
    }

    // Split into directory + partial filename.
    String dirPath;
    String partial;
    if (expanded.endsWith(p.separator) || expanded.endsWith('/')) {
      dirPath = expanded;
      partial = '';
    } else {
      dirPath = p.dirname(expanded);
      partial = p.basename(expanded);
    }

    final dir = Directory(dirPath);
    if (!dir.existsSync()) return [];

    final String lowerPartial = partial.toLowerCase();
    final matches = <String>[];

    try {
      for (final FileSystemEntity entity in dir.listSync()) {
        final String name = p.basename(entity.path);
        if (!name.toLowerCase().startsWith(lowerPartial)) continue;

        String fullPath = p.join(dirPath, name);
        // Re-apply ~ prefix if the user typed it.
        if (path.startsWith('~') && home.isNotEmpty && fullPath.startsWith(home)) {
          fullPath = '~${fullPath.substring(home.length)}';
        }
        if (entity is Directory) {
          fullPath = '$fullPath${p.separator}';
        }
        matches.add(fullPath);
      }
    } on FileSystemException {
      return [];
    }

    matches.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return matches;
  }

  static String _longestCommonPrefix(List<String> strings) {
    if (strings.isEmpty) return '';
    String prefix = strings[0];
    for (var i = 1; i < strings.length; i++) {
      while (!strings[i].toLowerCase().startsWith(prefix.toLowerCase())) {
        prefix = prefix.substring(0, prefix.length - 1);
        if (prefix.isEmpty) return '';
      }
    }
    // Use the casing from the first match up to prefix length.
    return strings[0].substring(0, prefix.length);
  }
}
