import 'package:args/command_runner.dart';

import 'package:mangabackupconverter_cli/src/commands/convert_command.dart';
import 'package:mangabackupconverter_cli/src/commands/merge_command.dart';

Future<void> runApp(List<String> arguments) async {
  final CommandRunner<void> runner = CommandRunner<void>('mangabackuputil', 'A utility cli for managing manga backups.')
    ..addCommand(ConvertCommand())
    ..addCommand(MergeCommand());
  await runner.run(arguments);
}
