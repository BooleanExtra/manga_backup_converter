// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'paperback_backup_item_type.dart';

class PaperbackBackupItemTypeMapper
    extends EnumMapper<PaperbackBackupItemType> {
  PaperbackBackupItemTypeMapper._();

  static PaperbackBackupItemTypeMapper? _instance;
  static PaperbackBackupItemTypeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = PaperbackBackupItemTypeMapper._(),
      );
    }
    return _instance!;
  }

  static PaperbackBackupItemType fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  PaperbackBackupItemType decode(dynamic value) {
    switch (value) {
      case '__CHAPTER_PROGRESS_MARKER_V4-1':
        return PaperbackBackupItemType.chapterProgressMarkerV4_1;
      case '__CHAPTER_V4':
        return PaperbackBackupItemType.chapterV4;
      case '__LIBRARY_MANGA_V4':
        return PaperbackBackupItemType.libraryMangaV4;
      case '__MANGA_INFO_V4':
        return PaperbackBackupItemType.mangaInfoV4;
      case '__SOURCE_MANGA_V4':
        return PaperbackBackupItemType.sourceMangaV4;
      case r'unknown':
        return PaperbackBackupItemType.unknown;
      default:
        return PaperbackBackupItemType.values[5];
    }
  }

  @override
  dynamic encode(PaperbackBackupItemType self) {
    switch (self) {
      case PaperbackBackupItemType.chapterProgressMarkerV4_1:
        return '__CHAPTER_PROGRESS_MARKER_V4-1';
      case PaperbackBackupItemType.chapterV4:
        return '__CHAPTER_V4';
      case PaperbackBackupItemType.libraryMangaV4:
        return '__LIBRARY_MANGA_V4';
      case PaperbackBackupItemType.mangaInfoV4:
        return '__MANGA_INFO_V4';
      case PaperbackBackupItemType.sourceMangaV4:
        return '__SOURCE_MANGA_V4';
      case PaperbackBackupItemType.unknown:
        return r'unknown';
    }
  }
}

extension PaperbackBackupItemTypeMapperExtension on PaperbackBackupItemType {
  dynamic toValue() {
    PaperbackBackupItemTypeMapper.ensureInitialized();
    return MapperContainer.globals.toValue<PaperbackBackupItemType>(this);
  }
}

