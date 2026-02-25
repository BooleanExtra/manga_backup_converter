// Quick test to verify Jsoup works from a child isolate.
// ignore_for_file: avoid_print
import 'dart:isolate';

import 'package:checks/checks.dart';
import 'package:jsoup/jsoup.dart';
import 'package:test/scaffolding.dart';

Future<void> _childMain(SendPort port) async {
  try {
    print('[child] Calling JreManager.ensureInitialized()...');
    JreManager.ensureInitialized();
    print('[child] JreManager initialized, creating Jsoup...');
    final jsoup = Jsoup();
    print('[child] Jsoup created, parsing...');
    final doc = jsoup.parse('<html><body><p>Hello</p></body></html>');
    print('[child] Parsed, getting text...');
    final text = doc.text;
    print('[child] text=$text');
    jsoup.dispose();
    port.send(text);
  } on Object catch (e, st) {
    print('[child] Error: $e\n$st');
    port.send('ERROR: $e');
  }
}

void main() {
  test('Jsoup works in child isolate', () async {
    print('[main] Calling JreManager.ensureInitialized()...');
    JreManager.ensureInitialized();
    print('[main] Done, spawning child...');

    final port = ReceivePort();
    await Isolate.spawn(_childMain, port.sendPort);
    final Object? result = await port.first;
    port.close();
    print('[main] result=$result');
    check(result).isA<String>().contains('Hello');
  });
}
