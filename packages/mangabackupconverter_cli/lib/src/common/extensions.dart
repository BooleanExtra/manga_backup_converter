import 'package:collection/collection.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:mangabackupconverter_cli/src/common/backup_type.dart';
import 'package:mangabackupconverter_cli/src/exceptions/extension_exception.dart';

part 'extensions.mapper.dart';

const String _extensionRepoIndexJson = '''
{
  "repos": {
    "aidoku": [
      {
        "name": "Aidoku Community Sources",
        "url": "https://raw.githubusercontent.com/Skittyblock/aidoku-community-sources/gh-pages"
      },
      {
        "name": "Kavya",
        "url": "https://raw.githubusercontent.com/ACK72/kavya-aidoku/gh-pages"
      },
      {
        "name": "Kavya 2",
        "url": "https://raw.githubusercontent.com/getBoolean/kavya-aidoku/gh-pages"
      }
    ],
    "paperback": [
      {
        "name": "Paperback Community Extensions (0.8)",
        "url": "https://thenetsky.github.io/community-extensions/0.8"
      }
    ]
  },
  "sites": [
    {
      "name": "MangaDex",
      "extensions": {
        "aidoku": [
          {
            "name": "MangaDex",
            "id": "multi.mangadex",
            "repo": "https://raw.githubusercontent.com/Skittyblock/aidoku-community-sources/gh-pages"
          }
        ],
        "paperback": [
          {
            "name": "MangaDex",
            "id": "MangaDex",
            "repo": "https://thenetsky.github.io/community-extensions/0.8"
          }
        ]
      }
    }
  ]
}
''';

class ExtensionConverter {
  ExtensionRepoIndex parseExtensionRepoIndex() {
    return ExtensionRepoIndex.fromJson(_extensionRepoIndexJson);
  }

  List<(Extension, ExtensionRepo)> convertExtension(
    ExtensionRepoIndex index,
    Extension ext,
    ExtensionType type,
    ExtensionType newType,
  ) {
    final site = index.findSite(type, ext);
    final siteExtensions = site.extensions[newType] ?? [];
    return siteExtensions.map((eachSiteExtension) {
      final repo = index.findRepo(newType, eachSiteExtension);
      return (eachSiteExtension, repo);
    }).toList();
  }
}

@MappableClass(caseStyle: CaseStyle.camelCase)
class ExtensionRepoIndex with ExtensionRepoIndexMappable {
  final Map<ExtensionType, List<ExtensionRepo>> repos;
  final List<SiteIndex> sites;

  const ExtensionRepoIndex({required this.repos, required this.sites});

  ExtensionRepo findRepo(ExtensionType type, Extension ext) {
    final repo = repos[type]?.firstWhereOrNull((repo) => repo.url == ext.repo);
    if (repo == null) {
      throw ExtensionException('Could not find repo "${ext.repo}" for type "$type"');
    }
    return repo;
  }

  SiteIndex findSite(ExtensionType type, Extension ext) {
    final site = sites.firstWhereOrNull(
      (site) => site.extensions[type]?.any((e) => e.name == ext.name && e.repo == ext.repo) ?? false,
    );
    if (site == null) {
      throw ExtensionException('Could not find site for extension "${ext.name}" of type "$type"');
    }
    return site;
  }

  static const fromMap = ExtensionRepoIndexMapper.fromMap;
  static const fromJson = ExtensionRepoIndexMapper.fromJson;
}

@MappableClass(caseStyle: CaseStyle.camelCase)
class SiteIndex with SiteIndexMappable {
  final String name;
  final Map<ExtensionType, List<Extension>> extensions;

  const SiteIndex({required this.name, required this.extensions});

  static const fromMap = SiteIndexMapper.fromMap;
  static const fromJson = SiteIndexMapper.fromJson;
}

@MappableClass(caseStyle: CaseStyle.camelCase)
class ExtensionRepo with ExtensionRepoMappable {
  final String name;
  final String url;

  const ExtensionRepo({required this.name, required this.url});

  static const fromMap = ExtensionRepoMapper.fromMap;
  static const fromJson = ExtensionRepoMapper.fromJson;
}

@MappableClass(caseStyle: CaseStyle.camelCase)
class Extension with ExtensionMappable {
  final String name;
  final String id;
  final String repo;

  const Extension({required this.name, required this.id, required this.repo});

  static const fromMap = ExtensionMapper.fromMap;
  static const fromJson = ExtensionMapper.fromJson;
}

@MappableEnum(caseStyle: CaseStyle.camelCase)
enum ExtensionType {
  aidoku,
  paperback,
  tachi,
  mangayomi;

  const ExtensionType();

  static ExtensionType fromBackupType(BackupType type) {
    return switch (type) {
      BackupType.aidoku => aidoku,
      BackupType.paperback => paperback,
      BackupType.tachi || BackupType.tachimanga => tachi,
      BackupType.mangayomi => mangayomi,
    };
  }
}
