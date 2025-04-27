// ignore_for_file: avoid_print

import 'package:args/command_runner.dart';

import 'src/convert_command.dart';
import 'src/merge_command.dart';

void main(List<String> args) async {
  final runner =
      CommandRunner<void>(
          'mangabackuputil',
          'A utility cli for managing manga backups.',
        )
        ..addCommand(ConvertCommand())
        ..addCommand(MergeCommand());
  await runner.run(args);
}
