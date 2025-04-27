import 'package:dart_mappable/dart_mappable.dart';
import 'package:mangabackupconverter_cli/src/common/seconds_epoc_date_time_mapper.dart';

part 'mangayomi_backup_settings.mapper.dart';

const _defaultUserAgent =
    'Mozilla/5.0 (Linux; Android 13; 22081212UG Build/TKQ1.220829.002; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/114.0.5735.131 Mobile Safari/537.36';

@MappableClass(
  includeCustomMappers: [SecondsEpochDateTimeMapper()],
  caseStyle: CaseStyle.camelCase,
)
class MangayomiBackupSettings with MangayomiBackupSettingsMappable {
  final int? id;
  final DisplayType displayType;
  final int? libraryFilterMangasDownloadType;
  final int? libraryFilterMangasUnreadType;
  final int? libraryFilterMangasStartedType;
  final int? libraryFilterMangasBookMarkedType;
  final bool? libraryShowCategoryTabs;
  final bool? libraryDownloadedChapters;
  final bool? libraryShowLanguage;
  final bool? libraryShowNumbersOfItems;
  final bool? libraryShowContinueReadingButton;
  final bool? libraryLocalSource;
  final SortLibraryManga? sortLibraryManga;
  final List<SortChapter>? sortChapterList;
  final List<ChapterFilterDownloaded>? chapterFilterDownloadedList;
  final List<ChapterFilterUnread>? chapterFilterUnreadList;
  final List<ChapterFilterBookmarked>? chapterFilterBookmarkedList;
  final double? flexColorSchemeBlendLevel;
  final String? dateFormat;
  final int? relativeTimesTamps;
  final int? flexSchemeColorIndex;
  final bool? themeIsDark;
  final bool? followSystemTheme;
  final bool? incognitoMode;
  final List<ChapterPageurls>? chapterPageUrlsList;
  final bool? showPagesNumber;
  final List<ChapterPageIndex>? chapterPageIndexList;
  final String? userAgent;
  final List<MCookie>? cookiesList;
  final ReaderMode defaultReaderMode;
  final List<PersonalReaderMode>? personalReaderModeList;
  final bool? animatePageTransitions;
  final int? doubleTapAnimationSpeed;
  final bool? onlyIncludePinnedSources;
  final bool? pureBlackDarkMode;
  final bool? downloadOnlyOnWifi;
  final bool? saveAsCBZArchive;
  final String? downloadLocation;
  final List<FilterScanlator>? filterScanlatorList;
  final bool? autoExtensionsUpdates;
  final bool? cropBorders;
  final L10nLocale? locale;
  final L10nLocale? defaultSubtitleLang;
  final DisplayType animeDisplayType;
  final int? libraryFilterAnimeDownloadType;
  final int? libraryFilterAnimeUnreadType;
  final int? libraryFilterAnimeStartedType;
  final int? libraryFilterAnimeBookMarkedType;
  final bool? animeLibraryShowCategoryTabs;
  final bool? animeLibraryDownloadedChapters;
  final bool? animeLibraryShowLanguage;
  final bool? animeLibraryShowNumbersOfItems;
  final bool? animeLibraryShowContinueReadingButton;
  final bool? animeLibraryLocalSource;
  final SortLibraryManga? sortLibraryAnime;
  final int? pagePreloadAmount;
  final bool? checkForExtensionUpdates;
  final ScaleType scaleType;
  final BackgroundColor backgroundColor;
  final List<PersonalPageMode>? personalPageModeList;
  final int? startDatebackup;
  final int? backupFrequency;
  final List<int>? backupListOptions;
  final String? autoBackupLocation;
  final bool? usePageTapZones;
  final List<AutoScrollPages>? autoScrollPages;
  final int? markEpisodeAsSeenType;
  final int? defaultSkipIntroLength;
  final int? defaultDoubleTapToSkipLength;
  final double? defaultPlayBackSpeed;
  final bool? fullScreenPlayer;
  final bool? updateProgressAfterReading;
  final bool? enableAniSkip;
  final bool? enableAutoSkip;
  final int? aniSkipTimeoutLength;
  final String? btServerAddress;
  final int? btServerPort;
  final bool? fullScreenReader;
  final CustomColorFilter? customColorFilter;
  final bool? enableCustomColorFilter;
  final ColorFilterBlendMode colorFilterBlendMode;
  final PlayerSubtitleSettings? playerSubtitleSettings;
  final DisplayType mangaHomeDisplayType;
  final String? appFontFamily;
  final int? mangaGridSize;
  final int? animeGridSize;
  final int? novelGridSize;
  final List<Repo>? mangaExtensionsRepo;
  final List<Repo>? animeExtensionsRepo;
  final List<Repo>? novelExtensionsRepo;
  final SectionType disableSectionType;
  final bool? useLibass;
  final int? libraryFilterNovelDownloadType;
  final int? libraryFilterNovelUnreadType;
  final int? libraryFilterNovelStartedType;
  final int? libraryFilterNovelBookMarkedType;
  final bool? novelLibraryShowCategoryTabs;
  final bool? novelLibraryDownloadedChapters;
  final bool? novelLibraryShowLanguage;
  final bool? novelLibraryShowNumbersOfItems;
  final bool? novelLibraryShowContinueReadingButton;
  final bool? novelLibraryLocalSource;
  final SortLibraryManga? sortLibraryNovel;
  final DisplayType novelDisplayType;
  final int? novelFontSize;
  final NovelTextAlign novelTextAlign;
  final List<String>? navigationOrder;
  final List<String>? hideItems;
  final bool? clearChapterCacheOnAppLaunch;

