# Manga Backup Converter <!-- omit in toc -->

[![latest release](https://img.shields.io/github/release/getBoolean/manga_backup_converter.svg?maxAge=3600&label=download)](https://github.com/getBoolean/manga_backup_converter/releases)
[![coverage](https://img.shields.io/codecov/c/github/getBoolean/manga_backup_converter)](https://app.codecov.io/gh/getBoolean/manga_backup_converter)

Convert manga backup files between formats. Available as a standalone CLI with a Flutter app planned.

**[Download latest release](https://github.com/getBoolean/manga_backup_converter/releases/latest)**

## Supported Formats

| Format | Extension | App |
|--------|-----------|-----|
| Aidoku | `.aib` | [Aidoku](https://aidoku.app/) |
| Paperback | `.pas4` | [Paperback](https://paperback.moe/) |
| Tachi (Mihon, TachiyomiSY, TachiyomiJ2K, Yokai, Neko) | `.tachibk`, `.proto.gz` | [Mihon](https://mihon.app/) and forks |
| Tachimanga | `.tmb` | [Tachimanga](https://tachimanga.app/) |
| Mangayomi | `.backup` | [Mangayomi](https://github.com/kodjodevf/mangayomi) |

## Feature Support

| Format | Import | Direct conversion | Plugin migration |
|--------|:------:|:------------------:|:----------------:|
| Aidoku | :white_check_mark: | — | :white_check_mark: |
| Paperback | :white_check_mark: | — | :x: |
| Tachi | :white_check_mark: | :arrow_right: Tachimanga | :x: |
| Tachimanga | :white_check_mark: | :arrow_right: Tachi | :x: |
| Mangayomi | :white_check_mark: | — | :x: |

- **Direct conversion** preserves data 1:1 between Tachi and Tachimanga without needing plugins.
- **Plugin migration** uses Aidoku source extensions to search and match manga. Currently only Aidoku is supported as a migration target.

## Platforms

- Windows, macOS, Linux (standalone CLI)
- Flutter app planned (iOS, Android, macOS, Windows, Linux, Web)

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md)

## License

See [LICENSE.md](./LICENSE.md)
