import 'dart:io';

import 'package:mangabackupconverter_cli/src/runner.dart';

Future<void> main(List<String> arguments) async {
  try {
    await runApp(arguments);
  } catch (e, stack) {
    stderr.writeln('Unexpected error: $e');
    stderr.writeln(stack);
    exitCode = 1;
  }
}
