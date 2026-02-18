// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'mangayomi_backup_settings.dart';

class SectionTypeMapper extends EnumMapper<SectionType> {
  SectionTypeMapper._();

  static SectionTypeMapper? _instance;
  static SectionTypeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SectionTypeMapper._());
    }
    return _instance!;
  }

  static SectionType fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  SectionType decode(dynamic value) {
    switch (value) {
      case 0:
        return SectionType.all;
      case 1:
        return SectionType.anime;
      case 2:
        return SectionType.manga;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(SectionType self) {
    switch (self) {
      case SectionType.all:
        return 0;
      case SectionType.anime:
        return 1;
      case SectionType.manga:
        return 2;
    }
  }
}

extension SectionTypeMapperExtension on SectionType {
  dynamic toValue() {
    SectionTypeMapper.ensureInitialized();
    return MapperContainer.globals.toValue<SectionType>(this);
  }
}

class DisplayTypeMapper extends EnumMapper<DisplayType> {
  DisplayTypeMapper._();

  static DisplayTypeMapper? _instance;
  static DisplayTypeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DisplayTypeMapper._());
    }
    return _instance!;
  }

  static DisplayType fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  DisplayType decode(dynamic value) {
    switch (value) {
      case 0:
        return DisplayType.compactGrid;
      case 1:
        return DisplayType.comfortableGrid;
      case 2:
        return DisplayType.coverOnlyGrid;
      case 3:
        return DisplayType.list;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(DisplayType self) {
    switch (self) {
      case DisplayType.compactGrid:
        return 0;
      case DisplayType.comfortableGrid:
        return 1;
      case DisplayType.coverOnlyGrid:
        return 2;
      case DisplayType.list:
        return 3;
    }
  }
}

extension DisplayTypeMapperExtension on DisplayType {
  dynamic toValue() {
    DisplayTypeMapper.ensureInitialized();
    return MapperContainer.globals.toValue<DisplayType>(this);
  }
}

class ScaleTypeMapper extends EnumMapper<ScaleType> {
  ScaleTypeMapper._();

  static ScaleTypeMapper? _instance;
  static ScaleTypeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ScaleTypeMapper._());
    }
    return _instance!;
  }

  static ScaleType fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  ScaleType decode(dynamic value) {
    switch (value) {
      case 0:
        return ScaleType.fitScreen;
      case 1:
        return ScaleType.stretch;
      case 2:
        return ScaleType.fitWidth;
      case 3:
        return ScaleType.fitHeight;
      case 4:
        return ScaleType.originalSize;
      case 5:
        return ScaleType.smartFit;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(ScaleType self) {
    switch (self) {
      case ScaleType.fitScreen:
        return 0;
      case ScaleType.stretch:
        return 1;
      case ScaleType.fitWidth:
        return 2;
      case ScaleType.fitHeight:
        return 3;
      case ScaleType.originalSize:
        return 4;
      case ScaleType.smartFit:
        return 5;
    }
  }
}

extension ScaleTypeMapperExtension on ScaleType {
  dynamic toValue() {
    ScaleTypeMapper.ensureInitialized();
    return MapperContainer.globals.toValue<ScaleType>(this);
  }
}

class BackgroundColorMapper extends EnumMapper<BackgroundColor> {
  BackgroundColorMapper._();

  static BackgroundColorMapper? _instance;
  static BackgroundColorMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = BackgroundColorMapper._());
    }
    return _instance!;
  }

  static BackgroundColor fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  BackgroundColor decode(dynamic value) {
    switch (value) {
      case 0:
        return BackgroundColor.black;
      case 1:
        return BackgroundColor.grey;
      case 2:
        return BackgroundColor.white;
      case 3:
        return BackgroundColor.automatic;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(BackgroundColor self) {
    switch (self) {
      case BackgroundColor.black:
        return 0;
      case BackgroundColor.grey:
        return 1;
      case BackgroundColor.white:
        return 2;
      case BackgroundColor.automatic:
        return 3;
    }
  }
}

extension BackgroundColorMapperExtension on BackgroundColor {
  dynamic toValue() {
    BackgroundColorMapper.ensureInitialized();
    return MapperContainer.globals.toValue<BackgroundColor>(this);
  }
}

class ReaderModeMapper extends EnumMapper<ReaderMode> {
  ReaderModeMapper._();

  static ReaderModeMapper? _instance;
  static ReaderModeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ReaderModeMapper._());
    }
    return _instance!;
  }

  static ReaderMode fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  ReaderMode decode(dynamic value) {
    switch (value) {
      case 0:
        return ReaderMode.vertical;
      case 1:
        return ReaderMode.ltr;
      case 2:
        return ReaderMode.rtl;
      case 3:
        return ReaderMode.verticalContinuous;
      case 4:
        return ReaderMode.webtoon;
      case 5:
        return ReaderMode.horizontalContinuous;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(ReaderMode self) {
    switch (self) {
      case ReaderMode.vertical:
        return 0;
      case ReaderMode.ltr:
        return 1;
      case ReaderMode.rtl:
        return 2;
      case ReaderMode.verticalContinuous:
        return 3;
      case ReaderMode.webtoon:
        return 4;
      case ReaderMode.horizontalContinuous:
        return 5;
    }
  }
}

extension ReaderModeMapperExtension on ReaderMode {
  dynamic toValue() {
    ReaderModeMapper.ensureInitialized();
    return MapperContainer.globals.toValue<ReaderMode>(this);
  }
}

class NovelTextAlignMapper extends EnumMapper<NovelTextAlign> {
  NovelTextAlignMapper._();

  static NovelTextAlignMapper? _instance;
  static NovelTextAlignMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = NovelTextAlignMapper._());
    }
    return _instance!;
  }

  static NovelTextAlign fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  NovelTextAlign decode(dynamic value) {
    switch (value) {
      case 0:
        return NovelTextAlign.left;
      case 1:
        return NovelTextAlign.center;
      case 2:
        return NovelTextAlign.right;
      case 3:
        return NovelTextAlign.block;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(NovelTextAlign self) {
    switch (self) {
      case NovelTextAlign.left:
        return 0;
      case NovelTextAlign.center:
        return 1;
      case NovelTextAlign.right:
        return 2;
      case NovelTextAlign.block:
        return 3;
    }
  }
}

extension NovelTextAlignMapperExtension on NovelTextAlign {
  dynamic toValue() {
    NovelTextAlignMapper.ensureInitialized();
    return MapperContainer.globals.toValue<NovelTextAlign>(this);
  }
}

class PageModeMapper extends EnumMapper<PageMode> {
  PageModeMapper._();

  static PageModeMapper? _instance;
  static PageModeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PageModeMapper._());
    }
    return _instance!;
  }

  static PageMode fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  PageMode decode(dynamic value) {
    switch (value) {
      case 0:
        return PageMode.onePage;
      case 1:
        return PageMode.doublePage;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(PageMode self) {
    switch (self) {
      case PageMode.onePage:
        return 0;
      case PageMode.doublePage:
        return 1;
    }
  }
}

extension PageModeMapperExtension on PageMode {
  dynamic toValue() {
    PageModeMapper.ensureInitialized();
    return MapperContainer.globals.toValue<PageMode>(this);
  }
}

class ColorFilterBlendModeMapper extends EnumMapper<ColorFilterBlendMode> {
  ColorFilterBlendModeMapper._();

  static ColorFilterBlendModeMapper? _instance;
  static ColorFilterBlendModeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ColorFilterBlendModeMapper._());
    }
    return _instance!;
  }

  static ColorFilterBlendMode fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  ColorFilterBlendMode decode(dynamic value) {
    switch (value) {
      case 0:
        return ColorFilterBlendMode.none;
      case 1:
        return ColorFilterBlendMode.multiply;
      case 2:
        return ColorFilterBlendMode.screen;
      case 3:
        return ColorFilterBlendMode.overlay;
      case 4:
        return ColorFilterBlendMode.colorDodge;
      case 5:
        return ColorFilterBlendMode.lighten;
      case 6:
        return ColorFilterBlendMode.colorBurn;
      case 7:
        return ColorFilterBlendMode.darken;
      case 8:
        return ColorFilterBlendMode.difference;
      case 9:
        return ColorFilterBlendMode.saturation;
      case 10:
        return ColorFilterBlendMode.softLight;
      case 11:
        return ColorFilterBlendMode.plus;
      case 12:
        return ColorFilterBlendMode.exclusion;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(ColorFilterBlendMode self) {
    switch (self) {
      case ColorFilterBlendMode.none:
        return 0;
      case ColorFilterBlendMode.multiply:
        return 1;
      case ColorFilterBlendMode.screen:
        return 2;
      case ColorFilterBlendMode.overlay:
        return 3;
      case ColorFilterBlendMode.colorDodge:
        return 4;
      case ColorFilterBlendMode.lighten:
        return 5;
      case ColorFilterBlendMode.colorBurn:
        return 6;
      case ColorFilterBlendMode.darken:
        return 7;
      case ColorFilterBlendMode.difference:
        return 8;
      case ColorFilterBlendMode.saturation:
        return 9;
      case ColorFilterBlendMode.softLight:
        return 10;
      case ColorFilterBlendMode.plus:
        return 11;
      case ColorFilterBlendMode.exclusion:
        return 12;
    }
  }
}

extension ColorFilterBlendModeMapperExtension on ColorFilterBlendMode {
  dynamic toValue() {
    ColorFilterBlendModeMapper.ensureInitialized();
    return MapperContainer.globals.toValue<ColorFilterBlendMode>(this);
  }
}

class MangayomiBackupSettingsMapper
    extends ClassMapperBase<MangayomiBackupSettings> {
  MangayomiBackupSettingsMapper._();

  static MangayomiBackupSettingsMapper? _instance;
  static MangayomiBackupSettingsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = MangayomiBackupSettingsMapper._(),
      );
      MapperContainer.globals.useAll([SecondsEpochDateTimeMapper()]);
      DisplayTypeMapper.ensureInitialized();
      SortLibraryMangaMapper.ensureInitialized();
      SortChapterMapper.ensureInitialized();
      ChapterFilterDownloadedMapper.ensureInitialized();
      ChapterPageurlsMapper.ensureInitialized();
      ChapterPageIndexMapper.ensureInitialized();
      MCookieMapper.ensureInitialized();
      ReaderModeMapper.ensureInitialized();
      PersonalReaderModeMapper.ensureInitialized();
      ScaleTypeMapper.ensureInitialized();
      BackgroundColorMapper.ensureInitialized();
      PersonalPageModeMapper.ensureInitialized();
      AutoScrollPagesMapper.ensureInitialized();
      CustomColorFilterMapper.ensureInitialized();
      ColorFilterBlendModeMapper.ensureInitialized();
      PlayerSubtitleSettingsMapper.ensureInitialized();
      SectionTypeMapper.ensureInitialized();
      NovelTextAlignMapper.ensureInitialized();
      RepoMapper.ensureInitialized();
      ChapterFilterUnreadMapper.ensureInitialized();
      ChapterFilterBookmarkedMapper.ensureInitialized();
      FilterScanlatorMapper.ensureInitialized();
      L10nLocaleMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MangayomiBackupSettings';

  static int? _$id(MangayomiBackupSettings v) => v.id;
  static const Field<MangayomiBackupSettings, int> _f$id = Field(
    'id',
    _$id,
    opt: true,
    def: 227,
  );
  static DisplayType _$displayType(MangayomiBackupSettings v) => v.displayType;
  static const Field<MangayomiBackupSettings, DisplayType> _f$displayType =
      Field(
        'displayType',
        _$displayType,
        opt: true,
        def: DisplayType.compactGrid,
      );
  static int? _$libraryFilterMangasDownloadType(MangayomiBackupSettings v) =>
      v.libraryFilterMangasDownloadType;
  static const Field<MangayomiBackupSettings, int>
  _f$libraryFilterMangasDownloadType = Field(
    'libraryFilterMangasDownloadType',
    _$libraryFilterMangasDownloadType,
    opt: true,
    def: 0,
  );
  static int? _$libraryFilterMangasUnreadType(MangayomiBackupSettings v) =>
      v.libraryFilterMangasUnreadType;
  static const Field<MangayomiBackupSettings, int>
  _f$libraryFilterMangasUnreadType = Field(
    'libraryFilterMangasUnreadType',
    _$libraryFilterMangasUnreadType,
    opt: true,
    def: 0,
  );
  static int? _$libraryFilterMangasStartedType(MangayomiBackupSettings v) =>
      v.libraryFilterMangasStartedType;
  static const Field<MangayomiBackupSettings, int>
  _f$libraryFilterMangasStartedType = Field(
    'libraryFilterMangasStartedType',
    _$libraryFilterMangasStartedType,
    opt: true,
    def: 0,
  );
  static int? _$libraryFilterMangasBookMarkedType(MangayomiBackupSettings v) =>
      v.libraryFilterMangasBookMarkedType;
  static const Field<MangayomiBackupSettings, int>
  _f$libraryFilterMangasBookMarkedType = Field(
    'libraryFilterMangasBookMarkedType',
    _$libraryFilterMangasBookMarkedType,
    opt: true,
    def: 0,
  );
  static bool? _$libraryShowCategoryTabs(MangayomiBackupSettings v) =>
      v.libraryShowCategoryTabs;
  static const Field<MangayomiBackupSettings, bool> _f$libraryShowCategoryTabs =
      Field(
        'libraryShowCategoryTabs',
        _$libraryShowCategoryTabs,
        opt: true,
        def: false,
      );
  static bool? _$libraryDownloadedChapters(MangayomiBackupSettings v) =>
      v.libraryDownloadedChapters;
  static const Field<MangayomiBackupSettings, bool>
  _f$libraryDownloadedChapters = Field(
    'libraryDownloadedChapters',
    _$libraryDownloadedChapters,
    opt: true,
    def: false,
  );
  static bool? _$libraryShowLanguage(MangayomiBackupSettings v) =>
      v.libraryShowLanguage;
  static const Field<MangayomiBackupSettings, bool> _f$libraryShowLanguage =
      Field(
        'libraryShowLanguage',
        _$libraryShowLanguage,
        opt: true,
        def: false,
      );
  static bool? _$libraryShowNumbersOfItems(MangayomiBackupSettings v) =>
      v.libraryShowNumbersOfItems;
  static const Field<MangayomiBackupSettings, bool>
  _f$libraryShowNumbersOfItems = Field(
    'libraryShowNumbersOfItems',
    _$libraryShowNumbersOfItems,
    opt: true,
    def: false,
  );
  static bool? _$libraryShowContinueReadingButton(MangayomiBackupSettings v) =>
      v.libraryShowContinueReadingButton;
  static const Field<MangayomiBackupSettings, bool>
  _f$libraryShowContinueReadingButton = Field(
    'libraryShowContinueReadingButton',
    _$libraryShowContinueReadingButton,
    opt: true,
    def: false,
  );
  static SortLibraryManga? _$sortLibraryManga(MangayomiBackupSettings v) =>
      v.sortLibraryManga;
  static const Field<MangayomiBackupSettings, SortLibraryManga>
  _f$sortLibraryManga = Field(
    'sortLibraryManga',
    _$sortLibraryManga,
    opt: true,
  );
  static List<SortChapter>? _$sortChapterList(MangayomiBackupSettings v) =>
      v.sortChapterList;
  static const Field<MangayomiBackupSettings, List<SortChapter>>
  _f$sortChapterList = Field('sortChapterList', _$sortChapterList, opt: true);
  static List<ChapterFilterDownloaded>? _$chapterFilterDownloadedList(
    MangayomiBackupSettings v,
  ) => v.chapterFilterDownloadedList;
  static const Field<MangayomiBackupSettings, List<ChapterFilterDownloaded>>
  _f$chapterFilterDownloadedList = Field(
    'chapterFilterDownloadedList',
    _$chapterFilterDownloadedList,
    opt: true,
  );
  static double? _$flexColorSchemeBlendLevel(MangayomiBackupSettings v) =>
      v.flexColorSchemeBlendLevel;
  static const Field<MangayomiBackupSettings, double>
  _f$flexColorSchemeBlendLevel = Field(
    'flexColorSchemeBlendLevel',
    _$flexColorSchemeBlendLevel,
    opt: true,
    def: 10.0,
  );
  static String? _$dateFormat(MangayomiBackupSettings v) => v.dateFormat;
  static const Field<MangayomiBackupSettings, String> _f$dateFormat = Field(
    'dateFormat',
    _$dateFormat,
    opt: true,
    def: 'M/d/y',
  );
  static int? _$relativeTimesTamps(MangayomiBackupSettings v) =>
      v.relativeTimesTamps;
  static const Field<MangayomiBackupSettings, int> _f$relativeTimesTamps =
      Field('relativeTimesTamps', _$relativeTimesTamps, opt: true, def: 2);
  static int? _$flexSchemeColorIndex(MangayomiBackupSettings v) =>
      v.flexSchemeColorIndex;
  static const Field<MangayomiBackupSettings, int> _f$flexSchemeColorIndex =
      Field('flexSchemeColorIndex', _$flexSchemeColorIndex, opt: true, def: 2);
  static bool? _$themeIsDark(MangayomiBackupSettings v) => v.themeIsDark;
  static const Field<MangayomiBackupSettings, bool> _f$themeIsDark = Field(
    'themeIsDark',
    _$themeIsDark,
    opt: true,
    def: false,
  );
  static bool? _$followSystemTheme(MangayomiBackupSettings v) =>
      v.followSystemTheme;
  static const Field<MangayomiBackupSettings, bool> _f$followSystemTheme =
      Field('followSystemTheme', _$followSystemTheme, opt: true, def: false);
  static bool? _$incognitoMode(MangayomiBackupSettings v) => v.incognitoMode;
  static const Field<MangayomiBackupSettings, bool> _f$incognitoMode = Field(
    'incognitoMode',
    _$incognitoMode,
    opt: true,
    def: false,
  );
  static List<ChapterPageurls>? _$chapterPageUrlsList(
    MangayomiBackupSettings v,
  ) => v.chapterPageUrlsList;
  static const Field<MangayomiBackupSettings, List<ChapterPageurls>>
  _f$chapterPageUrlsList = Field(
    'chapterPageUrlsList',
    _$chapterPageUrlsList,
    opt: true,
  );
  static bool? _$showPagesNumber(MangayomiBackupSettings v) =>
      v.showPagesNumber;
  static const Field<MangayomiBackupSettings, bool> _f$showPagesNumber = Field(
    'showPagesNumber',
    _$showPagesNumber,
    opt: true,
    def: true,
  );
  static List<ChapterPageIndex>? _$chapterPageIndexList(
    MangayomiBackupSettings v,
  ) => v.chapterPageIndexList;
  static const Field<MangayomiBackupSettings, List<ChapterPageIndex>>
  _f$chapterPageIndexList = Field(
    'chapterPageIndexList',
    _$chapterPageIndexList,
    opt: true,
  );
  static String? _$userAgent(MangayomiBackupSettings v) => v.userAgent;
  static const Field<MangayomiBackupSettings, String> _f$userAgent = Field(
    'userAgent',
    _$userAgent,
    opt: true,
    def: _defaultUserAgent,
  );
  static List<MCookie>? _$cookiesList(MangayomiBackupSettings v) =>
      v.cookiesList;
  static const Field<MangayomiBackupSettings, List<MCookie>> _f$cookiesList =
      Field('cookiesList', _$cookiesList, opt: true);
  static ReaderMode _$defaultReaderMode(MangayomiBackupSettings v) =>
      v.defaultReaderMode;
  static const Field<MangayomiBackupSettings, ReaderMode> _f$defaultReaderMode =
      Field(
        'defaultReaderMode',
        _$defaultReaderMode,
        opt: true,
        def: ReaderMode.vertical,
      );
  static List<PersonalReaderMode>? _$personalReaderModeList(
    MangayomiBackupSettings v,
  ) => v.personalReaderModeList;
  static const Field<MangayomiBackupSettings, List<PersonalReaderMode>>
  _f$personalReaderModeList = Field(
    'personalReaderModeList',
    _$personalReaderModeList,
    opt: true,
  );
  static bool? _$animatePageTransitions(MangayomiBackupSettings v) =>
      v.animatePageTransitions;
  static const Field<MangayomiBackupSettings, bool> _f$animatePageTransitions =
      Field(
        'animatePageTransitions',
        _$animatePageTransitions,
        opt: true,
        def: true,
      );
  static int? _$doubleTapAnimationSpeed(MangayomiBackupSettings v) =>
      v.doubleTapAnimationSpeed;
  static const Field<MangayomiBackupSettings, int> _f$doubleTapAnimationSpeed =
      Field(
        'doubleTapAnimationSpeed',
        _$doubleTapAnimationSpeed,
        opt: true,
        def: 1,
      );
  static bool? _$onlyIncludePinnedSources(MangayomiBackupSettings v) =>
      v.onlyIncludePinnedSources;
  static const Field<MangayomiBackupSettings, bool>
  _f$onlyIncludePinnedSources = Field(
    'onlyIncludePinnedSources',
    _$onlyIncludePinnedSources,
    opt: true,
    def: false,
  );
  static bool? _$pureBlackDarkMode(MangayomiBackupSettings v) =>
      v.pureBlackDarkMode;
  static const Field<MangayomiBackupSettings, bool> _f$pureBlackDarkMode =
      Field('pureBlackDarkMode', _$pureBlackDarkMode, opt: true, def: false);
  static bool? _$downloadOnlyOnWifi(MangayomiBackupSettings v) =>
      v.downloadOnlyOnWifi;
  static const Field<MangayomiBackupSettings, bool> _f$downloadOnlyOnWifi =
      Field('downloadOnlyOnWifi', _$downloadOnlyOnWifi, opt: true, def: false);
  static bool? _$saveAsCBZArchive(MangayomiBackupSettings v) =>
      v.saveAsCBZArchive;
  static const Field<MangayomiBackupSettings, bool> _f$saveAsCBZArchive = Field(
    'saveAsCBZArchive',
    _$saveAsCBZArchive,
    key: r'saveAsCbzarchive',
    opt: true,
    def: false,
  );
  static String? _$downloadLocation(MangayomiBackupSettings v) =>
      v.downloadLocation;
  static const Field<MangayomiBackupSettings, String> _f$downloadLocation =
      Field('downloadLocation', _$downloadLocation, opt: true, def: '');
  static bool? _$cropBorders(MangayomiBackupSettings v) => v.cropBorders;
  static const Field<MangayomiBackupSettings, bool> _f$cropBorders = Field(
    'cropBorders',
    _$cropBorders,
    opt: true,
    def: false,
  );
  static bool? _$libraryLocalSource(MangayomiBackupSettings v) =>
      v.libraryLocalSource;
  static const Field<MangayomiBackupSettings, bool> _f$libraryLocalSource =
      Field('libraryLocalSource', _$libraryLocalSource, opt: true);
  static bool? _$autoExtensionsUpdates(MangayomiBackupSettings v) =>
      v.autoExtensionsUpdates;
  static const Field<MangayomiBackupSettings, bool> _f$autoExtensionsUpdates =
      Field(
        'autoExtensionsUpdates',
        _$autoExtensionsUpdates,
        opt: true,
        def: false,
      );
  static DisplayType _$animeDisplayType(MangayomiBackupSettings v) =>
      v.animeDisplayType;
  static const Field<MangayomiBackupSettings, DisplayType> _f$animeDisplayType =
      Field(
        'animeDisplayType',
        _$animeDisplayType,
        opt: true,
        def: DisplayType.compactGrid,
      );
  static int? _$libraryFilterAnimeDownloadType(MangayomiBackupSettings v) =>
      v.libraryFilterAnimeDownloadType;
  static const Field<MangayomiBackupSettings, int>
  _f$libraryFilterAnimeDownloadType = Field(
    'libraryFilterAnimeDownloadType',
    _$libraryFilterAnimeDownloadType,
    opt: true,
    def: 0,
  );
  static int? _$libraryFilterAnimeUnreadType(MangayomiBackupSettings v) =>
      v.libraryFilterAnimeUnreadType;
  static const Field<MangayomiBackupSettings, int>
  _f$libraryFilterAnimeUnreadType = Field(
    'libraryFilterAnimeUnreadType',
    _$libraryFilterAnimeUnreadType,
    opt: true,
    def: 0,
  );
  static int? _$libraryFilterAnimeStartedType(MangayomiBackupSettings v) =>
      v.libraryFilterAnimeStartedType;
  static const Field<MangayomiBackupSettings, int>
  _f$libraryFilterAnimeStartedType = Field(
    'libraryFilterAnimeStartedType',
    _$libraryFilterAnimeStartedType,
    opt: true,
    def: 0,
  );
  static int? _$libraryFilterAnimeBookMarkedType(MangayomiBackupSettings v) =>
      v.libraryFilterAnimeBookMarkedType;
  static const Field<MangayomiBackupSettings, int>
  _f$libraryFilterAnimeBookMarkedType = Field(
    'libraryFilterAnimeBookMarkedType',
    _$libraryFilterAnimeBookMarkedType,
    opt: true,
    def: 0,
  );
  static bool? _$animeLibraryShowCategoryTabs(MangayomiBackupSettings v) =>
      v.animeLibraryShowCategoryTabs;
  static const Field<MangayomiBackupSettings, bool>
  _f$animeLibraryShowCategoryTabs = Field(
    'animeLibraryShowCategoryTabs',
    _$animeLibraryShowCategoryTabs,
    opt: true,
    def: false,
  );
  static bool? _$animeLibraryDownloadedChapters(MangayomiBackupSettings v) =>
      v.animeLibraryDownloadedChapters;
  static const Field<MangayomiBackupSettings, bool>
  _f$animeLibraryDownloadedChapters = Field(
    'animeLibraryDownloadedChapters',
    _$animeLibraryDownloadedChapters,
    opt: true,
    def: false,
  );
  static bool? _$animeLibraryShowLanguage(MangayomiBackupSettings v) =>
      v.animeLibraryShowLanguage;
  static const Field<MangayomiBackupSettings, bool>
  _f$animeLibraryShowLanguage = Field(
    'animeLibraryShowLanguage',
    _$animeLibraryShowLanguage,
    opt: true,
    def: false,
  );
  static bool? _$animeLibraryShowNumbersOfItems(MangayomiBackupSettings v) =>
      v.animeLibraryShowNumbersOfItems;
  static const Field<MangayomiBackupSettings, bool>
  _f$animeLibraryShowNumbersOfItems = Field(
    'animeLibraryShowNumbersOfItems',
    _$animeLibraryShowNumbersOfItems,
    opt: true,
    def: false,
  );
  static bool? _$animeLibraryShowContinueReadingButton(
    MangayomiBackupSettings v,
  ) => v.animeLibraryShowContinueReadingButton;
  static const Field<MangayomiBackupSettings, bool>
  _f$animeLibraryShowContinueReadingButton = Field(
    'animeLibraryShowContinueReadingButton',
    _$animeLibraryShowContinueReadingButton,
    opt: true,
    def: false,
  );
  static bool? _$animeLibraryLocalSource(MangayomiBackupSettings v) =>
      v.animeLibraryLocalSource;
  static const Field<MangayomiBackupSettings, bool> _f$animeLibraryLocalSource =
      Field('animeLibraryLocalSource', _$animeLibraryLocalSource, opt: true);
  static SortLibraryManga? _$sortLibraryAnime(MangayomiBackupSettings v) =>
      v.sortLibraryAnime;
  static const Field<MangayomiBackupSettings, SortLibraryManga>
  _f$sortLibraryAnime = Field(
    'sortLibraryAnime',
    _$sortLibraryAnime,
    opt: true,
  );
  static int? _$pagePreloadAmount(MangayomiBackupSettings v) =>
      v.pagePreloadAmount;
  static const Field<MangayomiBackupSettings, int> _f$pagePreloadAmount = Field(
    'pagePreloadAmount',
    _$pagePreloadAmount,
    opt: true,
    def: 6,
  );
  static ScaleType _$scaleType(MangayomiBackupSettings v) => v.scaleType;
  static const Field<MangayomiBackupSettings, ScaleType> _f$scaleType = Field(
    'scaleType',
    _$scaleType,
    opt: true,
    def: ScaleType.fitScreen,
  );
  static bool? _$checkForExtensionUpdates(MangayomiBackupSettings v) =>
      v.checkForExtensionUpdates;
  static const Field<MangayomiBackupSettings, bool>
  _f$checkForExtensionUpdates = Field(
    'checkForExtensionUpdates',
    _$checkForExtensionUpdates,
    opt: true,
    def: true,
  );
  static BackgroundColor _$backgroundColor(MangayomiBackupSettings v) =>
      v.backgroundColor;
  static const Field<MangayomiBackupSettings, BackgroundColor>
  _f$backgroundColor = Field(
    'backgroundColor',
    _$backgroundColor,
    opt: true,
    def: BackgroundColor.black,
  );
  static List<PersonalPageMode>? _$personalPageModeList(
    MangayomiBackupSettings v,
  ) => v.personalPageModeList;
  static const Field<MangayomiBackupSettings, List<PersonalPageMode>>
  _f$personalPageModeList = Field(
    'personalPageModeList',
    _$personalPageModeList,
    opt: true,
  );
  static int? _$backupFrequency(MangayomiBackupSettings v) => v.backupFrequency;
  static const Field<MangayomiBackupSettings, int> _f$backupFrequency = Field(
    'backupFrequency',
    _$backupFrequency,
    opt: true,
  );
  static List<int>? _$backupListOptions(MangayomiBackupSettings v) =>
      v.backupListOptions;
  static const Field<MangayomiBackupSettings, List<int>> _f$backupListOptions =
      Field('backupListOptions', _$backupListOptions, opt: true);
  static String? _$autoBackupLocation(MangayomiBackupSettings v) =>
      v.autoBackupLocation;
  static const Field<MangayomiBackupSettings, String> _f$autoBackupLocation =
      Field('autoBackupLocation', _$autoBackupLocation, opt: true);
  static int? _$startDatebackup(MangayomiBackupSettings v) => v.startDatebackup;
  static const Field<MangayomiBackupSettings, int> _f$startDatebackup = Field(
    'startDatebackup',
    _$startDatebackup,
    opt: true,
  );
  static bool? _$usePageTapZones(MangayomiBackupSettings v) =>
      v.usePageTapZones;
  static const Field<MangayomiBackupSettings, bool> _f$usePageTapZones = Field(
    'usePageTapZones',
    _$usePageTapZones,
    opt: true,
    def: true,
  );
  static List<AutoScrollPages>? _$autoScrollPages(MangayomiBackupSettings v) =>
      v.autoScrollPages;
  static const Field<MangayomiBackupSettings, List<AutoScrollPages>>
  _f$autoScrollPages = Field('autoScrollPages', _$autoScrollPages, opt: true);
  static int? _$markEpisodeAsSeenType(MangayomiBackupSettings v) =>
      v.markEpisodeAsSeenType;
  static const Field<MangayomiBackupSettings, int> _f$markEpisodeAsSeenType =
      Field(
        'markEpisodeAsSeenType',
        _$markEpisodeAsSeenType,
        opt: true,
        def: 85,
      );
  static int? _$defaultSkipIntroLength(MangayomiBackupSettings v) =>
      v.defaultSkipIntroLength;
  static const Field<MangayomiBackupSettings, int> _f$defaultSkipIntroLength =
      Field(
        'defaultSkipIntroLength',
        _$defaultSkipIntroLength,
        opt: true,
        def: 85,
      );
  static int? _$defaultDoubleTapToSkipLength(MangayomiBackupSettings v) =>
      v.defaultDoubleTapToSkipLength;
  static const Field<MangayomiBackupSettings, int>
  _f$defaultDoubleTapToSkipLength = Field(
    'defaultDoubleTapToSkipLength',
    _$defaultDoubleTapToSkipLength,
    opt: true,
    def: 10,
  );
  static double? _$defaultPlayBackSpeed(MangayomiBackupSettings v) =>
      v.defaultPlayBackSpeed;
  static const Field<MangayomiBackupSettings, double> _f$defaultPlayBackSpeed =
      Field(
        'defaultPlayBackSpeed',
        _$defaultPlayBackSpeed,
        opt: true,
        def: 1.0,
      );
  static bool? _$fullScreenPlayer(MangayomiBackupSettings v) =>
      v.fullScreenPlayer;
  static const Field<MangayomiBackupSettings, bool> _f$fullScreenPlayer = Field(
    'fullScreenPlayer',
    _$fullScreenPlayer,
    opt: true,
    def: false,
  );
  static bool? _$updateProgressAfterReading(MangayomiBackupSettings v) =>
      v.updateProgressAfterReading;
  static const Field<MangayomiBackupSettings, bool>
  _f$updateProgressAfterReading = Field(
    'updateProgressAfterReading',
    _$updateProgressAfterReading,
    opt: true,
    def: true,
  );
  static bool? _$enableAniSkip(MangayomiBackupSettings v) => v.enableAniSkip;
  static const Field<MangayomiBackupSettings, bool> _f$enableAniSkip = Field(
    'enableAniSkip',
    _$enableAniSkip,
    opt: true,
  );
  static bool? _$enableAutoSkip(MangayomiBackupSettings v) => v.enableAutoSkip;
  static const Field<MangayomiBackupSettings, bool> _f$enableAutoSkip = Field(
    'enableAutoSkip',
    _$enableAutoSkip,
    opt: true,
  );
  static int? _$aniSkipTimeoutLength(MangayomiBackupSettings v) =>
      v.aniSkipTimeoutLength;
  static const Field<MangayomiBackupSettings, int> _f$aniSkipTimeoutLength =
      Field('aniSkipTimeoutLength', _$aniSkipTimeoutLength, opt: true);
  static String? _$btServerAddress(MangayomiBackupSettings v) =>
      v.btServerAddress;
  static const Field<MangayomiBackupSettings, String> _f$btServerAddress =
      Field('btServerAddress', _$btServerAddress, opt: true, def: '127.0.0.1');
  static int? _$btServerPort(MangayomiBackupSettings v) => v.btServerPort;
  static const Field<MangayomiBackupSettings, int> _f$btServerPort = Field(
    'btServerPort',
    _$btServerPort,
    opt: true,
  );
  static bool? _$fullScreenReader(MangayomiBackupSettings v) =>
      v.fullScreenReader;
  static const Field<MangayomiBackupSettings, bool> _f$fullScreenReader = Field(
    'fullScreenReader',
    _$fullScreenReader,
    opt: true,
    def: true,
  );
  static bool? _$enableCustomColorFilter(MangayomiBackupSettings v) =>
      v.enableCustomColorFilter;
  static const Field<MangayomiBackupSettings, bool> _f$enableCustomColorFilter =
      Field(
        'enableCustomColorFilter',
        _$enableCustomColorFilter,
        opt: true,
        def: false,
      );
  static CustomColorFilter? _$customColorFilter(MangayomiBackupSettings v) =>
      v.customColorFilter;
  static const Field<MangayomiBackupSettings, CustomColorFilter>
  _f$customColorFilter = Field(
    'customColorFilter',
    _$customColorFilter,
    opt: true,
  );
  static ColorFilterBlendMode _$colorFilterBlendMode(
    MangayomiBackupSettings v,
  ) => v.colorFilterBlendMode;
  static const Field<MangayomiBackupSettings, ColorFilterBlendMode>
  _f$colorFilterBlendMode = Field(
    'colorFilterBlendMode',
    _$colorFilterBlendMode,
    opt: true,
    def: ColorFilterBlendMode.none,
  );
  static PlayerSubtitleSettings? _$playerSubtitleSettings(
    MangayomiBackupSettings v,
  ) => v.playerSubtitleSettings;
  static const Field<MangayomiBackupSettings, PlayerSubtitleSettings>
  _f$playerSubtitleSettings = Field(
    'playerSubtitleSettings',
    _$playerSubtitleSettings,
    opt: true,
  );
  static DisplayType _$mangaHomeDisplayType(MangayomiBackupSettings v) =>
      v.mangaHomeDisplayType;
  static const Field<MangayomiBackupSettings, DisplayType>
  _f$mangaHomeDisplayType = Field(
    'mangaHomeDisplayType',
    _$mangaHomeDisplayType,
    opt: true,
    def: DisplayType.comfortableGrid,
  );
  static String? _$appFontFamily(MangayomiBackupSettings v) => v.appFontFamily;
  static const Field<MangayomiBackupSettings, String> _f$appFontFamily = Field(
    'appFontFamily',
    _$appFontFamily,
    opt: true,
  );
  static int? _$mangaGridSize(MangayomiBackupSettings v) => v.mangaGridSize;
  static const Field<MangayomiBackupSettings, int> _f$mangaGridSize = Field(
    'mangaGridSize',
    _$mangaGridSize,
    opt: true,
  );
  static int? _$animeGridSize(MangayomiBackupSettings v) => v.animeGridSize;
  static const Field<MangayomiBackupSettings, int> _f$animeGridSize = Field(
    'animeGridSize',
    _$animeGridSize,
    opt: true,
  );
  static SectionType _$disableSectionType(MangayomiBackupSettings v) =>
      v.disableSectionType;
  static const Field<MangayomiBackupSettings, SectionType>
  _f$disableSectionType = Field(
    'disableSectionType',
    _$disableSectionType,
    opt: true,
    def: SectionType.all,
  );
  static bool? _$useLibass(MangayomiBackupSettings v) => v.useLibass;
  static const Field<MangayomiBackupSettings, bool> _f$useLibass = Field(
    'useLibass',
    _$useLibass,
    opt: true,
    def: true,
  );
  static int? _$libraryFilterNovelDownloadType(MangayomiBackupSettings v) =>
      v.libraryFilterNovelDownloadType;
  static const Field<MangayomiBackupSettings, int>
  _f$libraryFilterNovelDownloadType = Field(
    'libraryFilterNovelDownloadType',
    _$libraryFilterNovelDownloadType,
    opt: true,
    def: 0,
  );
  static int? _$libraryFilterNovelUnreadType(MangayomiBackupSettings v) =>
      v.libraryFilterNovelUnreadType;
  static const Field<MangayomiBackupSettings, int>
  _f$libraryFilterNovelUnreadType = Field(
    'libraryFilterNovelUnreadType',
    _$libraryFilterNovelUnreadType,
    opt: true,
    def: 0,
  );
  static int? _$libraryFilterNovelStartedType(MangayomiBackupSettings v) =>
      v.libraryFilterNovelStartedType;
  static const Field<MangayomiBackupSettings, int>
  _f$libraryFilterNovelStartedType = Field(
    'libraryFilterNovelStartedType',
    _$libraryFilterNovelStartedType,
    opt: true,
    def: 0,
  );
  static int? _$libraryFilterNovelBookMarkedType(MangayomiBackupSettings v) =>
      v.libraryFilterNovelBookMarkedType;
  static const Field<MangayomiBackupSettings, int>
  _f$libraryFilterNovelBookMarkedType = Field(
    'libraryFilterNovelBookMarkedType',
    _$libraryFilterNovelBookMarkedType,
    opt: true,
    def: 0,
  );
  static bool? _$novelLibraryShowCategoryTabs(MangayomiBackupSettings v) =>
      v.novelLibraryShowCategoryTabs;
  static const Field<MangayomiBackupSettings, bool>
  _f$novelLibraryShowCategoryTabs = Field(
    'novelLibraryShowCategoryTabs',
    _$novelLibraryShowCategoryTabs,
    opt: true,
    def: false,
  );
  static bool? _$novelLibraryDownloadedChapters(MangayomiBackupSettings v) =>
      v.novelLibraryDownloadedChapters;
  static const Field<MangayomiBackupSettings, bool>
  _f$novelLibraryDownloadedChapters = Field(
    'novelLibraryDownloadedChapters',
    _$novelLibraryDownloadedChapters,
    opt: true,
    def: false,
  );
  static bool? _$novelLibraryShowLanguage(MangayomiBackupSettings v) =>
      v.novelLibraryShowLanguage;
  static const Field<MangayomiBackupSettings, bool>
  _f$novelLibraryShowLanguage = Field(
    'novelLibraryShowLanguage',
    _$novelLibraryShowLanguage,
    opt: true,
    def: false,
  );
  static bool? _$novelLibraryShowNumbersOfItems(MangayomiBackupSettings v) =>
      v.novelLibraryShowNumbersOfItems;
  static const Field<MangayomiBackupSettings, bool>
  _f$novelLibraryShowNumbersOfItems = Field(
    'novelLibraryShowNumbersOfItems',
    _$novelLibraryShowNumbersOfItems,
    opt: true,
    def: false,
  );
  static bool? _$novelLibraryShowContinueReadingButton(
    MangayomiBackupSettings v,
  ) => v.novelLibraryShowContinueReadingButton;
  static const Field<MangayomiBackupSettings, bool>
  _f$novelLibraryShowContinueReadingButton = Field(
    'novelLibraryShowContinueReadingButton',
    _$novelLibraryShowContinueReadingButton,
    opt: true,
    def: false,
  );
  static bool? _$novelLibraryLocalSource(MangayomiBackupSettings v) =>
      v.novelLibraryLocalSource;
  static const Field<MangayomiBackupSettings, bool> _f$novelLibraryLocalSource =
      Field('novelLibraryLocalSource', _$novelLibraryLocalSource, opt: true);
  static SortLibraryManga? _$sortLibraryNovel(MangayomiBackupSettings v) =>
      v.sortLibraryNovel;
  static const Field<MangayomiBackupSettings, SortLibraryManga>
  _f$sortLibraryNovel = Field(
    'sortLibraryNovel',
    _$sortLibraryNovel,
    opt: true,
  );
  static DisplayType _$novelDisplayType(MangayomiBackupSettings v) =>
      v.novelDisplayType;
  static const Field<MangayomiBackupSettings, DisplayType> _f$novelDisplayType =
      Field(
        'novelDisplayType',
        _$novelDisplayType,
        opt: true,
        def: DisplayType.comfortableGrid,
      );
  static int? _$novelFontSize(MangayomiBackupSettings v) => v.novelFontSize;
  static const Field<MangayomiBackupSettings, int> _f$novelFontSize = Field(
    'novelFontSize',
    _$novelFontSize,
    opt: true,
    def: 14,
  );
  static NovelTextAlign _$novelTextAlign(MangayomiBackupSettings v) =>
      v.novelTextAlign;
  static const Field<MangayomiBackupSettings, NovelTextAlign>
  _f$novelTextAlign = Field(
    'novelTextAlign',
    _$novelTextAlign,
    opt: true,
    def: NovelTextAlign.left,
  );
  static List<String>? _$navigationOrder(MangayomiBackupSettings v) =>
      v.navigationOrder;
  static const Field<MangayomiBackupSettings, List<String>> _f$navigationOrder =
      Field('navigationOrder', _$navigationOrder, opt: true);
  static List<String>? _$hideItems(MangayomiBackupSettings v) => v.hideItems;
  static const Field<MangayomiBackupSettings, List<String>> _f$hideItems =
      Field('hideItems', _$hideItems, opt: true);
  static bool? _$clearChapterCacheOnAppLaunch(MangayomiBackupSettings v) =>
      v.clearChapterCacheOnAppLaunch;
  static const Field<MangayomiBackupSettings, bool>
  _f$clearChapterCacheOnAppLaunch = Field(
    'clearChapterCacheOnAppLaunch',
    _$clearChapterCacheOnAppLaunch,
    opt: true,
    def: false,
  );
  static List<Repo>? _$mangaExtensionsRepo(MangayomiBackupSettings v) =>
      v.mangaExtensionsRepo;
  static const Field<MangayomiBackupSettings, List<Repo>>
  _f$mangaExtensionsRepo = Field(
    'mangaExtensionsRepo',
    _$mangaExtensionsRepo,
    opt: true,
  );
  static List<Repo>? _$animeExtensionsRepo(MangayomiBackupSettings v) =>
      v.animeExtensionsRepo;
  static const Field<MangayomiBackupSettings, List<Repo>>
  _f$animeExtensionsRepo = Field(
    'animeExtensionsRepo',
    _$animeExtensionsRepo,
    opt: true,
  );
  static List<Repo>? _$novelExtensionsRepo(MangayomiBackupSettings v) =>
      v.novelExtensionsRepo;
  static const Field<MangayomiBackupSettings, List<Repo>>
  _f$novelExtensionsRepo = Field(
    'novelExtensionsRepo',
    _$novelExtensionsRepo,
    opt: true,
  );
  static List<ChapterFilterUnread>? _$chapterFilterUnreadList(
    MangayomiBackupSettings v,
  ) => v.chapterFilterUnreadList;
  static const Field<MangayomiBackupSettings, List<ChapterFilterUnread>>
  _f$chapterFilterUnreadList = Field(
    'chapterFilterUnreadList',
    _$chapterFilterUnreadList,
    opt: true,
  );
  static List<ChapterFilterBookmarked>? _$chapterFilterBookmarkedList(
    MangayomiBackupSettings v,
  ) => v.chapterFilterBookmarkedList;
  static const Field<MangayomiBackupSettings, List<ChapterFilterBookmarked>>
  _f$chapterFilterBookmarkedList = Field(
    'chapterFilterBookmarkedList',
    _$chapterFilterBookmarkedList,
    opt: true,
  );
  static List<FilterScanlator>? _$filterScanlatorList(
    MangayomiBackupSettings v,
  ) => v.filterScanlatorList;
  static const Field<MangayomiBackupSettings, List<FilterScanlator>>
  _f$filterScanlatorList = Field(
    'filterScanlatorList',
    _$filterScanlatorList,
    opt: true,
  );
  static L10nLocale? _$locale(MangayomiBackupSettings v) => v.locale;
  static const Field<MangayomiBackupSettings, L10nLocale> _f$locale = Field(
    'locale',
    _$locale,
    opt: true,
  );
  static L10nLocale? _$defaultSubtitleLang(MangayomiBackupSettings v) =>
      v.defaultSubtitleLang;
  static const Field<MangayomiBackupSettings, L10nLocale>
  _f$defaultSubtitleLang = Field(
    'defaultSubtitleLang',
    _$defaultSubtitleLang,
    opt: true,
  );
  static int? _$novelGridSize(MangayomiBackupSettings v) => v.novelGridSize;
  static const Field<MangayomiBackupSettings, int> _f$novelGridSize = Field(
    'novelGridSize',
    _$novelGridSize,
    opt: true,
  );

  @override
  final MappableFields<MangayomiBackupSettings> fields = const {
    #id: _f$id,
    #displayType: _f$displayType,
    #libraryFilterMangasDownloadType: _f$libraryFilterMangasDownloadType,
    #libraryFilterMangasUnreadType: _f$libraryFilterMangasUnreadType,
    #libraryFilterMangasStartedType: _f$libraryFilterMangasStartedType,
    #libraryFilterMangasBookMarkedType: _f$libraryFilterMangasBookMarkedType,
    #libraryShowCategoryTabs: _f$libraryShowCategoryTabs,
    #libraryDownloadedChapters: _f$libraryDownloadedChapters,
    #libraryShowLanguage: _f$libraryShowLanguage,
    #libraryShowNumbersOfItems: _f$libraryShowNumbersOfItems,
    #libraryShowContinueReadingButton: _f$libraryShowContinueReadingButton,
    #sortLibraryManga: _f$sortLibraryManga,
    #sortChapterList: _f$sortChapterList,
    #chapterFilterDownloadedList: _f$chapterFilterDownloadedList,
    #flexColorSchemeBlendLevel: _f$flexColorSchemeBlendLevel,
    #dateFormat: _f$dateFormat,
    #relativeTimesTamps: _f$relativeTimesTamps,
    #flexSchemeColorIndex: _f$flexSchemeColorIndex,
    #themeIsDark: _f$themeIsDark,
    #followSystemTheme: _f$followSystemTheme,
    #incognitoMode: _f$incognitoMode,
    #chapterPageUrlsList: _f$chapterPageUrlsList,
    #showPagesNumber: _f$showPagesNumber,
    #chapterPageIndexList: _f$chapterPageIndexList,
    #userAgent: _f$userAgent,
    #cookiesList: _f$cookiesList,
    #defaultReaderMode: _f$defaultReaderMode,
    #personalReaderModeList: _f$personalReaderModeList,
    #animatePageTransitions: _f$animatePageTransitions,
    #doubleTapAnimationSpeed: _f$doubleTapAnimationSpeed,
    #onlyIncludePinnedSources: _f$onlyIncludePinnedSources,
    #pureBlackDarkMode: _f$pureBlackDarkMode,
    #downloadOnlyOnWifi: _f$downloadOnlyOnWifi,
    #saveAsCBZArchive: _f$saveAsCBZArchive,
    #downloadLocation: _f$downloadLocation,
    #cropBorders: _f$cropBorders,
    #libraryLocalSource: _f$libraryLocalSource,
    #autoExtensionsUpdates: _f$autoExtensionsUpdates,
    #animeDisplayType: _f$animeDisplayType,
    #libraryFilterAnimeDownloadType: _f$libraryFilterAnimeDownloadType,
    #libraryFilterAnimeUnreadType: _f$libraryFilterAnimeUnreadType,
    #libraryFilterAnimeStartedType: _f$libraryFilterAnimeStartedType,
    #libraryFilterAnimeBookMarkedType: _f$libraryFilterAnimeBookMarkedType,
    #animeLibraryShowCategoryTabs: _f$animeLibraryShowCategoryTabs,
    #animeLibraryDownloadedChapters: _f$animeLibraryDownloadedChapters,
    #animeLibraryShowLanguage: _f$animeLibraryShowLanguage,
    #animeLibraryShowNumbersOfItems: _f$animeLibraryShowNumbersOfItems,
    #animeLibraryShowContinueReadingButton:
        _f$animeLibraryShowContinueReadingButton,
    #animeLibraryLocalSource: _f$animeLibraryLocalSource,
    #sortLibraryAnime: _f$sortLibraryAnime,
    #pagePreloadAmount: _f$pagePreloadAmount,
    #scaleType: _f$scaleType,
    #checkForExtensionUpdates: _f$checkForExtensionUpdates,
    #backgroundColor: _f$backgroundColor,
    #personalPageModeList: _f$personalPageModeList,
    #backupFrequency: _f$backupFrequency,
    #backupListOptions: _f$backupListOptions,
    #autoBackupLocation: _f$autoBackupLocation,
    #startDatebackup: _f$startDatebackup,
    #usePageTapZones: _f$usePageTapZones,
    #autoScrollPages: _f$autoScrollPages,
    #markEpisodeAsSeenType: _f$markEpisodeAsSeenType,
    #defaultSkipIntroLength: _f$defaultSkipIntroLength,
    #defaultDoubleTapToSkipLength: _f$defaultDoubleTapToSkipLength,
    #defaultPlayBackSpeed: _f$defaultPlayBackSpeed,
    #fullScreenPlayer: _f$fullScreenPlayer,
    #updateProgressAfterReading: _f$updateProgressAfterReading,
    #enableAniSkip: _f$enableAniSkip,
    #enableAutoSkip: _f$enableAutoSkip,
    #aniSkipTimeoutLength: _f$aniSkipTimeoutLength,
    #btServerAddress: _f$btServerAddress,
    #btServerPort: _f$btServerPort,
    #fullScreenReader: _f$fullScreenReader,
    #enableCustomColorFilter: _f$enableCustomColorFilter,
    #customColorFilter: _f$customColorFilter,
    #colorFilterBlendMode: _f$colorFilterBlendMode,
    #playerSubtitleSettings: _f$playerSubtitleSettings,
    #mangaHomeDisplayType: _f$mangaHomeDisplayType,
    #appFontFamily: _f$appFontFamily,
    #mangaGridSize: _f$mangaGridSize,
    #animeGridSize: _f$animeGridSize,
    #disableSectionType: _f$disableSectionType,
    #useLibass: _f$useLibass,
    #libraryFilterNovelDownloadType: _f$libraryFilterNovelDownloadType,
    #libraryFilterNovelUnreadType: _f$libraryFilterNovelUnreadType,
    #libraryFilterNovelStartedType: _f$libraryFilterNovelStartedType,
    #libraryFilterNovelBookMarkedType: _f$libraryFilterNovelBookMarkedType,
    #novelLibraryShowCategoryTabs: _f$novelLibraryShowCategoryTabs,
    #novelLibraryDownloadedChapters: _f$novelLibraryDownloadedChapters,
    #novelLibraryShowLanguage: _f$novelLibraryShowLanguage,
    #novelLibraryShowNumbersOfItems: _f$novelLibraryShowNumbersOfItems,
    #novelLibraryShowContinueReadingButton:
        _f$novelLibraryShowContinueReadingButton,
    #novelLibraryLocalSource: _f$novelLibraryLocalSource,
    #sortLibraryNovel: _f$sortLibraryNovel,
    #novelDisplayType: _f$novelDisplayType,
    #novelFontSize: _f$novelFontSize,
    #novelTextAlign: _f$novelTextAlign,
    #navigationOrder: _f$navigationOrder,
    #hideItems: _f$hideItems,
    #clearChapterCacheOnAppLaunch: _f$clearChapterCacheOnAppLaunch,
    #mangaExtensionsRepo: _f$mangaExtensionsRepo,
    #animeExtensionsRepo: _f$animeExtensionsRepo,
    #novelExtensionsRepo: _f$novelExtensionsRepo,
    #chapterFilterUnreadList: _f$chapterFilterUnreadList,
    #chapterFilterBookmarkedList: _f$chapterFilterBookmarkedList,
    #filterScanlatorList: _f$filterScanlatorList,
    #locale: _f$locale,
    #defaultSubtitleLang: _f$defaultSubtitleLang,
    #novelGridSize: _f$novelGridSize,
  };

  static MangayomiBackupSettings _instantiate(DecodingData data) {
    return MangayomiBackupSettings(
      id: data.dec(_f$id),
      displayType: data.dec(_f$displayType),
      libraryFilterMangasDownloadType: data.dec(
        _f$libraryFilterMangasDownloadType,
      ),
      libraryFilterMangasUnreadType: data.dec(_f$libraryFilterMangasUnreadType),
      libraryFilterMangasStartedType: data.dec(
        _f$libraryFilterMangasStartedType,
      ),
      libraryFilterMangasBookMarkedType: data.dec(
        _f$libraryFilterMangasBookMarkedType,
      ),
      libraryShowCategoryTabs: data.dec(_f$libraryShowCategoryTabs),
      libraryDownloadedChapters: data.dec(_f$libraryDownloadedChapters),
      libraryShowLanguage: data.dec(_f$libraryShowLanguage),
      libraryShowNumbersOfItems: data.dec(_f$libraryShowNumbersOfItems),
      libraryShowContinueReadingButton: data.dec(
        _f$libraryShowContinueReadingButton,
      ),
      sortLibraryManga: data.dec(_f$sortLibraryManga),
      sortChapterList: data.dec(_f$sortChapterList),
      chapterFilterDownloadedList: data.dec(_f$chapterFilterDownloadedList),
      flexColorSchemeBlendLevel: data.dec(_f$flexColorSchemeBlendLevel),
      dateFormat: data.dec(_f$dateFormat),
      relativeTimesTamps: data.dec(_f$relativeTimesTamps),
      flexSchemeColorIndex: data.dec(_f$flexSchemeColorIndex),
      themeIsDark: data.dec(_f$themeIsDark),
      followSystemTheme: data.dec(_f$followSystemTheme),
      incognitoMode: data.dec(_f$incognitoMode),
      chapterPageUrlsList: data.dec(_f$chapterPageUrlsList),
      showPagesNumber: data.dec(_f$showPagesNumber),
      chapterPageIndexList: data.dec(_f$chapterPageIndexList),
      userAgent: data.dec(_f$userAgent),
      cookiesList: data.dec(_f$cookiesList),
      defaultReaderMode: data.dec(_f$defaultReaderMode),
      personalReaderModeList: data.dec(_f$personalReaderModeList),
      animatePageTransitions: data.dec(_f$animatePageTransitions),
      doubleTapAnimationSpeed: data.dec(_f$doubleTapAnimationSpeed),
      onlyIncludePinnedSources: data.dec(_f$onlyIncludePinnedSources),
      pureBlackDarkMode: data.dec(_f$pureBlackDarkMode),
      downloadOnlyOnWifi: data.dec(_f$downloadOnlyOnWifi),
      saveAsCBZArchive: data.dec(_f$saveAsCBZArchive),
      downloadLocation: data.dec(_f$downloadLocation),
      cropBorders: data.dec(_f$cropBorders),
      libraryLocalSource: data.dec(_f$libraryLocalSource),
      autoExtensionsUpdates: data.dec(_f$autoExtensionsUpdates),
      animeDisplayType: data.dec(_f$animeDisplayType),
      libraryFilterAnimeDownloadType: data.dec(
        _f$libraryFilterAnimeDownloadType,
      ),
      libraryFilterAnimeUnreadType: data.dec(_f$libraryFilterAnimeUnreadType),
      libraryFilterAnimeStartedType: data.dec(_f$libraryFilterAnimeStartedType),
      libraryFilterAnimeBookMarkedType: data.dec(
        _f$libraryFilterAnimeBookMarkedType,
      ),
      animeLibraryShowCategoryTabs: data.dec(_f$animeLibraryShowCategoryTabs),
      animeLibraryDownloadedChapters: data.dec(
        _f$animeLibraryDownloadedChapters,
      ),
      animeLibraryShowLanguage: data.dec(_f$animeLibraryShowLanguage),
      animeLibraryShowNumbersOfItems: data.dec(
        _f$animeLibraryShowNumbersOfItems,
      ),
      animeLibraryShowContinueReadingButton: data.dec(
        _f$animeLibraryShowContinueReadingButton,
      ),
      animeLibraryLocalSource: data.dec(_f$animeLibraryLocalSource),
      sortLibraryAnime: data.dec(_f$sortLibraryAnime),
      pagePreloadAmount: data.dec(_f$pagePreloadAmount),
      scaleType: data.dec(_f$scaleType),
      checkForExtensionUpdates: data.dec(_f$checkForExtensionUpdates),
      backgroundColor: data.dec(_f$backgroundColor),
      personalPageModeList: data.dec(_f$personalPageModeList),
      backupFrequency: data.dec(_f$backupFrequency),
      backupListOptions: data.dec(_f$backupListOptions),
      autoBackupLocation: data.dec(_f$autoBackupLocation),
      startDatebackup: data.dec(_f$startDatebackup),
      usePageTapZones: data.dec(_f$usePageTapZones),
      autoScrollPages: data.dec(_f$autoScrollPages),
      markEpisodeAsSeenType: data.dec(_f$markEpisodeAsSeenType),
      defaultSkipIntroLength: data.dec(_f$defaultSkipIntroLength),
      defaultDoubleTapToSkipLength: data.dec(_f$defaultDoubleTapToSkipLength),
      defaultPlayBackSpeed: data.dec(_f$defaultPlayBackSpeed),
      fullScreenPlayer: data.dec(_f$fullScreenPlayer),
      updateProgressAfterReading: data.dec(_f$updateProgressAfterReading),
      enableAniSkip: data.dec(_f$enableAniSkip),
      enableAutoSkip: data.dec(_f$enableAutoSkip),
      aniSkipTimeoutLength: data.dec(_f$aniSkipTimeoutLength),
      btServerAddress: data.dec(_f$btServerAddress),
      btServerPort: data.dec(_f$btServerPort),
      fullScreenReader: data.dec(_f$fullScreenReader),
      enableCustomColorFilter: data.dec(_f$enableCustomColorFilter),
      customColorFilter: data.dec(_f$customColorFilter),
      colorFilterBlendMode: data.dec(_f$colorFilterBlendMode),
      playerSubtitleSettings: data.dec(_f$playerSubtitleSettings),
      mangaHomeDisplayType: data.dec(_f$mangaHomeDisplayType),
      appFontFamily: data.dec(_f$appFontFamily),
      mangaGridSize: data.dec(_f$mangaGridSize),
      animeGridSize: data.dec(_f$animeGridSize),
      disableSectionType: data.dec(_f$disableSectionType),
      useLibass: data.dec(_f$useLibass),
      libraryFilterNovelDownloadType: data.dec(
        _f$libraryFilterNovelDownloadType,
      ),
      libraryFilterNovelUnreadType: data.dec(_f$libraryFilterNovelUnreadType),
      libraryFilterNovelStartedType: data.dec(_f$libraryFilterNovelStartedType),
      libraryFilterNovelBookMarkedType: data.dec(
        _f$libraryFilterNovelBookMarkedType,
      ),
      novelLibraryShowCategoryTabs: data.dec(_f$novelLibraryShowCategoryTabs),
      novelLibraryDownloadedChapters: data.dec(
        _f$novelLibraryDownloadedChapters,
      ),
      novelLibraryShowLanguage: data.dec(_f$novelLibraryShowLanguage),
      novelLibraryShowNumbersOfItems: data.dec(
        _f$novelLibraryShowNumbersOfItems,
      ),
      novelLibraryShowContinueReadingButton: data.dec(
        _f$novelLibraryShowContinueReadingButton,
      ),
      novelLibraryLocalSource: data.dec(_f$novelLibraryLocalSource),
      sortLibraryNovel: data.dec(_f$sortLibraryNovel),
      novelDisplayType: data.dec(_f$novelDisplayType),
      novelFontSize: data.dec(_f$novelFontSize),
      novelTextAlign: data.dec(_f$novelTextAlign),
      navigationOrder: data.dec(_f$navigationOrder),
      hideItems: data.dec(_f$hideItems),
      clearChapterCacheOnAppLaunch: data.dec(_f$clearChapterCacheOnAppLaunch),
      mangaExtensionsRepo: data.dec(_f$mangaExtensionsRepo),
      animeExtensionsRepo: data.dec(_f$animeExtensionsRepo),
      novelExtensionsRepo: data.dec(_f$novelExtensionsRepo),
      chapterFilterUnreadList: data.dec(_f$chapterFilterUnreadList),
      chapterFilterBookmarkedList: data.dec(_f$chapterFilterBookmarkedList),
      filterScanlatorList: data.dec(_f$filterScanlatorList),
      locale: data.dec(_f$locale),
      defaultSubtitleLang: data.dec(_f$defaultSubtitleLang),
      novelGridSize: data.dec(_f$novelGridSize),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static MangayomiBackupSettings fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MangayomiBackupSettings>(map);
  }

  static MangayomiBackupSettings fromJson(String json) {
    return ensureInitialized().decodeJson<MangayomiBackupSettings>(json);
  }
}

mixin MangayomiBackupSettingsMappable {
  String toJson() {
    return MangayomiBackupSettingsMapper.ensureInitialized()
        .encodeJson<MangayomiBackupSettings>(this as MangayomiBackupSettings);
  }

  Map<String, dynamic> toMap() {
    return MangayomiBackupSettingsMapper.ensureInitialized()
        .encodeMap<MangayomiBackupSettings>(this as MangayomiBackupSettings);
  }

  MangayomiBackupSettingsCopyWith<
    MangayomiBackupSettings,
    MangayomiBackupSettings,
    MangayomiBackupSettings
  >
  get copyWith =>
      _MangayomiBackupSettingsCopyWithImpl<
        MangayomiBackupSettings,
        MangayomiBackupSettings
      >(this as MangayomiBackupSettings, $identity, $identity);
  @override
  String toString() {
    return MangayomiBackupSettingsMapper.ensureInitialized().stringifyValue(
      this as MangayomiBackupSettings,
    );
  }

  @override
  bool operator ==(Object other) {
    return MangayomiBackupSettingsMapper.ensureInitialized().equalsValue(
      this as MangayomiBackupSettings,
      other,
    );
  }

  @override
  int get hashCode {
    return MangayomiBackupSettingsMapper.ensureInitialized().hashValue(
      this as MangayomiBackupSettings,
    );
  }
}

extension MangayomiBackupSettingsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MangayomiBackupSettings, $Out> {
  MangayomiBackupSettingsCopyWith<$R, MangayomiBackupSettings, $Out>
  get $asMangayomiBackupSettings => $base.as(
    (v, t, t2) => _MangayomiBackupSettingsCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class MangayomiBackupSettingsCopyWith<
  $R,
  $In extends MangayomiBackupSettings,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  SortLibraryMangaCopyWith<$R, SortLibraryManga, SortLibraryManga>?
  get sortLibraryManga;
  ListCopyWith<
    $R,
    SortChapter,
    SortChapterCopyWith<$R, SortChapter, SortChapter>
  >?
  get sortChapterList;
  ListCopyWith<
    $R,
    ChapterFilterDownloaded,
    ChapterFilterDownloadedCopyWith<
      $R,
      ChapterFilterDownloaded,
      ChapterFilterDownloaded
    >
  >?
  get chapterFilterDownloadedList;
  ListCopyWith<
    $R,
    ChapterPageurls,
    ChapterPageurlsCopyWith<$R, ChapterPageurls, ChapterPageurls>
  >?
  get chapterPageUrlsList;
  ListCopyWith<
    $R,
    ChapterPageIndex,
    ChapterPageIndexCopyWith<$R, ChapterPageIndex, ChapterPageIndex>
  >?
  get chapterPageIndexList;
  ListCopyWith<$R, MCookie, MCookieCopyWith<$R, MCookie, MCookie>>?
  get cookiesList;
  ListCopyWith<
    $R,
    PersonalReaderMode,
    PersonalReaderModeCopyWith<$R, PersonalReaderMode, PersonalReaderMode>
  >?
  get personalReaderModeList;
  SortLibraryMangaCopyWith<$R, SortLibraryManga, SortLibraryManga>?
  get sortLibraryAnime;
  ListCopyWith<
    $R,
    PersonalPageMode,
    PersonalPageModeCopyWith<$R, PersonalPageMode, PersonalPageMode>
  >?
  get personalPageModeList;
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>>? get backupListOptions;
  ListCopyWith<
    $R,
    AutoScrollPages,
    AutoScrollPagesCopyWith<$R, AutoScrollPages, AutoScrollPages>
  >?
  get autoScrollPages;
  CustomColorFilterCopyWith<$R, CustomColorFilter, CustomColorFilter>?
  get customColorFilter;
  PlayerSubtitleSettingsCopyWith<
    $R,
    PlayerSubtitleSettings,
    PlayerSubtitleSettings
  >?
  get playerSubtitleSettings;
  SortLibraryMangaCopyWith<$R, SortLibraryManga, SortLibraryManga>?
  get sortLibraryNovel;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>?
  get navigationOrder;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>? get hideItems;
  ListCopyWith<$R, Repo, RepoCopyWith<$R, Repo, Repo>>? get mangaExtensionsRepo;
  ListCopyWith<$R, Repo, RepoCopyWith<$R, Repo, Repo>>? get animeExtensionsRepo;
  ListCopyWith<$R, Repo, RepoCopyWith<$R, Repo, Repo>>? get novelExtensionsRepo;
  ListCopyWith<
    $R,
    ChapterFilterUnread,
    ChapterFilterUnreadCopyWith<$R, ChapterFilterUnread, ChapterFilterUnread>
  >?
  get chapterFilterUnreadList;
  ListCopyWith<
    $R,
    ChapterFilterBookmarked,
    ChapterFilterBookmarkedCopyWith<
      $R,
      ChapterFilterBookmarked,
      ChapterFilterBookmarked
    >
  >?
  get chapterFilterBookmarkedList;
  ListCopyWith<
    $R,
    FilterScanlator,
    FilterScanlatorCopyWith<$R, FilterScanlator, FilterScanlator>
  >?
  get filterScanlatorList;
  L10nLocaleCopyWith<$R, L10nLocale, L10nLocale>? get locale;
  L10nLocaleCopyWith<$R, L10nLocale, L10nLocale>? get defaultSubtitleLang;
  $R call({
    int? id,
    DisplayType? displayType,
    int? libraryFilterMangasDownloadType,
    int? libraryFilterMangasUnreadType,
    int? libraryFilterMangasStartedType,
    int? libraryFilterMangasBookMarkedType,
    bool? libraryShowCategoryTabs,
    bool? libraryDownloadedChapters,
    bool? libraryShowLanguage,
    bool? libraryShowNumbersOfItems,
    bool? libraryShowContinueReadingButton,
    SortLibraryManga? sortLibraryManga,
    List<SortChapter>? sortChapterList,
    List<ChapterFilterDownloaded>? chapterFilterDownloadedList,
    double? flexColorSchemeBlendLevel,
    String? dateFormat,
    int? relativeTimesTamps,
    int? flexSchemeColorIndex,
    bool? themeIsDark,
    bool? followSystemTheme,
    bool? incognitoMode,
    List<ChapterPageurls>? chapterPageUrlsList,
    bool? showPagesNumber,
    List<ChapterPageIndex>? chapterPageIndexList,
    String? userAgent,
    List<MCookie>? cookiesList,
    ReaderMode? defaultReaderMode,
    List<PersonalReaderMode>? personalReaderModeList,
    bool? animatePageTransitions,
    int? doubleTapAnimationSpeed,
    bool? onlyIncludePinnedSources,
    bool? pureBlackDarkMode,
    bool? downloadOnlyOnWifi,
    bool? saveAsCBZArchive,
    String? downloadLocation,
    bool? cropBorders,
    bool? libraryLocalSource,
    bool? autoExtensionsUpdates,
    DisplayType? animeDisplayType,
    int? libraryFilterAnimeDownloadType,
    int? libraryFilterAnimeUnreadType,
    int? libraryFilterAnimeStartedType,
    int? libraryFilterAnimeBookMarkedType,
    bool? animeLibraryShowCategoryTabs,
    bool? animeLibraryDownloadedChapters,
    bool? animeLibraryShowLanguage,
    bool? animeLibraryShowNumbersOfItems,
    bool? animeLibraryShowContinueReadingButton,
    bool? animeLibraryLocalSource,
    SortLibraryManga? sortLibraryAnime,
    int? pagePreloadAmount,
    ScaleType? scaleType,
    bool? checkForExtensionUpdates,
    BackgroundColor? backgroundColor,
    List<PersonalPageMode>? personalPageModeList,
    int? backupFrequency,
    List<int>? backupListOptions,
    String? autoBackupLocation,
    int? startDatebackup,
    bool? usePageTapZones,
    List<AutoScrollPages>? autoScrollPages,
    int? markEpisodeAsSeenType,
    int? defaultSkipIntroLength,
    int? defaultDoubleTapToSkipLength,
    double? defaultPlayBackSpeed,
    bool? fullScreenPlayer,
    bool? updateProgressAfterReading,
    bool? enableAniSkip,
    bool? enableAutoSkip,
    int? aniSkipTimeoutLength,
    String? btServerAddress,
    int? btServerPort,
    bool? fullScreenReader,
    bool? enableCustomColorFilter,
    CustomColorFilter? customColorFilter,
    ColorFilterBlendMode? colorFilterBlendMode,
    PlayerSubtitleSettings? playerSubtitleSettings,
    DisplayType? mangaHomeDisplayType,
    String? appFontFamily,
    int? mangaGridSize,
    int? animeGridSize,
    SectionType? disableSectionType,
    bool? useLibass,
    int? libraryFilterNovelDownloadType,
    int? libraryFilterNovelUnreadType,
    int? libraryFilterNovelStartedType,
    int? libraryFilterNovelBookMarkedType,
    bool? novelLibraryShowCategoryTabs,
    bool? novelLibraryDownloadedChapters,
    bool? novelLibraryShowLanguage,
    bool? novelLibraryShowNumbersOfItems,
    bool? novelLibraryShowContinueReadingButton,
    bool? novelLibraryLocalSource,
    SortLibraryManga? sortLibraryNovel,
    DisplayType? novelDisplayType,
    int? novelFontSize,
    NovelTextAlign? novelTextAlign,
    List<String>? navigationOrder,
    List<String>? hideItems,
    bool? clearChapterCacheOnAppLaunch,
    List<Repo>? mangaExtensionsRepo,
    List<Repo>? animeExtensionsRepo,
    List<Repo>? novelExtensionsRepo,
    List<ChapterFilterUnread>? chapterFilterUnreadList,
    List<ChapterFilterBookmarked>? chapterFilterBookmarkedList,
    List<FilterScanlator>? filterScanlatorList,
    L10nLocale? locale,
    L10nLocale? defaultSubtitleLang,
    int? novelGridSize,
  });
  MangayomiBackupSettingsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _MangayomiBackupSettingsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MangayomiBackupSettings, $Out>
    implements
        MangayomiBackupSettingsCopyWith<$R, MangayomiBackupSettings, $Out> {
  _MangayomiBackupSettingsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MangayomiBackupSettings> $mapper =
      MangayomiBackupSettingsMapper.ensureInitialized();
  @override
  SortLibraryMangaCopyWith<$R, SortLibraryManga, SortLibraryManga>?
  get sortLibraryManga => $value.sortLibraryManga?.copyWith.$chain(
    (v) => call(sortLibraryManga: v),
  );
  @override
  ListCopyWith<
    $R,
    SortChapter,
    SortChapterCopyWith<$R, SortChapter, SortChapter>
  >?
  get sortChapterList => $value.sortChapterList != null
      ? ListCopyWith(
          $value.sortChapterList!,
          (v, t) => v.copyWith.$chain(t),
          (v) => call(sortChapterList: v),
        )
      : null;
  @override
  ListCopyWith<
    $R,
    ChapterFilterDownloaded,
    ChapterFilterDownloadedCopyWith<
      $R,
      ChapterFilterDownloaded,
      ChapterFilterDownloaded
    >
  >?
  get chapterFilterDownloadedList => $value.chapterFilterDownloadedList != null
      ? ListCopyWith(
          $value.chapterFilterDownloadedList!,
          (v, t) => v.copyWith.$chain(t),
          (v) => call(chapterFilterDownloadedList: v),
        )
      : null;
  @override
  ListCopyWith<
    $R,
    ChapterPageurls,
    ChapterPageurlsCopyWith<$R, ChapterPageurls, ChapterPageurls>
  >?
  get chapterPageUrlsList => $value.chapterPageUrlsList != null
      ? ListCopyWith(
          $value.chapterPageUrlsList!,
          (v, t) => v.copyWith.$chain(t),
          (v) => call(chapterPageUrlsList: v),
        )
      : null;
  @override
  ListCopyWith<
    $R,
    ChapterPageIndex,
    ChapterPageIndexCopyWith<$R, ChapterPageIndex, ChapterPageIndex>
  >?
  get chapterPageIndexList => $value.chapterPageIndexList != null
      ? ListCopyWith(
          $value.chapterPageIndexList!,
          (v, t) => v.copyWith.$chain(t),
          (v) => call(chapterPageIndexList: v),
        )
      : null;
  @override
  ListCopyWith<$R, MCookie, MCookieCopyWith<$R, MCookie, MCookie>>?
  get cookiesList => $value.cookiesList != null
      ? ListCopyWith(
          $value.cookiesList!,
          (v, t) => v.copyWith.$chain(t),
          (v) => call(cookiesList: v),
        )
      : null;
  @override
  ListCopyWith<
    $R,
    PersonalReaderMode,
    PersonalReaderModeCopyWith<$R, PersonalReaderMode, PersonalReaderMode>
  >?
  get personalReaderModeList => $value.personalReaderModeList != null
      ? ListCopyWith(
          $value.personalReaderModeList!,
          (v, t) => v.copyWith.$chain(t),
          (v) => call(personalReaderModeList: v),
        )
      : null;
  @override
  SortLibraryMangaCopyWith<$R, SortLibraryManga, SortLibraryManga>?
  get sortLibraryAnime => $value.sortLibraryAnime?.copyWith.$chain(
    (v) => call(sortLibraryAnime: v),
  );
  @override
  ListCopyWith<
    $R,
    PersonalPageMode,
    PersonalPageModeCopyWith<$R, PersonalPageMode, PersonalPageMode>
  >?
  get personalPageModeList => $value.personalPageModeList != null
      ? ListCopyWith(
          $value.personalPageModeList!,
          (v, t) => v.copyWith.$chain(t),
          (v) => call(personalPageModeList: v),
        )
      : null;
  @override
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>>? get backupListOptions =>
      $value.backupListOptions != null
      ? ListCopyWith(
          $value.backupListOptions!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(backupListOptions: v),
        )
      : null;
  @override
  ListCopyWith<
    $R,
    AutoScrollPages,
    AutoScrollPagesCopyWith<$R, AutoScrollPages, AutoScrollPages>
  >?
  get autoScrollPages => $value.autoScrollPages != null
      ? ListCopyWith(
          $value.autoScrollPages!,
          (v, t) => v.copyWith.$chain(t),
          (v) => call(autoScrollPages: v),
        )
      : null;
  @override
  CustomColorFilterCopyWith<$R, CustomColorFilter, CustomColorFilter>?
  get customColorFilter => $value.customColorFilter?.copyWith.$chain(
    (v) => call(customColorFilter: v),
  );
  @override
  PlayerSubtitleSettingsCopyWith<
    $R,
    PlayerSubtitleSettings,
    PlayerSubtitleSettings
  >?
  get playerSubtitleSettings => $value.playerSubtitleSettings?.copyWith.$chain(
    (v) => call(playerSubtitleSettings: v),
  );
  @override
  SortLibraryMangaCopyWith<$R, SortLibraryManga, SortLibraryManga>?
  get sortLibraryNovel => $value.sortLibraryNovel?.copyWith.$chain(
    (v) => call(sortLibraryNovel: v),
  );
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>?
  get navigationOrder => $value.navigationOrder != null
      ? ListCopyWith(
          $value.navigationOrder!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(navigationOrder: v),
        )
      : null;
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>? get hideItems =>
      $value.hideItems != null
      ? ListCopyWith(
          $value.hideItems!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(hideItems: v),
        )
      : null;
  @override
  ListCopyWith<$R, Repo, RepoCopyWith<$R, Repo, Repo>>?
  get mangaExtensionsRepo => $value.mangaExtensionsRepo != null
      ? ListCopyWith(
          $value.mangaExtensionsRepo!,
          (v, t) => v.copyWith.$chain(t),
          (v) => call(mangaExtensionsRepo: v),
        )
      : null;
  @override
  ListCopyWith<$R, Repo, RepoCopyWith<$R, Repo, Repo>>?
  get animeExtensionsRepo => $value.animeExtensionsRepo != null
      ? ListCopyWith(
          $value.animeExtensionsRepo!,
          (v, t) => v.copyWith.$chain(t),
          (v) => call(animeExtensionsRepo: v),
        )
      : null;
  @override
  ListCopyWith<$R, Repo, RepoCopyWith<$R, Repo, Repo>>?
  get novelExtensionsRepo => $value.novelExtensionsRepo != null
      ? ListCopyWith(
          $value.novelExtensionsRepo!,
          (v, t) => v.copyWith.$chain(t),
          (v) => call(novelExtensionsRepo: v),
        )
      : null;
  @override
  ListCopyWith<
    $R,
    ChapterFilterUnread,
    ChapterFilterUnreadCopyWith<$R, ChapterFilterUnread, ChapterFilterUnread>
  >?
  get chapterFilterUnreadList => $value.chapterFilterUnreadList != null
      ? ListCopyWith(
          $value.chapterFilterUnreadList!,
          (v, t) => v.copyWith.$chain(t),
          (v) => call(chapterFilterUnreadList: v),
        )
      : null;
  @override
  ListCopyWith<
    $R,
    ChapterFilterBookmarked,
    ChapterFilterBookmarkedCopyWith<
      $R,
      ChapterFilterBookmarked,
      ChapterFilterBookmarked
    >
  >?
  get chapterFilterBookmarkedList => $value.chapterFilterBookmarkedList != null
      ? ListCopyWith(
          $value.chapterFilterBookmarkedList!,
          (v, t) => v.copyWith.$chain(t),
          (v) => call(chapterFilterBookmarkedList: v),
        )
      : null;
  @override
  ListCopyWith<
    $R,
    FilterScanlator,
    FilterScanlatorCopyWith<$R, FilterScanlator, FilterScanlator>
  >?
  get filterScanlatorList => $value.filterScanlatorList != null
      ? ListCopyWith(
          $value.filterScanlatorList!,
          (v, t) => v.copyWith.$chain(t),
          (v) => call(filterScanlatorList: v),
        )
      : null;
  @override
  L10nLocaleCopyWith<$R, L10nLocale, L10nLocale>? get locale =>
      $value.locale?.copyWith.$chain((v) => call(locale: v));
  @override
  L10nLocaleCopyWith<$R, L10nLocale, L10nLocale>? get defaultSubtitleLang =>
      $value.defaultSubtitleLang?.copyWith.$chain(
        (v) => call(defaultSubtitleLang: v),
      );
  @override
  $R call({
    Object? id = $none,
    DisplayType? displayType,
    Object? libraryFilterMangasDownloadType = $none,
    Object? libraryFilterMangasUnreadType = $none,
    Object? libraryFilterMangasStartedType = $none,
    Object? libraryFilterMangasBookMarkedType = $none,
    Object? libraryShowCategoryTabs = $none,
    Object? libraryDownloadedChapters = $none,
    Object? libraryShowLanguage = $none,
    Object? libraryShowNumbersOfItems = $none,
    Object? libraryShowContinueReadingButton = $none,
    Object? sortLibraryManga = $none,
    Object? sortChapterList = $none,
    Object? chapterFilterDownloadedList = $none,
    Object? flexColorSchemeBlendLevel = $none,
    Object? dateFormat = $none,
    Object? relativeTimesTamps = $none,
    Object? flexSchemeColorIndex = $none,
    Object? themeIsDark = $none,
    Object? followSystemTheme = $none,
    Object? incognitoMode = $none,
    Object? chapterPageUrlsList = $none,
    Object? showPagesNumber = $none,
    Object? chapterPageIndexList = $none,
    Object? userAgent = $none,
    Object? cookiesList = $none,
    ReaderMode? defaultReaderMode,
    Object? personalReaderModeList = $none,
    Object? animatePageTransitions = $none,
    Object? doubleTapAnimationSpeed = $none,
    Object? onlyIncludePinnedSources = $none,
    Object? pureBlackDarkMode = $none,
    Object? downloadOnlyOnWifi = $none,
    Object? saveAsCBZArchive = $none,
    Object? downloadLocation = $none,
    Object? cropBorders = $none,
    Object? libraryLocalSource = $none,
    Object? autoExtensionsUpdates = $none,
    DisplayType? animeDisplayType,
    Object? libraryFilterAnimeDownloadType = $none,
    Object? libraryFilterAnimeUnreadType = $none,
    Object? libraryFilterAnimeStartedType = $none,
    Object? libraryFilterAnimeBookMarkedType = $none,
    Object? animeLibraryShowCategoryTabs = $none,
    Object? animeLibraryDownloadedChapters = $none,
    Object? animeLibraryShowLanguage = $none,
    Object? animeLibraryShowNumbersOfItems = $none,
    Object? animeLibraryShowContinueReadingButton = $none,
    Object? animeLibraryLocalSource = $none,
    Object? sortLibraryAnime = $none,
    Object? pagePreloadAmount = $none,
    ScaleType? scaleType,
    Object? checkForExtensionUpdates = $none,
    BackgroundColor? backgroundColor,
    Object? personalPageModeList = $none,
    Object? backupFrequency = $none,
    Object? backupListOptions = $none,
    Object? autoBackupLocation = $none,
    Object? startDatebackup = $none,
    Object? usePageTapZones = $none,
    Object? autoScrollPages = $none,
    Object? markEpisodeAsSeenType = $none,
    Object? defaultSkipIntroLength = $none,
    Object? defaultDoubleTapToSkipLength = $none,
    Object? defaultPlayBackSpeed = $none,
    Object? fullScreenPlayer = $none,
    Object? updateProgressAfterReading = $none,
    Object? enableAniSkip = $none,
    Object? enableAutoSkip = $none,
    Object? aniSkipTimeoutLength = $none,
    Object? btServerAddress = $none,
    Object? btServerPort = $none,
    Object? fullScreenReader = $none,
    Object? enableCustomColorFilter = $none,
    Object? customColorFilter = $none,
    ColorFilterBlendMode? colorFilterBlendMode,
    Object? playerSubtitleSettings = $none,
    DisplayType? mangaHomeDisplayType,
    Object? appFontFamily = $none,
    Object? mangaGridSize = $none,
    Object? animeGridSize = $none,
    SectionType? disableSectionType,
    Object? useLibass = $none,
    Object? libraryFilterNovelDownloadType = $none,
    Object? libraryFilterNovelUnreadType = $none,
    Object? libraryFilterNovelStartedType = $none,
    Object? libraryFilterNovelBookMarkedType = $none,
    Object? novelLibraryShowCategoryTabs = $none,
    Object? novelLibraryDownloadedChapters = $none,
    Object? novelLibraryShowLanguage = $none,
    Object? novelLibraryShowNumbersOfItems = $none,
    Object? novelLibraryShowContinueReadingButton = $none,
    Object? novelLibraryLocalSource = $none,
    Object? sortLibraryNovel = $none,
    DisplayType? novelDisplayType,
    Object? novelFontSize = $none,
    NovelTextAlign? novelTextAlign,
    Object? navigationOrder = $none,
    Object? hideItems = $none,
    Object? clearChapterCacheOnAppLaunch = $none,
    Object? mangaExtensionsRepo = $none,
    Object? animeExtensionsRepo = $none,
    Object? novelExtensionsRepo = $none,
    Object? chapterFilterUnreadList = $none,
    Object? chapterFilterBookmarkedList = $none,
    Object? filterScanlatorList = $none,
    Object? locale = $none,
    Object? defaultSubtitleLang = $none,
    Object? novelGridSize = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != $none) #id: id,
      if (displayType != null) #displayType: displayType,
      if (libraryFilterMangasDownloadType != $none)
        #libraryFilterMangasDownloadType: libraryFilterMangasDownloadType,
      if (libraryFilterMangasUnreadType != $none)
        #libraryFilterMangasUnreadType: libraryFilterMangasUnreadType,
      if (libraryFilterMangasStartedType != $none)
        #libraryFilterMangasStartedType: libraryFilterMangasStartedType,
      if (libraryFilterMangasBookMarkedType != $none)
        #libraryFilterMangasBookMarkedType: libraryFilterMangasBookMarkedType,
      if (libraryShowCategoryTabs != $none)
        #libraryShowCategoryTabs: libraryShowCategoryTabs,
      if (libraryDownloadedChapters != $none)
        #libraryDownloadedChapters: libraryDownloadedChapters,
      if (libraryShowLanguage != $none)
        #libraryShowLanguage: libraryShowLanguage,
      if (libraryShowNumbersOfItems != $none)
        #libraryShowNumbersOfItems: libraryShowNumbersOfItems,
      if (libraryShowContinueReadingButton != $none)
        #libraryShowContinueReadingButton: libraryShowContinueReadingButton,
      if (sortLibraryManga != $none) #sortLibraryManga: sortLibraryManga,
      if (sortChapterList != $none) #sortChapterList: sortChapterList,
      if (chapterFilterDownloadedList != $none)
        #chapterFilterDownloadedList: chapterFilterDownloadedList,
      if (flexColorSchemeBlendLevel != $none)
        #flexColorSchemeBlendLevel: flexColorSchemeBlendLevel,
      if (dateFormat != $none) #dateFormat: dateFormat,
      if (relativeTimesTamps != $none) #relativeTimesTamps: relativeTimesTamps,
      if (flexSchemeColorIndex != $none)
        #flexSchemeColorIndex: flexSchemeColorIndex,
      if (themeIsDark != $none) #themeIsDark: themeIsDark,
      if (followSystemTheme != $none) #followSystemTheme: followSystemTheme,
      if (incognitoMode != $none) #incognitoMode: incognitoMode,
      if (chapterPageUrlsList != $none)
        #chapterPageUrlsList: chapterPageUrlsList,
      if (showPagesNumber != $none) #showPagesNumber: showPagesNumber,
      if (chapterPageIndexList != $none)
        #chapterPageIndexList: chapterPageIndexList,
      if (userAgent != $none) #userAgent: userAgent,
      if (cookiesList != $none) #cookiesList: cookiesList,
      if (defaultReaderMode != null) #defaultReaderMode: defaultReaderMode,
      if (personalReaderModeList != $none)
        #personalReaderModeList: personalReaderModeList,
      if (animatePageTransitions != $none)
        #animatePageTransitions: animatePageTransitions,
      if (doubleTapAnimationSpeed != $none)
        #doubleTapAnimationSpeed: doubleTapAnimationSpeed,
      if (onlyIncludePinnedSources != $none)
        #onlyIncludePinnedSources: onlyIncludePinnedSources,
      if (pureBlackDarkMode != $none) #pureBlackDarkMode: pureBlackDarkMode,
      if (downloadOnlyOnWifi != $none) #downloadOnlyOnWifi: downloadOnlyOnWifi,
      if (saveAsCBZArchive != $none) #saveAsCBZArchive: saveAsCBZArchive,
      if (downloadLocation != $none) #downloadLocation: downloadLocation,
      if (cropBorders != $none) #cropBorders: cropBorders,
      if (libraryLocalSource != $none) #libraryLocalSource: libraryLocalSource,
      if (autoExtensionsUpdates != $none)
        #autoExtensionsUpdates: autoExtensionsUpdates,
      if (animeDisplayType != null) #animeDisplayType: animeDisplayType,
      if (libraryFilterAnimeDownloadType != $none)
        #libraryFilterAnimeDownloadType: libraryFilterAnimeDownloadType,
      if (libraryFilterAnimeUnreadType != $none)
        #libraryFilterAnimeUnreadType: libraryFilterAnimeUnreadType,
      if (libraryFilterAnimeStartedType != $none)
        #libraryFilterAnimeStartedType: libraryFilterAnimeStartedType,
      if (libraryFilterAnimeBookMarkedType != $none)
        #libraryFilterAnimeBookMarkedType: libraryFilterAnimeBookMarkedType,
      if (animeLibraryShowCategoryTabs != $none)
        #animeLibraryShowCategoryTabs: animeLibraryShowCategoryTabs,
      if (animeLibraryDownloadedChapters != $none)
        #animeLibraryDownloadedChapters: animeLibraryDownloadedChapters,
      if (animeLibraryShowLanguage != $none)
        #animeLibraryShowLanguage: animeLibraryShowLanguage,
      if (animeLibraryShowNumbersOfItems != $none)
        #animeLibraryShowNumbersOfItems: animeLibraryShowNumbersOfItems,
      if (animeLibraryShowContinueReadingButton != $none)
        #animeLibraryShowContinueReadingButton:
            animeLibraryShowContinueReadingButton,
      if (animeLibraryLocalSource != $none)
        #animeLibraryLocalSource: animeLibraryLocalSource,
      if (sortLibraryAnime != $none) #sortLibraryAnime: sortLibraryAnime,
      if (pagePreloadAmount != $none) #pagePreloadAmount: pagePreloadAmount,
      if (scaleType != null) #scaleType: scaleType,
      if (checkForExtensionUpdates != $none)
        #checkForExtensionUpdates: checkForExtensionUpdates,
      if (backgroundColor != null) #backgroundColor: backgroundColor,
      if (personalPageModeList != $none)
        #personalPageModeList: personalPageModeList,
      if (backupFrequency != $none) #backupFrequency: backupFrequency,
      if (backupListOptions != $none) #backupListOptions: backupListOptions,
      if (autoBackupLocation != $none) #autoBackupLocation: autoBackupLocation,
      if (startDatebackup != $none) #startDatebackup: startDatebackup,
      if (usePageTapZones != $none) #usePageTapZones: usePageTapZones,
      if (autoScrollPages != $none) #autoScrollPages: autoScrollPages,
      if (markEpisodeAsSeenType != $none)
        #markEpisodeAsSeenType: markEpisodeAsSeenType,
      if (defaultSkipIntroLength != $none)
        #defaultSkipIntroLength: defaultSkipIntroLength,
      if (defaultDoubleTapToSkipLength != $none)
        #defaultDoubleTapToSkipLength: defaultDoubleTapToSkipLength,
      if (defaultPlayBackSpeed != $none)
        #defaultPlayBackSpeed: defaultPlayBackSpeed,
      if (fullScreenPlayer != $none) #fullScreenPlayer: fullScreenPlayer,
      if (updateProgressAfterReading != $none)
        #updateProgressAfterReading: updateProgressAfterReading,
      if (enableAniSkip != $none) #enableAniSkip: enableAniSkip,
      if (enableAutoSkip != $none) #enableAutoSkip: enableAutoSkip,
      if (aniSkipTimeoutLength != $none)
        #aniSkipTimeoutLength: aniSkipTimeoutLength,
      if (btServerAddress != $none) #btServerAddress: btServerAddress,
      if (btServerPort != $none) #btServerPort: btServerPort,
      if (fullScreenReader != $none) #fullScreenReader: fullScreenReader,
      if (enableCustomColorFilter != $none)
        #enableCustomColorFilter: enableCustomColorFilter,
      if (customColorFilter != $none) #customColorFilter: customColorFilter,
      if (colorFilterBlendMode != null)
        #colorFilterBlendMode: colorFilterBlendMode,
      if (playerSubtitleSettings != $none)
        #playerSubtitleSettings: playerSubtitleSettings,
      if (mangaHomeDisplayType != null)
        #mangaHomeDisplayType: mangaHomeDisplayType,
      if (appFontFamily != $none) #appFontFamily: appFontFamily,
      if (mangaGridSize != $none) #mangaGridSize: mangaGridSize,
      if (animeGridSize != $none) #animeGridSize: animeGridSize,
      if (disableSectionType != null) #disableSectionType: disableSectionType,
      if (useLibass != $none) #useLibass: useLibass,
      if (libraryFilterNovelDownloadType != $none)
        #libraryFilterNovelDownloadType: libraryFilterNovelDownloadType,
      if (libraryFilterNovelUnreadType != $none)
        #libraryFilterNovelUnreadType: libraryFilterNovelUnreadType,
      if (libraryFilterNovelStartedType != $none)
        #libraryFilterNovelStartedType: libraryFilterNovelStartedType,
      if (libraryFilterNovelBookMarkedType != $none)
        #libraryFilterNovelBookMarkedType: libraryFilterNovelBookMarkedType,
      if (novelLibraryShowCategoryTabs != $none)
        #novelLibraryShowCategoryTabs: novelLibraryShowCategoryTabs,
      if (novelLibraryDownloadedChapters != $none)
        #novelLibraryDownloadedChapters: novelLibraryDownloadedChapters,
      if (novelLibraryShowLanguage != $none)
        #novelLibraryShowLanguage: novelLibraryShowLanguage,
      if (novelLibraryShowNumbersOfItems != $none)
        #novelLibraryShowNumbersOfItems: novelLibraryShowNumbersOfItems,
      if (novelLibraryShowContinueReadingButton != $none)
        #novelLibraryShowContinueReadingButton:
            novelLibraryShowContinueReadingButton,
      if (novelLibraryLocalSource != $none)
        #novelLibraryLocalSource: novelLibraryLocalSource,
      if (sortLibraryNovel != $none) #sortLibraryNovel: sortLibraryNovel,
      if (novelDisplayType != null) #novelDisplayType: novelDisplayType,
      if (novelFontSize != $none) #novelFontSize: novelFontSize,
      if (novelTextAlign != null) #novelTextAlign: novelTextAlign,
      if (navigationOrder != $none) #navigationOrder: navigationOrder,
      if (hideItems != $none) #hideItems: hideItems,
      if (clearChapterCacheOnAppLaunch != $none)
        #clearChapterCacheOnAppLaunch: clearChapterCacheOnAppLaunch,
      if (mangaExtensionsRepo != $none)
        #mangaExtensionsRepo: mangaExtensionsRepo,
      if (animeExtensionsRepo != $none)
        #animeExtensionsRepo: animeExtensionsRepo,
      if (novelExtensionsRepo != $none)
        #novelExtensionsRepo: novelExtensionsRepo,
      if (chapterFilterUnreadList != $none)
        #chapterFilterUnreadList: chapterFilterUnreadList,
      if (chapterFilterBookmarkedList != $none)
        #chapterFilterBookmarkedList: chapterFilterBookmarkedList,
      if (filterScanlatorList != $none)
        #filterScanlatorList: filterScanlatorList,
      if (locale != $none) #locale: locale,
      if (defaultSubtitleLang != $none)
        #defaultSubtitleLang: defaultSubtitleLang,
      if (novelGridSize != $none) #novelGridSize: novelGridSize,
    }),
  );
  @override
  MangayomiBackupSettings $make(CopyWithData data) => MangayomiBackupSettings(
    id: data.get(#id, or: $value.id),
    displayType: data.get(#displayType, or: $value.displayType),
    libraryFilterMangasDownloadType: data.get(
      #libraryFilterMangasDownloadType,
      or: $value.libraryFilterMangasDownloadType,
    ),
    libraryFilterMangasUnreadType: data.get(
      #libraryFilterMangasUnreadType,
      or: $value.libraryFilterMangasUnreadType,
    ),
    libraryFilterMangasStartedType: data.get(
      #libraryFilterMangasStartedType,
      or: $value.libraryFilterMangasStartedType,
    ),
    libraryFilterMangasBookMarkedType: data.get(
      #libraryFilterMangasBookMarkedType,
      or: $value.libraryFilterMangasBookMarkedType,
    ),
    libraryShowCategoryTabs: data.get(
      #libraryShowCategoryTabs,
      or: $value.libraryShowCategoryTabs,
    ),
    libraryDownloadedChapters: data.get(
      #libraryDownloadedChapters,
      or: $value.libraryDownloadedChapters,
    ),
    libraryShowLanguage: data.get(
      #libraryShowLanguage,
      or: $value.libraryShowLanguage,
    ),
    libraryShowNumbersOfItems: data.get(
      #libraryShowNumbersOfItems,
      or: $value.libraryShowNumbersOfItems,
    ),
    libraryShowContinueReadingButton: data.get(
      #libraryShowContinueReadingButton,
      or: $value.libraryShowContinueReadingButton,
    ),
    sortLibraryManga: data.get(#sortLibraryManga, or: $value.sortLibraryManga),
    sortChapterList: data.get(#sortChapterList, or: $value.sortChapterList),
    chapterFilterDownloadedList: data.get(
      #chapterFilterDownloadedList,
      or: $value.chapterFilterDownloadedList,
    ),
    flexColorSchemeBlendLevel: data.get(
      #flexColorSchemeBlendLevel,
      or: $value.flexColorSchemeBlendLevel,
    ),
    dateFormat: data.get(#dateFormat, or: $value.dateFormat),
    relativeTimesTamps: data.get(
      #relativeTimesTamps,
      or: $value.relativeTimesTamps,
    ),
    flexSchemeColorIndex: data.get(
      #flexSchemeColorIndex,
      or: $value.flexSchemeColorIndex,
    ),
    themeIsDark: data.get(#themeIsDark, or: $value.themeIsDark),
    followSystemTheme: data.get(
      #followSystemTheme,
      or: $value.followSystemTheme,
    ),
    incognitoMode: data.get(#incognitoMode, or: $value.incognitoMode),
    chapterPageUrlsList: data.get(
      #chapterPageUrlsList,
      or: $value.chapterPageUrlsList,
    ),
    showPagesNumber: data.get(#showPagesNumber, or: $value.showPagesNumber),
    chapterPageIndexList: data.get(
      #chapterPageIndexList,
      or: $value.chapterPageIndexList,
    ),
    userAgent: data.get(#userAgent, or: $value.userAgent),
    cookiesList: data.get(#cookiesList, or: $value.cookiesList),
    defaultReaderMode: data.get(
      #defaultReaderMode,
      or: $value.defaultReaderMode,
    ),
    personalReaderModeList: data.get(
      #personalReaderModeList,
      or: $value.personalReaderModeList,
    ),
    animatePageTransitions: data.get(
      #animatePageTransitions,
      or: $value.animatePageTransitions,
    ),
    doubleTapAnimationSpeed: data.get(
      #doubleTapAnimationSpeed,
      or: $value.doubleTapAnimationSpeed,
    ),
    onlyIncludePinnedSources: data.get(
      #onlyIncludePinnedSources,
      or: $value.onlyIncludePinnedSources,
    ),
    pureBlackDarkMode: data.get(
      #pureBlackDarkMode,
      or: $value.pureBlackDarkMode,
    ),
    downloadOnlyOnWifi: data.get(
      #downloadOnlyOnWifi,
      or: $value.downloadOnlyOnWifi,
    ),
    saveAsCBZArchive: data.get(#saveAsCBZArchive, or: $value.saveAsCBZArchive),
    downloadLocation: data.get(#downloadLocation, or: $value.downloadLocation),
    cropBorders: data.get(#cropBorders, or: $value.cropBorders),
    libraryLocalSource: data.get(
      #libraryLocalSource,
      or: $value.libraryLocalSource,
    ),
    autoExtensionsUpdates: data.get(
      #autoExtensionsUpdates,
      or: $value.autoExtensionsUpdates,
    ),
    animeDisplayType: data.get(#animeDisplayType, or: $value.animeDisplayType),
    libraryFilterAnimeDownloadType: data.get(
      #libraryFilterAnimeDownloadType,
      or: $value.libraryFilterAnimeDownloadType,
    ),
    libraryFilterAnimeUnreadType: data.get(
      #libraryFilterAnimeUnreadType,
      or: $value.libraryFilterAnimeUnreadType,
    ),
    libraryFilterAnimeStartedType: data.get(
      #libraryFilterAnimeStartedType,
      or: $value.libraryFilterAnimeStartedType,
    ),
    libraryFilterAnimeBookMarkedType: data.get(
      #libraryFilterAnimeBookMarkedType,
      or: $value.libraryFilterAnimeBookMarkedType,
    ),
    animeLibraryShowCategoryTabs: data.get(
      #animeLibraryShowCategoryTabs,
      or: $value.animeLibraryShowCategoryTabs,
    ),
    animeLibraryDownloadedChapters: data.get(
      #animeLibraryDownloadedChapters,
      or: $value.animeLibraryDownloadedChapters,
    ),
    animeLibraryShowLanguage: data.get(
      #animeLibraryShowLanguage,
      or: $value.animeLibraryShowLanguage,
    ),
    animeLibraryShowNumbersOfItems: data.get(
      #animeLibraryShowNumbersOfItems,
      or: $value.animeLibraryShowNumbersOfItems,
    ),
    animeLibraryShowContinueReadingButton: data.get(
      #animeLibraryShowContinueReadingButton,
      or: $value.animeLibraryShowContinueReadingButton,
    ),
    animeLibraryLocalSource: data.get(
      #animeLibraryLocalSource,
      or: $value.animeLibraryLocalSource,
    ),
    sortLibraryAnime: data.get(#sortLibraryAnime, or: $value.sortLibraryAnime),
    pagePreloadAmount: data.get(
      #pagePreloadAmount,
      or: $value.pagePreloadAmount,
    ),
    scaleType: data.get(#scaleType, or: $value.scaleType),
    checkForExtensionUpdates: data.get(
      #checkForExtensionUpdates,
      or: $value.checkForExtensionUpdates,
    ),
    backgroundColor: data.get(#backgroundColor, or: $value.backgroundColor),
    personalPageModeList: data.get(
      #personalPageModeList,
      or: $value.personalPageModeList,
    ),
    backupFrequency: data.get(#backupFrequency, or: $value.backupFrequency),
    backupListOptions: data.get(
      #backupListOptions,
      or: $value.backupListOptions,
    ),
    autoBackupLocation: data.get(
      #autoBackupLocation,
      or: $value.autoBackupLocation,
    ),
    startDatebackup: data.get(#startDatebackup, or: $value.startDatebackup),
    usePageTapZones: data.get(#usePageTapZones, or: $value.usePageTapZones),
    autoScrollPages: data.get(#autoScrollPages, or: $value.autoScrollPages),
    markEpisodeAsSeenType: data.get(
      #markEpisodeAsSeenType,
      or: $value.markEpisodeAsSeenType,
    ),
    defaultSkipIntroLength: data.get(
      #defaultSkipIntroLength,
      or: $value.defaultSkipIntroLength,
    ),
    defaultDoubleTapToSkipLength: data.get(
      #defaultDoubleTapToSkipLength,
      or: $value.defaultDoubleTapToSkipLength,
    ),
    defaultPlayBackSpeed: data.get(
      #defaultPlayBackSpeed,
      or: $value.defaultPlayBackSpeed,
    ),
    fullScreenPlayer: data.get(#fullScreenPlayer, or: $value.fullScreenPlayer),
    updateProgressAfterReading: data.get(
      #updateProgressAfterReading,
      or: $value.updateProgressAfterReading,
    ),
    enableAniSkip: data.get(#enableAniSkip, or: $value.enableAniSkip),
    enableAutoSkip: data.get(#enableAutoSkip, or: $value.enableAutoSkip),
    aniSkipTimeoutLength: data.get(
      #aniSkipTimeoutLength,
      or: $value.aniSkipTimeoutLength,
    ),
    btServerAddress: data.get(#btServerAddress, or: $value.btServerAddress),
    btServerPort: data.get(#btServerPort, or: $value.btServerPort),
    fullScreenReader: data.get(#fullScreenReader, or: $value.fullScreenReader),
    enableCustomColorFilter: data.get(
      #enableCustomColorFilter,
      or: $value.enableCustomColorFilter,
    ),
    customColorFilter: data.get(
      #customColorFilter,
      or: $value.customColorFilter,
    ),
    colorFilterBlendMode: data.get(
      #colorFilterBlendMode,
      or: $value.colorFilterBlendMode,
    ),
    playerSubtitleSettings: data.get(
      #playerSubtitleSettings,
      or: $value.playerSubtitleSettings,
    ),
    mangaHomeDisplayType: data.get(
      #mangaHomeDisplayType,
      or: $value.mangaHomeDisplayType,
    ),
    appFontFamily: data.get(#appFontFamily, or: $value.appFontFamily),
    mangaGridSize: data.get(#mangaGridSize, or: $value.mangaGridSize),
    animeGridSize: data.get(#animeGridSize, or: $value.animeGridSize),
    disableSectionType: data.get(
      #disableSectionType,
      or: $value.disableSectionType,
    ),
    useLibass: data.get(#useLibass, or: $value.useLibass),
    libraryFilterNovelDownloadType: data.get(
      #libraryFilterNovelDownloadType,
      or: $value.libraryFilterNovelDownloadType,
    ),
    libraryFilterNovelUnreadType: data.get(
      #libraryFilterNovelUnreadType,
      or: $value.libraryFilterNovelUnreadType,
    ),
    libraryFilterNovelStartedType: data.get(
      #libraryFilterNovelStartedType,
      or: $value.libraryFilterNovelStartedType,
    ),
    libraryFilterNovelBookMarkedType: data.get(
      #libraryFilterNovelBookMarkedType,
      or: $value.libraryFilterNovelBookMarkedType,
    ),
    novelLibraryShowCategoryTabs: data.get(
      #novelLibraryShowCategoryTabs,
      or: $value.novelLibraryShowCategoryTabs,
    ),
    novelLibraryDownloadedChapters: data.get(
      #novelLibraryDownloadedChapters,
      or: $value.novelLibraryDownloadedChapters,
    ),
    novelLibraryShowLanguage: data.get(
      #novelLibraryShowLanguage,
      or: $value.novelLibraryShowLanguage,
    ),
    novelLibraryShowNumbersOfItems: data.get(
      #novelLibraryShowNumbersOfItems,
      or: $value.novelLibraryShowNumbersOfItems,
    ),
    novelLibraryShowContinueReadingButton: data.get(
      #novelLibraryShowContinueReadingButton,
      or: $value.novelLibraryShowContinueReadingButton,
    ),
    novelLibraryLocalSource: data.get(
      #novelLibraryLocalSource,
      or: $value.novelLibraryLocalSource,
    ),
    sortLibraryNovel: data.get(#sortLibraryNovel, or: $value.sortLibraryNovel),
    novelDisplayType: data.get(#novelDisplayType, or: $value.novelDisplayType),
    novelFontSize: data.get(#novelFontSize, or: $value.novelFontSize),
    novelTextAlign: data.get(#novelTextAlign, or: $value.novelTextAlign),
    navigationOrder: data.get(#navigationOrder, or: $value.navigationOrder),
    hideItems: data.get(#hideItems, or: $value.hideItems),
    clearChapterCacheOnAppLaunch: data.get(
      #clearChapterCacheOnAppLaunch,
      or: $value.clearChapterCacheOnAppLaunch,
    ),
    mangaExtensionsRepo: data.get(
      #mangaExtensionsRepo,
      or: $value.mangaExtensionsRepo,
    ),
    animeExtensionsRepo: data.get(
      #animeExtensionsRepo,
      or: $value.animeExtensionsRepo,
    ),
    novelExtensionsRepo: data.get(
      #novelExtensionsRepo,
      or: $value.novelExtensionsRepo,
    ),
    chapterFilterUnreadList: data.get(
      #chapterFilterUnreadList,
      or: $value.chapterFilterUnreadList,
    ),
    chapterFilterBookmarkedList: data.get(
      #chapterFilterBookmarkedList,
      or: $value.chapterFilterBookmarkedList,
    ),
    filterScanlatorList: data.get(
      #filterScanlatorList,
      or: $value.filterScanlatorList,
    ),
    locale: data.get(#locale, or: $value.locale),
    defaultSubtitleLang: data.get(
      #defaultSubtitleLang,
      or: $value.defaultSubtitleLang,
    ),
    novelGridSize: data.get(#novelGridSize, or: $value.novelGridSize),
  );

  @override
  MangayomiBackupSettingsCopyWith<$R2, MangayomiBackupSettings, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _MangayomiBackupSettingsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class SortLibraryMangaMapper extends ClassMapperBase<SortLibraryManga> {
  SortLibraryMangaMapper._();

  static SortLibraryMangaMapper? _instance;
  static SortLibraryMangaMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SortLibraryMangaMapper._());
      MapperContainer.globals.useAll([SecondsEpochDateTimeMapper()]);
    }
    return _instance!;
  }

  @override
  final String id = 'SortLibraryManga';

  static bool? _$reverse(SortLibraryManga v) => v.reverse;
  static const Field<SortLibraryManga, bool> _f$reverse = Field(
    'reverse',
    _$reverse,
    opt: true,
    def: false,
  );
  static int? _$index(SortLibraryManga v) => v.index;
  static const Field<SortLibraryManga, int> _f$index = Field(
    'index',
    _$index,
    opt: true,
    def: 0,
  );

  @override
  final MappableFields<SortLibraryManga> fields = const {
    #reverse: _f$reverse,
    #index: _f$index,
  };

  static SortLibraryManga _instantiate(DecodingData data) {
    return SortLibraryManga(
      reverse: data.dec(_f$reverse),
      index: data.dec(_f$index),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SortLibraryManga fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SortLibraryManga>(map);
  }

  static SortLibraryManga fromJson(String json) {
    return ensureInitialized().decodeJson<SortLibraryManga>(json);
  }
}

mixin SortLibraryMangaMappable {
  String toJson() {
    return SortLibraryMangaMapper.ensureInitialized()
        .encodeJson<SortLibraryManga>(this as SortLibraryManga);
  }

  Map<String, dynamic> toMap() {
    return SortLibraryMangaMapper.ensureInitialized()
        .encodeMap<SortLibraryManga>(this as SortLibraryManga);
  }

  SortLibraryMangaCopyWith<SortLibraryManga, SortLibraryManga, SortLibraryManga>
  get copyWith =>
      _SortLibraryMangaCopyWithImpl<SortLibraryManga, SortLibraryManga>(
        this as SortLibraryManga,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return SortLibraryMangaMapper.ensureInitialized().stringifyValue(
      this as SortLibraryManga,
    );
  }

  @override
  bool operator ==(Object other) {
    return SortLibraryMangaMapper.ensureInitialized().equalsValue(
      this as SortLibraryManga,
      other,
    );
  }

  @override
  int get hashCode {
    return SortLibraryMangaMapper.ensureInitialized().hashValue(
      this as SortLibraryManga,
    );
  }
}

extension SortLibraryMangaValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SortLibraryManga, $Out> {
  SortLibraryMangaCopyWith<$R, SortLibraryManga, $Out>
  get $asSortLibraryManga =>
      $base.as((v, t, t2) => _SortLibraryMangaCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SortLibraryMangaCopyWith<$R, $In extends SortLibraryManga, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({bool? reverse, int? index});
  SortLibraryMangaCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SortLibraryMangaCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SortLibraryManga, $Out>
    implements SortLibraryMangaCopyWith<$R, SortLibraryManga, $Out> {
  _SortLibraryMangaCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SortLibraryManga> $mapper =
      SortLibraryMangaMapper.ensureInitialized();
  @override
  $R call({Object? reverse = $none, Object? index = $none}) => $apply(
    FieldCopyWithData({
      if (reverse != $none) #reverse: reverse,
      if (index != $none) #index: index,
    }),
  );
  @override
  SortLibraryManga $make(CopyWithData data) => SortLibraryManga(
    reverse: data.get(#reverse, or: $value.reverse),
    index: data.get(#index, or: $value.index),
  );

  @override
  SortLibraryMangaCopyWith<$R2, SortLibraryManga, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SortLibraryMangaCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class SortChapterMapper extends ClassMapperBase<SortChapter> {
  SortChapterMapper._();

  static SortChapterMapper? _instance;
  static SortChapterMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SortChapterMapper._());
      MapperContainer.globals.useAll([SecondsEpochDateTimeMapper()]);
    }
    return _instance!;
  }

  @override
  final String id = 'SortChapter';

  static int? _$mangaId(SortChapter v) => v.mangaId;
  static const Field<SortChapter, int> _f$mangaId = Field(
    'mangaId',
    _$mangaId,
    opt: true,
  );
  static bool? _$reverse(SortChapter v) => v.reverse;
  static const Field<SortChapter, bool> _f$reverse = Field(
    'reverse',
    _$reverse,
    opt: true,
    def: false,
  );
  static int? _$index(SortChapter v) => v.index;
  static const Field<SortChapter, int> _f$index = Field(
    'index',
    _$index,
    opt: true,
    def: 1,
  );

  @override
  final MappableFields<SortChapter> fields = const {
    #mangaId: _f$mangaId,
    #reverse: _f$reverse,
    #index: _f$index,
  };

  static SortChapter _instantiate(DecodingData data) {
    return SortChapter(
      mangaId: data.dec(_f$mangaId),
      reverse: data.dec(_f$reverse),
      index: data.dec(_f$index),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SortChapter fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SortChapter>(map);
  }

  static SortChapter fromJson(String json) {
    return ensureInitialized().decodeJson<SortChapter>(json);
  }
}

mixin SortChapterMappable {
  String toJson() {
    return SortChapterMapper.ensureInitialized().encodeJson<SortChapter>(
      this as SortChapter,
    );
  }

  Map<String, dynamic> toMap() {
    return SortChapterMapper.ensureInitialized().encodeMap<SortChapter>(
      this as SortChapter,
    );
  }

  SortChapterCopyWith<SortChapter, SortChapter, SortChapter> get copyWith =>
      _SortChapterCopyWithImpl<SortChapter, SortChapter>(
        this as SortChapter,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return SortChapterMapper.ensureInitialized().stringifyValue(
      this as SortChapter,
    );
  }

  @override
  bool operator ==(Object other) {
    return SortChapterMapper.ensureInitialized().equalsValue(
      this as SortChapter,
      other,
    );
  }

  @override
  int get hashCode {
    return SortChapterMapper.ensureInitialized().hashValue(this as SortChapter);
  }
}

extension SortChapterValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SortChapter, $Out> {
  SortChapterCopyWith<$R, SortChapter, $Out> get $asSortChapter =>
      $base.as((v, t, t2) => _SortChapterCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SortChapterCopyWith<$R, $In extends SortChapter, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({int? mangaId, bool? reverse, int? index});
  SortChapterCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _SortChapterCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SortChapter, $Out>
    implements SortChapterCopyWith<$R, SortChapter, $Out> {
  _SortChapterCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SortChapter> $mapper =
      SortChapterMapper.ensureInitialized();
  @override
  $R call({
    Object? mangaId = $none,
    Object? reverse = $none,
    Object? index = $none,
  }) => $apply(
    FieldCopyWithData({
      if (mangaId != $none) #mangaId: mangaId,
      if (reverse != $none) #reverse: reverse,
      if (index != $none) #index: index,
    }),
  );
  @override
  SortChapter $make(CopyWithData data) => SortChapter(
    mangaId: data.get(#mangaId, or: $value.mangaId),
    reverse: data.get(#reverse, or: $value.reverse),
    index: data.get(#index, or: $value.index),
  );

  @override
  SortChapterCopyWith<$R2, SortChapter, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SortChapterCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ChapterFilterDownloadedMapper
    extends ClassMapperBase<ChapterFilterDownloaded> {
  ChapterFilterDownloadedMapper._();

  static ChapterFilterDownloadedMapper? _instance;
  static ChapterFilterDownloadedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = ChapterFilterDownloadedMapper._(),
      );
      MapperContainer.globals.useAll([SecondsEpochDateTimeMapper()]);
    }
    return _instance!;
  }

  @override
  final String id = 'ChapterFilterDownloaded';

  static int? _$mangaId(ChapterFilterDownloaded v) => v.mangaId;
  static const Field<ChapterFilterDownloaded, int> _f$mangaId = Field(
    'mangaId',
    _$mangaId,
    opt: true,
  );
  static int? _$type(ChapterFilterDownloaded v) => v.type;
  static const Field<ChapterFilterDownloaded, int> _f$type = Field(
    'type',
    _$type,
    opt: true,
    def: 0,
  );

  @override
  final MappableFields<ChapterFilterDownloaded> fields = const {
    #mangaId: _f$mangaId,
    #type: _f$type,
  };

  static ChapterFilterDownloaded _instantiate(DecodingData data) {
    return ChapterFilterDownloaded(
      mangaId: data.dec(_f$mangaId),
      type: data.dec(_f$type),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ChapterFilterDownloaded fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ChapterFilterDownloaded>(map);
  }

  static ChapterFilterDownloaded fromJson(String json) {
    return ensureInitialized().decodeJson<ChapterFilterDownloaded>(json);
  }
}

mixin ChapterFilterDownloadedMappable {
  String toJson() {
    return ChapterFilterDownloadedMapper.ensureInitialized()
        .encodeJson<ChapterFilterDownloaded>(this as ChapterFilterDownloaded);
  }

  Map<String, dynamic> toMap() {
    return ChapterFilterDownloadedMapper.ensureInitialized()
        .encodeMap<ChapterFilterDownloaded>(this as ChapterFilterDownloaded);
  }

  ChapterFilterDownloadedCopyWith<
    ChapterFilterDownloaded,
    ChapterFilterDownloaded,
    ChapterFilterDownloaded
  >
  get copyWith =>
      _ChapterFilterDownloadedCopyWithImpl<
        ChapterFilterDownloaded,
        ChapterFilterDownloaded
      >(this as ChapterFilterDownloaded, $identity, $identity);
  @override
  String toString() {
    return ChapterFilterDownloadedMapper.ensureInitialized().stringifyValue(
      this as ChapterFilterDownloaded,
    );
  }

  @override
  bool operator ==(Object other) {
    return ChapterFilterDownloadedMapper.ensureInitialized().equalsValue(
      this as ChapterFilterDownloaded,
      other,
    );
  }

  @override
  int get hashCode {
    return ChapterFilterDownloadedMapper.ensureInitialized().hashValue(
      this as ChapterFilterDownloaded,
    );
  }
}

extension ChapterFilterDownloadedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ChapterFilterDownloaded, $Out> {
  ChapterFilterDownloadedCopyWith<$R, ChapterFilterDownloaded, $Out>
  get $asChapterFilterDownloaded => $base.as(
    (v, t, t2) => _ChapterFilterDownloadedCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class ChapterFilterDownloadedCopyWith<
  $R,
  $In extends ChapterFilterDownloaded,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({int? mangaId, int? type});
  ChapterFilterDownloadedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ChapterFilterDownloadedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ChapterFilterDownloaded, $Out>
    implements
        ChapterFilterDownloadedCopyWith<$R, ChapterFilterDownloaded, $Out> {
  _ChapterFilterDownloadedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ChapterFilterDownloaded> $mapper =
      ChapterFilterDownloadedMapper.ensureInitialized();
  @override
  $R call({Object? mangaId = $none, Object? type = $none}) => $apply(
    FieldCopyWithData({
      if (mangaId != $none) #mangaId: mangaId,
      if (type != $none) #type: type,
    }),
  );
  @override
  ChapterFilterDownloaded $make(CopyWithData data) => ChapterFilterDownloaded(
    mangaId: data.get(#mangaId, or: $value.mangaId),
    type: data.get(#type, or: $value.type),
  );

  @override
  ChapterFilterDownloadedCopyWith<$R2, ChapterFilterDownloaded, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _ChapterFilterDownloadedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ChapterPageurlsMapper extends ClassMapperBase<ChapterPageurls> {
  ChapterPageurlsMapper._();

  static ChapterPageurlsMapper? _instance;
  static ChapterPageurlsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ChapterPageurlsMapper._());
      MapperContainer.globals.useAll([SecondsEpochDateTimeMapper()]);
    }
    return _instance!;
  }

  @override
  final String id = 'ChapterPageurls';

  static int? _$chapterId(ChapterPageurls v) => v.chapterId;
  static const Field<ChapterPageurls, int> _f$chapterId = Field(
    'chapterId',
    _$chapterId,
    opt: true,
  );
  static List<String>? _$urls(ChapterPageurls v) => v.urls;
  static const Field<ChapterPageurls, List<String>> _f$urls = Field(
    'urls',
    _$urls,
    opt: true,
  );
  static List<String>? _$headers(ChapterPageurls v) => v.headers;
  static const Field<ChapterPageurls, List<String>> _f$headers = Field(
    'headers',
    _$headers,
    opt: true,
  );

  @override
  final MappableFields<ChapterPageurls> fields = const {
    #chapterId: _f$chapterId,
    #urls: _f$urls,
    #headers: _f$headers,
  };

  static ChapterPageurls _instantiate(DecodingData data) {
    return ChapterPageurls(
      chapterId: data.dec(_f$chapterId),
      urls: data.dec(_f$urls),
      headers: data.dec(_f$headers),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ChapterPageurls fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ChapterPageurls>(map);
  }

  static ChapterPageurls fromJson(String json) {
    return ensureInitialized().decodeJson<ChapterPageurls>(json);
  }
}

mixin ChapterPageurlsMappable {
  String toJson() {
    return ChapterPageurlsMapper.ensureInitialized()
        .encodeJson<ChapterPageurls>(this as ChapterPageurls);
  }

  Map<String, dynamic> toMap() {
    return ChapterPageurlsMapper.ensureInitialized().encodeMap<ChapterPageurls>(
      this as ChapterPageurls,
    );
  }

  ChapterPageurlsCopyWith<ChapterPageurls, ChapterPageurls, ChapterPageurls>
  get copyWith =>
      _ChapterPageurlsCopyWithImpl<ChapterPageurls, ChapterPageurls>(
        this as ChapterPageurls,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ChapterPageurlsMapper.ensureInitialized().stringifyValue(
      this as ChapterPageurls,
    );
  }

  @override
  bool operator ==(Object other) {
    return ChapterPageurlsMapper.ensureInitialized().equalsValue(
      this as ChapterPageurls,
      other,
    );
  }

  @override
  int get hashCode {
    return ChapterPageurlsMapper.ensureInitialized().hashValue(
      this as ChapterPageurls,
    );
  }
}

extension ChapterPageurlsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ChapterPageurls, $Out> {
  ChapterPageurlsCopyWith<$R, ChapterPageurls, $Out> get $asChapterPageurls =>
      $base.as((v, t, t2) => _ChapterPageurlsCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ChapterPageurlsCopyWith<$R, $In extends ChapterPageurls, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>? get urls;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>? get headers;
  $R call({int? chapterId, List<String>? urls, List<String>? headers});
  ChapterPageurlsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ChapterPageurlsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ChapterPageurls, $Out>
    implements ChapterPageurlsCopyWith<$R, ChapterPageurls, $Out> {
  _ChapterPageurlsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ChapterPageurls> $mapper =
      ChapterPageurlsMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>? get urls =>
      $value.urls != null
      ? ListCopyWith(
          $value.urls!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(urls: v),
        )
      : null;
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>? get headers =>
      $value.headers != null
      ? ListCopyWith(
          $value.headers!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(headers: v),
        )
      : null;
  @override
  $R call({
    Object? chapterId = $none,
    Object? urls = $none,
    Object? headers = $none,
  }) => $apply(
    FieldCopyWithData({
      if (chapterId != $none) #chapterId: chapterId,
      if (urls != $none) #urls: urls,
      if (headers != $none) #headers: headers,
    }),
  );
  @override
  ChapterPageurls $make(CopyWithData data) => ChapterPageurls(
    chapterId: data.get(#chapterId, or: $value.chapterId),
    urls: data.get(#urls, or: $value.urls),
    headers: data.get(#headers, or: $value.headers),
  );

  @override
  ChapterPageurlsCopyWith<$R2, ChapterPageurls, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ChapterPageurlsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ChapterPageIndexMapper extends ClassMapperBase<ChapterPageIndex> {
  ChapterPageIndexMapper._();

  static ChapterPageIndexMapper? _instance;
  static ChapterPageIndexMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ChapterPageIndexMapper._());
      MapperContainer.globals.useAll([SecondsEpochDateTimeMapper()]);
    }
    return _instance!;
  }

  @override
  final String id = 'ChapterPageIndex';

  static int? _$chapterId(ChapterPageIndex v) => v.chapterId;
  static const Field<ChapterPageIndex, int> _f$chapterId = Field(
    'chapterId',
    _$chapterId,
    opt: true,
  );
  static int? _$index(ChapterPageIndex v) => v.index;
  static const Field<ChapterPageIndex, int> _f$index = Field(
    'index',
    _$index,
    opt: true,
  );

  @override
  final MappableFields<ChapterPageIndex> fields = const {
    #chapterId: _f$chapterId,
    #index: _f$index,
  };

  static ChapterPageIndex _instantiate(DecodingData data) {
    return ChapterPageIndex(
      chapterId: data.dec(_f$chapterId),
      index: data.dec(_f$index),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ChapterPageIndex fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ChapterPageIndex>(map);
  }

  static ChapterPageIndex fromJson(String json) {
    return ensureInitialized().decodeJson<ChapterPageIndex>(json);
  }
}

mixin ChapterPageIndexMappable {
  String toJson() {
    return ChapterPageIndexMapper.ensureInitialized()
        .encodeJson<ChapterPageIndex>(this as ChapterPageIndex);
  }

  Map<String, dynamic> toMap() {
    return ChapterPageIndexMapper.ensureInitialized()
        .encodeMap<ChapterPageIndex>(this as ChapterPageIndex);
  }

  ChapterPageIndexCopyWith<ChapterPageIndex, ChapterPageIndex, ChapterPageIndex>
  get copyWith =>
      _ChapterPageIndexCopyWithImpl<ChapterPageIndex, ChapterPageIndex>(
        this as ChapterPageIndex,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ChapterPageIndexMapper.ensureInitialized().stringifyValue(
      this as ChapterPageIndex,
    );
  }

  @override
  bool operator ==(Object other) {
    return ChapterPageIndexMapper.ensureInitialized().equalsValue(
      this as ChapterPageIndex,
      other,
    );
  }

  @override
  int get hashCode {
    return ChapterPageIndexMapper.ensureInitialized().hashValue(
      this as ChapterPageIndex,
    );
  }
}

extension ChapterPageIndexValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ChapterPageIndex, $Out> {
  ChapterPageIndexCopyWith<$R, ChapterPageIndex, $Out>
  get $asChapterPageIndex =>
      $base.as((v, t, t2) => _ChapterPageIndexCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ChapterPageIndexCopyWith<$R, $In extends ChapterPageIndex, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({int? chapterId, int? index});
  ChapterPageIndexCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ChapterPageIndexCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ChapterPageIndex, $Out>
    implements ChapterPageIndexCopyWith<$R, ChapterPageIndex, $Out> {
  _ChapterPageIndexCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ChapterPageIndex> $mapper =
      ChapterPageIndexMapper.ensureInitialized();
  @override
  $R call({Object? chapterId = $none, Object? index = $none}) => $apply(
    FieldCopyWithData({
      if (chapterId != $none) #chapterId: chapterId,
      if (index != $none) #index: index,
    }),
  );
  @override
  ChapterPageIndex $make(CopyWithData data) => ChapterPageIndex(
    chapterId: data.get(#chapterId, or: $value.chapterId),
    index: data.get(#index, or: $value.index),
  );

  @override
  ChapterPageIndexCopyWith<$R2, ChapterPageIndex, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ChapterPageIndexCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class MCookieMapper extends ClassMapperBase<MCookie> {
  MCookieMapper._();

  static MCookieMapper? _instance;
  static MCookieMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MCookieMapper._());
      MapperContainer.globals.useAll([SecondsEpochDateTimeMapper()]);
    }
    return _instance!;
  }

  @override
  final String id = 'MCookie';

  static String? _$host(MCookie v) => v.host;
  static const Field<MCookie, String> _f$host = Field(
    'host',
    _$host,
    opt: true,
  );
  static String? _$cookie(MCookie v) => v.cookie;
  static const Field<MCookie, String> _f$cookie = Field(
    'cookie',
    _$cookie,
    opt: true,
  );

  @override
  final MappableFields<MCookie> fields = const {
    #host: _f$host,
    #cookie: _f$cookie,
  };

  static MCookie _instantiate(DecodingData data) {
    return MCookie(host: data.dec(_f$host), cookie: data.dec(_f$cookie));
  }

  @override
  final Function instantiate = _instantiate;

  static MCookie fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MCookie>(map);
  }

  static MCookie fromJson(String json) {
    return ensureInitialized().decodeJson<MCookie>(json);
  }
}

mixin MCookieMappable {
  String toJson() {
    return MCookieMapper.ensureInitialized().encodeJson<MCookie>(
      this as MCookie,
    );
  }

  Map<String, dynamic> toMap() {
    return MCookieMapper.ensureInitialized().encodeMap<MCookie>(
      this as MCookie,
    );
  }

  MCookieCopyWith<MCookie, MCookie, MCookie> get copyWith =>
      _MCookieCopyWithImpl<MCookie, MCookie>(
        this as MCookie,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return MCookieMapper.ensureInitialized().stringifyValue(this as MCookie);
  }

  @override
  bool operator ==(Object other) {
    return MCookieMapper.ensureInitialized().equalsValue(
      this as MCookie,
      other,
    );
  }

  @override
  int get hashCode {
    return MCookieMapper.ensureInitialized().hashValue(this as MCookie);
  }
}

extension MCookieValueCopy<$R, $Out> on ObjectCopyWith<$R, MCookie, $Out> {
  MCookieCopyWith<$R, MCookie, $Out> get $asMCookie =>
      $base.as((v, t, t2) => _MCookieCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MCookieCopyWith<$R, $In extends MCookie, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? host, String? cookie});
  MCookieCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MCookieCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MCookie, $Out>
    implements MCookieCopyWith<$R, MCookie, $Out> {
  _MCookieCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MCookie> $mapper =
      MCookieMapper.ensureInitialized();
  @override
  $R call({Object? host = $none, Object? cookie = $none}) => $apply(
    FieldCopyWithData({
      if (host != $none) #host: host,
      if (cookie != $none) #cookie: cookie,
    }),
  );
  @override
  MCookie $make(CopyWithData data) => MCookie(
    host: data.get(#host, or: $value.host),
    cookie: data.get(#cookie, or: $value.cookie),
  );

  @override
  MCookieCopyWith<$R2, MCookie, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _MCookieCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class PersonalReaderModeMapper extends ClassMapperBase<PersonalReaderMode> {
  PersonalReaderModeMapper._();

  static PersonalReaderModeMapper? _instance;
  static PersonalReaderModeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PersonalReaderModeMapper._());
      MapperContainer.globals.useAll([SecondsEpochDateTimeMapper()]);
      ReaderModeMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'PersonalReaderMode';

  static int? _$mangaId(PersonalReaderMode v) => v.mangaId;
  static const Field<PersonalReaderMode, int> _f$mangaId = Field(
    'mangaId',
    _$mangaId,
    opt: true,
  );
  static ReaderMode _$readerMode(PersonalReaderMode v) => v.readerMode;
  static const Field<PersonalReaderMode, ReaderMode> _f$readerMode = Field(
    'readerMode',
    _$readerMode,
    opt: true,
    def: ReaderMode.vertical,
  );

  @override
  final MappableFields<PersonalReaderMode> fields = const {
    #mangaId: _f$mangaId,
    #readerMode: _f$readerMode,
  };

  static PersonalReaderMode _instantiate(DecodingData data) {
    return PersonalReaderMode(
      mangaId: data.dec(_f$mangaId),
      readerMode: data.dec(_f$readerMode),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PersonalReaderMode fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PersonalReaderMode>(map);
  }

  static PersonalReaderMode fromJson(String json) {
    return ensureInitialized().decodeJson<PersonalReaderMode>(json);
  }
}

mixin PersonalReaderModeMappable {
  String toJson() {
    return PersonalReaderModeMapper.ensureInitialized()
        .encodeJson<PersonalReaderMode>(this as PersonalReaderMode);
  }

  Map<String, dynamic> toMap() {
    return PersonalReaderModeMapper.ensureInitialized()
        .encodeMap<PersonalReaderMode>(this as PersonalReaderMode);
  }

  PersonalReaderModeCopyWith<
    PersonalReaderMode,
    PersonalReaderMode,
    PersonalReaderMode
  >
  get copyWith =>
      _PersonalReaderModeCopyWithImpl<PersonalReaderMode, PersonalReaderMode>(
        this as PersonalReaderMode,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return PersonalReaderModeMapper.ensureInitialized().stringifyValue(
      this as PersonalReaderMode,
    );
  }

  @override
  bool operator ==(Object other) {
    return PersonalReaderModeMapper.ensureInitialized().equalsValue(
      this as PersonalReaderMode,
      other,
    );
  }

  @override
  int get hashCode {
    return PersonalReaderModeMapper.ensureInitialized().hashValue(
      this as PersonalReaderMode,
    );
  }
}

extension PersonalReaderModeValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PersonalReaderMode, $Out> {
  PersonalReaderModeCopyWith<$R, PersonalReaderMode, $Out>
  get $asPersonalReaderMode => $base.as(
    (v, t, t2) => _PersonalReaderModeCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class PersonalReaderModeCopyWith<
  $R,
  $In extends PersonalReaderMode,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({int? mangaId, ReaderMode? readerMode});
  PersonalReaderModeCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PersonalReaderModeCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PersonalReaderMode, $Out>
    implements PersonalReaderModeCopyWith<$R, PersonalReaderMode, $Out> {
  _PersonalReaderModeCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PersonalReaderMode> $mapper =
      PersonalReaderModeMapper.ensureInitialized();
  @override
  $R call({Object? mangaId = $none, ReaderMode? readerMode}) => $apply(
    FieldCopyWithData({
      if (mangaId != $none) #mangaId: mangaId,
      if (readerMode != null) #readerMode: readerMode,
    }),
  );
  @override
  PersonalReaderMode $make(CopyWithData data) => PersonalReaderMode(
    mangaId: data.get(#mangaId, or: $value.mangaId),
    readerMode: data.get(#readerMode, or: $value.readerMode),
  );

  @override
  PersonalReaderModeCopyWith<$R2, PersonalReaderMode, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _PersonalReaderModeCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class PersonalPageModeMapper extends ClassMapperBase<PersonalPageMode> {
  PersonalPageModeMapper._();

  static PersonalPageModeMapper? _instance;
  static PersonalPageModeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PersonalPageModeMapper._());
      MapperContainer.globals.useAll([SecondsEpochDateTimeMapper()]);
      PageModeMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'PersonalPageMode';

  static int? _$mangaId(PersonalPageMode v) => v.mangaId;
  static const Field<PersonalPageMode, int> _f$mangaId = Field(
    'mangaId',
    _$mangaId,
    opt: true,
  );
  static PageMode _$pageMode(PersonalPageMode v) => v.pageMode;
  static const Field<PersonalPageMode, PageMode> _f$pageMode = Field(
    'pageMode',
    _$pageMode,
    opt: true,
    def: PageMode.onePage,
  );

  @override
  final MappableFields<PersonalPageMode> fields = const {
    #mangaId: _f$mangaId,
    #pageMode: _f$pageMode,
  };

  static PersonalPageMode _instantiate(DecodingData data) {
    return PersonalPageMode(
      mangaId: data.dec(_f$mangaId),
      pageMode: data.dec(_f$pageMode),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PersonalPageMode fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PersonalPageMode>(map);
  }

  static PersonalPageMode fromJson(String json) {
    return ensureInitialized().decodeJson<PersonalPageMode>(json);
  }
}

mixin PersonalPageModeMappable {
  String toJson() {
    return PersonalPageModeMapper.ensureInitialized()
        .encodeJson<PersonalPageMode>(this as PersonalPageMode);
  }

  Map<String, dynamic> toMap() {
    return PersonalPageModeMapper.ensureInitialized()
        .encodeMap<PersonalPageMode>(this as PersonalPageMode);
  }

  PersonalPageModeCopyWith<PersonalPageMode, PersonalPageMode, PersonalPageMode>
  get copyWith =>
      _PersonalPageModeCopyWithImpl<PersonalPageMode, PersonalPageMode>(
        this as PersonalPageMode,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return PersonalPageModeMapper.ensureInitialized().stringifyValue(
      this as PersonalPageMode,
    );
  }

  @override
  bool operator ==(Object other) {
    return PersonalPageModeMapper.ensureInitialized().equalsValue(
      this as PersonalPageMode,
      other,
    );
  }

  @override
  int get hashCode {
    return PersonalPageModeMapper.ensureInitialized().hashValue(
      this as PersonalPageMode,
    );
  }
}

extension PersonalPageModeValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PersonalPageMode, $Out> {
  PersonalPageModeCopyWith<$R, PersonalPageMode, $Out>
  get $asPersonalPageMode =>
      $base.as((v, t, t2) => _PersonalPageModeCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class PersonalPageModeCopyWith<$R, $In extends PersonalPageMode, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({int? mangaId, PageMode? pageMode});
  PersonalPageModeCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PersonalPageModeCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PersonalPageMode, $Out>
    implements PersonalPageModeCopyWith<$R, PersonalPageMode, $Out> {
  _PersonalPageModeCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PersonalPageMode> $mapper =
      PersonalPageModeMapper.ensureInitialized();
  @override
  $R call({Object? mangaId = $none, PageMode? pageMode}) => $apply(
    FieldCopyWithData({
      if (mangaId != $none) #mangaId: mangaId,
      if (pageMode != null) #pageMode: pageMode,
    }),
  );
  @override
  PersonalPageMode $make(CopyWithData data) => PersonalPageMode(
    mangaId: data.get(#mangaId, or: $value.mangaId),
    pageMode: data.get(#pageMode, or: $value.pageMode),
  );

  @override
  PersonalPageModeCopyWith<$R2, PersonalPageMode, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _PersonalPageModeCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class AutoScrollPagesMapper extends ClassMapperBase<AutoScrollPages> {
  AutoScrollPagesMapper._();

  static AutoScrollPagesMapper? _instance;
  static AutoScrollPagesMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AutoScrollPagesMapper._());
      MapperContainer.globals.useAll([SecondsEpochDateTimeMapper()]);
    }
    return _instance!;
  }

  @override
  final String id = 'AutoScrollPages';

  static int? _$mangaId(AutoScrollPages v) => v.mangaId;
  static const Field<AutoScrollPages, int> _f$mangaId = Field(
    'mangaId',
    _$mangaId,
    opt: true,
  );
  static double? _$pageOffset(AutoScrollPages v) => v.pageOffset;
  static const Field<AutoScrollPages, double> _f$pageOffset = Field(
    'pageOffset',
    _$pageOffset,
    opt: true,
    def: 10,
  );
  static bool? _$autoScroll(AutoScrollPages v) => v.autoScroll;
  static const Field<AutoScrollPages, bool> _f$autoScroll = Field(
    'autoScroll',
    _$autoScroll,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<AutoScrollPages> fields = const {
    #mangaId: _f$mangaId,
    #pageOffset: _f$pageOffset,
    #autoScroll: _f$autoScroll,
  };

  static AutoScrollPages _instantiate(DecodingData data) {
    return AutoScrollPages(
      mangaId: data.dec(_f$mangaId),
      pageOffset: data.dec(_f$pageOffset),
      autoScroll: data.dec(_f$autoScroll),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AutoScrollPages fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AutoScrollPages>(map);
  }

  static AutoScrollPages fromJson(String json) {
    return ensureInitialized().decodeJson<AutoScrollPages>(json);
  }
}

mixin AutoScrollPagesMappable {
  String toJson() {
    return AutoScrollPagesMapper.ensureInitialized()
        .encodeJson<AutoScrollPages>(this as AutoScrollPages);
  }

  Map<String, dynamic> toMap() {
    return AutoScrollPagesMapper.ensureInitialized().encodeMap<AutoScrollPages>(
      this as AutoScrollPages,
    );
  }

  AutoScrollPagesCopyWith<AutoScrollPages, AutoScrollPages, AutoScrollPages>
  get copyWith =>
      _AutoScrollPagesCopyWithImpl<AutoScrollPages, AutoScrollPages>(
        this as AutoScrollPages,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return AutoScrollPagesMapper.ensureInitialized().stringifyValue(
      this as AutoScrollPages,
    );
  }

  @override
  bool operator ==(Object other) {
    return AutoScrollPagesMapper.ensureInitialized().equalsValue(
      this as AutoScrollPages,
      other,
    );
  }

  @override
  int get hashCode {
    return AutoScrollPagesMapper.ensureInitialized().hashValue(
      this as AutoScrollPages,
    );
  }
}

extension AutoScrollPagesValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AutoScrollPages, $Out> {
  AutoScrollPagesCopyWith<$R, AutoScrollPages, $Out> get $asAutoScrollPages =>
      $base.as((v, t, t2) => _AutoScrollPagesCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AutoScrollPagesCopyWith<$R, $In extends AutoScrollPages, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({int? mangaId, double? pageOffset, bool? autoScroll});
  AutoScrollPagesCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _AutoScrollPagesCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AutoScrollPages, $Out>
    implements AutoScrollPagesCopyWith<$R, AutoScrollPages, $Out> {
  _AutoScrollPagesCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AutoScrollPages> $mapper =
      AutoScrollPagesMapper.ensureInitialized();
  @override
  $R call({
    Object? mangaId = $none,
    Object? pageOffset = $none,
    Object? autoScroll = $none,
  }) => $apply(
    FieldCopyWithData({
      if (mangaId != $none) #mangaId: mangaId,
      if (pageOffset != $none) #pageOffset: pageOffset,
      if (autoScroll != $none) #autoScroll: autoScroll,
    }),
  );
  @override
  AutoScrollPages $make(CopyWithData data) => AutoScrollPages(
    mangaId: data.get(#mangaId, or: $value.mangaId),
    pageOffset: data.get(#pageOffset, or: $value.pageOffset),
    autoScroll: data.get(#autoScroll, or: $value.autoScroll),
  );

  @override
  AutoScrollPagesCopyWith<$R2, AutoScrollPages, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _AutoScrollPagesCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class CustomColorFilterMapper extends ClassMapperBase<CustomColorFilter> {
  CustomColorFilterMapper._();

  static CustomColorFilterMapper? _instance;
  static CustomColorFilterMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CustomColorFilterMapper._());
      MapperContainer.globals.useAll([SecondsEpochDateTimeMapper()]);
    }
    return _instance!;
  }

  @override
  final String id = 'CustomColorFilter';

  static int? _$a(CustomColorFilter v) => v.a;
  static const Field<CustomColorFilter, int> _f$a = Field('a', _$a, opt: true);
  static int? _$r(CustomColorFilter v) => v.r;
  static const Field<CustomColorFilter, int> _f$r = Field('r', _$r, opt: true);
  static int? _$g(CustomColorFilter v) => v.g;
  static const Field<CustomColorFilter, int> _f$g = Field('g', _$g, opt: true);
  static int? _$b(CustomColorFilter v) => v.b;
  static const Field<CustomColorFilter, int> _f$b = Field('b', _$b, opt: true);

  @override
  final MappableFields<CustomColorFilter> fields = const {
    #a: _f$a,
    #r: _f$r,
    #g: _f$g,
    #b: _f$b,
  };

  static CustomColorFilter _instantiate(DecodingData data) {
    return CustomColorFilter(
      a: data.dec(_f$a),
      r: data.dec(_f$r),
      g: data.dec(_f$g),
      b: data.dec(_f$b),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static CustomColorFilter fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<CustomColorFilter>(map);
  }

  static CustomColorFilter fromJson(String json) {
    return ensureInitialized().decodeJson<CustomColorFilter>(json);
  }
}

mixin CustomColorFilterMappable {
  String toJson() {
    return CustomColorFilterMapper.ensureInitialized()
        .encodeJson<CustomColorFilter>(this as CustomColorFilter);
  }

  Map<String, dynamic> toMap() {
    return CustomColorFilterMapper.ensureInitialized()
        .encodeMap<CustomColorFilter>(this as CustomColorFilter);
  }

  CustomColorFilterCopyWith<
    CustomColorFilter,
    CustomColorFilter,
    CustomColorFilter
  >
  get copyWith =>
      _CustomColorFilterCopyWithImpl<CustomColorFilter, CustomColorFilter>(
        this as CustomColorFilter,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return CustomColorFilterMapper.ensureInitialized().stringifyValue(
      this as CustomColorFilter,
    );
  }

  @override
  bool operator ==(Object other) {
    return CustomColorFilterMapper.ensureInitialized().equalsValue(
      this as CustomColorFilter,
      other,
    );
  }

  @override
  int get hashCode {
    return CustomColorFilterMapper.ensureInitialized().hashValue(
      this as CustomColorFilter,
    );
  }
}

extension CustomColorFilterValueCopy<$R, $Out>
    on ObjectCopyWith<$R, CustomColorFilter, $Out> {
  CustomColorFilterCopyWith<$R, CustomColorFilter, $Out>
  get $asCustomColorFilter => $base.as(
    (v, t, t2) => _CustomColorFilterCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class CustomColorFilterCopyWith<
  $R,
  $In extends CustomColorFilter,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({int? a, int? r, int? g, int? b});
  CustomColorFilterCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _CustomColorFilterCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, CustomColorFilter, $Out>
    implements CustomColorFilterCopyWith<$R, CustomColorFilter, $Out> {
  _CustomColorFilterCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<CustomColorFilter> $mapper =
      CustomColorFilterMapper.ensureInitialized();
  @override
  $R call({
    Object? a = $none,
    Object? r = $none,
    Object? g = $none,
    Object? b = $none,
  }) => $apply(
    FieldCopyWithData({
      if (a != $none) #a: a,
      if (r != $none) #r: r,
      if (g != $none) #g: g,
      if (b != $none) #b: b,
    }),
  );
  @override
  CustomColorFilter $make(CopyWithData data) => CustomColorFilter(
    a: data.get(#a, or: $value.a),
    r: data.get(#r, or: $value.r),
    g: data.get(#g, or: $value.g),
    b: data.get(#b, or: $value.b),
  );

  @override
  CustomColorFilterCopyWith<$R2, CustomColorFilter, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _CustomColorFilterCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class PlayerSubtitleSettingsMapper
    extends ClassMapperBase<PlayerSubtitleSettings> {
  PlayerSubtitleSettingsMapper._();

  static PlayerSubtitleSettingsMapper? _instance;
  static PlayerSubtitleSettingsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PlayerSubtitleSettingsMapper._());
      MapperContainer.globals.useAll([SecondsEpochDateTimeMapper()]);
    }
    return _instance!;
  }

  @override
  final String id = 'PlayerSubtitleSettings';

  static int? _$fontSize(PlayerSubtitleSettings v) => v.fontSize;
  static const Field<PlayerSubtitleSettings, int> _f$fontSize = Field(
    'fontSize',
    _$fontSize,
    opt: true,
    def: 45,
  );
  static bool? _$useBold(PlayerSubtitleSettings v) => v.useBold;
  static const Field<PlayerSubtitleSettings, bool> _f$useBold = Field(
    'useBold',
    _$useBold,
    opt: true,
    def: true,
  );
  static bool? _$useItalic(PlayerSubtitleSettings v) => v.useItalic;
  static const Field<PlayerSubtitleSettings, bool> _f$useItalic = Field(
    'useItalic',
    _$useItalic,
    opt: true,
    def: false,
  );
  static int? _$textColorA(PlayerSubtitleSettings v) => v.textColorA;
  static const Field<PlayerSubtitleSettings, int> _f$textColorA = Field(
    'textColorA',
    _$textColorA,
    opt: true,
    def: 255,
  );
  static int? _$textColorR(PlayerSubtitleSettings v) => v.textColorR;
  static const Field<PlayerSubtitleSettings, int> _f$textColorR = Field(
    'textColorR',
    _$textColorR,
    opt: true,
    def: 255,
  );
  static int? _$textColorG(PlayerSubtitleSettings v) => v.textColorG;
  static const Field<PlayerSubtitleSettings, int> _f$textColorG = Field(
    'textColorG',
    _$textColorG,
    opt: true,
    def: 255,
  );
  static int? _$textColorB(PlayerSubtitleSettings v) => v.textColorB;
  static const Field<PlayerSubtitleSettings, int> _f$textColorB = Field(
    'textColorB',
    _$textColorB,
    opt: true,
    def: 255,
  );
  static int? _$borderColorA(PlayerSubtitleSettings v) => v.borderColorA;
  static const Field<PlayerSubtitleSettings, int> _f$borderColorA = Field(
    'borderColorA',
    _$borderColorA,
    opt: true,
    def: 255,
  );
  static int? _$borderColorR(PlayerSubtitleSettings v) => v.borderColorR;
  static const Field<PlayerSubtitleSettings, int> _f$borderColorR = Field(
    'borderColorR',
    _$borderColorR,
    opt: true,
    def: 0,
  );
  static int? _$borderColorG(PlayerSubtitleSettings v) => v.borderColorG;
  static const Field<PlayerSubtitleSettings, int> _f$borderColorG = Field(
    'borderColorG',
    _$borderColorG,
    opt: true,
    def: 0,
  );
  static int? _$borderColorB(PlayerSubtitleSettings v) => v.borderColorB;
  static const Field<PlayerSubtitleSettings, int> _f$borderColorB = Field(
    'borderColorB',
    _$borderColorB,
    opt: true,
    def: 0,
  );
  static int? _$backgroundColorA(PlayerSubtitleSettings v) =>
      v.backgroundColorA;
  static const Field<PlayerSubtitleSettings, int> _f$backgroundColorA = Field(
    'backgroundColorA',
    _$backgroundColorA,
    opt: true,
    def: 0,
  );
  static int? _$backgroundColorR(PlayerSubtitleSettings v) =>
      v.backgroundColorR;
  static const Field<PlayerSubtitleSettings, int> _f$backgroundColorR = Field(
    'backgroundColorR',
    _$backgroundColorR,
    opt: true,
    def: 0,
  );
  static int? _$backgroundColorG(PlayerSubtitleSettings v) =>
      v.backgroundColorG;
  static const Field<PlayerSubtitleSettings, int> _f$backgroundColorG = Field(
    'backgroundColorG',
    _$backgroundColorG,
    opt: true,
    def: 0,
  );
  static int? _$backgroundColorB(PlayerSubtitleSettings v) =>
      v.backgroundColorB;
  static const Field<PlayerSubtitleSettings, int> _f$backgroundColorB = Field(
    'backgroundColorB',
    _$backgroundColorB,
    opt: true,
    def: 0,
  );

  @override
  final MappableFields<PlayerSubtitleSettings> fields = const {
    #fontSize: _f$fontSize,
    #useBold: _f$useBold,
    #useItalic: _f$useItalic,
    #textColorA: _f$textColorA,
    #textColorR: _f$textColorR,
    #textColorG: _f$textColorG,
    #textColorB: _f$textColorB,
    #borderColorA: _f$borderColorA,
    #borderColorR: _f$borderColorR,
    #borderColorG: _f$borderColorG,
    #borderColorB: _f$borderColorB,
    #backgroundColorA: _f$backgroundColorA,
    #backgroundColorR: _f$backgroundColorR,
    #backgroundColorG: _f$backgroundColorG,
    #backgroundColorB: _f$backgroundColorB,
  };

  static PlayerSubtitleSettings _instantiate(DecodingData data) {
    return PlayerSubtitleSettings(
      fontSize: data.dec(_f$fontSize),
      useBold: data.dec(_f$useBold),
      useItalic: data.dec(_f$useItalic),
      textColorA: data.dec(_f$textColorA),
      textColorR: data.dec(_f$textColorR),
      textColorG: data.dec(_f$textColorG),
      textColorB: data.dec(_f$textColorB),
      borderColorA: data.dec(_f$borderColorA),
      borderColorR: data.dec(_f$borderColorR),
      borderColorG: data.dec(_f$borderColorG),
      borderColorB: data.dec(_f$borderColorB),
      backgroundColorA: data.dec(_f$backgroundColorA),
      backgroundColorR: data.dec(_f$backgroundColorR),
      backgroundColorG: data.dec(_f$backgroundColorG),
      backgroundColorB: data.dec(_f$backgroundColorB),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PlayerSubtitleSettings fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PlayerSubtitleSettings>(map);
  }

  static PlayerSubtitleSettings fromJson(String json) {
    return ensureInitialized().decodeJson<PlayerSubtitleSettings>(json);
  }
}

mixin PlayerSubtitleSettingsMappable {
  String toJson() {
    return PlayerSubtitleSettingsMapper.ensureInitialized()
        .encodeJson<PlayerSubtitleSettings>(this as PlayerSubtitleSettings);
  }

  Map<String, dynamic> toMap() {
    return PlayerSubtitleSettingsMapper.ensureInitialized()
        .encodeMap<PlayerSubtitleSettings>(this as PlayerSubtitleSettings);
  }

  PlayerSubtitleSettingsCopyWith<
    PlayerSubtitleSettings,
    PlayerSubtitleSettings,
    PlayerSubtitleSettings
  >
  get copyWith =>
      _PlayerSubtitleSettingsCopyWithImpl<
        PlayerSubtitleSettings,
        PlayerSubtitleSettings
      >(this as PlayerSubtitleSettings, $identity, $identity);
  @override
  String toString() {
    return PlayerSubtitleSettingsMapper.ensureInitialized().stringifyValue(
      this as PlayerSubtitleSettings,
    );
  }

  @override
  bool operator ==(Object other) {
    return PlayerSubtitleSettingsMapper.ensureInitialized().equalsValue(
      this as PlayerSubtitleSettings,
      other,
    );
  }

  @override
  int get hashCode {
    return PlayerSubtitleSettingsMapper.ensureInitialized().hashValue(
      this as PlayerSubtitleSettings,
    );
  }
}

extension PlayerSubtitleSettingsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PlayerSubtitleSettings, $Out> {
  PlayerSubtitleSettingsCopyWith<$R, PlayerSubtitleSettings, $Out>
  get $asPlayerSubtitleSettings => $base.as(
    (v, t, t2) => _PlayerSubtitleSettingsCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class PlayerSubtitleSettingsCopyWith<
  $R,
  $In extends PlayerSubtitleSettings,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    int? fontSize,
    bool? useBold,
    bool? useItalic,
    int? textColorA,
    int? textColorR,
    int? textColorG,
    int? textColorB,
    int? borderColorA,
    int? borderColorR,
    int? borderColorG,
    int? borderColorB,
    int? backgroundColorA,
    int? backgroundColorR,
    int? backgroundColorG,
    int? backgroundColorB,
  });
  PlayerSubtitleSettingsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PlayerSubtitleSettingsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PlayerSubtitleSettings, $Out>
    implements
        PlayerSubtitleSettingsCopyWith<$R, PlayerSubtitleSettings, $Out> {
  _PlayerSubtitleSettingsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PlayerSubtitleSettings> $mapper =
      PlayerSubtitleSettingsMapper.ensureInitialized();
  @override
  $R call({
    Object? fontSize = $none,
    Object? useBold = $none,
    Object? useItalic = $none,
    Object? textColorA = $none,
    Object? textColorR = $none,
    Object? textColorG = $none,
    Object? textColorB = $none,
    Object? borderColorA = $none,
    Object? borderColorR = $none,
    Object? borderColorG = $none,
    Object? borderColorB = $none,
    Object? backgroundColorA = $none,
    Object? backgroundColorR = $none,
    Object? backgroundColorG = $none,
    Object? backgroundColorB = $none,
  }) => $apply(
    FieldCopyWithData({
      if (fontSize != $none) #fontSize: fontSize,
      if (useBold != $none) #useBold: useBold,
      if (useItalic != $none) #useItalic: useItalic,
      if (textColorA != $none) #textColorA: textColorA,
      if (textColorR != $none) #textColorR: textColorR,
      if (textColorG != $none) #textColorG: textColorG,
      if (textColorB != $none) #textColorB: textColorB,
      if (borderColorA != $none) #borderColorA: borderColorA,
      if (borderColorR != $none) #borderColorR: borderColorR,
      if (borderColorG != $none) #borderColorG: borderColorG,
      if (borderColorB != $none) #borderColorB: borderColorB,
      if (backgroundColorA != $none) #backgroundColorA: backgroundColorA,
      if (backgroundColorR != $none) #backgroundColorR: backgroundColorR,
      if (backgroundColorG != $none) #backgroundColorG: backgroundColorG,
      if (backgroundColorB != $none) #backgroundColorB: backgroundColorB,
    }),
  );
  @override
  PlayerSubtitleSettings $make(CopyWithData data) => PlayerSubtitleSettings(
    fontSize: data.get(#fontSize, or: $value.fontSize),
    useBold: data.get(#useBold, or: $value.useBold),
    useItalic: data.get(#useItalic, or: $value.useItalic),
    textColorA: data.get(#textColorA, or: $value.textColorA),
    textColorR: data.get(#textColorR, or: $value.textColorR),
    textColorG: data.get(#textColorG, or: $value.textColorG),
    textColorB: data.get(#textColorB, or: $value.textColorB),
    borderColorA: data.get(#borderColorA, or: $value.borderColorA),
    borderColorR: data.get(#borderColorR, or: $value.borderColorR),
    borderColorG: data.get(#borderColorG, or: $value.borderColorG),
    borderColorB: data.get(#borderColorB, or: $value.borderColorB),
    backgroundColorA: data.get(#backgroundColorA, or: $value.backgroundColorA),
    backgroundColorR: data.get(#backgroundColorR, or: $value.backgroundColorR),
    backgroundColorG: data.get(#backgroundColorG, or: $value.backgroundColorG),
    backgroundColorB: data.get(#backgroundColorB, or: $value.backgroundColorB),
  );

  @override
  PlayerSubtitleSettingsCopyWith<$R2, PlayerSubtitleSettings, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _PlayerSubtitleSettingsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class RepoMapper extends ClassMapperBase<Repo> {
  RepoMapper._();

  static RepoMapper? _instance;
  static RepoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = RepoMapper._());
      MapperContainer.globals.useAll([SecondsEpochDateTimeMapper()]);
    }
    return _instance!;
  }

  @override
  final String id = 'Repo';

  static String? _$name(Repo v) => v.name;
  static const Field<Repo, String> _f$name = Field('name', _$name, opt: true);
  static String? _$website(Repo v) => v.website;
  static const Field<Repo, String> _f$website = Field(
    'website',
    _$website,
    opt: true,
  );
  static String? _$jsonUrl(Repo v) => v.jsonUrl;
  static const Field<Repo, String> _f$jsonUrl = Field(
    'jsonUrl',
    _$jsonUrl,
    opt: true,
  );

  @override
  final MappableFields<Repo> fields = const {
    #name: _f$name,
    #website: _f$website,
    #jsonUrl: _f$jsonUrl,
  };

  static Repo _instantiate(DecodingData data) {
    return Repo(
      name: data.dec(_f$name),
      website: data.dec(_f$website),
      jsonUrl: data.dec(_f$jsonUrl),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Repo fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Repo>(map);
  }

  static Repo fromJson(String json) {
    return ensureInitialized().decodeJson<Repo>(json);
  }
}

mixin RepoMappable {
  String toJson() {
    return RepoMapper.ensureInitialized().encodeJson<Repo>(this as Repo);
  }

  Map<String, dynamic> toMap() {
    return RepoMapper.ensureInitialized().encodeMap<Repo>(this as Repo);
  }

  RepoCopyWith<Repo, Repo, Repo> get copyWith =>
      _RepoCopyWithImpl<Repo, Repo>(this as Repo, $identity, $identity);
  @override
  String toString() {
    return RepoMapper.ensureInitialized().stringifyValue(this as Repo);
  }

  @override
  bool operator ==(Object other) {
    return RepoMapper.ensureInitialized().equalsValue(this as Repo, other);
  }

  @override
  int get hashCode {
    return RepoMapper.ensureInitialized().hashValue(this as Repo);
  }
}

extension RepoValueCopy<$R, $Out> on ObjectCopyWith<$R, Repo, $Out> {
  RepoCopyWith<$R, Repo, $Out> get $asRepo =>
      $base.as((v, t, t2) => _RepoCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class RepoCopyWith<$R, $In extends Repo, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? name, String? website, String? jsonUrl});
  RepoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _RepoCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Repo, $Out>
    implements RepoCopyWith<$R, Repo, $Out> {
  _RepoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Repo> $mapper = RepoMapper.ensureInitialized();
  @override
  $R call({
    Object? name = $none,
    Object? website = $none,
    Object? jsonUrl = $none,
  }) => $apply(
    FieldCopyWithData({
      if (name != $none) #name: name,
      if (website != $none) #website: website,
      if (jsonUrl != $none) #jsonUrl: jsonUrl,
    }),
  );
  @override
  Repo $make(CopyWithData data) => Repo(
    name: data.get(#name, or: $value.name),
    website: data.get(#website, or: $value.website),
    jsonUrl: data.get(#jsonUrl, or: $value.jsonUrl),
  );

  @override
  RepoCopyWith<$R2, Repo, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _RepoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ChapterFilterUnreadMapper extends ClassMapperBase<ChapterFilterUnread> {
  ChapterFilterUnreadMapper._();

  static ChapterFilterUnreadMapper? _instance;
  static ChapterFilterUnreadMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ChapterFilterUnreadMapper._());
      MapperContainer.globals.useAll([SecondsEpochDateTimeMapper()]);
    }
    return _instance!;
  }

  @override
  final String id = 'ChapterFilterUnread';

  static int? _$mangaId(ChapterFilterUnread v) => v.mangaId;
  static const Field<ChapterFilterUnread, int> _f$mangaId = Field(
    'mangaId',
    _$mangaId,
    opt: true,
  );
  static int? _$type(ChapterFilterUnread v) => v.type;
  static const Field<ChapterFilterUnread, int> _f$type = Field(
    'type',
    _$type,
    opt: true,
    def: 0,
  );

  @override
  final MappableFields<ChapterFilterUnread> fields = const {
    #mangaId: _f$mangaId,
    #type: _f$type,
  };

  static ChapterFilterUnread _instantiate(DecodingData data) {
    return ChapterFilterUnread(
      mangaId: data.dec(_f$mangaId),
      type: data.dec(_f$type),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ChapterFilterUnread fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ChapterFilterUnread>(map);
  }

  static ChapterFilterUnread fromJson(String json) {
    return ensureInitialized().decodeJson<ChapterFilterUnread>(json);
  }
}

mixin ChapterFilterUnreadMappable {
  String toJson() {
    return ChapterFilterUnreadMapper.ensureInitialized()
        .encodeJson<ChapterFilterUnread>(this as ChapterFilterUnread);
  }

  Map<String, dynamic> toMap() {
    return ChapterFilterUnreadMapper.ensureInitialized()
        .encodeMap<ChapterFilterUnread>(this as ChapterFilterUnread);
  }

  ChapterFilterUnreadCopyWith<
    ChapterFilterUnread,
    ChapterFilterUnread,
    ChapterFilterUnread
  >
  get copyWith =>
      _ChapterFilterUnreadCopyWithImpl<
        ChapterFilterUnread,
        ChapterFilterUnread
      >(this as ChapterFilterUnread, $identity, $identity);
  @override
  String toString() {
    return ChapterFilterUnreadMapper.ensureInitialized().stringifyValue(
      this as ChapterFilterUnread,
    );
  }

  @override
  bool operator ==(Object other) {
    return ChapterFilterUnreadMapper.ensureInitialized().equalsValue(
      this as ChapterFilterUnread,
      other,
    );
  }

  @override
  int get hashCode {
    return ChapterFilterUnreadMapper.ensureInitialized().hashValue(
      this as ChapterFilterUnread,
    );
  }
}

extension ChapterFilterUnreadValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ChapterFilterUnread, $Out> {
  ChapterFilterUnreadCopyWith<$R, ChapterFilterUnread, $Out>
  get $asChapterFilterUnread => $base.as(
    (v, t, t2) => _ChapterFilterUnreadCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class ChapterFilterUnreadCopyWith<
  $R,
  $In extends ChapterFilterUnread,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({int? mangaId, int? type});
  ChapterFilterUnreadCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ChapterFilterUnreadCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ChapterFilterUnread, $Out>
    implements ChapterFilterUnreadCopyWith<$R, ChapterFilterUnread, $Out> {
  _ChapterFilterUnreadCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ChapterFilterUnread> $mapper =
      ChapterFilterUnreadMapper.ensureInitialized();
  @override
  $R call({Object? mangaId = $none, Object? type = $none}) => $apply(
    FieldCopyWithData({
      if (mangaId != $none) #mangaId: mangaId,
      if (type != $none) #type: type,
    }),
  );
  @override
  ChapterFilterUnread $make(CopyWithData data) => ChapterFilterUnread(
    mangaId: data.get(#mangaId, or: $value.mangaId),
    type: data.get(#type, or: $value.type),
  );

  @override
  ChapterFilterUnreadCopyWith<$R2, ChapterFilterUnread, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _ChapterFilterUnreadCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ChapterFilterBookmarkedMapper
    extends ClassMapperBase<ChapterFilterBookmarked> {
  ChapterFilterBookmarkedMapper._();

  static ChapterFilterBookmarkedMapper? _instance;
  static ChapterFilterBookmarkedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = ChapterFilterBookmarkedMapper._(),
      );
      MapperContainer.globals.useAll([SecondsEpochDateTimeMapper()]);
    }
    return _instance!;
  }

  @override
  final String id = 'ChapterFilterBookmarked';

  static int? _$mangaId(ChapterFilterBookmarked v) => v.mangaId;
  static const Field<ChapterFilterBookmarked, int> _f$mangaId = Field(
    'mangaId',
    _$mangaId,
    opt: true,
  );
  static int? _$type(ChapterFilterBookmarked v) => v.type;
  static const Field<ChapterFilterBookmarked, int> _f$type = Field(
    'type',
    _$type,
    opt: true,
    def: 0,
  );

  @override
  final MappableFields<ChapterFilterBookmarked> fields = const {
    #mangaId: _f$mangaId,
    #type: _f$type,
  };

  static ChapterFilterBookmarked _instantiate(DecodingData data) {
    return ChapterFilterBookmarked(
      mangaId: data.dec(_f$mangaId),
      type: data.dec(_f$type),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ChapterFilterBookmarked fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ChapterFilterBookmarked>(map);
  }

  static ChapterFilterBookmarked fromJson(String json) {
    return ensureInitialized().decodeJson<ChapterFilterBookmarked>(json);
  }
}

mixin ChapterFilterBookmarkedMappable {
  String toJson() {
    return ChapterFilterBookmarkedMapper.ensureInitialized()
        .encodeJson<ChapterFilterBookmarked>(this as ChapterFilterBookmarked);
  }

  Map<String, dynamic> toMap() {
    return ChapterFilterBookmarkedMapper.ensureInitialized()
        .encodeMap<ChapterFilterBookmarked>(this as ChapterFilterBookmarked);
  }

  ChapterFilterBookmarkedCopyWith<
    ChapterFilterBookmarked,
    ChapterFilterBookmarked,
    ChapterFilterBookmarked
  >
  get copyWith =>
      _ChapterFilterBookmarkedCopyWithImpl<
        ChapterFilterBookmarked,
        ChapterFilterBookmarked
      >(this as ChapterFilterBookmarked, $identity, $identity);
  @override
  String toString() {
    return ChapterFilterBookmarkedMapper.ensureInitialized().stringifyValue(
      this as ChapterFilterBookmarked,
    );
  }

  @override
  bool operator ==(Object other) {
    return ChapterFilterBookmarkedMapper.ensureInitialized().equalsValue(
      this as ChapterFilterBookmarked,
      other,
    );
  }

  @override
  int get hashCode {
    return ChapterFilterBookmarkedMapper.ensureInitialized().hashValue(
      this as ChapterFilterBookmarked,
    );
  }
}

extension ChapterFilterBookmarkedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ChapterFilterBookmarked, $Out> {
  ChapterFilterBookmarkedCopyWith<$R, ChapterFilterBookmarked, $Out>
  get $asChapterFilterBookmarked => $base.as(
    (v, t, t2) => _ChapterFilterBookmarkedCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class ChapterFilterBookmarkedCopyWith<
  $R,
  $In extends ChapterFilterBookmarked,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({int? mangaId, int? type});
  ChapterFilterBookmarkedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ChapterFilterBookmarkedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ChapterFilterBookmarked, $Out>
    implements
        ChapterFilterBookmarkedCopyWith<$R, ChapterFilterBookmarked, $Out> {
  _ChapterFilterBookmarkedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ChapterFilterBookmarked> $mapper =
      ChapterFilterBookmarkedMapper.ensureInitialized();
  @override
  $R call({Object? mangaId = $none, Object? type = $none}) => $apply(
    FieldCopyWithData({
      if (mangaId != $none) #mangaId: mangaId,
      if (type != $none) #type: type,
    }),
  );
  @override
  ChapterFilterBookmarked $make(CopyWithData data) => ChapterFilterBookmarked(
    mangaId: data.get(#mangaId, or: $value.mangaId),
    type: data.get(#type, or: $value.type),
  );

  @override
  ChapterFilterBookmarkedCopyWith<$R2, ChapterFilterBookmarked, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _ChapterFilterBookmarkedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FilterScanlatorMapper extends ClassMapperBase<FilterScanlator> {
  FilterScanlatorMapper._();

  static FilterScanlatorMapper? _instance;
  static FilterScanlatorMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FilterScanlatorMapper._());
      MapperContainer.globals.useAll([SecondsEpochDateTimeMapper()]);
    }
    return _instance!;
  }

  @override
  final String id = 'FilterScanlator';

  static int? _$mangaId(FilterScanlator v) => v.mangaId;
  static const Field<FilterScanlator, int> _f$mangaId = Field(
    'mangaId',
    _$mangaId,
    opt: true,
  );
  static List<String>? _$scanlators(FilterScanlator v) => v.scanlators;
  static const Field<FilterScanlator, List<String>> _f$scanlators = Field(
    'scanlators',
    _$scanlators,
    opt: true,
  );

  @override
  final MappableFields<FilterScanlator> fields = const {
    #mangaId: _f$mangaId,
    #scanlators: _f$scanlators,
  };

  static FilterScanlator _instantiate(DecodingData data) {
    return FilterScanlator(
      mangaId: data.dec(_f$mangaId),
      scanlators: data.dec(_f$scanlators),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FilterScanlator fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FilterScanlator>(map);
  }

  static FilterScanlator fromJson(String json) {
    return ensureInitialized().decodeJson<FilterScanlator>(json);
  }
}

mixin FilterScanlatorMappable {
  String toJson() {
    return FilterScanlatorMapper.ensureInitialized()
        .encodeJson<FilterScanlator>(this as FilterScanlator);
  }

  Map<String, dynamic> toMap() {
    return FilterScanlatorMapper.ensureInitialized().encodeMap<FilterScanlator>(
      this as FilterScanlator,
    );
  }

  FilterScanlatorCopyWith<FilterScanlator, FilterScanlator, FilterScanlator>
  get copyWith =>
      _FilterScanlatorCopyWithImpl<FilterScanlator, FilterScanlator>(
        this as FilterScanlator,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FilterScanlatorMapper.ensureInitialized().stringifyValue(
      this as FilterScanlator,
    );
  }

  @override
  bool operator ==(Object other) {
    return FilterScanlatorMapper.ensureInitialized().equalsValue(
      this as FilterScanlator,
      other,
    );
  }

  @override
  int get hashCode {
    return FilterScanlatorMapper.ensureInitialized().hashValue(
      this as FilterScanlator,
    );
  }
}

extension FilterScanlatorValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FilterScanlator, $Out> {
  FilterScanlatorCopyWith<$R, FilterScanlator, $Out> get $asFilterScanlator =>
      $base.as((v, t, t2) => _FilterScanlatorCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FilterScanlatorCopyWith<$R, $In extends FilterScanlator, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>? get scanlators;
  $R call({int? mangaId, List<String>? scanlators});
  FilterScanlatorCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FilterScanlatorCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FilterScanlator, $Out>
    implements FilterScanlatorCopyWith<$R, FilterScanlator, $Out> {
  _FilterScanlatorCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FilterScanlator> $mapper =
      FilterScanlatorMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>?
  get scanlators => $value.scanlators != null
      ? ListCopyWith(
          $value.scanlators!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(scanlators: v),
        )
      : null;
  @override
  $R call({Object? mangaId = $none, Object? scanlators = $none}) => $apply(
    FieldCopyWithData({
      if (mangaId != $none) #mangaId: mangaId,
      if (scanlators != $none) #scanlators: scanlators,
    }),
  );
  @override
  FilterScanlator $make(CopyWithData data) => FilterScanlator(
    mangaId: data.get(#mangaId, or: $value.mangaId),
    scanlators: data.get(#scanlators, or: $value.scanlators),
  );

  @override
  FilterScanlatorCopyWith<$R2, FilterScanlator, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FilterScanlatorCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class L10nLocaleMapper extends ClassMapperBase<L10nLocale> {
  L10nLocaleMapper._();

  static L10nLocaleMapper? _instance;
  static L10nLocaleMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = L10nLocaleMapper._());
      MapperContainer.globals.useAll([SecondsEpochDateTimeMapper()]);
    }
    return _instance!;
  }

  @override
  final String id = 'L10nLocale';

  static String? _$languageCode(L10nLocale v) => v.languageCode;
  static const Field<L10nLocale, String> _f$languageCode = Field(
    'languageCode',
    _$languageCode,
    opt: true,
  );
  static String? _$countryCode(L10nLocale v) => v.countryCode;
  static const Field<L10nLocale, String> _f$countryCode = Field(
    'countryCode',
    _$countryCode,
    opt: true,
  );

  @override
  final MappableFields<L10nLocale> fields = const {
    #languageCode: _f$languageCode,
    #countryCode: _f$countryCode,
  };

  static L10nLocale _instantiate(DecodingData data) {
    return L10nLocale(
      languageCode: data.dec(_f$languageCode),
      countryCode: data.dec(_f$countryCode),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static L10nLocale fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<L10nLocale>(map);
  }

  static L10nLocale fromJson(String json) {
    return ensureInitialized().decodeJson<L10nLocale>(json);
  }
}

mixin L10nLocaleMappable {
  String toJson() {
    return L10nLocaleMapper.ensureInitialized().encodeJson<L10nLocale>(
      this as L10nLocale,
    );
  }

  Map<String, dynamic> toMap() {
    return L10nLocaleMapper.ensureInitialized().encodeMap<L10nLocale>(
      this as L10nLocale,
    );
  }

  L10nLocaleCopyWith<L10nLocale, L10nLocale, L10nLocale> get copyWith =>
      _L10nLocaleCopyWithImpl<L10nLocale, L10nLocale>(
        this as L10nLocale,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return L10nLocaleMapper.ensureInitialized().stringifyValue(
      this as L10nLocale,
    );
  }

  @override
  bool operator ==(Object other) {
    return L10nLocaleMapper.ensureInitialized().equalsValue(
      this as L10nLocale,
      other,
    );
  }

  @override
  int get hashCode {
    return L10nLocaleMapper.ensureInitialized().hashValue(this as L10nLocale);
  }
}

extension L10nLocaleValueCopy<$R, $Out>
    on ObjectCopyWith<$R, L10nLocale, $Out> {
  L10nLocaleCopyWith<$R, L10nLocale, $Out> get $asL10nLocale =>
      $base.as((v, t, t2) => _L10nLocaleCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class L10nLocaleCopyWith<$R, $In extends L10nLocale, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? languageCode, String? countryCode});
  L10nLocaleCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _L10nLocaleCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, L10nLocale, $Out>
    implements L10nLocaleCopyWith<$R, L10nLocale, $Out> {
  _L10nLocaleCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<L10nLocale> $mapper =
      L10nLocaleMapper.ensureInitialized();
  @override
  $R call({Object? languageCode = $none, Object? countryCode = $none}) =>
      $apply(
        FieldCopyWithData({
          if (languageCode != $none) #languageCode: languageCode,
          if (countryCode != $none) #countryCode: countryCode,
        }),
      );
  @override
  L10nLocale $make(CopyWithData data) => L10nLocale(
    languageCode: data.get(#languageCode, or: $value.languageCode),
    countryCode: data.get(#countryCode, or: $value.countryCode),
  );

  @override
  L10nLocaleCopyWith<$R2, L10nLocale, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _L10nLocaleCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