  const MangayomiBackupSettings({
    this.id = 227,
    this.displayType = DisplayType.compactGrid,
    this.libraryFilterMangasDownloadType = 0,
    this.libraryFilterMangasUnreadType = 0,
    this.libraryFilterMangasStartedType = 0,
    this.libraryFilterMangasBookMarkedType = 0,
    this.libraryShowCategoryTabs = false,
    this.libraryDownloadedChapters = false,
    this.libraryShowLanguage = false,
    this.libraryShowNumbersOfItems = false,
    this.libraryShowContinueReadingButton = false,
    this.sortLibraryManga,
    this.sortChapterList,
    this.chapterFilterDownloadedList,
    this.flexColorSchemeBlendLevel = 10.0,
    this.dateFormat = 'M/d/y',
    this.relativeTimesTamps = 2,
    this.flexSchemeColorIndex = 2,
    this.themeIsDark = false,
    this.followSystemTheme = false,
    this.incognitoMode = false,
    this.chapterPageUrlsList,
    this.showPagesNumber = true,
    this.chapterPageIndexList,
    this.userAgent = _defaultUserAgent,
    this.cookiesList,
    this.defaultReaderMode = ReaderMode.vertical,
    this.personalReaderModeList,
    this.animatePageTransitions = true,
    this.doubleTapAnimationSpeed = 1,
    this.onlyIncludePinnedSources = false,
    this.pureBlackDarkMode = false,
    this.downloadOnlyOnWifi = false,
    this.saveAsCBZArchive = false,
    this.downloadLocation = '',
    this.cropBorders = false,
    this.libraryLocalSource,
    this.autoExtensionsUpdates = false,
    this.animeDisplayType = DisplayType.compactGrid,
    this.libraryFilterAnimeDownloadType = 0,
    this.libraryFilterAnimeUnreadType = 0,
    this.libraryFilterAnimeStartedType = 0,
    this.libraryFilterAnimeBookMarkedType = 0,
    this.animeLibraryShowCategoryTabs = false,
    this.animeLibraryDownloadedChapters = false,
    this.animeLibraryShowLanguage = false,
    this.animeLibraryShowNumbersOfItems = false,
    this.animeLibraryShowContinueReadingButton = false,
    this.animeLibraryLocalSource,
    this.sortLibraryAnime,
    this.pagePreloadAmount = 6,
    this.scaleType = ScaleType.fitScreen,
    this.checkForExtensionUpdates = true,
    this.backgroundColor = BackgroundColor.black,
    this.personalPageModeList,
    this.backupFrequency,
    this.backupListOptions,
    this.autoBackupLocation,
    this.startDatebackup,
    this.usePageTapZones = true,
    this.autoScrollPages,
    this.markEpisodeAsSeenType = 85,
    this.defaultSkipIntroLength = 85,
    this.defaultDoubleTapToSkipLength = 10,
    this.defaultPlayBackSpeed = 1.0,
    this.fullScreenPlayer = false,
    this.updateProgressAfterReading = true,
    this.enableAniSkip,
    this.enableAutoSkip,
    this.aniSkipTimeoutLength,
    this.btServerAddress = '127.0.0.1',
    this.btServerPort,
    this.fullScreenReader = true,
    this.enableCustomColorFilter = false,
    this.customColorFilter,
    this.colorFilterBlendMode = ColorFilterBlendMode.none,
    this.playerSubtitleSettings,
    this.mangaHomeDisplayType = DisplayType.comfortableGrid,
    this.appFontFamily,
    this.mangaGridSize,
    this.animeGridSize,
    this.disableSectionType = SectionType.all,
    this.useLibass = true,
    this.libraryFilterNovelDownloadType = 0,
    this.libraryFilterNovelUnreadType = 0,
    this.libraryFilterNovelStartedType = 0,
    this.libraryFilterNovelBookMarkedType = 0,
    this.novelLibraryShowCategoryTabs = false,
    this.novelLibraryDownloadedChapters = false,
    this.novelLibraryShowLanguage = false,
    this.novelLibraryShowNumbersOfItems = false,
    this.novelLibraryShowContinueReadingButton = false,
    this.novelLibraryLocalSource,
    this.sortLibraryNovel,
    this.novelDisplayType = DisplayType.comfortableGrid,
    this.novelFontSize = 14,
    this.novelTextAlign = NovelTextAlign.left,
    this.navigationOrder,
    this.hideItems,
    this.clearChapterCacheOnAppLaunch = false,
    this.mangaExtensionsRepo,
    this.animeExtensionsRepo,
    this.novelExtensionsRepo,
    this.chapterFilterUnreadList,
    this.chapterFilterBookmarkedList,
    this.filterScanlatorList,
    this.locale,
    this.defaultSubtitleLang,
    this.novelGridSize,
  });

