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
      ..addFlag(
        'verbose',
        abbr: 'v',
        negatable: false,
        help: 'Show additional command output.',
      )
      ..addOption(
        'backup',
        abbr: 'b',
        help:
            'A backup file from Mihon, Aidoku, Paperback, or Tachimanga to convert to the output format',
        mandatory: true,
      )
      ..addOption(
        'output-format',
        abbr: 'f',
        help: 'The output backup format the backup will be converted to',
        allowed: ['aidoku', 'tachi', 'paperback', 'mangayomi'],
        mandatory: true,
      )
      ..addOption(
        'tachi-fork',
        abbr: 't',
        help: 'The specific Tachiyomi fork to use for the backup format',
        allowed: [
          TachiFork.mihon.name,
          TachiFork.sy.name,
          TachiFork.j2k.name,
          TachiFork.yokai.name,
          TachiFork.neko.name,
        ],
        defaultsTo: TachiFork.mihon.name,
      );
  }

  @override
  Future<void> run() async {
    return await _executeConvertCommand(argResults!);
  }

  Future<void> _executeConvertCommand(ArgResults results) async {
    bool verbose = false;
    String outputFormat = 'aib';
    TachiFork outputTachiFork = TachiFork.mihon;

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

    final backupFileExtension = p.extension(backupFile.uri.toString());
    if (verbose) {
      print('Imported Backup Extension: $backupFileExtension');
    }

    if (results.wasParsed('output-format')) {
      outputFormat = results.option('output-format') ?? 'aib';
    }
    if (!['.aib', '.tachibk', '.proto.gz', '.pas4', '.tmb', '.backup']
        .contains(backupFileExtension)) {
      print('Unsupported file extension: "$backupFileExtension"');
      return;
    }

    if (results.wasParsed('tachi-fork')) {
      outputTachiFork = TachiFork.values
          .byName(results.option('tachi-fork') ?? TachiFork.mihon.name);
    }

    final converter = MangaBackupConverter();

    final TachiBackup? tachiBackup = switch (backupFileExtension) {
      '.aib' => () {
          final AidokuBackup aidokuBackup = converter.importAidokuBackup(
            ByteData.sublistView(
              backupFile.readAsBytesSync(),
            ),
          );
          if (verbose) {
            print('Imported Library Manga: ${aidokuBackup.library?.length}');
            print('Imported Manga: ${aidokuBackup.manga?.length}');
            print('Imported Chapters: ${aidokuBackup.chapters?.length}');
            print('Imported Manga History: ${aidokuBackup.history?.length}');
            print(
              'Imported Tracked Manga Items: ${aidokuBackup.trackItems?.length}',
            );
            print('Imported Categories: ${aidokuBackup.categories?.length}');
            print('Imported Sources: ${aidokuBackup.sources?.length}');
            print('Aidoku Backup Name: ${aidokuBackup.name}');
            print('Aidoku Version: ${aidokuBackup.version}');
          }
          // TODO: Implement Aidoku to Tachi
          return null;
        }(),
      '.tachibk' || '.proto.gz' => () {
          final TachiBackup tachibkBackup = converter.importTachibkBackup(
            backupFile.readAsBytesSync(),
            fork: outputTachiFork,
          );
          if (verbose) {
            print(tachibkBackup);
          }
          return tachibkBackup;
        }(),
      '.pas4' => () {
          final PaperbackBackup paperbackBackup =
              converter.importPaperbackPas4Backup(
            backupFile.readAsBytesSync(),
            name: p.basenameWithoutExtension(backupFile.uri.toString()),
          );
          if (verbose) {
            print('Imported Manga Info: ${paperbackBackup.mangaInfo?.length}');
            print(
              'Imported Library Manga: ${paperbackBackup.libraryManga?.length}',
            );
            print('Imported Chapters: ${paperbackBackup.chapters?.length}');
            print(
              'Imported Chapter Progress Marker: ${paperbackBackup.chapterProgressMarker?.length}',
            );
            print(
              'Imported Source Manga: ${paperbackBackup.sourceManga?.length}',
            );
            final trackedManga = paperbackBackup.libraryManga
                ?.where((i) => i.trackedSources.isNotEmpty)
                .toList();
            print('Tracked Manga: ${trackedManga?.length}');
            final mangaWithSecondarySources = paperbackBackup.libraryManga
                ?.where((i) => i.secondarySources.isNotEmpty)
                .toList();
            print(
              'Manga with Secondary Sources: ${mangaWithSecondarySources?.length}',
            );
            final mangaTagsWithTags = paperbackBackup.mangaInfo
                ?.where(
                  (i) => i.tags.where((e) => e.tags.isNotEmpty).isNotEmpty,
                )
                .toList();
            print('Manga with Tags: ${mangaTagsWithTags?.length}');
          }

          // TODO: Implement Paperback to Tachi
          return null;
        }(),
      '.tmb' => await () async {
          final TachimangaBackup tachimangaBackup =
              await converter.importTachimangaBackup(
            backupFile.readAsBytesSync(),
          );
          if (verbose) {
            print('Imported Manga: ${tachimangaBackup.db.mangaTable.length}');
            print(
              'Imported Chapters: ${tachimangaBackup.db.chapterTable.length}',
            );
            print(
              'Imported Manga History: ${tachimangaBackup.db.historyTable.length}',
            );
            print(
              'Imported Tracked Manga Items: ${tachimangaBackup.db.trackRecordTable.length}',
            );
            print(
              'Imported Categories: ${tachimangaBackup.db.categoryTable.length}',
            );
            print(
              'Imported Sources: ${tachimangaBackup.db.sourceTable.length}',
            );
            print('Imported Repos: ${tachimangaBackup.db.repoTable.length}');
            print('Tachimanga Backup Name: ${tachimangaBackup.name}');
            print('Tachimanga Version: ${tachimangaBackup.meta.version}');
          }

          return tachimangaBackup.toTachi();
        }(),
      _ => () {
          print('Unsupported imported backup type');
          return null;
        }(),
    };
    if (tachiBackup == null) {
      print(
        'Failed to convert backup type $backupFileExtension to Tachi format',
      );
      return;
    }
    if (verbose) {
      print('Converted Categories: ${tachiBackup.backupCategories.length}');
      print('Converted Manga: ${tachiBackup.backupManga.length}');
      print('Converted Sources: ${tachiBackup.backupSources.length}');
      print(
        'Converted Extension Repos: ${tachiBackup.backupExtensionRepo.length}',
      );
    }

    // TODO: Fix output format not the extension
    final io.File outputFile = io.File(
      '${p.basenameWithoutExtension(backupFile.uri.toString())}.$outputFormat',
    );
    switch (outputFormat) {
      case 'tachi':
        outputFile.writeAsStringSync(
          tachiBackup.toJson(),
        );
      case 'paperback':
        // TODO: Implement Tachi to Paperback
        break;
      case 'aidoku':
        // TODO: Implement Tachi to Aidoku
        break;
      default:
        print('Unsupported output format');
        return;
    }
  }
}
