# Implementation Details Reference

Exact interfaces, data types, and code patterns for adding a backup format. All paths relative to `packages/mangabackupconverter_cli/`.

## 1. ConvertableBackup Interface

From `lib/src/common/convertable.dart`:

```dart
abstract interface class ConvertableBackup {
  Future<Uint8List> toData();
  void verbosePrint(bool verbose);
  List<MangaSearchEntry> get mangaSearchEntries;
  List<SourceMangaData> get sourceMangaDataEntries;
}
```

The top-level backup class implements this. Also needs a static `fromData(Uint8List)` factory (not part of the interface, but required by convention for `MangaBackupConverter`).

There is also a `ConvertableType<ReturnType, ArgumentType>` interface for direct format-to-format conversion (used by Tachimanga-to-Tachi), but most formats only need `ConvertableBackup`.

## 2. MangaSearchEntry and MangaSearchDetails

From `lib/src/pipeline/manga_details.dart`:

```dart
mixin MangaSearchEntry {
  MangaSearchDetails toMangaSearchDetails();
}

class MangaSearchDetails {
  const MangaSearchDetails({
    required this.title,
    this.altTitles = const <String>[],
    this.authors = const <String>[],
    this.artists = const <String>[],
    this.tagNames = const <String>[],
    this.description,
    this.chaptersCount,
    this.latestChapterNum,
    this.coverImageUrl,
    this.languages = const <String>[],
  });

  final String title;
  final List<String> altTitles;
  final List<String> authors;
  final List<String> artists;
  final List<String> tagNames;
  final String? description;
  final int? chaptersCount;
  final double? latestChapterNum;
  final String? coverImageUrl;
  final List<String> languages;
}
```

The manga model class mixes in `MangaSearchEntry` and maps its fields to `MangaSearchDetails`. This is used for UI display during migration proposals.

## 3. SourceMangaData and Related Types

From `lib/src/pipeline/source_manga_data.dart`. This is the **normalized intermediate representation** that carries all data from the source backup through the pipeline.

```dart
class SourceMangaData {
  const SourceMangaData({
    required this.details,          // MangaSearchDetails
    this.categories = const <String>[],
    this.chapters = const <SourceChapter>[],
    this.history = const <SourceHistoryEntry>[],
    this.tracking = const <SourceTrackingEntry>[],
    this.dateAdded,
    this.lastRead,
    this.lastOpened,
    this.lastUpdated,
    this.status,                    // int? (format-specific status code)
  });
}
```

### SourceChapter

```dart
class SourceChapter {
  const SourceChapter({
    required this.title,
    this.chapterNumber,       // double? — used for matching target chapters
    this.volumeNumber,        // double?
    this.scanlator,
    this.language,
    this.isRead = false,      // key field for read-state transfer
    this.isBookmarked = false,
    this.lastPageRead = 0,    // int — page progress
    this.dateUploaded,
    this.sourceOrder = 0,
  });
}
```

### SourceHistoryEntry

```dart
class SourceHistoryEntry {
  const SourceHistoryEntry({
    required this.chapterTitle,
    this.chapterNumber,
    this.dateRead,
    this.completed = false,
    this.progress,            // int? — page number
    this.total,               // int? — total pages
  });
}
```

### SourceTrackingEntry

```dart
class SourceTrackingEntry {
  const SourceTrackingEntry({
    required this.syncId,     // int — tracker service ID (e.g. MAL=1, AniList=2)
    this.libraryId,
    this.mediaId,
    this.trackingUrl,
    this.title,
    this.lastChapterRead,     // double?
    this.totalChapters,       // int?
    this.score,               // double?
    this.status,              // int?
    this.startedReadingDate,
    this.finishedReadingDate,
  });
}
```

## 4. BackupFormat Sealed Class

From `lib/src/pipeline/backup_format.dart`. Uses dart_mappable discriminator-based serialization.

### Class annotation pattern

