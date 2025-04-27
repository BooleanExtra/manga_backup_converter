import 'package:dart_mappable/dart_mappable.dart';
import 'package:mangabackupconverter_cli/src/proto/schema_neko.proto/proto/schema_neko.pb.dart' as neko;

part 'neko_backup_merge_manga.mapper.dart';

@MappableClass()
class NekoBackupMergeManga with NekoBackupMergeMangaMappable {
  final String url;
  final String title;
  final String coverUrl;
  final int mergeType;

  const NekoBackupMergeManga({required this.url, required this.title, required this.coverUrl, required this.mergeType});

  factory NekoBackupMergeManga.fromNeko(neko.BackupMergeManga backupCategory) {
    return NekoBackupMergeManga(
      url: backupCategory.url,
      title: backupCategory.title,
      coverUrl: backupCategory.coverUrl,
      mergeType: backupCategory.mergeType,
    );
  }

  static const fromMap = NekoBackupMergeMangaMapper.fromMap;
  static const fromJson = NekoBackupMergeMangaMapper.fromJson;
}
