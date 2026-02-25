import 'package:code_assets/code_assets.dart';
import 'package:hooks/hooks.dart';
import 'package:native_toolchain_c/native_toolchain_c.dart';

void main(List<String> args) async {
  await build(args, (input, output) async {
    if (!input.config.buildCodeAssets) return;

    final CodeConfig codeConfig = input.config.code;

    // NDK clang 18 crashes on armv7 with musttail attribute:
    // "failed to perform tail call elimination on a call site marked musttail"
    // Disable musttail for Android armv7 via M3_HAS_TAIL_CALL=0.
    final defines = <String, String?>{
      if (codeConfig.targetOS == OS.android &&
          codeConfig.targetArchitecture == Architecture.arm)
        'M3_HAS_TAIL_CALL': '0',
    };

    final cbuilder = CBuilder.library(
      name: 'wasm3',
      assetName: 'src/wasm3_bindings_generated.dart',
      defines: defines,
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