```dart
@MappableClass(discriminatorKey: 'type')
@immutable
sealed class BackupFormat with BackupFormatMappable {
  const BackupFormat();

  String get alias;
  List<String> get extensions;
  PluginLoader get pluginLoader;
  TargetBackupBuilder get backupBuilder;

  static const List<BackupFormat> values = <BackupFormat>[
    Aidoku(), Paperback(), Mihon(), TachiSy(), TachiJ2k(),
    TachiYokai(), TachiNeko(), Tachimanga(), Mangayomi(),
  ];

  static BackupFormat byName(String alias) { ... }
  static BackupFormat? byExtension(String ext) { ... }
}
```

### Subclass boilerplate

Every concrete `BackupFormat` subclass follows this exact pattern:

```dart
@MappableClass(discriminatorValue: '<alias>')
@immutable
class <FormatName> extends BackupFormat with <FormatName>Mappable {
  const <FormatName>();

  @override
  String get alias => '<alias>';

  @override
  List<String> get extensions => const <String>['.<ext>'];

  @override
  PluginLoader get pluginLoader => const <Format>PluginLoader();

  @override
  TargetBackupBuilder get backupBuilder => const <Format>BackupBuilder();
  // Use UnimplementedBackupBuilder() if target not yet supported

  @override
  bool operator ==(Object other) => other is <FormatName>;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => '<FormatName>';
}
```

### Intermediate sealed class (Tachiyomi pattern)

Tachi forks share a sealed intermediate class. New Tachi forks extend `Tachiyomi`, not `BackupFormat` directly:

```dart
@MappableClass()
sealed class Tachiyomi extends BackupFormat with TachiyomiMappable {
  const Tachiyomi();

  @override
  List<String> get extensions => const <String>['.tachibk', '.proto.gz'];

  @override
  PluginLoader get pluginLoader => const TachiPluginLoader();

  @override
  TargetBackupBuilder get backupBuilder => const UnimplementedBackupBuilder();
}
```

Non-Tachi formats extend `BackupFormat` directly (like `Mangayomi`, `Paperback`).

## 5. TargetBackupBuilder

From `lib/src/pipeline/target_backup_builder.dart`:

```dart
sealed class TargetBackupBuilder {
  const TargetBackupBuilder();
  ConvertableBackup build(
    List<MangaMatchConfirmation> confirmations, {
    String? sourceFormatAlias,
  });
}

class UnimplementedBackupBuilder extends TargetBackupBuilder {
  const UnimplementedBackupBuilder();

  @override
  ConvertableBackup build(
    List<MangaMatchConfirmation> confirmations, {
    String? sourceFormatAlias,
  }) {
    throw UnimplementedError(
      'Target backup construction not yet implemented for this format',
    );
  }
}
```

New builders extend `TargetBackupBuilder` and are placed in the same file.

## 6. AidokuBackupBuilder Walkthrough

The only complete target builder implementation. Follow this pattern for new builders.

### Step-by-step build() logic

1. **Filter confirmations** — `confirmations.where((c) => c.confirmedMatch != null)` to skip unmatched manga.

2. **Initialize collection sets** — Use `Set` types to avoid duplicates:
   ```dart
   final mangaSet = <FormatManga>{};
   final librarySet = <FormatLibraryManga>{};
   final chapterSet = <FormatChapter>{};
   final historySet = <FormatHistory>{};
   final allCategories = <String>{};
   ```

