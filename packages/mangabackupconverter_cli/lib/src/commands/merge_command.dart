// ignore_for_file: avoid_print

import 'dart:io' as io;
import 'dart:typed_data';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:mangabackupconverter_cli/mangabackupconverter_lib.dart';
import 'package:path/path.dart' as p;

/// A command to merge two Aidoku backups.
class MergeCommand extends Command<void> {
  @override
  final String name = 'merge';
  @override
  final String description = 'Merge an Aidoku manga backup with another.';

  MergeCommand() {
    argParser
      ..addFlag('verbose', abbr: 'v', negatable: false, help: 'Show additional command output.')
      ..addOption('backup', abbr: 'f', help: 'A backup file from Aidoku', mandatory: true)
      ..addOption('other', abbr: 'm', help: 'The other Aidoku backup to merge with the first', mandatory: true)
      ..addOption('output', abbr: 'o', help: 'The output folder to save the merged backup');
  }

  @override
  Future<void> run() async {
    final ArgResults results = argResults!;
    final bool verbose = results.flag('verbose');

    if (verbose) {
      print('[VERBOSE] All arguments: ${results.arguments}');
    }

    final io.File backupFile = _parseFile(results, 'backup');
    final io.File otherBackupFile = _parseFile(results, 'other');

    final String backupFileExtension = p.extension(backupFile.uri.toString());
    final String otherBackupFileExtension = p.extension(otherBackupFile.uri.toString());
    if (backupFileExtension != '.aib') {
      throw UsageException('Backup file format "$backupFileExtension" not supported', usage);
    }
    if (otherBackupFileExtension != '.aib') {
      throw UsageException('Other backup file format "$otherBackupFileExtension" not supported', usage);
    }

    final String outputFolder = results.wasParsed('output') ? results.option('output')! : '.';
    io.Directory(outputFolder).createSync(recursive: true);
    final String outputPath = p.join(
      outputFolder,
      '${p.basenameWithoutExtension(backupFile.path)}_MergedWith_${p.basenameWithoutExtension(otherBackupFile.path)}.aib',
    );

    final AidokuBackup aidokuBackup = AidokuBackup.fromData(backupFile.readAsBytesSync());
    print('Backup Library: ${aidokuBackup.library?.length}');

    final AidokuBackup otherAidokuBackup = AidokuBackup.fromData(otherBackupFile.readAsBytesSync());
    print('Other Backup Library: ${otherAidokuBackup.library?.length}');

    final AidokuBackup combinedBackup = aidokuBackup.mergeWith(otherAidokuBackup, verbose: verbose);
    print('Combined Library: ${combinedBackup.manga?.length}');

    final Uint8List combinedBackupData = await combinedBackup.toData();
    final io.File outputFile = io.File(outputPath);
    outputFile.writeAsBytesSync(combinedBackupData);
    print('Saved merged backup to ${outputFile.path}');
  }

  io.File _parseFile(ArgResults results, String optionName) {
    final io.File file = io.File(results.option(optionName)!);
    if (!file.existsSync()) {
      throw UsageException('$optionName file does not exist: ${file.path}', usage);
    }
    return file;
  }
}
