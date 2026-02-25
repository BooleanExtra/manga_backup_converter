import 'package:code_assets/code_assets.dart';
import 'package:hooks/hooks.dart';
import 'package:native_toolchain_c/native_toolchain_c.dart';

void main(List<String> args) async {
  await build(args, (input, output) async {
    if (!input.config.buildCodeAssets) return;

    final cbuilder = CBuilder.library(
      name: 'wasm3',
      assetName: 'src/wasm3_bindings_generated.dart',
      // O3 causes NDK clang to crash on armv7 (internal compiler error).
      optimizationLevel: OptimizationLevel.o2,
      sources: [
        // Core wasm3 source files — no WASI/libc/tracer (not needed for aidoku
        // plugins).
        'vendor/wasm3/source/m3_bind.c',
        'vendor/wasm3/source/m3_code.c',
        'vendor/wasm3/source/m3_compile.c',
        'vendor/wasm3/source/m3_core.c',
        'vendor/wasm3/source/m3_env.c',
        'vendor/wasm3/source/m3_exec.c',
        'vendor/wasm3/source/m3_function.c',
        'vendor/wasm3/source/m3_info.c',
        'vendor/wasm3/source/m3_module.c',
        'vendor/wasm3/source/m3_parse.c',
        // MSVC linker pragmas to export wasm3 symbols from the DLL.
        // No-op on other compilers.
        'vendor/wasm3_dart_exports.c',
      ],
      includes: ['vendor/wasm3/source/'],
    );
    await cbuilder.run(input: input, output: output);
  });
}
