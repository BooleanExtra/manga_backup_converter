import 'package:dart_mappable/dart_mappable.dart';
import 'package:mangabackupconverter_cli/src/proto/schema_mihon.proto/proto/schema_mihon.pb.dart' as mihon;
import 'package:mangabackupconverter_cli/src/proto/schema_sy.proto/proto/schema_sy.pb.dart' as sy;

part 'tachi_backup_extension_repo.mapper.dart';

@MappableClass()
class TachiBackupExtensionRepo with TachiBackupExtensionRepoMappable {
  final String name;
  final String baseUrl;
  final String shortName;
  final String website;
  final String signingKeyFingerprint;

  const TachiBackupExtensionRepo({
    required this.name,
    required this.baseUrl,
    required this.shortName,
    required this.website,
    required this.signingKeyFingerprint,
  });

  factory TachiBackupExtensionRepo.fromMihon(mihon.BackupExtensionRepos backupExtensionRepos) {
    return TachiBackupExtensionRepo(
      name: backupExtensionRepos.name,
      baseUrl: backupExtensionRepos.baseUrl,
      shortName: backupExtensionRepos.shortName,
      website: backupExtensionRepos.website,
      signingKeyFingerprint: backupExtensionRepos.signingKeyFingerprint,
    );
  }

  factory TachiBackupExtensionRepo.fromSy(sy.BackupExtensionRepos backupExtensionRepos) {
    return TachiBackupExtensionRepo(
      name: backupExtensionRepos.name,
      baseUrl: backupExtensionRepos.baseUrl,
      shortName: backupExtensionRepos.shortName,
      website: backupExtensionRepos.website,
      signingKeyFingerprint: backupExtensionRepos.signingKeyFingerprint,
    );
  }

  static const TachiBackupExtensionRepo Function(Map<String, dynamic> map) fromMap =
      TachiBackupExtensionRepoMapper.fromMap;
  static const TachiBackupExtensionRepo Function(String json) fromJson = TachiBackupExtensionRepoMapper.fromJson;
}
