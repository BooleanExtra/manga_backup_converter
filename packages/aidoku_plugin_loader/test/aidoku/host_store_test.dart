import 'dart:typed_data';

import 'package:aidoku_plugin_loader/src/aidoku/libs/host_store.dart';
import 'package:aidoku_plugin_loader/src/codec/postcard_writer.dart';
import 'package:checks/checks.dart';
import 'package:test/scaffolding.dart';

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
        final bytes = Uint8List.fromList(<int>[1, 2, 3]);
        final int rid = store.add(BytesResource(bytes));
        final BytesResource? res = store.get<BytesResource>(rid);
        check(res).isNotNull();
        if (res == null) throw Exception('res is null');
        check(res.bytes).deepEquals(bytes);
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
        final bytes = Uint8List.fromList(<int>[9, 8, 7]);
        final int rid = store.addBytes(bytes);
        final BytesResource? res = store.get<BytesResource>(rid);
        check(res).isNotNull();
        if (res == null) throw Exception('res is null');
        check(res.bytes).deepEquals(bytes);
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

      test('can set and read back Uint8List values', () {
        final writer = PostcardWriter()..writeString('hello');
        final Uint8List bytes = writer.bytes;
        store.defaults['str_key'] = bytes;
        final Object? stored = store.defaults['str_key'];
        check(stored).isA<Uint8List>().deepEquals(bytes);
      });

      test('can be pre-seeded with addAll', () {
        final Uint8List a = (PostcardWriter()..writeBool(true)).bytes;
        final Uint8List b = (PostcardWriter()..writeBool(false)).bytes;
        store.defaults.addAll(<String, Object>{'a': a, 'b': b});
        check(store.defaults['a']).isA<Uint8List>().deepEquals(a);
        check(store.defaults['b']).isA<Uint8List>().deepEquals(b);
      });
    });

    group('partialResults stream', () {
      test('emits data added via addPartialResult', () async {
        final store = HostStore();
        final data = Uint8List.fromList(<int>[1, 2, 3]);
        final Future<Uint8List> future = store.partialResults.first;
        store.addPartialResult(data);
        check(await future).deepEquals(data);
        store.dispose();
      });

      test('emits multiple items in order', () async {
        final store = HostStore();
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

    group('JsContextResource disposal', () {
      late HostStore store;
      setUp(() => store = HostStore());
      tearDown(() => store.dispose());

      test('onDispose called when resource removed', () {
        var disposed = false;
        final int rid = store.add(
          JsContextResource(context: Object(), onDispose: () => disposed = true),
        );
        store.remove(rid);
        check(disposed).isTrue();
      });

      test('onDispose called on store dispose', () {
        var disposed = false;
        store.add(
          JsContextResource(context: Object(), onDispose: () => disposed = true),
        );
        store.dispose();
        check(disposed).isTrue();
      });

      test('onDispose not called for non-JsContext resources', () {
        final int rid = store.add(BytesResource(Uint8List(0)));
        store.remove(rid); // should not throw
      });
    });

    group('dispose', () {
      test('clears all resources', () {
        final store = HostStore();
        final int rid = store.add(BytesResource(Uint8List(0)));
        store.dispose();
        check(store.contains(rid)).isFalse();
      });

      test('closes partialResults stream', () async {
        final store = HostStore();
        final Future<List<Uint8List>> events = store.partialResults.toList();
        store.dispose();
        check(await events).isEmpty();
      });
    });
  });
}
