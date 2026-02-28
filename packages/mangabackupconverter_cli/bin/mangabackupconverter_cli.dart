import 'dart:io';

import 'package:mangabackupconverter_cli/src/runner.dart';

Future<void> main(List<String> arguments) async {
  stdout.write('Starting...\r');
  try {
    await runApp(arguments);
  } on Exception catch (e, stack) {
    stderr.writeln('Unexpected error: $e');
    stderr.writeln(stack);
    exitCode = 1;
  }
}
