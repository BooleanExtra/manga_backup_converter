// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'aidoku_enums.dart';

class AidokuMangaContentRatingMapper extends EnumMapper<AidokuMangaContentRating> {
  AidokuMangaContentRatingMapper._();

  static AidokuMangaContentRatingMapper? _instance;
  static AidokuMangaContentRatingMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AidokuMangaContentRatingMapper._());
    }
    return _instance!;
  }

  static AidokuMangaContentRating fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  AidokuMangaContentRating decode(dynamic value) {
    switch (value) {
      case 0:
        return AidokuMangaContentRating.safe;
      case 1:
        return AidokuMangaContentRating.suggestive;
      case 2:
        return AidokuMangaContentRating.nsfw;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(AidokuMangaContentRating self) {
    switch (self) {
      case AidokuMangaContentRating.safe:
        return 0;
      case AidokuMangaContentRating.suggestive:
        return 1;
      case AidokuMangaContentRating.nsfw:
        return 2;
    }
  }
}

extension AidokuMangaContentRatingMapperExtension on AidokuMangaContentRating {
  dynamic toValue() {
    AidokuMangaContentRatingMapper.ensureInitialized();
    return MapperContainer.globals.toValue<AidokuMangaContentRating>(this);
  }
}

class AidokuMangaViewerMapper extends EnumMapper<AidokuMangaViewer> {
  AidokuMangaViewerMapper._();

  static AidokuMangaViewerMapper? _instance;
  static AidokuMangaViewerMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AidokuMangaViewerMapper._());
    }
    return _instance!;
  }

  static AidokuMangaViewer fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  AidokuMangaViewer decode(dynamic value) {
    switch (value) {
      case 0:
        return AidokuMangaViewer.defaultViewer;
      case 1:
        return AidokuMangaViewer.rtl;
      case 2:
        return AidokuMangaViewer.ltr;
      case 3:
        return AidokuMangaViewer.vertial;
      case 4:
        return AidokuMangaViewer.scroll;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(AidokuMangaViewer self) {
    switch (self) {
      case AidokuMangaViewer.defaultViewer:
        return 0;
      case AidokuMangaViewer.rtl:
        return 1;
      case AidokuMangaViewer.ltr:
        return 2;
      case AidokuMangaViewer.vertial:
        return 3;
      case AidokuMangaViewer.scroll:
        return 4;
    }
  }
}

extension AidokuMangaViewerMapperExtension on AidokuMangaViewer {
  dynamic toValue() {
    AidokuMangaViewerMapper.ensureInitialized();
    return MapperContainer.globals.toValue<AidokuMangaViewer>(this);
  }
}

class AidokuPublishingStatusMapper extends EnumMapper<AidokuPublishingStatus> {
  AidokuPublishingStatusMapper._();

  static AidokuPublishingStatusMapper? _instance;
  static AidokuPublishingStatusMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AidokuPublishingStatusMapper._());
    }
    return _instance!;
  }

  static AidokuPublishingStatus fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  AidokuPublishingStatus decode(dynamic value) {
    switch (value) {
      case 0:
        return AidokuPublishingStatus.unknown;
      case 1:
        return AidokuPublishingStatus.ongoing;
      case 2:
        return AidokuPublishingStatus.completed;
      case 3:
        return AidokuPublishingStatus.cancelled;
      case 4:
        return AidokuPublishingStatus.hiatus;
      case 5:
        return AidokuPublishingStatus.notPublished;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(AidokuPublishingStatus self) {
    switch (self) {
      case AidokuPublishingStatus.unknown:
        return 0;
      case AidokuPublishingStatus.ongoing:
        return 1;
      case AidokuPublishingStatus.completed:
        return 2;
      case AidokuPublishingStatus.cancelled:
        return 3;
      case AidokuPublishingStatus.hiatus:
        return 4;
      case AidokuPublishingStatus.notPublished:
        return 5;
    }
  }
}

extension AidokuPublishingStatusMapperExtension on AidokuPublishingStatus {
  dynamic toValue() {
    AidokuPublishingStatusMapper.ensureInitialized();
    return MapperContainer.globals.toValue<AidokuPublishingStatus>(this);
  }
}
