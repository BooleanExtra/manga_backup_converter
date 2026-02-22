// ignore_for_file: avoid_print

import 'dart:io' as io;
import 'dart:typed_data';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:mangabackupconverter_cli/mangabackupconverter_lib.dart';
import 'package:mangabackupconverter_cli/src/commands/migration_dashboard.dart';
import 'package:mangabackupconverter_cli/src/commands/terminal_ui.dart';
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
      )
      ..addMultiOption(
        'repos',
        abbr: 'r',
        help: 'Extension repo URLs for plugin-based migration.',
      )
      ..addOption(
        'output',
        abbr: 'o',
        help: 'Output file path. Defaults to <input>_converted.<ext> in the current directory.',
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

    final List<String> repoUrls = results.multiOption('repos');
    final bool interactive = hasTerminal;
    if (verbose && !interactive) {
      print('[VERBOSE] Non-interactive mode: auto-accepting best matches');
    }

    final OnConfirmMatches onConfirmMatches = interactive
        ? MigrationDashboard().run
        : _autoAcceptMatches;

    final pipeline = MigrationPipeline(
      repoUrls: repoUrls,
      onSelectExtensions: (List<ExtensionEntry> extensions) async {
        // TODO: Implement extension selection logic
        // User will pick from list of extensions
        // If none are correct, user can search in the terminal for the extension and then pick from the results
        //     - The results should be streamed in, some extensions may be very slow or not functional so we should handle that gracefully
        return extensions;
      },
      onConfirmMatches: onConfirmMatches,
      onProgress: (int current, int total, String message) {
        if (verbose) print('[$current/$total] $message');
      },
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
      final String outputPath = results.option('output') ??
          '${p.basenameWithoutExtension(backupFile.uri.toString())}_converted${outputFormat.extensions.first}';
      final outputFile = io.File(outputPath);
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

/// Non-interactive fallback: searches for each manga, auto-accepts the best match.
Future<List<MangaMatchConfirmation>> _autoAcceptMatches(
  List<SourceMangaData> manga,
  Stream<PluginSearchEvent> Function(String query) onSearch,
  Future<(PluginMangaDetails, List<PluginChapter>)?> Function(
    String pluginSourceId,
    String mangaKey,
  ) onFetchDetails,
) async {
  final confirmations = <MangaMatchConfirmation>[];
  for (final entry in manga) {
    final allResults = <PluginSearchResult>[];
    await for (final PluginSearchEvent event in onSearch(entry.details.title)) {
      if (event is PluginSearchResults) {
        allResults.addAll(event.results);
      }
    }
    final String lower = entry.details.title.toLowerCase();
    PluginSearchResult? best;
    if (allResults.isNotEmpty) {
      for (final r in allResults) {
        if (r.title.toLowerCase() == lower) {
          best = r;
          break;
        }
      }
      best ??= allResults.first;
    }
    confirmations.add(MangaMatchConfirmation(sourceManga: entry, confirmedMatch: best));
  }
  return confirmations;
}
