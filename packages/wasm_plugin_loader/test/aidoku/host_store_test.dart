import 'dart:typed_data';

import 'package:checks/checks.dart';
import 'package:test/scaffolding.dart';
import 'package:wasm_plugin_loader/src/aidoku/host_store.dart';
import 'package:wasm_plugin_loader/src/codec/postcard_writer.dart';

void main() {
  group('HostStore', () {
    group('add / get', () {
      late HostStore store;
      setUp(() => store = HostStore());
      tearDown(() => store.dispose());

      test('add returns a positive RID', () {
        final int rid = store.add(BytesResource(Uint8List(0)));
        check(rid).isGreaterThan(0);
      });

      test('get returns stored BytesResource', () {
        final Uint8List bytes = Uint8List.fromList(<int>[1, 2, 3]);
        final int rid = store.add(BytesResource(bytes));
        final BytesResource? res = store.get<BytesResource>(rid);
        check(res).isNotNull();
        check(res!.bytes).deepEquals(bytes);
      });

      test('get with wrong type returns null', () {
        final int rid = store.add(BytesResource(Uint8List(0)));
        check(store.get<HttpRequestResource>(rid)).isNull();
      });

      test('get with unknown RID returns null', () {
        check(store.get<BytesResource>(9999)).isNull();
      });

      test('add assigns incrementing RIDs', () {
        final int rid1 = store.add(BytesResource(Uint8List(0)));
        final int rid2 = store.add(BytesResource(Uint8List(0)));
        check(rid2).equals(rid1 + 1);
      });

      test('addBytes shorthand stores BytesResource', () {
        final Uint8List bytes = Uint8List.fromList(<int>[9, 8, 7]);
        final int rid = store.addBytes(bytes);
        final BytesResource? res = store.get<BytesResource>(rid);
        check(res).isNotNull();
        check(res!.bytes).deepEquals(bytes);
      });
    });

    group('remove', () {
      late HostStore store;
      setUp(() => store = HostStore());
      tearDown(() => store.dispose());

      test('get returns null after remove', () {
        final int rid = store.add(BytesResource(Uint8List(0)));
        store.remove(rid);
        check(store.get<BytesResource>(rid)).isNull();
      });

      test('contains returns false after remove', () {
        final int rid = store.add(BytesResource(Uint8List(0)));
        store.remove(rid);
        check(store.contains(rid)).isFalse();
      });

      test('add after removing last resource gives RID 1', () {
        final int rid = store.add(BytesResource(Uint8List(0)));
        store.remove(rid);
        final int rid2 = store.add(BytesResource(Uint8List(0)));
        check(rid2).equals(1);
      });
    });

    group('contains', () {
      late HostStore store;
      setUp(() => store = HostStore());
      tearDown(() => store.dispose());

      test('returns false for unknown RID', () {
        check(store.contains(42)).isFalse();
      });

      test('returns true after add', () {
        final int rid = store.add(BytesResource(Uint8List(0)));
        check(store.contains(rid)).isTrue();
      });
    });

    group('defaults', () {
      late HostStore store;
      setUp(() => store = HostStore());
      tearDown(() => store.dispose());

      test('is initially empty', () {
        check(store.defaults).isEmpty();
      });

      test('can set and read back int values', () {
        store.defaults['pref_key'] = 7;
        check(store.defaults['pref_key']).equals(7);
      });

      test('can set and read back Uint8List values', () {
        final PostcardWriter writer = PostcardWriter()..writeString('hello');
        final Uint8List bytes = writer.bytes;
        store.defaults['str_key'] = bytes;
        final Object? stored = store.defaults['str_key'];
        check(stored).isA<Uint8List>().deepEquals(bytes);
      });

      test('can be pre-seeded with addAll', () {
        store.defaults.addAll(<String, Object>{'a': 1, 'b': 0});
        check(store.defaults['a']).equals(1);
        check(store.defaults['b']).equals(0);
      });
    });

    group('partialResults stream', () {
      test('emits data added via addPartialResult', () async {
        final HostStore store = HostStore();
        final Uint8List data = Uint8List.fromList(<int>[1, 2, 3]);
        final Future<Uint8List> future = store.partialResults.first;
        store.addPartialResult(data);
        check(await future).deepEquals(data);
        store.dispose();
      });

      test('emits multiple items in order', () async {
        final HostStore store = HostStore();
        final Future<List<Uint8List>> eventsFuture = store.partialResults.take(3).toList();
        store.addPartialResult(Uint8List.fromList(<int>[1]));
        store.addPartialResult(Uint8List.fromList(<int>[2]));
        store.addPartialResult(Uint8List.fromList(<int>[3]));
        final List<Uint8List> events = await eventsFuture;
        store.dispose();
        check(events).length.equals(3);
        check(events[0]).deepEquals(<Object?>[1]);
        check(events[1]).deepEquals(<Object?>[2]);
        check(events[2]).deepEquals(<Object?>[3]);
      });
    });

    group('dispose', () {
      test('clears all resources', () {
        final HostStore store = HostStore();
        final int rid = store.add(BytesResource(Uint8List(0)));
        store.dispose();
        check(store.contains(rid)).isFalse();
      });

      test('closes partialResults stream', () async {
        final HostStore store = HostStore();
        final Future<List<Uint8List>> events = store.partialResults.toList();
        store.dispose();
        check(await events).isEmpty();
      });
    });
  });
}
