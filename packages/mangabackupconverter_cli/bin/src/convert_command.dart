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
        allowed: BackupType.values.map((e) => e.name).toList(),
        mandatory: true,
      )
      ..addOption(
        'input-format',
        abbr: 'i',
        help:
            'Specify the input backup format type if not detected automatically',
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
      inputFormat = inputFormatArg != null
          ? BackupType.values.byName(inputFormatArg)
          : null;
    }
    if (inputFormat == null &&
        !BackupType.validExtensions.contains(backupFileExtension)) {
      print(
        'Unsupported file extension: "$backupFileExtension". Use --input-format to specify the input format.',
      );
      return;
    }

    TachiFork outputTachiFork = TachiFork.mihon;
    if (results.wasParsed('tachi-fork')) {
      outputTachiFork = TachiFork.values
          .byName(results.option('tachi-fork') ?? TachiFork.mihon.name);
    }

    final converter = MangaBackupConverter();

    final TachiBackup? tachiBackup = switch (inputFormat) {
      BackupType.aidoku => () {
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
      BackupType.tachi => () {
          final TachiBackup tachibkBackup = converter.importTachibkBackup(
            backupFile.readAsBytesSync(),
            fork: outputTachiFork,
          );
          if (verbose) {
            print(tachibkBackup);
          }
          return tachibkBackup;
        }(),
      BackupType.paperback => () {
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
      BackupType.tachimanga => await () async {
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

    final io.File outputFile = io.File(
      '${p.basenameWithoutExtension(backupFile.uri.toString())}_converted${outputFormat.extensions.first}',
    );
    final Uint8List? fileData = switch (outputFormat) {
      BackupType.tachi => tachiBackup.toBackup(),
      BackupType.paperback =>
        // TODO: Implement Tachi to Paperback
        null,
      BackupType.aidoku =>
        // TODO: Implement Tachi to Aidoku
        null,
      BackupType.tachimanga =>
        // TODO: Implement Tachi to Tachimanga
        null,
      BackupType.mangayomi =>
        // TODO: Implement Tachi to Mangayomi
        null,
    };
    if (fileData == null) {
      print(
        'Failed to convert backup type $inputFormat to $outputFormat format',
      );
      return;
    }
    if (verbose) {
      print('Converted Backup Size: ${fileData.length}');
    }
    if (outputFile.existsSync()) {
      print('Output file already exists, overwriting...');
    }
    outputFile.writeAsBytesSync(fileData);
  }
}

enum BackupType {
  aidoku(['.aib']),
  paperback(['.pas4']),
  tachi(['.tachibk', '.proto.gz']),
  tachimanga(['.tmb']),
  mangayomi(['.backup']);

  const BackupType(this.extensions);

  final List<String> extensions;

  static List<String> get validExtensions =>
      values.expand((e) => e.extensions).toList();

  static BackupType? byExtension(String extension) {
    for (final type in values) {
      if (type.extensions.contains(extension)) {
        return type;
      }
    }
    return null;
  }
}
