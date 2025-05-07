import 'package:collection/collection.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:mangabackupconverter_cli/src/common/backup_type.dart';
import 'package:mangabackupconverter_cli/src/exceptions/extension_exception.dart';

part 'extensions.mapper.dart';

// TODO: Expand supported websites and extensions. Currently only MangaDex and Weeb Central are supported.
// Unsupported sites should be converted to use WeebCentral as a fallback.
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
      }
    ],
    "mangayomi": [
      {
        "name": "Mangayomi Extensions",
        "url": "https://kodjodevf.github.io/mangayomi-extensions/index.json"
      }
    ],
    "tachi": [
      {
        "name": "Keiyoushi Extensions",
        "url": "https://raw.githubusercontent.com/keiyoushi/extensions/repo/index.min.json"
      }
    ],
    "paperback": [
      {
        "name": "Kavya",
        "url": "https://ACK72.github.io/kavya-paperback"
      },
      {
        "name": "Netsky's Extensions (0.8)",
        "url": "https://ACK72.github.io/kavya-paperback"
      },
      {
        "name": "Extensions Generic Madara (0.8)",
        "url": "https://thenetsky.github.io/extensions-generic-0.8/madara"
      },
      {
        "name": "Extensions Generic MangaBox (0.8)",
        "url": "https://thenetsky.github.io/extensions-generic-0.8/mangabox"
      },
      {
        "name": "Extensions Generic BuddyComplex (0.8)",
        "url": "https://thenetsky.github.io/extensions-generic-0.8/buddycomplex"
      },
      {
        "name": "xOnlyFadi's Extensions (0.8)",
        "url": "https://xonlyfadi.github.io/xonlyfadi-extensions/0.8"
      },
      {
        "name": "Paperback Community Extensions (0.8)",
        "url": "https://thenetsky.github.io/community-extensions/0.8"
      },
      {
        "name": "Extensions Generic MangaStream (0.8)",
        "url": "https://thenetsky.github.io/extensions-generic-0.8/mangastream"
      },
      {
        "name": "NmN's Foreign Extensions (0.8)",
        "url": "https://pandeynmn.github.io/extensions-foreign/0.8"
      },
      {
        "name": "NineManga Extensions (0.8)",
        "url": "https://pandeynmn.github.io/extensions-foreign/ninemanga-0.8"
      },
      {
        "name": "NmN's Extensions (0.8)",
        "url": "https://pandeynmn.github.io/nmns-extensions/0.8"
      },
      {
        "name": "Extensions Generic MangaCatalog (0.8)",
        "url": "https://thenetsky.github.io/extensions-generic-0.8/mangacatalog"
      },
      {
        "name": "kameia Extensions (0.8)",
        "url": "https://kameiaa.github.io/kameia-extensions/0.8"
      },
      {
        "name": "Gabes's Extensions (0.8)",
        "url": "https://gabrielcwt.github.io/gabe-extensions/0.8"
      },
      {
        "name": "Webtoons.com (0.8)",
        "url": "https://yvespa.github.io/webtoons-extensions/0.8"
      },
      {
        "name": "Hean Generic (0.8)",
        "url": "https://thenetsky.github.io/extensions-generic-0.8/hean"
      },
      {
        "name": "Liliana Generic (0.8)",
        "url": "https://thenetsky.github.io/extensions-generic-0.8/liliana"
      },
      {
        "name": "IvanMatthew's Extensions (0.8)",
        "url": "https://ivanmatthew.github.io/ivans-paperback-extensions/paperback-0.8"
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
            "repo": "https://raw.githubusercontent.com/Skittyblock/aidoku-community-sources/gh-pages",
            "lang": "en"
          }
        ],
        "paperback": [
          {
            "name": "MangaDex",
            "id": "MangaDex",
            "repo": "https://thenetsky.github.io/community-extensions/0.8",
            "lang": "en"
          }
        ],
        "mangayomi": [
          {
            "name": "MangaDex",
            "id": "202373705",
            "repo": "https://kodjodevf.github.io/mangayomi-extensions/index.json",
            "lang": "en"
          }
        ],
        "tachi": [
          {
            "name": "MangaDex",
            "id": "2499283573021220255",
            "repo": "https://raw.githubusercontent.com/keiyoushi/extensions/repo/index.min.json",
            "lang": "en"
          },
          {
            "name": "MangaDex",
            "id": "1411768577036936240",
            "repo": "https://raw.githubusercontent.com/keiyoushi/extensions/repo/index.min.json",
            "lang": "ja"
          }
        ]
      }
    },
    {
      "name": "WeebCentral",
      "extensions": {
        "aidoku": [
          {
            "name": "Weeb Central",
            "id": "en.weebcentral",
            "repo": "https://raw.githubusercontent.com/Skittyblock/aidoku-community-sources/gh-pages",
            "lang": "en"
          }
        ],
        "paperback": [
          {
            "name": "WeebCentral",
            "id": "WeebCentral",
            "repo": "https://gabrielcwt.github.io/gabe-extensions/0.8",
            "lang": "en"
          }
        ],
        "mangayomi": [
          {
            "name": "Weeb Central",
            "id": "693275080",
            "repo": "https://kodjodevf.github.io/mangayomi-extensions/index.json",
            "lang": "en"
          }
        ],
        "tachi": [
          {
            "name": "Weeb Central",
            "id": "2131019126180322627",
            "repo": "https://raw.githubusercontent.com/keiyoushi/extensions/repo/index.min.json",
            "lang": "en"
          }
        ]
      }
    }
  ]
}
''';

// TODO: Implement manga id format mapping for each supported site
//
// Use javascript engine to run the Dart/JavaScript extension to query for the id from the website
// Tachiyomi Extensions would not be supported since they are APK files
//
// Alternatively, use wrong but unique ids and require the user to use the app's migration tool to fix them

@MappableClass(caseStyle: CaseStyle.camelCase)
class ExtensionRepoIndex with ExtensionRepoIndexMappable {
  final Map<ExtensionType, List<ExtensionRepo>> repos;
  final List<SiteIndex> sites;

  const ExtensionRepoIndex({required this.repos, required this.sites});

  factory ExtensionRepoIndex.parseExtensionRepoIndex() {
    return ExtensionRepoIndex.fromJson(_extensionRepoIndexJson);
  }

  List<(Extension, ExtensionRepo)> findExtension(String id, ExtensionType type) {
    final site = sites.firstWhereOrNull((site) => site.extensions[type]?.any((e) => e.id == id) ?? false);
    if (site == null) {
      throw ExtensionException('Could not find site for extension id "$id" of type "$type"');
    }
    final siteExtensions = site.extensions[type] ?? [];
    return siteExtensions.map((eachSiteExtension) {
      final repo = findRepo(type, eachSiteExtension);
      return (eachSiteExtension, repo);
    }).toList();
  }

  List<(Extension, ExtensionRepo)> convertExtension(Extension ext, ExtensionType type, ExtensionType newType) {
    final site = findSite(type, ext);
    final siteExtensions = site.extensions[newType] ?? [];
    return siteExtensions.map((eachSiteExtension) {
      final repo = findRepo(newType, eachSiteExtension);
      return (eachSiteExtension, repo);
    }).toList();
  }

  ExtensionRepo findRepo(ExtensionType type, Extension ext) {
    final repo = repos[type]?.firstWhereOrNull((repo) => repo.url == ext.repo);
    if (repo == null) {
      throw ExtensionException('Could not find repo "${ext.repo}" for type "$type"');
    }
    return repo;
  }

  SiteIndex findSite(ExtensionType type, Extension ext) {
    final site = sites.firstWhereOrNull(
      (site) => site.extensions[type]?.any((e) => e.id == ext.id && e.repo == ext.repo) ?? false,
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
  final String? repo;
  final String? lang;

  const Extension({required this.name, required this.id, this.repo, this.lang});

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