  static const fromMap = MangayomiBackupSettingsMapper.fromMap;
  static const fromJson = MangayomiBackupSettingsMapper.fromJson;
}

@MappableEnum(mode: ValuesMode.indexed, caseStyle: CaseStyle.camelCase)
enum SectionType { all, anime, manga }

@MappableEnum(mode: ValuesMode.indexed, caseStyle: CaseStyle.camelCase)
enum DisplayType { compactGrid, comfortableGrid, coverOnlyGrid, list }

@MappableEnum(mode: ValuesMode.indexed, caseStyle: CaseStyle.camelCase)
enum ScaleType {
  fitScreen,
  stretch,
  fitWidth,
  fitHeight,
  originalSize,
  smartFit,
}

@MappableEnum(mode: ValuesMode.indexed, caseStyle: CaseStyle.camelCase)
enum BackgroundColor { black, grey, white, automatic }

@MappableClass(
  includeCustomMappers: [SecondsEpochDateTimeMapper()],
  caseStyle: CaseStyle.camelCase,
)
class MCookie with MCookieMappable {
  final String? host;
  final String? cookie;

  const MCookie({this.host, this.cookie});

  static const fromMap = MCookieMapper.fromMap;
  static const fromJson = MCookieMapper.fromJson;
}

@MappableClass(
  includeCustomMappers: [SecondsEpochDateTimeMapper()],
  caseStyle: CaseStyle.camelCase,
)
class SortLibraryManga with SortLibraryMangaMappable {
  final bool? reverse;
  final int? index;

  const SortLibraryManga({this.reverse = false, this.index = 0});

  static const fromMap = SortLibraryMangaMapper.fromMap;
  static const fromJson = SortLibraryMangaMapper.fromJson;
}

@MappableClass(
  includeCustomMappers: [SecondsEpochDateTimeMapper()],
  caseStyle: CaseStyle.camelCase,
)
class SortChapter with SortChapterMappable {
  final int? mangaId;
  final bool? reverse;
  final int? index;

