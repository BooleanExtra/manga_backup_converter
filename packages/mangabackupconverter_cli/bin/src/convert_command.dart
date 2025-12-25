// ignore_for_file: avoid_print

import 'dart:io' as io;
import 'dart:typed_data';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:mangabackupconverter_cli/mangabackupconverter_lib.dart';
import 'package:path/path.dart' as p;

class ConvertCommand extends Command<void> {
  // The [name] and [description] properties must be defined by every
  // subclass.
  @override
  final name = 'convert';
  @override
  final description = 'Convert a manga backup to another format.';

  ConvertCommand() {
    // we can add command specific arguments here.
    // [argParser] is automatically created by the parent class.
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
        allowed: BackupType.values.map((e) => e.name).toList(),
        mandatory: true,
      )
      ..addOption(
        'input-format',
        abbr: 'i',
        help: 'Specify the input backup format type if not detected automatically',
        allowed: BackupType.values.map((e) => e.name).toList(),
      )
      ..addOption(
        'tachi-fork',
        abbr: 't',
        help: 'The specific Tachiyomi fork to use for the backup format',
        allowed: TachiFork.values.map((e) => e.name).toList(),
        defaultsTo: TachiFork.mihon.name,
      );
  }

  @override
  Future<void> run() async {
    return await _executeConvertCommand(argResults!);
  }

  Future<void> _executeConvertCommand(ArgResults results) async {
    bool verbose = false;

    if (results.wasParsed('verbose')) {
      verbose = true;
    }

    if (verbose) {
      print('[VERBOSE] All arguments: ${results.arguments}');
    }

    final io.File backupFile;
    if (results.wasParsed('backup')) {
      backupFile = io.File(results.option('backup') ?? '');
      if (!backupFile.existsSync()) {
        print('backup file does not exist');
        return;
      }
    } else {
      print('backup file not provided');
      return;
    }

    BackupType outputFormat = BackupType.aidoku;
    if (results.wasParsed('output-format')) {
      final outputFormatArg = results.option('output-format');
      if (outputFormatArg == null) {
        print('Output format not provided');
        return;
      }
      outputFormat = BackupType.values.byName(outputFormatArg);
    }

    final backupFileExtension = p.extension(backupFile.uri.toString());
    BackupType? inputFormat = BackupType.byExtension(backupFileExtension);
    if (verbose) {
      print('Imported Backup Extension: $backupFileExtension');
    }

    if (results.wasParsed('input-format')) {
      final inputFormatArg = results.option('input-format');
      inputFormat = inputFormatArg != null ? BackupType.values.byName(inputFormatArg) : null;
    }
    if (inputFormat == null && !BackupType.validExtensions.contains(backupFileExtension)) {
      print('Unsupported file extension: "$backupFileExtension". Use --input-format to specify the input format.');
      return;
    }

    TachiFork outputTachiFork = TachiFork.mihon;
    if (results.wasParsed('tachi-fork')) {
      outputTachiFork = TachiFork.values.byName(results.option('tachi-fork') ?? TachiFork.mihon.name);
    }

    final converter = MangaBackupConverter();

    final ConvertableBackup? importedBackup = switch (inputFormat) {
      BackupType.aidoku => converter.importAidokuBackup(backupFile.readAsBytesSync()),
      BackupType.tachi => converter.importTachibkBackup(backupFile.readAsBytesSync(), fork: outputTachiFork),
      BackupType.paperback => converter.importPaperbackPas4Backup(
        backupFile.readAsBytesSync(),
        name: p.basenameWithoutExtension(backupFile.uri.toString()),
      ),
      BackupType.tachimanga => await converter.importTachimangaBackup(backupFile.readAsBytesSync()),
      BackupType.mangayomi => converter.importMangayomiBackup(backupFile.readAsBytesSync()),
      null => () {
        print('Unsupported imported backup type');
        return null;
      }(),
    };
    if (importedBackup == null) {
      print('Failed to import backup type $backupFileExtension');
      return;
    }
    if (verbose) {
      print('============ Imported Backup Data ============ ');
      importedBackup.verbosePrint(verbose);
    }
    final ConvertableBackup convertedBackup = importedBackup.toBackup(outputFormat);
    if (verbose) {
      print('============ Converted Backup Data ============ ');
      convertedBackup.verbosePrint(verbose);
    }

    final io.File outputFile = io.File(
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
