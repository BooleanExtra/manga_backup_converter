---
name: add-backup-format
description: Use when adding a new manga backup format to the converter, implementing target or source support for a format, or extending the pipeline to support a new manga app backup type. Triggers include "add format", "implement target builder", "add source support", "support a new manga app backup", "new backup type", "import support for", "export to format".
---

# Add Backup Format

## Overview

Adding a backup format has two independent dimensions: **source** (reading/importing backups) and **target** (building/exporting backups). Both require pipeline registration. A format can be source-only, target-only, or both.

All format code lives in `packages/mangabackupconverter_cli/`. The pipeline layer in `lib/src/pipeline/` ties formats together. Detailed interface signatures and code patterns are in `references/implementation-details.md`.

## When to Use

- Adding import support for a new manga app's backup file
- Adding export/target support so the pipeline can build backups in a format
- Registering a new format in the pipeline (BackupFormat, ConversionStrategy)
- Extending an existing format with source or target capabilities it lacks

Do NOT use for modifying existing format models without adding a new format.

## Part A: Source Format Support

Add the ability to **read and import** a backup file.

### Checklist

- [ ] **A1. Create format directory** — `lib/src/formats/<format>/` with model classes annotated with `@MappableClass()` from dart_mappable. Each model gets a `with <Name>Mappable` mixin. Top-level backup class needs a `fromData(Uint8List)` factory and a `toData()` method returning `Future<Uint8List>`.

- [ ] **A2. Add MangaSearchEntry mixin** — The manga model class must `with MangaSearchEntry` and implement `toMangaSearchDetails()`, returning a `MangaSearchDetails` populated from format-specific fields.

- [ ] **A3. Implement ConvertableBackup** — The top-level backup class must `implements ConvertableBackup`, providing:
  - `toData()` — serialize back to bytes
  - `verbosePrint(bool verbose)` — print summary to stdout
  - `mangaSearchEntries` — `List<MangaSearchEntry>` from the backup's manga list
  - `sourceMangaDataEntries` — `List<SourceMangaData>` mapping each manga to the normalized pipeline type (chapters, history, tracking, categories, timestamps)

- [ ] **A4. Create exception class** — `lib/src/exceptions/<format>_exception.dart` extending `MangaConverterException`. Follow the pattern: constructor with optional `super.message`, `toString()` override.

- [ ] **A5. Add import method to MangaBackupConverter** — In `lib/src/converter.dart`, add an `import<Format>Backup(Uint8List bytes)` method that calls `<Format>Backup.fromData(bytes)`.

- [ ] **A6. Export from barrel file** — Add all new public files to `lib/mangabackupconverter_lib.dart`. Group format exports together (models), then exception. Follow existing grouping convention.

- [ ] **A7. Run codegen** — `melos run generate` to regenerate `*.mapper.dart` files.

## Part B: Pipeline Registration

Register the format so the pipeline can select and route it.

### Checklist

- [ ] **B1. Add BackupFormat subclass** — In `lib/src/pipeline/backup_format.dart`, create a new `@MappableClass(discriminatorValue: '<alias>')` class extending `BackupFormat` (or an intermediate sealed class like `Tachiyomi` if applicable). Provide `alias`, `extensions`, `pluginLoader`, `backupBuilder`, equality (`==`, `hashCode`), and `toString()`. See `references/implementation-details.md` for the exact boilerplate.

- [ ] **B2. Add to BackupFormat.values** — Insert the new `const <Format>()` into the `values` list.

- [ ] **B3. Update ConversionStrategy** — In `lib/src/pipeline/conversion_strategy.dart`, add any direct-conversion or skip rules for the new format in `determineStrategy()`. Default behavior: returns `Migration()` for unrecognized pairs.

- [ ] **B4. Run codegen** — `melos run generate` to regenerate `backup_format.mapper.dart`.

## Part C: Target Format Support

Add the ability to **build/export** a backup in this format from migration results.

### Checklist

- [ ] **C1. Create BackupBuilder** — `<Format>BackupBuilder extends TargetBackupBuilder` with a `const` constructor. Implement `build(List<MangaMatchConfirmation> confirmations, {String? sourceFormatAlias})` returning a `ConvertableBackup`.

- [ ] **C2. Implement build() mapping** — Filter confirmations to those with `confirmedMatch != null`. For each, map `SourceMangaData`, `PluginSearchResult`, `PluginMangaDetails?`, and `List<PluginChapter>` into format-specific models. Build chapter read-state by matching `SourceChapter.chapterNumber` against `PluginChapter.chapterNumber`. See `AidokuBackupBuilder` walkthrough in `references/implementation-details.md`.

- [ ] **C3. Wire into BackupFormat** — Replace `UnimplementedBackupBuilder()` with `const <Format>BackupBuilder()` in the format's `backupBuilder` getter.

- [ ] **C4. Optionally implement PluginLoader/PluginSource** — For real migration support, implement a `PluginLoader` subclass and `PluginSource` subclass that can fetch extension lists and search for manga. Otherwise, use `StubPluginSource` (returns stubs, throws on search).

## Part D: Testing

### Checklist

- [ ] **D1. Unit tests for format models** — `test/formats/<format>/` — test `fromData`/`toData` round-trip with fixture files. Use `package:checks` assertions (`check(x).equals(y)`, `isA<T>()`).

- [ ] **D2. Test ConvertableBackup impl** — Verify `mangaSearchEntries` and `sourceMangaDataEntries` return correct data from a parsed fixture.

- [ ] **D3. Test BackupFormat registration** — Verify `BackupFormat.byName('<alias>')` returns the correct subclass. Verify `BackupFormat.byExtension('.<ext>')` works.

- [ ] **D4. Test TargetBackupBuilder** — Create `MangaMatchConfirmation` instances with test data, call `build()`, verify the output backup contains expected manga, chapters, and history.

- [ ] **D5. Test ConversionStrategy** — Verify `determineStrategy(source, target)` returns expected strategy for new format pairs.

### Test conventions

- Import `package:checks/checks.dart` + `package:test/scaffolding.dart` (not `package:test/test.dart`)
- Avoid barrel import (`mangabackupconverter_lib.dart`) when names clash with `package:test` (e.g. `Skip`)
- Use `--reporter expanded` for `dart test` (not `-v`)
- dart_mappable models with `with ...Mappable` cannot be `const`-constructed in tests

## Key References

Exact interface signatures, data type fields, annotation patterns, builder walkthrough, and code examples: see `references/implementation-details.md`.

Key source files:
- `lib/src/common/convertable.dart` — `ConvertableBackup`, `MangaSearchEntry`
- `lib/src/pipeline/backup_format.dart` — `BackupFormat` sealed class
- `lib/src/pipeline/target_backup_builder.dart` — `TargetBackupBuilder`, `AidokuBackupBuilder`
- `lib/src/pipeline/source_manga_data.dart` — normalized data types
- `lib/src/pipeline/plugin_source.dart` — `PluginSource` interface, search result types
- `lib/src/pipeline/plugin_loader.dart` — `PluginLoader` sealed class
- `lib/src/pipeline/conversion_strategy.dart` — `determineStrategy()`
- `lib/src/converter.dart` — `MangaBackupConverter`
- `lib/mangabackupconverter_lib.dart` — barrel exports

All paths relative to `packages/mangabackupconverter_cli/`.
