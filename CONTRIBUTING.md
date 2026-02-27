# Contributing

## Setup

1. Install [Flutter](https://flutter.dev/docs/get-started/install)
2. Install [Melos](https://pub.dev/packages/melos) globally: `dart pub global activate melos`
3. Run `melos bootstrap` to install dependencies and generate env files

## Common Commands

```bash
melos bootstrap              # Install deps + generate env files
melos run generate           # Run all code generation
melos run test               # Run all tests with coverage
melos run lint               # Run dart analyze + custom_lint
melos run format             # Format all packages
melos run cli                # Run the CLI (args forwarded)
```

## Monorepo Structure

```
├── lib/                                    # Flutter app
├── packages/
│   ├── mangabackupconverter_cli/           # Core conversion logic + CLI
│   ├── aidoku_plugin_loader/               # Aidoku WASM plugin loader
│   ├── jsoup/                              # Jsoup-compatible HTML parsing
│   ├── scraper/                            # Rust scraper FFI bridge
│   ├── swiftsoup/                          # SwiftSoup FFI bindings
│   ├── wasm_runner/                        # Abstract WASM runner interface
│   ├── wasm3/                              # Wasm3 interpreter runner
│   ├── wasmer_runner/                      # Wasmer FFI runner (native)
│   ├── web_wasm_runner/                    # Browser WASM runner (web)
│   ├── assets/                             # Asset code generation
│   ├── constants/                          # App-wide constants
│   └── app_lints/                          # Shared lint rules
```

## Building

```bash
dart build packages/mangabackupconverter_cli
```

CI automatically builds for all platforms via GitHub Actions.

## How to Contribute

1. Fork it [https://github.com/getBoolean/manga_backup_converter/fork](https://github.com/getBoolean/manga_backup_converter/fork)
1. Create your feature branch (git checkout -b feature/fooBar)
1. Commit your changes (git commit -am 'Add some fooBar')
1. Push to the branch (git push origin feature/fooBar)
1. Create a new Pull Request
