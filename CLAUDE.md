# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Manga Backup Converter — a Flutter/Dart monorepo that converts manga backup files between formats: Aidoku (.aib), Paperback (.pas4), Tachi (.tachibk, .proto.gz), Tachimanga (.tmb), and Mangayomi (.backup). Includes a multi-platform Flutter app and a standalone CLI package.

## Monorepo Structure (Melos)

- Root: Flutter app (iOS, Android, macOS, Windows, Linux, Web)
- `packages/mangabackupconverter_cli/` — Core conversion logic (pure Dart, no Flutter dependency)
- `packages/aidoku_plugin_loader/` — Aidoku WASM plugin loader (host imports, isolate management, picks runtime)
- `packages/wasm_runner/` — Abstract WASM runner interface (`WasmRunner`, `WasmRuntimeException`, `WasmTrapException`)
- `packages/wasmer_runner/` — Wasmer FFI runner implementing `WasmRunner` (native platforms, build hook downloads prebuilt wasmer)
- `packages/web_wasm_runner/` — Browser WebAssembly runner implementing `WasmRunner` (web platform)
- `packages/wasm3/` — Wasm3 interpreter runner implementing `WasmRunner`
- `packages/app_lints/` — Shared lint rules (based on `solid_lints`)
- `packages/jsoup/` — Jsoup-compatible HTML parsing (Rust scraper on Windows/Linux/Android, SwiftSoup on iOS/macOS, TeaVM on Web)
- `packages/scraper/` — Rust scraper crate (html5ever/Servo) FFI bridge; build hook compiles via cargo + registers CodeAsset; for Android, auto-discovers NDK from `ANDROID_HOME/ndk/` and runs `rustup target add` before cross-compiling
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
                                 # Melos config is in root pubspec.yaml (workspace: key), NOT melos.yaml
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
                                 # Root pubspec.yaml must depend on packages with build hooks (native code assets)
                                 # for `dart test` from root to discover them (e.g. wasm3, jsoup)
