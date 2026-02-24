# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Manga Backup Converter — a Flutter/Dart monorepo that converts manga backup files between formats: Aidoku (.aib), Paperback (.pas4), Tachi (.tachibk, .proto.gz), Tachimanga (.tmb), and Mangayomi (.backup). Includes a multi-platform Flutter app and a standalone CLI package.

## Monorepo Structure (Melos)

- Root: Flutter app (iOS, Android, macOS, Windows, Linux, Web)
- `packages/mangabackupconverter_cli/` — Core conversion logic (pure Dart, no Flutter dependency)
- `packages/aidoku_plugin_loader/` — Aidoku WASM plugin loader (native wasmer FFI + web WebAssembly)
- `packages/app_lints/` — Shared lint rules (based on `solid_lints`)
- `packages/jsoup/` — Jsoup-compatible HTML parsing (JNI on Android/Windows/Linux, SwiftSoup on iOS/macOS, Cheerio on Web)
- `packages/assets/` — Asset code generation
- `packages/constants/` — App-wide constants

## One-Time Setup (per clone)

```bash
git config core.hooksPath .githooks   # Enable .githooks/post-checkout for worktree file sync
```

## Common Commands

```bash
melos bootstrap                  # Install deps + generate env files + activate coverage
                                 # If bare `melos` is not on PATH, use `dart run melos` as fallback
melos run generate               # Run all code generation (assets, env, build_runner, format)
melos run generate:pkg           # Run build_runner for a specific package (interactive)
melos run watch:pkg              # Watch mode for build_runner in a specific package
melos run test                   # Run all tests (flutter + dart) with coverage
melos run flutter_test:pkg       # Flutter tests for a specific package
melos run dart_test:pkg          # Dart tests for a specific package
                                 # For dart test directly: use --reporter expanded (not -v, which is invalid)
                                 # Interactive melos scripts (dart_test:pkg, generate:pkg) fail in non-TTY shells;
                                 # run `dart test --reporter expanded` directly in the package directory instead
                                 # Native WASM tests skip automatically if test fixture is absent
melos run cli                    # Run CLI directly (args forwarded automatically)
melos run lint                   # Run dart analyze + custom_lint
melos run format                 # Format all packages
melos run fix                    # Auto-fix lint issues
```

Build: `flutter build <platform>`

## Architecture

**Riverpod App Architecture** — feature-first with layered structure per feature:

```txt
lib/src/features/<feature>/
  ├── domain/         # Entities, value objects (freezed + modddels)
  ├── data/           # Repositories, DTOs (dart_mappable), data sources
  ├── application/    # Riverpod providers/controllers (riverpod_generator)
  └── presentation/   # ConsumerWidgets, screens
```

Active features: `books`, `connectivity`, `initialization`, `settings`. The `example_feature` directory is a reference template showing the full pattern.

### CLI Package Architecture

`packages/mangabackupconverter_cli/` is organized by format:

