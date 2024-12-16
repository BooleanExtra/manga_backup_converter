// ignore_for_file: avoid_print

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:mangabackupconverter_cli/mangabackupconverter_lib.dart';

class MergeCommand extends Command<void> {
  // The [name] and [description] properties must be defined by every
  // subclass.
  @override
  final name = 'merge';
  @override
  final description = 'Merge an Aidoku manga backup with another.';

  MergeCommand() {
    // we can add command specific arguments here.
    // [argParser] is automatically created by the parent class.
    argParser
      ..addFlag(
        'verbose',
        abbr: 'v',
        negatable: false,
        help: 'Show additional command output.',
      )
      ..addOption(
        'backup',
        abbr: 'b',
        help: 'A backup file from Aidoku',
        mandatory: true,
      )
      ..addOption(
        'other',
        abbr: 'o',
        help: 'The other Aidoku backup to merge with the first',
        mandatory: true,
      );
  }

  @override
  Future<void> run() async {
    return await _executeMergeCommand(argResults!);
  }

  Future<void> _executeMergeCommand(ArgResults results) async {
    final converter = MangaBackupConverter();
  }
}
