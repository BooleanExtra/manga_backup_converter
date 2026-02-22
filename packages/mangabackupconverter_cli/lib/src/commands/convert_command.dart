// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io' as io;
import 'dart:typed_data';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:collection/collection.dart';
import 'package:mangabackupconverter_cli/mangabackupconverter_lib.dart';
import 'package:mangabackupconverter_cli/src/commands/extension_select_screen.dart';
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
      )
      ..addOption(
        'log-file',
        abbr: 'l',
        help:
            'Log file path for verbose output in interactive mode. '
            'Defaults to <output-basename>.log next to the output file.',
      );
  }

  @override
  Future<void> run() async {
    final ArgResults results = argResults!;
    final bool verbose = results.flag('verbose');

    final backupFile = io.File(results.option('backup')!);
    if (!backupFile.existsSync()) {
      throw UsageException('Backup file does not exist: ${backupFile.path}', usage);
    }

    final BackupFormat outputFormat = BackupFormat.byName(results.option('output-format')!);

    final String backupFileExtension = p.extension(backupFile.uri.toString());

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
    final BackupFormat resolvedInputFormat = inputFormat;

    final List<String> repoUrls = results.multiOption('repos');
    final bool interactive = hasTerminal;

    String outputPath =
        results.option('output') ??
        '${p.basenameWithoutExtension(backupFile.uri.toString())}_converted${outputFormat.extensions.first}';

    // If -o points to a directory, append default filename inside it.
    if (io.FileSystemEntity.isDirectorySync(outputPath) ||
        outputPath.endsWith(p.separator) ||
        outputPath.endsWith('/')) {
      outputPath = p.join(
        outputPath,
        '${p.basenameWithoutExtension(backupFile.uri.toString())}_converted${outputFormat.extensions.first}',
      );
    }

    final String logPath = results.option('log-file') ?? (interactive ? '${p.withoutExtension(outputPath)}.log' : '');
    final io.IOSink? logSink = logPath.isNotEmpty ? io.File(logPath).openWrite() : null;
    var logSinkMounted = logSink != null;

    final TerminalContext? context = interactive ? TerminalContext() : null;

    // Loading indicator for interactive startup.
    final Spinner? spinner = interactive ? Spinner() : null;
    final ScreenRegion? loadingRegion = context != null ? ScreenRegion(context) : null;
    var loadingMessage = '';
    void updateLoading(String message) {
      loadingMessage = message;
      loadingRegion?.render(['${spinner!.frame} $loadingMessage']);
    }

    if (interactive) {
      context!.hideCursor();
      spinner!.start(() => loadingRegion!.render(['${spinner.frame} $loadingMessage']));
    }

    final OnConfirmMatches onConfirmMatches = interactive
        ? (pluginNames, manga, onSearch, onFetchDetails) {
            spinner!.stop();
            loadingRegion!.clear();
            context!.showCursor();
            return MigrationDashboard().run(
              context: context,
              pluginNames: pluginNames,
              manga: manga,
              onSearch: onSearch,
              onFetchDetails: onFetchDetails,
            );
          }
        : _autoAcceptMatches;

    try {
      await runZoned(
        () async {
          updateLoading('Reading backup file...');
          final converter = MangaBackupConverter();
          final Uint8List bytes = backupFile.readAsBytesSync();

          updateLoading('Importing ${resolvedInputFormat.alias} backup...');
          final ConvertableBackup importedBackup = switch (resolvedInputFormat) {
            Aidoku() => converter.importAidokuBackup(bytes),
            Tachiyomi() => converter.importTachibkBackup(bytes, format: resolvedInputFormat),
            Paperback() => converter.importPaperbackPas4Backup(
              bytes,
              name: p.basenameWithoutExtension(backupFile.uri.toString()),
            ),
            Tachimanga() => await converter.importTachimangaBackup(bytes),
            Mangayomi() => converter.importMangayomiBackup(bytes),
          };

          if (verbose) {
            print('[VERBOSE] All arguments: ${results.arguments}');
            print('Imported Backup Extension: $backupFileExtension');
            print('============ Imported Backup Data ============ ');
            importedBackup.verbosePrint(verbose);
          }
          if (verbose && !interactive) {
            print('[VERBOSE] Non-interactive mode: auto-accepting best matches');
          }

          final pipeline = MigrationPipeline(
            repoUrls: repoUrls,
            onSelectExtensions: interactive
                ? (List<ExtensionEntry> extensions) async {
                    spinner!.stop();
                    loadingRegion!.clear();
                    context!.showCursor();

                    final List<ExtensionEntry>? result = await ExtensionSelectScreen().run(
                      context: context,
                      extensions: extensions,
                    );

                    if (result == null || result.isEmpty) {
                      throw const MigrationException('No extensions selected.');
                    }

                    context.hideCursor();
                    spinner.start(
                      () => loadingRegion.render(
                        ['${spinner.frame} $loadingMessage'],
                      ),
                    );
                    return result;
                  }
                : (List<ExtensionEntry> extensions) async {
                    return [
                      extensions.firstWhereOrNull(
                            (ExtensionEntry e) => e.id == 'multi.mangadex',
                          ) ??
                          extensions.first,
                    ];
                  },
            onConfirmMatches: onConfirmMatches,
            onProgress: (int current, int total, String message) {
              if (verbose) print('[$current/$total] $message');
              if (interactive) {
                final progress = total > 0 ? ' [$current/$total]' : '';
                updateLoading('$message$progress');
              }
            },
          );

          final ConvertableBackup convertedBackup = await pipeline.run(
            sourceBackup: importedBackup,
            sourceFormat: resolvedInputFormat,
            targetFormat: outputFormat,
          );

          if (verbose) {
            print('============ Converted Backup Data ============ ');
            convertedBackup.verbosePrint(verbose);
          }

          final Uint8List fileData = await convertedBackup.toData();
          final outputFile = io.File(outputPath);
          if (verbose) {
            print('Converted Backup Size: ${fileData.length}');
          }
          if (outputFile.existsSync()) {
            // Write outside zone — user-facing status message
            Zone.root.print('Output file already exists, overwriting...');
          }
          outputFile.writeAsBytesSync(fileData);
          // Write outside zone — user-facing status message
          Zone.root.print('Converted backup written to ${outputFile.path}');
        },
        zoneSpecification: logSink != null
            ? ZoneSpecification(
                print: (self, parent, zone, line) {
                  if (logSinkMounted) logSink.writeln(line);
                },
              )
            : null,
      );
    } on MigrationException catch (e) {
      io.stderr.writeln('Migration failed: $e');
      io.exitCode = 1;
    } finally {
      spinner?.stop();
      loadingRegion?.clear();
      context?.showCursor();
      context?.dispose();
      logSinkMounted = false;
      await logSink?.flush();
      await logSink?.close();
      if (logSink != null) {
        print('Logs written to $logPath');
      }
    }
  }
}

/// Non-interactive fallback: searches for each manga, auto-accepts the best match.
Future<List<MangaMatchConfirmation>> _autoAcceptMatches(
  List<String> pluginNames,
  List<SourceMangaData> manga,
  Stream<PluginSearchEvent> Function(String query) onSearch,
  Future<(PluginMangaDetails, List<PluginChapter>)?> Function(
    String pluginSourceId,
    String mangaKey,
  )
  onFetchDetails,
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
