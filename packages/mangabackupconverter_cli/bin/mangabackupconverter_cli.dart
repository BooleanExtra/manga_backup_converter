import 'dart:io';

import 'package:mangabackupconverter_cli/src/runner.dart';

Future<void> main(List<String> arguments) async {
  try {
    await runApp(arguments);
    // ignore: avoid_catches_without_on_clauses
  } catch (e, stack) {
    stderr.writeln('Unexpected error: $e');
    stderr.writeln(stack);
    exitCode = 1;
  }
}