3. **For each confirmed match**, extract:
   - `match` — `PluginSearchResult` (target plugin's search result with `pluginSourceId`, `mangaKey`, `title`, `coverUrl`, `authors`)
   - `sourceManga` — `SourceMangaData` (chapters, history, tracking, categories, timestamps from source backup)
   - `details` — `PluginMangaDetails?` (fetched target details, may be null)
   - `targetChapters` — `List<PluginChapter>` (fetched target chapter list)

4. **Build manga model** — Prefer `details` fields over `match` fields over `sourceManga.details` fields (most specific to least):
   ```dart
   title: details?.title ?? match.title,
   cover: details?.coverUrl ?? match.coverUrl,
   ```

5. **Build library entry** — Use timestamps from `sourceManga` with fallbacks:
   ```dart
   dateAdded: sourceManga.dateAdded ?? DateTime.now(),
   lastOpened: sourceManga.lastOpened ?? sourceManga.lastRead ?? DateTime.now(),
   ```

6. **Transfer chapter read state** — Match by `chapterNumber` (double):
   ```dart
   final readSourceChapters = <double, SourceChapter>{
     for (final ch in sourceManga.chapters)
       if (ch.isRead && ch.chapterNumber != null) ch.chapterNumber!: ch,
   };

   for (final (i, ch) in targetChapters.indexed) {
     // Build chapter model from PluginChapter...
     final sourceCh = ch.chapterNumber != null
         ? readSourceChapters[ch.chapterNumber] : null;
     if (sourceCh != null) {
       // Build history entry marking this chapter as read
     }
   }
   ```

7. **Build history from source history entries** — In addition to chapter-matched history, add entries from `sourceManga.history` directly (keyed by `chapterTitle`).

8. **Assemble final backup** — Pass all sets to the format's backup constructor. Include `sourceFormatAlias` in metadata if provided.

## 7. PluginLoader and PluginSource

### PluginLoader (sealed class)

From `lib/src/pipeline/plugin_loader.dart`:

```dart
sealed class PluginLoader {
  const PluginLoader();
  Future<List<ExtensionEntry>> fetchExtensionLists(
    List<String> repoUrls, {
    void Function(String)? onWarning,
  });
  Future<List<PluginSource>> loadPlugins(
    List<ExtensionEntry> extensions, {
    void Function(int current, int total, String message)? onProgress,
  });
}
```

Stub loaders (for formats without real plugin support) return empty extension lists and map entries to `StubPluginSource`:

```dart
class <Format>PluginLoader extends PluginLoader {
  const <Format>PluginLoader();

  @override
  Future<List<ExtensionEntry>> fetchExtensionLists(
    List<String> repoUrls, {void Function(String)? onWarning}
  ) async => <ExtensionEntry>[];

  @override
  Future<List<PluginSource>> loadPlugins(
    List<ExtensionEntry> extensions, {
    void Function(int, int, String)? onProgress,
  }) async => extensions
      .map((e) => StubPluginSource(sourceId: e.id, sourceName: e.name))
      .toList();
}
```

### PluginSource (interface)

From `lib/src/pipeline/plugin_source.dart`:

```dart
abstract interface class PluginSource {
  String get sourceId;
  String get sourceName;
  Future<PluginSearchPageResult> search(String query, int page);
  Future<(PluginMangaDetails, List<PluginChapter>)?> getMangaWithChapters(String mangaKey);
  void dispose();
}
```

### StubPluginSource

From `lib/src/pipeline/plugin_source_stub.dart` — implements `PluginSource`, throws `UnimplementedError` on search/details calls:

```dart
class StubPluginSource implements PluginSource {
  const StubPluginSource({required this.sourceId, required this.sourceName});
  // search() and getMangaWithChapters() throw UnimplementedError
  // dispose() is a no-op
}
```

### ExtensionEntry (sealed class)

```dart
sealed class ExtensionEntry {
  const ExtensionEntry({required this.id, required this.name, this.languages});
  final String id;
  final String name;
  final List<String> languages;
}

class StubExtensionEntry extends ExtensionEntry { ... }
```

Create a format-specific `ExtensionEntry` subclass if the format's repo provides additional metadata (like `AidokuExtensionEntry` with `downloadUrl`, `iconUrl`, `version`).

## 8. MangaBackupConverter

From `lib/src/converter.dart`. Add one import method per format:

```dart
class MangaBackupConverter {
  // Sync for simple formats:
  <Format>Backup import<Format>Backup(Uint8List bytes) {
    return <Format>Backup.fromData(bytes);
  }

  // Async if fromData needs I/O:
  Future<<Format>Backup> import<Format>Backup(Uint8List bytes) async {
    return await <Format>Backup.fromData(bytes);
  }
}
```

Some import methods accept additional parameters (e.g. `name`, `overrideName`, `format`).

## 9. Exception Class Pattern

From `lib/src/exceptions/`:

```dart
import 'package:mangabackupconverter_cli/src/exceptions/base_exeption.dart';

class <Format>Exception extends MangaConverterException {
  const <Format>Exception([super.message]);

  @override
  String toString() {
    final Object? message = this.message;
    if (message == null) return '<Format>Exception';
    return '<Format>Exception: $message';
  }
}
```

Note: the base class file is `base_exeption.dart` (typo preserved).

## 10. Barrel Export Convention

In `lib/mangabackupconverter_lib.dart`, exports are grouped:

1. `src/common/` — shared interfaces
2. `src/converter.dart`
3. `src/exceptions/` — one per format + base + migration
4. `src/formats/<format>/` — grouped per format, all public model files
5. `src/pipeline/` — all pipeline files

Add new format exports in alphabetical position within the formats group. Add new exception export in the exceptions group.

## 11. ConversionStrategy

From `lib/src/pipeline/conversion_strategy.dart`:

```dart
sealed class ConversionStrategy { const ConversionStrategy(); }
class DirectConversion extends ConversionStrategy { const DirectConversion(); }
class Migration extends ConversionStrategy { const Migration(); }
class Skip extends ConversionStrategy { const Skip(); }

ConversionStrategy determineStrategy(BackupFormat source, BackupFormat target) {
  if (source == target) return const Skip();
  if (source is Tachiyomi && target is Tachiyomi) return const Skip();
  if (source is Tachiyomi && target is Tachimanga) return const Skip();
  if (source is Tachimanga && target is Tachiyomi) return const DirectConversion();
  return const Migration();
}
```

Rules:
- **Skip** — same format, or Tachi↔Tachi, or Tachi→Tachimanga (identical proto structure)
- **DirectConversion** — Tachimanga→Tachi (calls `toTachiBackup()`)
- **Migration** — everything else (full pipeline: search, match, build)

Add new rules before the final `return const Migration()` if the new format has direct-conversion paths with existing formats.

## 12. Test Patterns

### File locations

- Format model tests: `test/formats/<format>/`
- Pipeline tests: `test/pipeline/`
- Integration tests: `test/` root

### Assertion style (package:checks)

```dart
import 'package:checks/checks.dart';
import 'package:test/scaffolding.dart';

test('parses backup', () {
  final backup = FormatBackup.fromData(fixtureBytes);
  check(backup.manga).length.equals(5);
  check(backup.manga.first.title).equals('One Piece');
  check(backup.mangaSearchEntries).isNotEmpty();
  check(backup.sourceMangaDataEntries.first.details)
      .isA<MangaSearchDetails>();
});
```

### Testing dart_mappable models

Models with `with ...Mappable` cannot use `const` constructors. Use non-const:

```dart
final manga = FormatManga(title: 'Test', id: '123');  // no const
```

### Testing BackupBuilder

```dart
test('builds backup from confirmations', () {
  final confirmations = [
    MangaMatchConfirmation(
      sourceManga: SourceMangaData(
        details: MangaSearchDetails(title: 'Test'),
        chapters: [SourceChapter(title: 'Ch 1', chapterNumber: 1, isRead: true)],
      ),
      confirmedMatch: PluginSearchResult(
        pluginSourceId: 'source.test',
        mangaKey: '/manga/123',
        title: 'Test',
      ),
      targetChapters: [
        PluginChapter(chapterId: 'ch-1', chapterNumber: 1),
      ],
    ),
  ];
  final builder = FormatBackupBuilder();
  final backup = builder.build(confirmations);
  check(backup).isA<FormatBackup>();
});
```