  const SortChapter({this.mangaId, this.reverse = false, this.index = 1});

  static const fromMap = SortChapterMapper.fromMap;
  static const fromJson = SortChapterMapper.fromJson;
}

@MappableClass(
  includeCustomMappers: [SecondsEpochDateTimeMapper()],
  caseStyle: CaseStyle.camelCase,
)
class ChapterFilterDownloaded with ChapterFilterDownloadedMappable {
  final int? mangaId;
  final int? type;

  const ChapterFilterDownloaded({this.mangaId, this.type = 0});

  static const fromMap = ChapterFilterDownloadedMapper.fromMap;
  static const fromJson = ChapterFilterDownloadedMapper.fromJson;
}

@MappableClass(
  includeCustomMappers: [SecondsEpochDateTimeMapper()],
  caseStyle: CaseStyle.camelCase,
)
class ChapterFilterUnread with ChapterFilterUnreadMappable {
  final int? mangaId;
  final int? type;

  const ChapterFilterUnread({this.mangaId, this.type = 0});

  static const fromMap = ChapterFilterUnreadMapper.fromMap;
  static const fromJson = ChapterFilterUnreadMapper.fromJson;
}

@MappableClass(
  includeCustomMappers: [SecondsEpochDateTimeMapper()],
  caseStyle: CaseStyle.camelCase,
)
class ChapterFilterBookmarked with ChapterFilterBookmarkedMappable {
  final int? mangaId;
  final int? type;

  const ChapterFilterBookmarked({this.mangaId, this.type = 0});

  static const fromMap = ChapterFilterBookmarkedMapper.fromMap;
  static const fromJson = ChapterFilterBookmarkedMapper.fromJson;
}

@MappableClass(
  includeCustomMappers: [SecondsEpochDateTimeMapper()],
  caseStyle: CaseStyle.camelCase,
)
class ChapterPageurls with ChapterPageurlsMappable {
  final int? chapterId;
  final List<String>? urls;
  final List<String>? headers;

  const ChapterPageurls({this.chapterId, this.urls, this.headers});

  static const fromMap = ChapterPageurlsMapper.fromMap;
  static const fromJson = ChapterPageurlsMapper.fromJson;
}

@MappableClass(
  includeCustomMappers: [SecondsEpochDateTimeMapper()],
  caseStyle: CaseStyle.camelCase,
)
class ChapterPageIndex with ChapterPageIndexMappable {
  final int? chapterId;
  final int? index;

  const ChapterPageIndex({this.chapterId, this.index});

  static const fromMap = ChapterPageIndexMapper.fromMap;
  static const fromJson = ChapterPageIndexMapper.fromJson;
}

@MappableClass(
  includeCustomMappers: [SecondsEpochDateTimeMapper()],
  caseStyle: CaseStyle.camelCase,
)
class PersonalReaderMode with PersonalReaderModeMappable {
  final int? mangaId;
  final ReaderMode readerMode;

  const PersonalReaderMode({
    this.mangaId,
    this.readerMode = ReaderMode.vertical,
  });

  static const fromMap = PersonalReaderModeMapper.fromMap;
  static const fromJson = PersonalReaderModeMapper.fromJson;
}

@MappableClass(
  includeCustomMappers: [SecondsEpochDateTimeMapper()],
  caseStyle: CaseStyle.camelCase,
)
class AutoScrollPages with AutoScrollPagesMappable {
  final int? mangaId;
  final double? pageOffset;
  final bool? autoScroll;

  const AutoScrollPages({
    this.mangaId,
    this.pageOffset = 10,
    this.autoScroll = false,
  });

  static const fromMap = AutoScrollPagesMapper.fromMap;
  static const fromJson = AutoScrollPagesMapper.fromJson;
}

@MappableClass(
  includeCustomMappers: [SecondsEpochDateTimeMapper()],
  caseStyle: CaseStyle.camelCase,
)
class Repo with RepoMappable {
  final String? name;
  final String? website;
  final String? jsonUrl;

  const Repo({this.name, this.website, this.jsonUrl});

  static const fromMap = RepoMapper.fromMap;
  static const fromJson = RepoMapper.fromJson;
}

