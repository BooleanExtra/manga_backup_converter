// TODO: Implement mapping of extensions and extension repos, defined using json
/// {
///   "repos": [
///     {
///       "name": "Aidoku Community Sources",
///       "repo": "https://raw.githubusercontent.com/Skittyblock/aidoku-community-sources/gh-pages",
///       "type": "aidoku"
///     },
///     {
///       "name": "Paperback Community Extensions (0.8)",
///       "repo": "https://thenetsky.github.io/community-extensions/0.8",
///       "type": "paperback"
///     }
///   ],
///   "websites": [
///     {
///       "name": "MangaDex",
///       "extensions": [
///         {
///           "name": "MangaDex",
///           "repo": "https://raw.githubusercontent.com/Skittyblock/aidoku-community-sources/gh-pages",
///           "type": "aidoku"
///         },
///         {
///           "name": "MangaDex",
///           "repo": "https://thenetsky.github.io/community-extensions/0.8",
///           "type": "paperback"
///         }
///       ]
///     }
///   ]
/// }
abstract interface class ConvertableExtension {
  ConvertableExtension toExtension(ExtensionWebsite type);
}

class AidokuRepoIndex {
  static const String communitySources =
      'https://raw.githubusercontent.com/Skittyblock/aidoku-community-sources/gh-pages';
  static const String kavya = 'https://raw.githubusercontent.com/ACK72/kavya-aidoku/gh-pages';
  static const String kavya2 = 'https://raw.githubusercontent.com/getBoolean/kavya-aidoku/gh-pages';
}

enum ExtensionWebsite {
  mangadex(aidoku: Extension(name: 'MangaDex', repo: AidokuRepoIndex.communitySources, type: ExtensionType.aidoku)),
  kavya(aidoku: Extension(name: 'Kavya', repo: AidokuRepoIndex.kavya, type: ExtensionType.aidoku)),
  kavya2(aidoku: Extension(name: 'Kavya2', repo: AidokuRepoIndex.kavya2, type: ExtensionType.aidoku));

  const ExtensionWebsite({required this.aidoku});

  final Extension aidoku;
}

class Extension {
  final String name;
  final String repo;
  final ExtensionType type;

  const Extension({required this.name, required this.repo, required this.type});
}

enum ExtensionType { aidoku, paperback, tachi, mangayomi }

// list of supported websites

// list of extensions from aidoku
// list of extensions from tachiyomi/tachimanga
// list of extensions from paperback
// list of extensions from mangayomi
