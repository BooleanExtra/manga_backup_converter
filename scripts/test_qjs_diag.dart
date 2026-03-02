// ignore_for_file: avoid_print, implementation_imports
import 'package:quickjs/src/js_eval_result.dart';
import 'package:quickjs/src/native_js_engine.dart';

void main() {
  try {
    print('Creating NativeEngineManager...');
    final mgr = NativeEngineManager();
    print('Created mgr, length=${mgr.length}');
    print('Creating NativeJsEngine...');
    final engine = NativeJsEngine();
    print('Created engine');
    final JsEvalResult result = engine.eval('1 + 1');
    print(
      'eval result: ${result.value}, isError=${result.isError}, stderr=${result.stderr}',
    );
    engine.dispose();
    mgr.dispose();
    print('Done');
  } on Object catch (e, st) {
    print('ERROR: $e');
    print(st);
  }
}
