# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Manga Backup Converter — a Flutter/Dart monorepo that converts manga backup files between formats: Aidoku (.aib), Paperback (.pas4), Tachi (.tachibk, .proto.gz), Tachimanga (.tmb), and Mangayomi (.backup). Includes a multi-platform Flutter app and a standalone CLI package.

## Monorepo Structure (Melos)

- Root: Flutter app (iOS, Android, macOS, Windows, Linux, Web)
- `packages/mangabackupconverter_cli/` — Core conversion logic (pure Dart, no Flutter dependency)
- `packages/wasm_plugin_loader/` — Aidoku WASM plugin loader (native wasmer FFI + web WebAssembly)
- `packages/app_lints/` — Shared lint rules (based on `solid_lints`)
- `packages/assets/` — Asset code generation
- `packages/constants/` — App-wide constants

## One-Time Setup (per clone)

```bash
git config core.hooksPath .githooks   # Enable .githooks/post-checkout for worktree file sync
```

## Common Commands

```bash
melos bootstrap                  # Install deps + generate env files + activate coverage
melos run generate               # Run all code generation (assets, env, build_runner, format)
melos run generate:pkg           # Run build_runner for a specific package (interactive)
melos run watch:pkg              # Watch mode for build_runner in a specific package
melos run test                   # Run all tests (flutter + dart) with coverage
melos run flutter_test:pkg       # Flutter tests for a specific package
melos run dart_test:pkg          # Dart tests for a specific package
                                 # For dart test directly: use --reporter expanded (not -v, which is invalid)
                                 # Native WASM tests skip automatically if wasmer or test fixture is absent
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
- `lib/src/common/` — `BackupType` enum, `Convertable` interface, shared mappers
- `lib/src/formats/<format>/` — Format-specific backup models and parsers
- `lib/src/pipeline/` — Migration pipeline API (BackupFormat, MangaSearchDetails, MigrationPipeline, plugin sources)
- `lib/src/proto/` — Protocol buffer schemas for Tachi forks (mihon, j2k, neko, sy, yokai)
- `lib/src/exceptions/` — Format-specific exception classes

Each backup format class has a `fromData(Uint8List)` factory and conversion methods to other formats.

## Code Generation

This project relies heavily on code generation. Generated files use these suffixes:

- `*.mapper.dart` (dart_mappable), `*.freezed.dart` (freezed)
- `*.g.dart` (riverpod_generator, json_serializable), `*.pb.dart` / `*.pbenum.dart` (protobuf)

Always run `melos run generate` after modifying annotated model classes. The env package generates separately during bootstrap.

## Lint Rules

- Base: `solid_lints` via `packages/app_lints`
- `prefer_single_quotes`, `strict-inference: true`, `dart analyze --fatal-infos`
- **Directional UI required**: Use `EdgeInsetsDirectional`, `PositionedDirectional`, `AlignmentDirectional`, `BorderDirectional`, `BorderRadiusDirectional` instead of their non-directional counterparts
- CI enforces formatting via `melos run verify_format`

## Key Libraries

- **State**: Riverpod + riverpod_generator + hooks_riverpod
- **Models**: freezed (immutable), dart_mappable (serialization)
- **Navigation**: go_router
- **Theme**: flex_color_scheme
- **Testing**: mocktail, patrol (integration tests)
- **CLI formats**: protobuf, archive, sqflite_common

## CI

GitHub Actions runs on all branches: format verification, analysis, tests with coverage (Codecov), then platform builds (iOS, Android, Web, Windows, Linux). Flutter 3.41.1 stable.

## Commits

Do not commit changes with "Co-Authored-By: Claude" or similar in the description.

## Other Instructions

- WASM_ABI.md in wasm_plugin_loader documents the Aidoku ABI; cross-check against aidoku-rs source if behavior doesn't match
- IMPORTANT: Compiled .aix plugins may use older aidoku-rs versions — always verify enum/struct layouts against integration tests with real plugins, not just aidoku-rs source
- AidokuPluginMemoryStore.loadAixBytes() accepts `defaults: Map<String,dynamic>` to pre-seed per-source defaults (e.g. auth tokens); keys are raw (no sourceId prefix); see WASM_ABI.md "defaults" section
- `start` export is always generated by aidoku-rs `register_source!` macro (core, not optional); the `on Exception catch` around `runner.call('start')` is defensive only
