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
        final rid = store.add(BytesResource(Uint8List(0)));
        check(rid).isGreaterThan(0);
      });

      test('get returns stored BytesResource', () {
        final bytes = Uint8List.fromList([1, 2, 3]);
        final rid = store.add(BytesResource(bytes));
        final res = store.get<BytesResource>(rid);
        check(res).isNotNull();
        check(res!.bytes).deepEquals(bytes);
      });

      test('get with wrong type returns null', () {
        final rid = store.add(BytesResource(Uint8List(0)));
        check(store.get<HttpRequestResource>(rid)).isNull();
      });

      test('get with unknown RID returns null', () {
        check(store.get<BytesResource>(9999)).isNull();
      });

      test('add assigns incrementing RIDs', () {
        final rid1 = store.add(BytesResource(Uint8List(0)));
        final rid2 = store.add(BytesResource(Uint8List(0)));
        check(rid2).equals(rid1 + 1);
      });

      test('addBytes shorthand stores BytesResource', () {
        final bytes = Uint8List.fromList([9, 8, 7]);
        final rid = store.addBytes(bytes);
        final res = store.get<BytesResource>(rid);
        check(res).isNotNull();
        check(res!.bytes).deepEquals(bytes);
      });
    });

    group('remove', () {
      late HostStore store;
      setUp(() => store = HostStore());
      tearDown(() => store.dispose());

      test('get returns null after remove', () {
        final rid = store.add(BytesResource(Uint8List(0)));
        store.remove(rid);
        check(store.get<BytesResource>(rid)).isNull();
      });

      test('contains returns false after remove', () {
        final rid = store.add(BytesResource(Uint8List(0)));
        store.remove(rid);
        check(store.contains(rid)).isFalse();
      });

      test('add after removing last resource gives RID 1', () {
        final rid = store.add(BytesResource(Uint8List(0)));
        store.remove(rid);
        final rid2 = store.add(BytesResource(Uint8List(0)));
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
        final rid = store.add(BytesResource(Uint8List(0)));
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
        final writer = PostcardWriter()..writeString('hello');
        final bytes = writer.bytes;
        store.defaults['str_key'] = bytes;
        final stored = store.defaults['str_key'];
        check(stored).isA<Uint8List>().deepEquals(bytes);
      });

      test('can be pre-seeded with addAll', () {
        store.defaults.addAll({'a': 1, 'b': 0});
        check(store.defaults['a']).equals(1);
        check(store.defaults['b']).equals(0);
      });
    });

    group('partialResults stream', () {
      test('emits data added via addPartialResult', () async {
        final store = HostStore();
        final data = Uint8List.fromList([1, 2, 3]);
        final future = store.partialResults.first;
        store.addPartialResult(data);
        check(await future).deepEquals(data);
        store.dispose();
      });

      test('emits multiple items in order', () async {
        final store = HostStore();
        final eventsFuture = store.partialResults.take(3).toList();
        store.addPartialResult(Uint8List.fromList([1]));
        store.addPartialResult(Uint8List.fromList([2]));
        store.addPartialResult(Uint8List.fromList([3]));
        final events = await eventsFuture;
        store.dispose();
        check(events).length.equals(3);
        check(events[0]).deepEquals([1]);
        check(events[1]).deepEquals([2]);
        check(events[2]).deepEquals([3]);
      });
    });

    group('dispose', () {
      test('clears all resources', () {
        final store = HostStore();
        final rid = store.add(BytesResource(Uint8List(0)));
        store.dispose();
        check(store.contains(rid)).isFalse();
      });

      test('closes partialResults stream', () async {
        final store = HostStore();
        final events = store.partialResults.toList();
        store.dispose();
        check(await events).isEmpty();
      });
    });
  });
}
