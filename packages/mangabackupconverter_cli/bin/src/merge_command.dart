// ignore_for_file: avoid_print

import 'dart:io' as io;
import 'dart:typed_data';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:mangabackupconverter_cli/mangabackupconverter_lib.dart';
import 'package:path/path.dart' as p;

/// A command to merge two Aidoku backups.
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
        abbr: 'f',
        help: 'A backup file from Aidoku',
        mandatory: true,
      )
      ..addOption(
        'other',
        abbr: 'm',
        help: 'The other Aidoku backup to merge with the first',
        mandatory: true,
      )
      ..addOption(
        'output',
        abbr: 'o',
        help: 'The output folder to save the merged backup',
      );
  }

  @override
  Future<void> run() async {
    return await _executeMergeCommand(argResults!);
  }

  Future<void> _executeMergeCommand(ArgResults results) async {
    final bool verbose = results.wasParsed('verbose');
    if (verbose) {
      print('[VERBOSE] All arguments: ${results.arguments}');
    }
    final io.File backupFile = _parseFile(results, 'backup');
    final io.File otherBackupFile = _parseFile(results, 'other');
    final outputFolder =
        results.wasParsed('output') ? results.option('output')! : '.';
    io.Directory(outputFolder).createSync(recursive: true);
    final String outputPath = p.join(
      outputFolder,
      '${p.basenameWithoutExtension(backupFile.path)}_MergedWith_${p.basenameWithoutExtension(otherBackupFile.path)}.aib',
    );
    final backupFileExtension = p.extension(backupFile.uri.toString());
    final otherBackupFileExtension =
        p.extension(otherBackupFile.uri.toString());
    if (backupFileExtension != '.aib') {
      print('Backup file format "$backupFileExtension" not supported');
      throw ArgumentError(
        'Backup file format "$backupFileExtension" not supported',
      );
    }
    if (otherBackupFileExtension != '.aib') {
      print('Backup file format "$otherBackupFileExtension" not supported');
      throw ArgumentError(
        'Backup file format "$otherBackupFileExtension" not supported',
      );
    }
    final AidokuBackup aidokuBackup = AidokuBackup.fromBinaryPropertyList(
      ByteData.sublistView(
        backupFile.readAsBytesSync(),
      ),
    );
    if (verbose) {
      print('[VERBOSE] Imported Aidoku Backup: $aidokuBackup');
    }
    print('Backup Library: ${aidokuBackup.library?.length}');
    final AidokuBackup otherAidokuBackup = AidokuBackup.fromBinaryPropertyList(
      ByteData.sublistView(
        otherBackupFile.readAsBytesSync(),
      ),
    );
    if (verbose) {
      print('[VERBOSE] Imported Other Aidoku Backup: $otherAidokuBackup');
    }
    print('Other Backup Library: ${otherAidokuBackup.library?.length}');
    final AidokuBackup combinedBackup =
        aidokuBackup.mergeWith(otherAidokuBackup);
    if (verbose) {
      print('[VERBOSE] Combined Aidoku Backup: $combinedBackup');
      final library = combinedBackup.library!.toList();
      final Set<String> duplicates = {};
      for (int i = 0; i < library.length; i++) {
        for (int j = i + 1; j < library.length; j++) {
          final libraryManga = library[i];
          final otherManga = library[j];
          if (libraryManga.mangaId == otherManga.mangaId &&
              libraryManga != otherManga) {
            duplicates.add(libraryManga.mangaId);
            break;
          }
        }
      }
      print('[VERBOSE] Duplicate Library Manga Ids: $duplicates');
      print('[VERBOSE] Duplicate Library Manga: ${duplicates.length}');
    }
    print('Combined Library: ${combinedBackup.manga?.length}');
    final Uint8List combinedBackupData = await combinedBackup.toData();
    final io.File outputFile = io.File(outputPath);
    outputFile.writeAsBytesSync(combinedBackupData);
    print('Saved merged backup to ${outputFile.path}');
  }

  io.File _parseFile(ArgResults results, String optionName) {
    final io.File backupFile;
    if (results.wasParsed(optionName)) {
      backupFile = io.File(results.option(optionName) ?? '');
      if (!backupFile.existsSync()) {
        print('$optionName file does not exist');
        throw ArgumentError('$optionName file does not exist');
      }
    } else {
      print('$optionName file not provided');
      throw ArgumentError('$optionName file not provided');
    }

    return backupFile;
  }
}