@MappableClass(
  includeCustomMappers: [SecondsEpochDateTimeMapper()],
  caseStyle: CaseStyle.camelCase,
)
class PersonalPageMode with PersonalPageModeMappable {
  final int? mangaId;
  final PageMode pageMode;

  const PersonalPageMode({this.mangaId, this.pageMode = PageMode.onePage});

  static const fromMap = PersonalPageModeMapper.fromMap;
  static const fromJson = PersonalPageModeMapper.fromJson;
}

@MappableEnum(mode: ValuesMode.indexed, caseStyle: CaseStyle.camelCase)
enum ReaderMode {
  vertical,
  ltr,
  rtl,
  verticalContinuous,
  webtoon,
  horizontalContinuous,
}

@MappableEnum(mode: ValuesMode.indexed, caseStyle: CaseStyle.camelCase)
enum NovelTextAlign { left, center, right, block }

@MappableEnum(mode: ValuesMode.indexed, caseStyle: CaseStyle.camelCase)
enum PageMode { onePage, doublePage }

@MappableClass(
  includeCustomMappers: [SecondsEpochDateTimeMapper()],
  caseStyle: CaseStyle.camelCase,
)
class FilterScanlator with FilterScanlatorMappable {
  final int? mangaId;
  final List<String>? scanlators;

  const FilterScanlator({this.mangaId, this.scanlators});

  static const fromMap = FilterScanlatorMapper.fromMap;
  static const fromJson = FilterScanlatorMapper.fromJson;
}

@MappableClass(
  includeCustomMappers: [SecondsEpochDateTimeMapper()],
  caseStyle: CaseStyle.camelCase,
)
class L10nLocale with L10nLocaleMappable {
  final String? languageCode;
  final String? countryCode;

  const L10nLocale({this.languageCode, this.countryCode});

  static const fromMap = L10nLocaleMapper.fromMap;
  static const fromJson = L10nLocaleMapper.fromJson;
}

@MappableClass(
  includeCustomMappers: [SecondsEpochDateTimeMapper()],
  caseStyle: CaseStyle.camelCase,
)
class CustomColorFilter with CustomColorFilterMappable {
  final int? a;
  final int? r;
  final int? g;
  final int? b;

  const CustomColorFilter({this.a, this.r, this.g, this.b});

  static const fromMap = CustomColorFilterMapper.fromMap;
  static const fromJson = CustomColorFilterMapper.fromJson;
}

@MappableClass(
  includeCustomMappers: [SecondsEpochDateTimeMapper()],
  caseStyle: CaseStyle.camelCase,
)
class PlayerSubtitleSettings with PlayerSubtitleSettingsMappable {
  final int? fontSize;
  final bool? useBold;
  final bool? useItalic;
  final int? textColorA;
  final int? textColorR;
  final int? textColorG;
  final int? textColorB;
  final int? borderColorA;
  final int? borderColorR;
  final int? borderColorG;
  final int? borderColorB;
  final int? backgroundColorA;
  final int? backgroundColorR;
  final int? backgroundColorG;
  final int? backgroundColorB;

  const PlayerSubtitleSettings({
    this.fontSize = 45,
    this.useBold = true,
    this.useItalic = false,
    this.textColorA = 255,
    this.textColorR = 255,
    this.textColorG = 255,
    this.textColorB = 255,
    this.borderColorA = 255,
    this.borderColorR = 0,
    this.borderColorG = 0,
    this.borderColorB = 0,
    this.backgroundColorA = 0,
    this.backgroundColorR = 0,
    this.backgroundColorG = 0,
    this.backgroundColorB = 0,
  });

  static const fromMap = PlayerSubtitleSettingsMapper.fromMap;
  static const fromJson = PlayerSubtitleSettingsMapper.fromJson;
}

@MappableEnum(mode: ValuesMode.indexed, caseStyle: CaseStyle.camelCase)
enum ColorFilterBlendMode {
  none,
  multiply,
  screen,
  overlay,
  colorDodge,
  lighten,
  colorBurn,
  darken,
  difference,
  saturation,
  softLight,
  plus,
  exclusion,
}
