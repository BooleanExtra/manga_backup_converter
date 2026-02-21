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

  static final List<String> _aliases = BackupFormat.values.map((BackupFormat f) => f.alias).toList();

  ConvertCommand() {
    argParser
      ..addFlag('verbose', abbr: 'v', negatable: false, help: 'Show additional command output.')
      ..addOption(
        'backup',
        abbr: 'b',
        help: 'A backup file to convert to the output format.',
        mandatory: true,
      )
      ..addOption(
        'output-format',
        abbr: 'f',
        help: 'The output backup format.',
        allowed: _aliases,
        mandatory: true,
      )
      ..addOption(
        'input-format',
        abbr: 'i',
        help: 'Specify the input backup format if not detected automatically.',
        allowed: _aliases,
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

    final BackupFormat outputFormat = BackupFormat.byName(results.option('output-format')!);

    final String backupFileExtension = p.extension(backupFile.uri.toString());
    if (verbose) {
      print('Imported Backup Extension: $backupFileExtension');
    }

    BackupFormat? inputFormat = BackupFormat.byExtension(backupFileExtension);
    if (results.wasParsed('input-format')) {
      inputFormat = BackupFormat.byName(results.option('input-format')!);
    }

    if (inputFormat == null) {
      throw UsageException(
        'Unsupported file extension: "$backupFileExtension". Use --input-format to specify the input format.',
        usage,
      );
    }

    final converter = MangaBackupConverter();
    final Uint8List bytes = backupFile.readAsBytesSync();
    final ConvertableBackup importedBackup = switch (inputFormat) {
      Aidoku() => converter.importAidokuBackup(bytes),
      Tachiyomi() => converter.importTachibkBackup(bytes, format: inputFormat),
      Paperback() => converter.importPaperbackPas4Backup(
        bytes,
        name: p.basenameWithoutExtension(backupFile.uri.toString()),
      ),
      Tachimanga() => await converter.importTachimangaBackup(bytes),
      Mangayomi() => converter.importMangayomiBackup(bytes),
    };

    if (verbose) {
      print('============ Imported Backup Data ============ ');
      importedBackup.verbosePrint(verbose);
    }

    final pipeline = MigrationPipeline(
      repoUrls: const <String>[],
      onSelectExtensions: (List<ExtensionEntry> extensions) async => extensions,
      onConfirmMatch: (MangaMatchProposal proposal) async =>
          MangaMatchConfirmation(sourceManga: proposal.sourceManga, confirmedMatch: proposal.bestMatch),
      onProgress: (int current, int total, String message) => verbose ? print('[$current/$total] $message') : null,
    );

    try {
      final ConvertableBackup convertedBackup = await pipeline.run(
        sourceBackup: importedBackup,
        sourceFormat: inputFormat,
        targetFormat: outputFormat,
      );

      if (verbose) {
        print('============ Converted Backup Data ============ ');
        convertedBackup.verbosePrint(verbose);
      }

      final Uint8List fileData = await convertedBackup.toData();
      final outputFile = io.File(
        '${p.basenameWithoutExtension(backupFile.uri.toString())}_converted${outputFormat.extensions.first}',
      );
      if (verbose) {
        print('Converted Backup Size: ${fileData.length}');
      }
      if (outputFile.existsSync()) {
        print('Output file already exists, overwriting...');
      }
      outputFile.writeAsBytesSync(fileData);
      print('Converted backup written to ${outputFile.path}');
    } on MigrationException catch (e) {
      io.stderr.writeln('Migration failed: $e');
      io.exitCode = 1;
    }
  }
}