melos run cli                    # Run CLI directly (args forwarded automatically)
melos run jnigen                 # Generate JNI bindings for jsoup (uses system JDK for javadoc)
melos run jni_setup              # Build dartjni.dll (uses bundled JDK, handles MSYS2)
melos run lint                   # Run dart analyze + custom_lint
melos run format                 # Format all packages
melos run fix                    # Auto-fix lint issues
```

Build: `flutter build <platform>`

## CLI Build Output

`dart build cli` outputs to platform-specific directories under the CLI package:
- Windows: `packages/mangabackupconverter_cli/build/cli/windows_x64/bundle/` (bin/ + lib/)
- Linux: `packages/mangabackupconverter_cli/build/cli/linux_x64/bundle/` (bin/ + lib/)
- macOS: `packages/mangabackupconverter_cli/build/cli/macos_arm64/bundle/` (bin/ + lib/)
- Windows installer: `packages/mangabackupconverter_cli/installer/windows_setup.iss` (Inno Setup, compiled in CI)

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
- **Wasm3 code assets**: `packages/wasm3/hook/build.dart` compiles vendored wasm3 C source via `native_toolchain_c` and registers it as a `CodeAsset` with `DynamicLoadingBundled()` — runs automatically during `dart run`, `dart build`, `dart test`; no manual install needed; defines `M3_HAS_TAIL_CALL=0` for Android armv7 — NDK clang 18 crashes on `musttail` attribute
- **Wasm3 version**: vendored at latest HEAD (`79d412e`, post-v0.5.0); `m3_emit.c`, `m3_emit.h`, `m3_optimize.c` were removed upstream (merged into `m3_compile.c`) — `hook/build.dart` reflects this; regenerate bindings with `dart run ffigen --config ffigen.yaml` from `packages/wasm3/`
- ffigen config in `packages/wasm3/ffigen.yaml`; uses `ffi-native` mode — generates `@Native`-annotated top-level functions
- `Wasm3Runner` `readMemory`/`writeMemory`/`call` throw `WasmRuntimeException` (an `Exception`, not `Error`)
- **WASM runner conditional export**: `aidoku_plugin_loader/lib/src/wasm/wasm_runner.dart` re-exports `wasm3` on native, `web_wasm_runner` on web via `if (dart.library.js_interop)`
- Root `pubspec.yaml` must depend on `wasm3` (has build hook) for `dart test` from root to discover code assets
- **No `print()` in WASM isolate code** — `aidoku_host.dart`, `wasm_isolate.dart`, and the active WASM runner route all log messages through `onLog` callback (threaded via `buildAidokuHostImports` and `WasmRunner.fromBytes`), which sends `WasmLogMsg` to the main isolate; this allows `convert_command.dart`'s `runZoned` print redirect to capture them
- `_processCmd` in `wasm_isolate.dart` replies via `cmd.replyPort.send()` — when changing reply format (e.g. to a tuple), update ALL corresponding `await port.first as ...` casts in `aidoku_plugin_io.dart`
- **Isolate error handling**: `wasmIsolateMain` and `_processCmd` use `on Object catch` (not `on Exception catch`) — `Error` subtypes (`ArgumentError`, `RangeError`, `StateError`) from the WASM runner/FFI must be caught or the isolate dies silently, causing `port.first` hangs on the main isolate
- **Isolate init failure**: Runner creation happens AFTER the handshake sends cmdPort — if `WasmRunner.fromBytes` fails, the isolate enters a command-drain loop replying with errors (can't send on the already-consumed handshake port)
- **`_sendErrorReply` in `wasm_isolate.dart`**: Best-effort error reply for all command types; `WasmSearchCmd`/`WasmMangaDetailsCmd` reply with `(String error, List<String>)`, all others reply with `null`
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
- All `actions/checkout@v4` steps require `submodules: true` — wasm3 vendored source is a git submodule at `packages/wasm3/vendor/wasm3`

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
- **html:: WASM imports use jsoup OO API** — re-integrated after switching from wasmer to wasm3 (no VEH conflict). `wasm_isolate.dart` creates `Jsoup()` per isolate with graceful fallback (`htmlParser == null` → imports return `-1`). HTML imports in `imports/html_imports.dart`; `ImportContext` helpers in `libs/import_context.dart`. `HtmlElementResource`/`HtmlElementsResource` in `host_store.dart` store jsoup DOM objects.
- **aidoku_host.dart modular imports**: `buildAidokuHostImports` delegates to `imports/html_imports.dart`, `imports/std_imports.dart`, `imports/net_imports.dart`, `imports/env_imports.dart`, `imports/defaults_imports.dart`, `imports/canvas_imports.dart`, `imports/js_imports.dart`; shared context in `libs/import_context.dart`
- **jsoup package layout** (`packages/jsoup/lib/src/`): `jsoup.dart` (entry point), `html_parser.dart` (abstract `NativeHtmlParser` interface), `jsoup_version.dart`; `nodes/` (OO API: `document.dart`, `element.dart`, `elements.dart`, `node.dart`, `text_node.dart`); `platform/` (`parser_native.dart`, `parser_web.dart` — conditional import factories); `scraper/` (`scraper_parser.dart` — Rust scraper backend, used on Windows/Linux/Android); `jni/` (`jni_parser.dart`, `jre_manager.dart`, `bindings/` — JNI backend, retained for Android fallback/reference); `swift/` (`swift_parser.dart` — SwiftSoup stub); `web/` (`teavm_parser.dart`, `teavm_bundle.dart` — TeaVM backend)
- **jsoup OO API** (`packages/jsoup/`): public classes `Jsoup`, `Document extends Element`, `Element extends Node`, `Elements extends Iterable<Element>`, `Node` (base class), `TextNode extends Node`; `NativeHtmlParser` is internal (not exported from barrel `package:jsoup/jsoup.dart`)
- `Jsoup.parser` is `@internal`; `Element.fromHandle`/`Elements.fromHandle`/`Document.fromHandle` are `@internal` — external code uses `Jsoup()`, `jsoup.parse()`, `element.select()` etc.
- `Elements` is always native-backed; public constructor `Elements(Jsoup, List<Element>)` creates via `createElements`; for empty fallback use `Elements.fromHandle(parser, parser.createElements(const <int>[]))`
- `Node` base class: `nodeName`, `parentNode`, `childNode(index)`, `childNodes`, `childNodeSize`, `outerHtml`, `remove()`
- `TextNode extends Node`: `text` (get/set), `wholeText`, `isBlank`; `Element.textNodes` returns `List<TextNode>`, `Element.childNodes` returns `List<Node>` (mixed)
- `Jsoup` factory methods: `element(tag)`, `textNode(text)`, `elements(list)` — preferred entry points alongside `parse`/`parseFragment`
- Node type discrimination in `jni/jni_parser.dart`: `_addNode()` checks `nodeName() == "#text"` then casts with `.as(TextNode.type)` or `.as(Element.type)`
- JNI inherited methods (not in jnigen bindings): use raw FFI `ProtectedJniExtensions.lookup` pattern — see `_callBooleanMethodWithObject` for `List.add`, `_callIntMethod` for `List.size`
- `Element.absUrl(key)` resolves relative URLs via `Uri.parse(baseUri).resolve(raw)` — replaces manual `abs:` prefix handling
- **Rust scraper backend** (`packages/scraper/`): Rust `scraper` crate 0.25 (html5ever/Servo) compiled to cdylib via cargo; ~45 `extern "C"` functions with `scraper_` prefix; thread-local handle stores (`DOCUMENTS`, `NODES`, `NODE_LISTS`) with atomic counter; `ScraperParser` lives in `packages/jsoup/lib/src/scraper/` (not in scraper package) to avoid circular dependency
- **Scraper `:contains()` support**: `:contains()`, `:containsOwn()`, `:containsWholeText()`, `:containsWholeOwnText()`, `:containsData()`, `:matches(regex)`, `:matchesOwn(regex)` implemented via `contains_filter.rs` — strips the pseudo-selector from the CSS string, passes base selector to Servo, then post-filters matched elements; `:matches`/`:matchesOwn` use `regex` crate
- **Scraper Jsoup parity**: `scraper_text`/`scraper_text_node_text` normalize whitespace (`split_whitespace().join(" ")`); `scraper_text_node_whole_text` returns raw text; `scraper_node_outer_html` for text nodes HTML-escapes `&`, `<`, `>`; `scraper_data` only returns content for `script`/`style`/`textarea`/`title` (empty for other elements); `scraper_class_name` returns `""` (not null) for classless elements; `scraper_node_abs_url` returns `""` for relative URLs when base URI is empty (absolute URLs still returned)
- **Scraper select self-matching**: `scraper_select`/`scraper_select_first` check if the element itself matches the selector before iterating descendants (via `sel.matches(&el_ref)`) — Java Jsoup includes the root element in results; without this, `el.selectFirst("a")` on an `<a>` element returns null
- **Scraper mutation gotcha**: `scraper::node::Element` uses `OnceCell` for `id`/`classes` caching — attribute mutations must rebuild the entire Element via `Element::new()` to invalidate caches (see `rebuild_element` in `mutation.rs`)
- **html5ever fragment wrapping**: `Html::parse_fragment()` wraps content in implicit `<html>/<head>/<body>` — `collect_fragment_trees()` in `mutation.rs` unwraps these before transplanting children
- **Scraper build hook caching**: To force rebuild after Rust changes, delete BOTH `.dart_tool/hooks_runner/scraper/` (per-package hash/output cache) AND `.dart_tool/hooks_runner/shared/scraper/` (built DLL cache); deleting only the DLL causes `PathNotFoundException` because the hooks_runner skips re-running the hook if hashes match
- **jsoup platform routing**: Windows/Linux → Rust scraper (`ScraperParser`); Android → Rust scraper; iOS/macOS → SwiftSoup (TODO); Web → TeaVM (`TeaVMParser`); `parser_native.dart` returns `ScraperParser()` for all native platforms except iOS/macOS
- **JAR discovery**: `JreManager._findJsoupJar()` checks exe-relative paths → walks upward from `Directory.current` for `.dart_tool/hooks_runner/shared/jsoup/build/jsoup-<version>/`; no env var fallbacks; version constant in `lib/src/jsoup_version.dart`
- **MSYS2/MinGW CMake**: Windows backslash paths cause `Invalid character escape` in CMake; use `/c/...` format (not `C:\...`); `jni:setup` expects MSVC `Debug/` layout — `generate_jni_bindings.dart --jni-setup` works around this by rescuing `libdartjni.so` from the temp dir
- **JNI test prereq**: Run `melos run jni_setup` (or `dart run tool/generate_jni_bindings.dart --jni-setup` from `packages/jsoup/`) — uses bundled JDK and handles MSYS2/MinGW CMake path issues; raw `dart run jni:setup` fails under MSYS2
- **jsoup tests**: `@TestOn('vm')` required (native-only); create fresh `Jsoup()` in `setUp`, call `jsoup.dispose()` in `tearDown`; scraper backend is default on Windows/Linux — no JRE/JNI setup needed; JNI backend tests tagged `@Tags(['jni'])` and skipped by default via `dart_test.yaml` — run separately: `dart test -t jni --run-skipped` (avoids Windows VEH crash when combined with scraper tests)
- **Windows DLL loading**: `dartjni.dll` depends on `jvm.dll` at load time; `JreManager` pre-loads `jvm.dll` by full path (`DynamicLibrary.open(jvmLibPath)`) before `Jni.spawnIfNotExists` — no PATH modification needed
- **JVM is process-global**: Use `Jni.spawnIfNotExists` (not `Jni.spawn`) — child isolates share the JVM created by the main isolate; `JreManager.ensureInitialized()` is safe in child isolates (early return via `GetModuleHandleW` when jvm.dll already loaded)
- **Web backend** (TeaVM): `TeaVMParser` in `lib/src/web/teavm_parser.dart` — loads TeaVM-compiled Java Jsoup via Blob URL + `importScripts` (Worker-only); the UMD module exports all bridge functions on `self`
- `platform/parser_web.dart` is the web branch of the conditional export — MUST NOT import files that use `dart:io` or `dart:ffi` (transitive imports included)
- `host_store.dart`: `HtmlElementResource`, `HtmlElementsResource`, `BytesResource`, `HttpRequestResource`, canvas/image/font resources
- **Web JS interop**: `dart:js_interop_unsafe` is required for `JSObject.getProperty`/`setProperty`; `JSNull`/`JSUndefined` are not types — use `jsValue.isUndefinedOrNull` instead; extension types with setters need matching getters (`avoid_setters_without_getters`)
- **Aidoku web WASM**: Runs in a Dart isolate (`lib/src/web/wasm_worker_isolate.dart`) compiled to a Web Worker
  - Reuses `buildAidokuHostImports()`, `HostStore`, `WasmRunner` (web), `Jsoup()` (TeaVMParser) — unified with native
  - `Isolate.spawn(wasmWorkerMain, initMap)` + `SendPort`/`ReceivePort` with Map-based messages (structured-cloneable)
  - Sync XHR via `dart:js_interop` (`_JSXMLHttpRequest`) — required because WASM host imports must return synchronously
  - `LazyWasmRunner` (`lib/src/wasm/lazy_wasm_runner.dart`) breaks circular dependency — shared by both native `wasm_isolate.dart` and web `wasm_worker_isolate.dart`
  - Rate limiting enforced in-worker via `RateLimiter` + busy-wait before each sync XHR (unlike native where it's on the main isolate, because web HTTP is synchronous)
- **Web JS interop arity**: dart2js `.toJS` creates fixed-arity JS functions; WASM imports need variable-arity. `_varArgsFactory` in `packages/web_wasm_runner/lib/src/web_wasm_runner.dart` uses `eval` to create wrappers that forward `arguments` as JSArray to a 1-arg Dart bridge. Requires `eval` (already needed since WASM uses `wasm-eval`)
- **TeaVM web bundle** (`packages/jsoup/`): `tool/build_teavm.dart` compiles `tool/teavm/` (Maven + TeaVM 0.13.0 + Jsoup 1.18.3) → `lib/src/web/teavm_bundle.dart` (567 KB minified JS as const string); `package:jsoup/teavm.dart` exports `teavmJsoupJs`
- **TeaVM build requirements**: JDK 17+ and Maven 3.x; `tool/teavm/pom.xml` must include `teavm-core` as explicit dependency (contains `PlatformDetector` needed by classlib); `JsoupBridge.java` uses `@JSExport` (not `@Export`) from `org.teavm.jso.JSExport`; ADVANCED optimization produces smaller output than FULL
- **TeaVM Java bridge** (`tool/teavm/src/main/java/.../JsoupBridge.java`): 54 `@JSExport` static methods wrapping Jsoup API with `HashMap<Integer, Object>` handle store; method renames: `id`→`elementId`, `get`→`getAt`, `remove`→`removeElement`, `dispose`→`disposeAll` (mapped back in `TeaVMParser`)
- **`code_assets` `OS` class**: No `web` constant — only native OS values (android, iOS, linux, macOS, windows, fuchsia); `buildCodeAssets` is already false for web targets, so build hooks return early
