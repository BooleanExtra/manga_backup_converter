import 'dart:async';

import 'package:checks/checks.dart';
import 'package:mangabackupconverter_cli/src/commands/terminal_ui.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('KeyInput broadcast', () {
    test('broadcast stream allows multiple listeners', () async {
      final controller = StreamController<List<int>>();
      addTearDown(controller.close);
      final Stream<List<int>> broadcast = controller.stream.asBroadcastStream();

      final keyInput = KeyInput.withStream(broadcast);
      keyInput.start();

      final events1 = <KeyEvent>[];
      final events2 = <KeyEvent>[];
      final StreamSubscription<KeyEvent> sub1 = keyInput.stream.listen(events1.add);
      final StreamSubscription<KeyEvent> sub2 = keyInput.stream.listen(events2.add);
      addTearDown(sub1.cancel);
      addTearDown(sub2.cancel);

      controller.add([0x61]); // 'a'
      await Future<void>.delayed(Duration.zero);

      check(events1).length.equals(1);
      check(events1.first).isA<CharKey>().has((e) => e.char, 'char').equals('a');
      check(events2).length.equals(1);
      check(events2.first).isA<CharKey>().has((e) => e.char, 'char').equals('a');

      keyInput.dispose();
    });

    test('pause/resume on broadcast subscription works for child screen pattern', () async {
      final controller = StreamController<List<int>>();
      addTearDown(controller.close);
      final Stream<List<int>> broadcast = controller.stream.asBroadcastStream();

      final keyInput = KeyInput.withStream(broadcast);
      keyInput.start();

      final parentEvents = <KeyEvent>[];
      final StreamSubscription<KeyEvent> parentSub = keyInput.stream.listen(parentEvents.add);
      addTearDown(parentSub.cancel);

      controller.add([0x61]); // 'a'
      await Future<void>.delayed(Duration.zero);
      check(parentEvents).length.equals(1);

      // Simulate parent pausing for child screen.
      parentSub.pause();
      parentEvents.clear();

      // Child creates its own subscription on the same broadcast stream.
      final childEvents = <KeyEvent>[];
      final StreamSubscription<KeyEvent> childSub = keyInput.stream.listen(childEvents.add);

      controller.add([0x62]); // 'b'
      await Future<void>.delayed(Duration.zero);

      // Parent is paused — shouldn't receive events.
      check(parentEvents).isEmpty();
      // Child should receive events.
      check(childEvents).length.equals(1);
      check(childEvents.first).isA<CharKey>().has((e) => e.char, 'char').equals('b');

      // Child done — cancel and resume parent.
      await childSub.cancel();
      parentSub.resume();

      // Paused broadcast subs buffer events — 'b' is delivered on resume.
      await Future<void>.delayed(Duration.zero);
      check(parentEvents).length.equals(1);
      check(parentEvents.first).isA<CharKey>().has((e) => e.char, 'char').equals('b');

      parentEvents.clear();
      controller.add([0x63]); // 'c'
      await Future<void>.delayed(Duration.zero);
      check(parentEvents).length.equals(1);
      check(parentEvents.first).isA<CharKey>().has((e) => e.char, 'char').equals('c');

      keyInput.dispose();
    });

    test('dispose closes the event stream', () async {
      final controller = StreamController<List<int>>();
      addTearDown(controller.close);
      final Stream<List<int>> broadcast = controller.stream.asBroadcastStream();

      final keyInput = KeyInput.withStream(broadcast);
      keyInput.start();

      final done = Completer<void>();
      keyInput.stream.listen(null, onDone: done.complete);

      keyInput.dispose();
      await done.future;
    });
  });

  group('TerminalContext.test', () {
    test('write/writeln go to output sink', () {
      final output = StringBuffer();
      final input = StreamController<List<int>>.broadcast();
      addTearDown(input.close);

      final context = TerminalContext.test(
        output: output,
        inputStream: input.stream,
      );
      addTearDown(context.dispose);

      context.write('hello');
      context.writeln(' world');

      check(output.toString()).contains('hello');
      check(output.toString()).contains('world');
    });

    test('width and height return configured values', () {
      final output = StringBuffer();
      final input = StreamController<List<int>>.broadcast();
      addTearDown(input.close);

      final context = TerminalContext.test(
        output: output,
        inputStream: input.stream,
        width: 120,
        height: 40,
      );
      addTearDown(context.dispose);

      check(context.width).equals(120);
      check(context.height).equals(40);
    });

    test('keyInput receives events from inputStream', () async {
      final output = StringBuffer();
      final input = StreamController<List<int>>.broadcast();
      addTearDown(input.close);

      final context = TerminalContext.test(
        output: output,
        inputStream: input.stream,
      );
      addTearDown(context.dispose);

      final events = <KeyEvent>[];
      final StreamSubscription<KeyEvent> sub = context.keyInput.stream.listen(events.add);
      addTearDown(sub.cancel);

      input.add([0x61]); // 'a'
      await Future<void>.delayed(Duration.zero);

      check(events).length.equals(1);
      check(events.first).isA<CharKey>().has((e) => e.char, 'char').equals('a');
    });
  });

  group('ScreenRegion', () {
    test('render writes lines to context output', () {
      final output = StringBuffer();
      final input = StreamController<List<int>>.broadcast();
      addTearDown(input.close);

      final context = TerminalContext.test(
        output: output,
        inputStream: input.stream,
        width: 40,
      );
      addTearDown(context.dispose);

      final screen = ScreenRegion(context);
      screen.render(['Line 1', 'Line 2']);

      final rendered = output.toString();
      check(rendered).contains('Line 1');
      check(rendered).contains('Line 2');
    });

    test('clear moves cursor up and clears', () {
      final output = StringBuffer();
      final input = StreamController<List<int>>.broadcast();
      addTearDown(input.close);

      final context = TerminalContext.test(
        output: output,
        inputStream: input.stream,
      );
      addTearDown(context.dispose);

      final screen = ScreenRegion(context);
      screen.render(['Line 1', 'Line 2']);
      screen.clear();

      // Should contain cursor-up ANSI sequence.
      final rendered = output.toString();
      check(rendered).contains('\x1b[2A'); // Move up 2 lines.
      check(rendered).contains('\x1b[J');  // Clear down.
    });
  });
}
