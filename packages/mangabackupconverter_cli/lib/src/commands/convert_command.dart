// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io' as io;
import 'dart:typed_data';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:characters/characters.dart';
import 'package:collection/collection.dart';
import 'package:mangabackupconverter_cli/mangabackupconverter_lib.dart';
import 'package:mangabackupconverter_cli/src/commands/caching_plugin_loader.dart';
import 'package:mangabackupconverter_cli/src/commands/extension_select_screen.dart';
import 'package:mangabackupconverter_cli/src/commands/format_select_screen.dart';
import 'package:mangabackupconverter_cli/src/commands/migration_dashboard.dart';
import 'package:mangabackupconverter_cli/src/commands/plugin_cache.dart';
import 'package:mangabackupconverter_cli/src/commands/terminal_ui.dart';
import 'package:path/path.dart' as p;

class ConvertCommand extends Command<void> {
  @override
  final String name = 'convert';
  @override
  final String description = 'Convert a manga backup to another format.';

  static final List<String> _aliases = BackupFormat.values.map((BackupFormat f) => f.alias).toList();
  static final List<BackupFormat> _outputFormats = BackupFormat.values
      .where((BackupFormat f) => f.backupBuilder is! UnimplementedBackupBuilder)
      .toList();

  ConvertCommand() {
    argParser
      ..addFlag('verbose', abbr: 'v', negatable: false, help: 'Show additional command output.')
      ..addOption(
        'backup',
        abbr: 'b',
        help: 'A backup file to convert to the output format.',
      )
      ..addOption(
        'output-format',
        abbr: 'f',
        help: 'The output backup format.',
        allowed: _outputFormats.map((BackupFormat f) => f.alias).toList(),
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
      ..addMultiOption(
        'extensions',
        abbr: 'e',
        help:
            'Extension IDs to install (e.g. multi.mangadex). '
            'Skips interactive extension selection.',
      )
      ..addOption(
        'max-rating',
        help: 'Maximum extension content rating (safe, suggestive, nsfw).',
        allowed: <String>['safe', 'suggestive', 'nsfw'],
        defaultsTo: 'suggestive',
      )
      ..addOption(
        'output',
        abbr: 'o',
        help: 'Output file path. Defaults to <input>_converted.<ext> next to the backup file.',
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
    final bool interactive = hasTerminal;

    // Single TerminalContext for the entire interactive session — stdin's
    // broadcast subscription is killed on dispose(), so we must not create
    // multiple short-lived contexts.
    final TerminalContext? context = interactive ? TerminalContext() : null;

    // --- Backup file path ---
    String? backupPath = results.option('backup');
    if (backupPath == null) {
      if (!interactive) {
        context?.showCursor();
        context?.dispose();
        throw UsageException('--backup is required in non-interactive mode.', usage);
      }
      backupPath = await _readPath(context!, prompt: 'Backup file path: ');
      if (backupPath == null || backupPath.isEmpty) {
        context.showCursor();
        context.dispose();
        throw UsageException('No backup file path provided.', usage);
      }
    }

    final backupFile = io.File(backupPath);
    if (!backupFile.existsSync()) {
      context?.showCursor();
      context?.dispose();
      throw UsageException('Backup file does not exist: ${backupFile.path}', usage);
    }

    try {
      return await _runWithContext(results, verbose, interactive, backupFile, context);
    } finally {
      context?.showCursor();
      context?.dispose();
    }
  }

  Future<void> _runWithContext(
    ArgResults results,
    bool verbose,
    bool interactive,
    io.File backupFile,
    TerminalContext? context,
  ) async {
    // --- Output format ---
    final String? outputFormatName = results.option('output-format');
    final BackupFormat outputFormat;
    if (outputFormatName == null) {
      if (!interactive) {
        throw UsageException('--output-format is required in non-interactive mode.', usage);
      }
      final BackupFormat? picked = await FormatSelectScreen().run(
        context: context!,
        formats: _outputFormats,
        title: 'Select output format',
      );
      if (picked == null) {
        throw UsageException('No output format selected.', usage);
      }
      outputFormat = picked;
    } else {
      outputFormat = BackupFormat.byName(outputFormatName);
    }

    if (outputFormat.backupBuilder is UnimplementedBackupBuilder) {
      throw UsageException(
        '${outputFormat.alias} is not yet supported as a target format.',
        usage,
      );
    }

    // --- Input format ---
    final String backupFileExtension = p.extension(backupFile.uri.toString());

    BackupFormat? inputFormat = BackupFormat.byExtension(backupFileExtension);
    if (results.wasParsed('input-format')) {
      inputFormat = BackupFormat.byName(results.option('input-format')!);
    }

    if (inputFormat == null) {
      if (!interactive) {
        throw UsageException(
          'Unsupported file extension: "$backupFileExtension". Use --input-format to specify.',
          usage,
        );
      }
      context!.write('Could not detect format from extension "$backupFileExtension".\r\n');
      final BackupFormat? picked = await FormatSelectScreen().run(
        context: context,
        formats: BackupFormat.values,
        title: 'Select input format',
      );
      if (picked == null) {
        throw UsageException('No input format selected.', usage);
      }
      inputFormat = picked;
    }
    final BackupFormat resolvedInputFormat = inputFormat;

    List<String> repoUrls = results.multiOption('repos');

    final ConversionStrategy strategy = determineStrategy(resolvedInputFormat, outputFormat);
    var forceMigration = false;

    if (interactive) {
      if (strategy is DirectConversion) {
        context!.write(
          '${resolvedInputFormat.alias} can be converted directly to '
          '${outputFormat.alias} without plugins.\r\n'
          'Use plugin migration instead? [y/N] ',
        );
        forceMigration = await _readYesNo(context);
        context.write('\r\n');
      } else if (_isSameBackupFormat(resolvedInputFormat, outputFormat)) {
        context!.write(
          'Source (${resolvedInputFormat.alias}) and target (${outputFormat.alias}) '
          'use the same backup format. '
          'This will re-migrate all manga through plugins.\r\n'
          'Continue? [y/N] ',
        );
        if (!await _readYesNo(context)) {
          throw UsageException('Aborted.', usage);
        }
        context.write('\r\n');
      }
    }

    // --- Repo URL prompt ---
    final bool willMigrate = strategy is Migration || forceMigration;
    if (interactive && willMigrate && repoUrls.isEmpty) {
      final required = strategy is Migration;
      final promptLabel = required ? 'Extension repo URL: ' : 'Extension repo URL (Enter to skip): ';
      String? repoInput;
      do {
        repoInput = await _readLine(context!, prompt: promptLabel);
        if (repoInput == null) {
          throw UsageException('Cancelled.', usage);
        }
        if (repoInput.isEmpty && required) {
          context.write('A repo URL is required for migration.\r\n');
        }
      } while (repoInput.isEmpty && required);
      if (repoInput.isNotEmpty) {
        repoUrls = [repoInput];
      }
    }

    // --- Output path ---
    final String defaultOutputPath = p.join(
      p.dirname(backupFile.path),
      '${p.basenameWithoutExtension(backupFile.uri.toString())}_converted'
      '${outputFormat.extensions.first}',
    );

    String outputPath;
    if (results.wasParsed('output')) {
      outputPath = results.option('output')!;
    } else if (interactive) {
      final String? customPath = await _readPath(
        context!,
        prompt: 'Output path: ',
        defaultValue: defaultOutputPath,
      );
      if (customPath == null) {
        throw UsageException('Cancelled.', usage);
      }
      outputPath = customPath;
    } else {
      outputPath = defaultOutputPath;
    }

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

          final List<String> extensionIds = results.multiOption('extensions');
          final int maxRating = switch (results.option('max-rating')) {
            'safe' => 0,
            'nsfw' => 2,
            _ => 1,
          };

          final pluginCache = PluginCache();
          final cachingLoader = CachingPluginLoader(
            outputFormat.pluginLoader,
            cache: pluginCache,
          );
          final pipeline = MigrationPipeline(
            repoUrls: repoUrls,
            pluginLoader: cachingLoader,
            onSelectExtensions: (List<ExtensionEntry> allExtensions) async {
              final List<ExtensionEntry> extensions = allExtensions
                  .where((ExtensionEntry e) => e.contentRating <= maxRating)
                  .toList();
              if (extensions.isEmpty) {
                throw const MigrationException(
                  'No extensions available at the selected content rating.',
                );
              }

              // --extensions flag: filter by ID, skip TUI/auto-select.
              if (extensionIds.isNotEmpty) {
                final Set<String> idSet = extensionIds.toSet();
                final List<ExtensionEntry> matched = extensions
                    .where((ExtensionEntry e) => idSet.contains(e.id))
                    .toList();
                final Set<String> unmatched = idSet.difference(
                  matched.map((ExtensionEntry e) => e.id).toSet(),
                );
                for (final id in unmatched) {
                  Zone.root.print('Warning: extension "$id" not found in repos.');
                }
                if (matched.isNotEmpty) return matched;
                if (!interactive) {
                  throw UsageException(
                    'None of the specified extensions were found.',
                    usage,
                  );
                }
                // Fall through to TUI when interactive.
              }

              if (interactive) {
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

              // Non-interactive fallback: auto-select MangaDex or first.
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
            forceMigration: forceMigration,
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

/// Reads a single y/n keypress from [KeyInput] in raw mode.
Future<bool> _readYesNo(TerminalContext context) async {
  await for (final KeyEvent key in context.keyInput.stream) {
    if (key is CharKey) {
      final String ch = key.char.toLowerCase();
      if (ch == 'y') return true;
      if (ch == 'n') return false;
    }
    if (key is Enter) return false; // default = No
    if (key is Escape) return false;
  }
  return false;
}

bool _isSameBackupFormat(BackupFormat source, BackupFormat target) =>
    source == target || (source is Tachiyomi && target is Tachiyomi);

/// Reads a file path from the user with Tab completion support.
///
/// Renders a prompt line with an inverse-video block cursor and shows
/// completion candidates when multiple Tab matches exist.
/// Returns `null` on Escape; returns [defaultValue] (or `''`) on empty Enter.
Future<String?> _readPath(
  TerminalContext context, {
  String prompt = '',
  String? defaultValue,
}) async {
  final state = PathInputState(defaultValue ?? '');
  final region = ScreenRegion(context);
  const maxCompletionRows = 8;

  void render() {
    final lines = <String>[];
    lines.add(_renderPathInput(prompt, state, context.width));
    // Show completion candidates below the input line.
    final List<String> completions = state.completions;
    if (completions.isNotEmpty) {
      final int count = completions.length.clamp(0, maxCompletionRows);
      for (var i = 0; i < count; i++) {
        final String entry = completions[i];
        final String label = truncate(entry, context.width - 2);
        if (i == state.completionIndex) {
          lines.add(green('❯ $label'));
        } else {
          lines.add('  $label');
        }
      }
      if (completions.length > maxCompletionRows) {
        lines.add(dim('  … ${completions.length - maxCompletionRows} more'));
      }
    }
    region.render(lines);
  }

  context.hideCursor();
  render();

  await for (final KeyEvent key in context.keyInput.stream) {
    final PathInputResult result = state.handleKey(key);
    switch (result) {
      case PathInputResult.submitted:
        region.clear();
        context.showCursor();
        final String text = state.text.trim();
        final String resolved = text.isEmpty ? (defaultValue ?? '') : text;
        context.write('$prompt$resolved\r\n');
        return resolved;
      case PathInputResult.cancelled:
        region.clear();
        context.showCursor();
        context.write('$prompt\r\n');
        return null;
      case PathInputResult.textChanged:
      case PathInputResult.cursorMoved:
      case PathInputResult.tabCompleted:
        render();
      case PathInputResult.ignored:
        break;
    }
  }
  context.showCursor();
  return null;
}

/// Renders the path input line with an inverse-video block cursor.
String _renderPathInput(String prompt, PathInputState state, int width) {
  final String text = state.text;
  final int cursorPos = state.cursorPos;
  final int promptWidth = displayWidth(prompt);
  final int availableWidth = width - promptWidth;

  if (availableWidth <= 0) return truncate(prompt, width);

  final List<String> chars = text.characters.toList();
  final int clampedPos = cursorPos.clamp(0, chars.length);

  final buf = StringBuffer(prompt);
  var col = 0;
  for (var i = 0; i < chars.length; i++) {
    final int gw = displayWidth(chars[i]);
    if (col + gw > availableWidth) break;
    if (i == clampedPos) {
      buf.write('\x1b[7m${chars[i]}\x1b[27m');
    } else {
      buf.write(chars[i]);
    }
    col += gw;
  }
  if (clampedPos == chars.length && col < availableWidth) {
    buf.write('\x1b[7m \x1b[27m');
  }

  return buf.toString();
}

/// Reads a line of text from [KeyInput] in raw mode, echoing characters.
/// Returns `null` on Escape; returns [defaultValue] (or `''`) on empty Enter.
Future<String?> _readLine(
  TerminalContext context, {
  String prompt = '',
  String? defaultValue,
}) async {
  final buf = StringBuffer();
  final String defaultHint = defaultValue != null ? dim(' ($defaultValue)') : '';
  context.write('$prompt$defaultHint');

  await for (final KeyEvent key in context.keyInput.stream) {
    switch (key) {
      case Escape():
        context.write('\r\n');
        return null;
      case Enter():
        context.write('\r\n');
        final String text = buf.toString().trim();
        return text.isEmpty ? (defaultValue ?? '') : text;
      case Backspace():
        if (buf.isNotEmpty) {
          context.write('\x08 \x08');
          final s = buf.toString();
          buf.clear();
          buf.write(s.substring(0, s.length - 1));
        }
      case CharKey(:final char):
        buf.write(char);
        context.write(char);
      default:
        break;
    }
  }
  return null;
}
