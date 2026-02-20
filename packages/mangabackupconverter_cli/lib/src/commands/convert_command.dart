// ignore_for_file: avoid_print

import 'dart:io' as io;
import 'dart:typed_data';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:mangabackupconverter_cli/mangabackupconverter_lib.dart';
import 'package:path/path.dart' as p;

class ConvertCommand extends Command<void> {
  @override
  final String name = 'convert';
  @override
  final String description = 'Convert a manga backup to another format.';

  ConvertCommand() {
    argParser
      ..addFlag('verbose', abbr: 'v', negatable: false, help: 'Show additional command output.')
      ..addOption(
        'backup',
        abbr: 'b',
        help: 'A backup file from Mihon, Aidoku, Paperback, or Tachimanga to convert to the output format',
        mandatory: true,
      )
      ..addOption(
        'output-format',
        abbr: 'f',
        help: 'The output backup format the backup will be converted to',
        allowed: BackupType.values.map((BackupType e) => e.name).toList(),
        mandatory: true,
      )
      ..addOption(
        'input-format',
        abbr: 'i',
        help: 'Specify the input backup format type if not detected automatically',
        allowed: BackupType.values.map((BackupType e) => e.name).toList(),
      )
      ..addOption(
        'tachi-fork',
        abbr: 't',
        help: 'The specific Tachiyomi fork to use for the backup format',
        allowed: TachiFork.values.map((TachiFork e) => e.name).toList(),
        defaultsTo: TachiFork.mihon.name,
      );
  }

  @override
  Future<void> run() async {
    final ArgResults results = argResults!;
    final bool verbose = results.flag('verbose');

    if (verbose) {
      print('[VERBOSE] All arguments: ${results.arguments}');
    }

    final backupFile = io.File(results.option('backup')!);
    if (!backupFile.existsSync()) {
      throw UsageException('Backup file does not exist: ${backupFile.path}', usage);
    }

    final BackupType outputFormat = BackupType.values.byName(results.option('output-format')!);

    final String backupFileExtension = p.extension(backupFile.uri.toString());
    if (verbose) {
      print('Imported Backup Extension: $backupFileExtension');
    }

    BackupType? inputFormat = BackupType.byExtension(backupFileExtension);
    if (results.wasParsed('input-format')) {
      inputFormat = BackupType.values.byName(results.option('input-format')!);
    }

    if (inputFormat == null) {
      throw UsageException(
        'Unsupported file extension: "$backupFileExtension". Use --input-format to specify the input format.',
        usage,
      );
    }

    final TachiFork outputTachiFork = TachiFork.values.byName(results.option('tachi-fork')!);

    final converter = MangaBackupConverter();
    final ConvertableBackup importedBackup = switch (inputFormat) {
      BackupType.aidoku => converter.importAidokuBackup(backupFile.readAsBytesSync()),
      BackupType.tachi => converter.importTachibkBackup(backupFile.readAsBytesSync(), fork: outputTachiFork),
      BackupType.paperback => converter.importPaperbackPas4Backup(
        backupFile.readAsBytesSync(),
        name: p.basenameWithoutExtension(backupFile.uri.toString()),
      ),
      BackupType.tachimanga => await converter.importTachimangaBackup(backupFile.readAsBytesSync()),
      BackupType.mangayomi => converter.importMangayomiBackup(backupFile.readAsBytesSync()),
    };

    if (verbose) {
      print('============ Imported Backup Data ============ ');
      importedBackup.verbosePrint(verbose);
    }

    final ConvertableBackup convertedBackup = importedBackup.toBackup(outputFormat);
    if (verbose) {
      print('============ Converted Backup Data ============ ');
      convertedBackup.verbosePrint(verbose);
    }

    final outputFile = io.File(
      '${p.basenameWithoutExtension(backupFile.uri.toString())}_converted${outputFormat.extensions.first}',
    );
    final Uint8List fileData = await convertedBackup.toData();
    if (verbose) {
      print('Converted Backup Size: ${fileData.length}');
    }
    if (outputFile.existsSync()) {
      print('Output file already exists, overwriting...');
    }
    outputFile.writeAsBytesSync(fileData);
  }
}
