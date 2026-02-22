import 'dart:async';

import 'package:checks/checks.dart';
import 'package:mangabackupconverter_cli/src/commands/terminal_ui.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('KeyInput suspend/start', () {
    test('second listen on same single-subscription stream without suspend '
        'throws', () {
      // Proves the bug: two KeyInput instances on a raw single-subscription
      // stream crash when both call start() without suspending the first.
      final controller = StreamController<List<int>>();
      addTearDown(controller.close);

      final first = KeyInput.withStream(controller.stream);
      first.start();

      final second = KeyInput.withStream(controller.stream);
      check(second.start).throws<StateError>();

      first.dispose();
      second.dispose();
    });

    test('suspend + new KeyInput on broadcast stream succeeds', () async {
      // Simulates the production fix: stdin wrapped via asBroadcastStream()
      // allows cancel-then-re-listen across KeyInput instances.
      final controller = StreamController<List<int>>();
      addTearDown(controller.close);
      final Stream<List<int>> broadcast = controller.stream.asBroadcastStream();

      final parent = KeyInput.withStream(broadcast);
      parent.start();
      await parent.suspend();

      final child = KeyInput.withStream(broadcast);
      child.start(); // Must not throw.

      final events = <KeyEvent>[];
      final StreamSubscription<KeyEvent> sub = child.stream.listen(events.add);
      addTearDown(sub.cancel);

      controller.add([0x61]); // 'a'
      await Future<void>.delayed(Duration.zero);

      check(events).length.equals(1);
      check(events.first).isA<CharKey>().has((e) => e.char, 'char').equals('a');

      child.dispose();
      parent.dispose();
    });

    test('start after suspend re-subscribes and receives events', () async {
      final controller = StreamController<List<int>>();
      addTearDown(controller.close);
      final Stream<List<int>> broadcast = controller.stream.asBroadcastStream();

      final keyInput = KeyInput.withStream(broadcast);
      keyInput.start();

      final events = <KeyEvent>[];
      final StreamSubscription<KeyEvent> sub = keyInput.stream.listen(events.add);
      addTearDown(sub.cancel);

      controller.add([0x61]); // 'a'
      await Future<void>.delayed(Duration.zero);
      check(events).length.equals(1);

      await keyInput.suspend();
      events.clear();

      // Events emitted while suspended are lost (broadcast, no listener).
      controller.add([0x63]); // 'c'
      await Future<void>.delayed(Duration.zero);
      check(events).isEmpty();

      // Re-subscribe on the same instance.
      keyInput.start();

      controller.add([0x62]); // 'b'
      await Future<void>.delayed(Duration.zero);
      check(events).length.equals(1);
      check(events.first).isA<CharKey>().has((e) => e.char, 'char').equals('b');

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
}