- `lib/src/converter.dart` — `MangaBackupConverter` class with import methods per format
- `lib/src/common/` — `Convertable` interface, shared mappers, extension repo index
- `lib/src/formats/<format>/` — Format-specific backup models and parsers
- `lib/src/pipeline/` — Migration pipeline API (BackupFormat, MangaSearchDetails, MigrationPipeline, plugin sources)
- `lib/src/commands/` — CLI command implementations + interactive terminal UI (`terminal_ui.dart`, `migration_dashboard.dart`, `live_search_select.dart`, `manga_details_screen.dart`, `extension_select_screen.dart`)
- CLI TUI screens use `TerminalContext` + `ScreenRegion` for all I/O, NOT `print()` — `print()` goes through Dart zones while `TerminalContext.write` does not, enabling zone-based log redirection in interactive mode
- `TerminalContext` bundles KeyInput, ScreenRegion output, SIGINT handling, and terminal dimensions — screens receive it as a parameter, never create their own I/O objects
- `TerminalContext` is single-use per process — `dispose()` cancels `_stdinSub` (the broadcast source), permanently killing stdin; never create multiple sequential contexts, use one for the entire interactive session
- `readLineSync()` must be called BEFORE creating `TerminalContext` — once the context puts stdin in raw mode (`lineMode=false`), `readLineSync()` won't work; use `_readYesNo` for y/N prompts and `_readLine` (in `convert_command.dart`) for free-text input after context creation — both read raw keys from `KeyInput`
- Raw mode output: when `TerminalContext` is active, use `\r\n` (not `\n`) for newlines in `context.write()` calls — raw mode disables automatic CR insertion
- `TerminalContext.test()` constructor accepts `StringSink` + `Stream<List<int>>` for testable rendering/input
- `TerminalContext.dispose()` cancels the underlying `stdin` broadcast subscription (`_stdinSub`) — without this the Dart event loop hangs after the CLI finishes
- `MangaDetailsScreen.run()` returns `Future<bool>` — `true` = Enter (confirm selection), `false` = Escape (go back); `LiveSearchSelect` closes the event loop on `true` (same as direct Enter on a result)
- `ExtensionSelectScreen` Enter behavior: `when cursorIndex >= 0` guard — Enter does nothing while search bar is focused; with extensions toggled returns toggled set, without toggled auto-selects highlighted entry
- CLI TUI hyperlinks: wrap text in `green()` then `hyperlink()` — `green(text)` not `green(bold(text))` to match the dashboard's color; bold brightens green to a different shade
- `renderMarkdown()` in `terminal_ui.dart` converts markdown (`[text](url)`, `**bold**`, `*italic*`) to ANSI escapes — applied per-line AFTER `wordWrap()` to avoid ANSI sequences spanning wrapped lines
- `win_console_stub.dart` / `win_console_native.dart` — conditional import (`dart.library.ffi`) enables `ENABLE_VIRTUAL_TERMINAL_INPUT` on Windows; `enableVirtualTerminalInput()` called in `KeyInput.start()`, `restoreConsoleMode()` in `dispose()`
- `SearchInputState` in `terminal_ui.dart` owns query text, cursor position, focus state (`focused`), key routing (`tryHandleKey` → `SearchKeyResult`), and box rendering (`renderBox`) — callers pass unhandled keys through and check the result enum; `renderSearchInput()` renders the ANSI inverse block cursor
- Both search screens use `cursorIndex` (`-1` = search bar, `>= 0` = result) and sync `searchInput.focused` on arrow navigation; `tryHandleKey` auto-refocuses on text-modifying keys (CharKey, Backspace, Delete) but leaves Space to callers for screen-specific actions
- `KeyInput` parses two escape sequence formats: `ESC [ <byte>` (arrows, Home, End) and `ESC [ <digit> ~` (Delete=3); the escape buffer handles split delivery across both
- `KeyInput._controller` is broadcast — parent screens `cancel()` their subscription before opening a child screen, child creates its own subscription, then parent creates a fresh subscription on return (declare `keySub` as non-final). Do NOT use `pause()`/`resume()` (causes buffered event flood) or `suspend()`/`start()` (removed)
- `convert_command.dart` interactive callbacks (e.g. `onSelectExtensions`, `onConfirmMatches`) follow a stop/restore pattern: `spinner.stop()` → `loadingRegion.clear()` → `context.showCursor()` → run TUI screen → `context.hideCursor()` → `spinner.start(...)`. Non-interactive mode uses auto-select fallbacks.
- `convert_command.dart` uses `runZoned` with `ZoneSpecification.print` to redirect all `print()` (including from `aidoku_plugin_loader`) to a log file when interactive; `Zone.root.print()` escapes the zone for user-facing messages
- `_readPath` in `convert_command.dart` hides the terminal cursor on entry (`_renderPathInput` draws its own inverse-video block cursor) and restores it on all exit paths — callers should not call `showCursor()` before `_readPath`
- `PathInputState.handleKey()` exhaustively matches all `KeyEvent` subtypes — no `default` case needed; adding new `KeyEvent` subtypes requires adding a case here
- `extension_entry.dart` — `ExtensionEntry` sealed class (`id`, `name`, `languages`, `cacheKey`); `AidokuExtensionEntry` adds `version`, `contentRating` (0=Safe, 1=Suggestive, 2=NSFW), `altNames`, `iconUrl`, `downloadUrl`, `baseUrl?` (`cacheKey` = `'$id-v$version'`); `StubExtensionEntry` has only base fields (`cacheKey` = `id`)
- `PluginLoader` base class has `downloadPluginBytes(entry)` and `loadPluginFromBytes(entry, bytes)` with default null-returning implementations — `AidokuPluginLoader` overrides both; `CachingPluginLoader` uses these to cache/restore plugin bytes format-agnostically
- `lib/src/pipeline/plugin_source_stub.dart` — `StubPluginSource` implements `PluginSource`; must be updated when the interface changes
- `lib/src/pipeline/source_manga_data.dart` — `SourceMangaData` normalized type (chapters, history, tracking, categories)
- `lib/src/pipeline/target_backup_builder.dart` — `TargetBackupBuilder` sealed class; `AidokuBackupBuilder` is the only concrete impl; `build()` accepts optional `sourceFormatAlias` for backup metadata
- **Postcard integer encoding**: `u8`–`u64` → unsigned varint (LEB128); `i8`–`i64` → zigzag varint; `f32` → 4 LE bytes; `f64` → 8 LE bytes. Both `PostcardReader.readI64` and `PostcardWriter.writeI64` use zigzag varint, NOT raw bytes
- **Wasmer code assets**: `hook/build.dart` (singular `hook/`, not `hooks/`) downloads prebuilt wasmer v7.0.1 and registers it as a `CodeAsset` with `DynamicLoadingBundled()` — runs automatically during `dart run`, `dart build`, `dart test`; no manual wasmer install needed
- ffigen uses `ffi-native` mode (`ffi-native:` + `asset-id:` in YAML, hyphenated keys) — generates `@Native`-annotated top-level functions; `WasmerBindings()` constructor is parameterless (no `DynamicLibrary`)
- `wasm_runner_native.dart` `readMemory`/`writeMemory`/`call` throw `WasmRuntimeException` (an `Exception`, not `Error`) — `_makeCallable`'s `on Exception catch` handles these naturally; do not use `on Object catch`
- **No `print()` in WASM isolate code** — `aidoku_host.dart`, `wasm_isolate.dart`, and `wasm_runner_native.dart` route all log messages through `onLog` callback (threaded via `buildAidokuHostImports` and `WasmRunner.fromBytes`), which sends `WasmLogMsg` to the main isolate; this allows `convert_command.dart`'s `runZoned` print redirect to capture them
- `_processCmd` in `wasm_isolate.dart` replies via `cmd.replyPort.send()` — when changing reply format (e.g. to a tuple), update ALL corresponding `await port.first as ...` casts in `aidoku_plugin_io.dart`
- `aidoku_plugin_io.dart` (native) and `aidoku_plugin_web.dart` (web) are conditional exports of `aidoku_plugin.dart` — any public method added to one MUST be added to the other
- Host import errors (CSS selector failures, HTML parse errors) are logged with `[CB]` prefix via `onLog` — `wasm_isolate.dart` accumulates these during WASM calls and returns them as warnings alongside results; `PluginSearchPageResult.warnings` carries them to the pipeline; `_streamSearch` emits `PluginSearchError` for non-empty warnings; web worker `console.warn` calls in `wasm_worker_js.dart` must also use `[CB]` prefix for consistency
- WASM plugins are single-threaded — never call `search`/`getMangaWithChapters` concurrently on the same `PluginSource`; the migration dashboard serializes searches (one manga at a time) and `_streamSearch` enriches results with `getMangaWithChapters` before emitting so the TUI receives complete data (URL, chapters) upfront
- `migration_dashboard.dart` search lifecycle: `activeEntry` tracks the entry being searched; `pendingRetries` queues re-selected entries; `startNextSearch` drains retries before the linear index scan — when skipping a deselected entry in the scan, `searching` is set to `false`, so re-select logic must check `match == null` (not `searching`) to decide whether to retrigger
- `migration_dashboard.dart` `_findBestMatch` must evaluate ALL `entry.candidates` (not just the latest plugin's `results`) — using `=` not `??=` — so the best match across all plugins wins regardless of response order
- `diceCoefficient` in `terminal_ui.dart` — bigram Dice coefficient (0.0–1.0) for title similarity; used by live search sorting and dashboard auto-matching
- `live_search_select.dart` display rows include non-selectable group headers (result index `-1`); scroll offset operates in display-row space, not result-index space
- `get_manga_update` WASM ABI: `(manga_descriptor_rid, needs_details, needs_chapters)` — `getMangaDetails` accepts `{bool includeChapters = false}`; `plugin_source_aidoku.dart` passes `includeChapters: true` so chapters are included in migration output
- `PluginSearchResult` carries optional `details` (`PluginMangaDetails?`) and `chapters` (`List<PluginChapter>`) populated by `_streamSearch` enrichment — the TUI reads these directly, no async detail fetching needed
- WASM `get_search_manga_list` returns minimal data (authors typically empty); full author/artist data comes from `getMangaWithChapters` enrichment — always prefer detail-level fields over search-level fields when both exist
- `PluginMangaDetails` has separate `authors` and `artists` lists — display code should merge both into a `<String>{}` set to deduplicate (authors who are also artists)
- `lib/src/proto/` — Protocol buffer schemas for Tachi forks (mihon, j2k, neko, sy, yokai)
- `lib/src/exceptions/` — Format-specific exception classes

Each backup format class has a `fromData(Uint8List)` factory and conversion methods to other formats.

## Pipeline & Backup Format

- `BackupFormat` (sealed) is the single type for all format selection (CLI, pipeline, TachiBackup)
- Aliases: `aidoku, paperback, mihon, sy, j2k, yokai, neko, tachimanga, mangayomi`
- `BackupType` enum and `TachiFork` enum have been deleted — do not recreate
- `TachiBackup.format` is `Tachiyomi` (sealed subtype of `BackupFormat`), not an enum
- `Mangayomi` extends `BackupFormat` directly, not `Tachiyomi`
- `BackupFormat` hierarchy uses dart_mappable `discriminatorKey`/`discriminatorValue` for serialization
- `TachiUpdateStrategy` uses `ValuesMode.indexed` — maps to/from `int` (0=alwaysUpdate, 1=onlyFetchOnce), not string names
- `ConversionStrategy` (sealed): `DirectConversion` (Tachimanga↔Tachi) or `Migration` (all other pairs including same-format); no `Skip` — all pairs allow plugin migration
- `MigrationPipeline.run()` accepts `forceMigration` — when true, `DirectConversion` pairs use plugin migration instead of direct conversion
- `TachiBackup.toTachimangaBackup()` flattens nested Tachi structures into normalized Tachimanga DB tables with autoincrement-style sequential PKs (matching Tachimanga's `IntIdTable`); history is collapsed to one row per manga (Tachimanga's History table has `UNIQUE(manga_id)`) — latest chapter by `lastRead` timestamp, summed `readDuration`; Source IDs are preserved as-is (Source table uses `BIGINT NOT NULL`, not autoincrement)

### Pipeline Data Flow

- `MigrationPipeline.onConfirmMatches` is a batch callback — receives all `SourceMangaData` plus `onSearch` (streaming) and `onFetchDetails` functions; UI handles searching and user interaction
- `PluginSearchEvent` (sealed) streams search results per-plugin: `PluginSearchStarted` (emitted before each plugin's search begins) / `PluginSearchResults` / `PluginSearchError`
- `MangaMatchConfirmation.sourceManga` is `SourceMangaData` (not `MangaSearchDetails`) — carries chapters, history, tracking, categories from source backup
- `ConvertableBackup.sourceMangaDataEntries` extracts `List<SourceMangaData>` from each backup format
- `MangaMatchProposal.sourceManga` remains `MangaSearchDetails` (UI display only)
- `MangaSearchDetails` constructor applies `fixDoubleEncoding` (from `common/fix_double_encoding.dart`) to all text fields (`title`, `altTitles`, `authors`, `artists`, `description`) — NOT a const constructor; do not use `const MangaSearchDetails(...)`
- `SourceChapter`, `SourceHistoryEntry`, `SourceTrackingEntry`, `PluginChapter` constructors apply `normalizeChapterNumber` (from `common/normalize_chapter_number.dart`) to chapter/volume numbers — NOT const constructors
- `tachi_backup.dart` must directly import `tachi_backup_chapter.dart`, `tachi_backup_history.dart`, `tachi_backup_tracking.dart` — they are NOT re-exported by `tachi_backup_manga.dart`

## Code Generation

This project relies heavily on code generation. Generated files use these suffixes:

- `*.mapper.dart` (dart_mappable), `*.freezed.dart` (freezed)
- `*.g.dart` (riverpod_generator, json_serializable), `*.pb.dart` / `*.pbenum.dart` (protobuf)

Always run `melos run generate` after modifying annotated model classes. The env package generates separately during bootstrap.

## Lint Rules

- Base: `solid_lints` via `packages/app_lints`
- `prefer_single_quotes`, `strict-inference: true`, `dart analyze --fatal-infos`
- `omit_obvious_local_variable_types` + `specify_nonobvious_local_variable_types` + `avoid_multiple_declarations_per_line` — use `dart fix --apply <directory>` after writing new code (only accepts one path argument)
- `dart fix --apply` may add incorrect imports on web-only files (e.g. importing `dart:io` transitives) — always review changes after running
- `avoid_catching_errors` lint: don't use `on UnimplementedError catch` in tests — use `on Object catch (e)` + `check(e).isA<UnimplementedError>()` instead
- `directives_ordering` — all `package:` imports must be in one alphabetically-sorted section; conditional imports (`if (dart.library.ffi)`) count as their primary URI for sorting
- **Directional UI required**: Use `EdgeInsetsDirectional`, `PositionedDirectional`, `AlignmentDirectional`, `BorderDirectional`, `BorderRadiusDirectional` instead of their non-directional counterparts
- CI enforces formatting via `melos run verify_format`

## Key Libraries

- **State**: Riverpod + riverpod_generator + hooks_riverpod
- **Models**: freezed (immutable), dart_mappable (serialization)
- dart_mappable `with ...Mappable` mixin prevents const constructors — use non-const when constructing these objects in tests
- dart_mappable custom mapper `encode()`/`decode()` return `dynamic` — use `final dynamic result = mapper.encode(...)` to satisfy `specify_nonobvious_local_variable_types`
- **Navigation**: go_router
- **Theme**: flex_color_scheme
- **Testing**: mocktail, patrol (integration tests)
- **Testing assertions**: `package:checks` (not `package:matcher`) — use `check(val).equals()`, `isCloseTo()`, `isA<T>()`, `isNotNull()`, `isEmpty()`; import from `package:checks/checks.dart` + `package:test/scaffolding.dart` (not `package:test/test.dart`)
- **Testing imports**: avoid barrel import (`mangabackupconverter_lib.dart`) in tests when names clash with `package:test`; use specific imports or `hide`
- **Web-only tests**: `@TestOn('browser')` + `dart test --reporter expanded --platform chrome test/web/` — hand-crafted WASM binaries as `Uint8List` constants for testing without .aix fixtures
- **CLI formats**: protobuf, archive, sqflite_common

## CI

GitHub Actions runs on all branches: format verification, analysis, tests with coverage (Codecov), then platform builds (iOS, Android, Web, Windows, Linux). Flutter 3.41.1 stable.

## Commits

Do not commit changes with "Co-Authored-By: Claude" or similar in the description.

## Other Instructions

- WASM_ABI.md in aidoku_plugin_loader documents the Aidoku ABI; cross-check against aidoku-rs source if behavior doesn't match
- IMPORTANT: Compiled .aix plugins may use older aidoku-rs versions — always verify enum/struct layouts against integration tests with real plugins, not just aidoku-rs source
- `AidokuPlugin.fromAix()` accepts `defaults: Map<String,dynamic>` to pre-seed per-source defaults (e.g. auth tokens); keys are raw (no sourceId prefix); see WASM_ABI.md "defaults" section
- `start` export is always generated by aidoku-rs `register_source!` macro (core, not optional); the `on Exception catch` around `runner.call('start')` is defensive only
- `HostStore` is shared between web (Worker) and native (WASM isolate) — stores raw `Uint8List` resources
  - Decoding postcard results must happen at the consumer level (`aidoku_plugin_io.dart` / `aidoku_plugin_web.dart`), not inside `HostStore`
  - Native isolate forwards raw bytes via `WasmPartialResultMsg`
- `_encodeString` in `aidoku_host.dart` returns **raw UTF-8** (`utf8.encode`), NOT postcard-encoded — aidoku-rs SDK reads host strings via `String::from_utf8(buffer)` which expects no length prefix
- `html::attr` supports `abs:` prefix (Jsoup convention) — uses `element.absUrl(key)`; `HtmlElementResource`/`HtmlElementsResource` in `host_store.dart` hold `Element`/`Elements` objects; `baseUri` propagates via `Element.baseUri`
- `html::parse_fragment` returns `HtmlElementResource` (wrapping a `Document`) so CSS selectors work
- **jsoup OO API** (`packages/jsoup/`): public classes `Jsoup`, `Document extends Element`, `Element extends Node`, `Elements extends Iterable<Element>`, `Node` (base class), `TextNode extends Node`; `NativeHtmlParser` is internal (not exported from barrel `package:jsoup/jsoup.dart`)
- `Jsoup.parser` is `@internal`; `Element.fromHandle`/`Elements.fromHandle`/`Document.fromHandle` are `@internal` — external code uses `Jsoup()`, `jsoup.parse()`, `element.select()` etc.
- `Elements` is always native-backed; public constructor `Elements(Jsoup, List<Element>)` creates via `createElements`; for empty fallback use `Elements.fromHandle(parser, parser.createElements(const <int>[]))`
- `Node` base class: `nodeName`, `parentNode`, `childNode(index)`, `childNodes`, `childNodeSize`, `outerHtml`, `remove()`
- `TextNode extends Node`: `text` (get/set), `wholeText`, `isBlank`; `Element.textNodes` returns `List<TextNode>`, `Element.childNodes` returns `List<Node>` (mixed)
- `Jsoup` factory methods: `element(tag)`, `textNode(text)`, `elements(list)` — preferred entry points alongside `parse`/`parseFragment`
- Node type discrimination in `jsoup_parser.dart`: `_addNode()` checks `nodeName() == "#text"` then casts with `.as(TextNode.type)` or `.as(Element.type)`
- JNI inherited methods (not in jnigen bindings): use raw FFI `ProtectedJniExtensions.lookup` pattern — see `_callBooleanMethodWithObject` for `List.add`, `_callIntMethod` for `List.size`
- `Element.absUrl(key)` resolves relative URLs via `Uri.parse(baseUri).resolve(raw)` — replaces manual `abs:` prefix handling
- **Web backend** (Cheerio): `CheerioParser` in `lib/src/web/jsoup_web.dart` — loads Cheerio via Blob URL + `importScripts` (Worker-only); `_ensureCheerioLoaded()` checks `globalThis.cheerio` first so pre-loaded contexts skip loading
- `jsoup_stub.dart` is the web branch of the conditional export — MUST NOT import files that use `dart:io` or `dart:ffi` (transitive imports included)
- `jsoup_selector.dart` — Dart port of jsoup pseudo-selector engine from `wasm_worker_js.dart`; mid-chain pseudo-selectors apply to final results only (same limitation as the JS version)
- `aidoku_host.dart` takes `Jsoup? htmlParser`; `wasm_isolate.dart` creates `Jsoup()` per isolate (JVM is process-global)
- **Web JS interop**: `dart:js_interop_unsafe` is required for `JSObject.getProperty`/`setProperty`; `JSNull`/`JSUndefined` are not types — use `jsValue.isUndefinedOrNull` instead; extension types with setters need matching getters (`avoid_setters_without_getters`)
- **Aidoku web WASM**: Runs in a Dart isolate (`lib/src/web/wasm_worker_isolate.dart`) compiled to a Web Worker
  - Reuses `buildAidokuHostImports()`, `HostStore`, `WasmRunner` (web), `Jsoup()` (CheerioParser) — unified with native
  - `Isolate.spawn(wasmWorkerMain, initMap)` + `SendPort`/`ReceivePort` with Map-based messages (structured-cloneable)
  - Sync XHR via `dart:js_interop` (`_JSXMLHttpRequest`) — required because WASM host imports must return synchronously
  - `_LazyRunner` proxy breaks circular dependency (same pattern as native `wasm_isolate.dart`)
- **Web JS interop arity**: dart2js `.toJS` creates fixed-arity JS functions; WASM imports need variable-arity. `_varArgsFactory` in `wasm_runner_web.dart` uses `eval` to create wrappers that forward `arguments` as JSArray to a 1-arg Dart bridge. Requires `eval` (already needed since WASM uses `wasm-eval`)
- **Cheerio web bundle** (`packages/jsoup/`): `tool/bundle_cheerio.dart` generates `lib/src/web/cheerio_bundle.dart` — cheerio 1.2.0 UMD via browserify + custom `node:` prefix stripping transform + `undici` excluded; `package:jsoup/cheerio.dart` exports the `cheerioJs` const string
- **`code_assets` `OS` class**: No `web` constant — only native OS values (android, iOS, linux, macOS, windows, fuchsia); `buildCodeAssets` is already false for web targets, so build hooks return early
