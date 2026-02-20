import 'package:dart_mappable/dart_mappable.dart';
import 'package:mangabackupconverter_cli/src/common/seconds_epoc_date_time_mapper.dart';
import 'package:mangabackupconverter_cli/src/formats/mangayomi/mangayomi_backup_settings.dart';

part 'mangayomi_backup_db.mapper.dart';

@MappableClass(includeCustomMappers: <MapperBase<Object>>[SecondsEpochDateTimeMapper()], caseStyle: CaseStyle.camelCase)
class MangayomiBackupDb with MangayomiBackupDbMappable {
  final String? version;
  final List<MangayomiBackupManga>? manga;
  final List<MangayomiBackupCategory>? categories;
  final List<MangayomiBackupChapter>? chapters;
  final List<MangayomiBackupDownload>? downloads;
  final List<MangayomiBackupTrack>? tracks;
  final List<MangayomiBackupHistory>? history;
  final List<MangayomiBackupUpdate>? updates;
  final List<MangayomiBackupSettings>? settings;

  @MappableField(key: 'extension_preferences')
  final List<MangayomiBackupExtensionPreferences>? extensionPreferences;
  final List<MangayomiBackupTrackPreferences>? trackPreferences;
  final List<MangayomiBackupExtension>? extensions;

  const MangayomiBackupDb({
    this.version = '2',
    this.manga,
    this.categories,
    this.chapters,
    this.downloads,
    this.tracks,
    this.history,
    this.updates,
    this.settings,
    this.extensionPreferences,
    this.trackPreferences,
    this.extensions,
  });

  static const MangayomiBackupDb Function(Map<String, dynamic> map) fromMap = MangayomiBackupDbMapper.fromMap;
  static const MangayomiBackupDb Function(String json) fromJson = MangayomiBackupDbMapper.fromJson;
}

@MappableClass(includeCustomMappers: <MapperBase<Object>>[SecondsEpochDateTimeMapper()], caseStyle: CaseStyle.camelCase)
class MangayomiBackupManga with MangayomiBackupMangaMappable {
  final String? author;
  final String? artist;
  final String? categories;
  final String? customCoverImage;
  final int? dateAdded;
  final String? description;
  final bool? favorite;
  final List<String>? genres;
  final int? id;
  final String? imageUrl;
  final bool? isLocalArchive;
  final bool? isManga;
  final ItemType? itemType;
  final List<String>? genre;
  final String? lang;
  final int? lastRead;
  final int? lastUpdate;
  final String? link;
  final String? name;
  final String? source;
  final int? status;
  final String? customCoverFromTracker;

  const MangayomiBackupManga({
    required this.source,
    required this.author,
    required this.artist,
    required this.genre,
    required this.imageUrl,
    required this.lang,
    required this.link,
    required this.name,
    required this.status,
    required this.description,
    this.id,
    this.favorite = false,
    this.isManga,
    this.itemType = ItemType.manga,
    this.genres,
    this.dateAdded,
    this.lastUpdate,
    this.categories,
    this.lastRead = 0,
    this.isLocalArchive = false,
    this.customCoverImage,
    this.customCoverFromTracker,
  });

  static const MangayomiBackupManga Function(Map<String, dynamic> map) fromMap = MangayomiBackupMangaMapper.fromMap;
  static const MangayomiBackupManga Function(String json) fromJson = MangayomiBackupMangaMapper.fromJson;
}

@MappableEnum(mode: ValuesMode.indexed, caseStyle: CaseStyle.camelCase)
enum ItemType { manga, anime, novel }

@MappableClass(includeCustomMappers: <MapperBase<Object>>[SecondsEpochDateTimeMapper()], caseStyle: CaseStyle.camelCase)
class MangayomiBackupCategory with MangayomiBackupCategoryMappable {
  final int? id;
  final String? name;
  final int? forItemType;
  final int? pos;
  final bool? hide;

  const MangayomiBackupCategory({required this.name, required this.forItemType, this.id, this.pos, this.hide});

  static const MangayomiBackupCategory Function(Map<String, dynamic> map) fromMap =
      MangayomiBackupCategoryMapper.fromMap;
  static const MangayomiBackupCategory Function(String json) fromJson = MangayomiBackupCategoryMapper.fromJson;
}

@MappableClass(includeCustomMappers: <MapperBase<Object>>[SecondsEpochDateTimeMapper()], caseStyle: CaseStyle.camelCase)
class MangayomiBackupChapter with MangayomiBackupChapterMappable {
  final int? id;
  final int? mangaId;
  final String? name;
  final String? url;
  final String? dateUpload;
  final String? scanlator;
  final bool? isBookmarked;
  final bool? isRead;
  final String? lastPageRead;

  ///Only for local archive Comic
  final String? archivePath;

  const MangayomiBackupChapter({
    required this.mangaId,
    required this.name,
    this.id,
    this.url = '',
    this.dateUpload = '',
    this.isBookmarked = false,
    this.scanlator = '',
    this.isRead = false,
    this.lastPageRead = '',
    this.archivePath = '',
  });

  static const MangayomiBackupChapter Function(Map<String, dynamic> map) fromMap = MangayomiBackupChapterMapper.fromMap;
  static const MangayomiBackupChapter Function(String json) fromJson = MangayomiBackupChapterMapper.fromJson;
}

@MappableClass(includeCustomMappers: <MapperBase<Object>>[SecondsEpochDateTimeMapper()], caseStyle: CaseStyle.camelCase)
class MangayomiBackupDownload with MangayomiBackupDownloadMappable {
  final int? failed;
  final int? id;
  final bool? isDownload;
  final bool? isStartDownload;
  final int? succeeded;
  final int? total;

  const MangayomiBackupDownload({
    required this.succeeded,
    required this.failed,
    required this.total,
    required this.isDownload,
    required this.isStartDownload,
    this.id = 0,
  });

  static const MangayomiBackupDownload Function(Map<String, dynamic> map) fromMap =
      MangayomiBackupDownloadMapper.fromMap;
  static const MangayomiBackupDownload Function(String json) fromJson = MangayomiBackupDownloadMapper.fromJson;
}

@MappableClass(includeCustomMappers: <MapperBase<Object>>[SecondsEpochDateTimeMapper()], caseStyle: CaseStyle.camelCase)
class MangayomiBackupTrack with MangayomiBackupTrackMappable {
  final int? finishedReadingDate;
  final int? id;
  final int? lastChapterRead;
  final int? libraryId;
  final int? mangaId;
  final int? mediaId;
  final int? score;
  final int? startedReadingDate;
  final int? status;
  final int? syncId;
  final String? title;
  final int? totalChapter;
  final String? trackingUrl;
  final bool? isManga;
  final ItemType itemType;

  const MangayomiBackupTrack({
    required this.status,
    this.id,
    this.libraryId,
    this.mediaId,
    this.mangaId,
    this.syncId,
    this.title,
    this.lastChapterRead,
    this.totalChapter,
    this.score,
    this.startedReadingDate,
    this.finishedReadingDate,
    this.trackingUrl,
    this.isManga,
    this.itemType = ItemType.manga,
  });

  static const MangayomiBackupTrack Function(Map<String, dynamic> map) fromMap = MangayomiBackupTrackMapper.fromMap;
  static const MangayomiBackupTrack Function(String json) fromJson = MangayomiBackupTrackMapper.fromJson;
}

@MappableClass(includeCustomMappers: <MapperBase<Object>>[SecondsEpochDateTimeMapper()], caseStyle: CaseStyle.camelCase)
class MangayomiBackupTrackPreferences with MangayomiBackupTrackPreferencesMappable {
  final int? syncId;
  final String? username;
  final String? oAuth;
  final String? prefs;

  const MangayomiBackupTrackPreferences({
    required this.syncId,
    required this.username,
    required this.oAuth,
    required this.prefs,
  });

  static const MangayomiBackupTrackPreferences Function(Map<String, dynamic> map) fromMap =
      MangayomiBackupTrackPreferencesMapper.fromMap;
  static const MangayomiBackupTrackPreferences Function(String json) fromJson =
      MangayomiBackupTrackPreferencesMapper.fromJson;
}

@MappableClass(includeCustomMappers: <MapperBase<Object>>[SecondsEpochDateTimeMapper()], caseStyle: CaseStyle.camelCase)
class MangayomiBackupHistory with MangayomiBackupHistoryMappable {
  final int? id;
  final int? mangaId;
  final int? chapterId;
  final bool? isManga;
  final ItemType itemType;
  final String? date;

  const MangayomiBackupHistory({
    required this.itemType,
    required this.chapterId,
    required this.mangaId,
    required this.date,
    this.id,
    this.isManga,
  });

  static const MangayomiBackupHistory Function(Map<String, dynamic> map) fromMap = MangayomiBackupHistoryMapper.fromMap;
  static const MangayomiBackupHistory Function(String json) fromJson = MangayomiBackupHistoryMapper.fromJson;
}

@MappableClass(includeCustomMappers: <MapperBase<Object>>[SecondsEpochDateTimeMapper()], caseStyle: CaseStyle.camelCase)
class MangayomiBackupUpdate with MangayomiBackupUpdateMappable {
  final int? id;
  final int? mangaId;
  final String? chapterName;
  final String? date;

  const MangayomiBackupUpdate({required this.mangaId, required this.chapterName, required this.date, this.id});

  static const MangayomiBackupUpdate Function(Map<String, dynamic> map) fromMap = MangayomiBackupUpdateMapper.fromMap;
  static const MangayomiBackupUpdate Function(String json) fromJson = MangayomiBackupUpdateMapper.fromJson;
}

@MappableClass(includeCustomMappers: <MapperBase<Object>>[SecondsEpochDateTimeMapper()], caseStyle: CaseStyle.camelCase)
class MangayomiBackupExtension with MangayomiBackupExtensionMappable {
  final int? id;
  final String? name;
  final String? baseUrl;
  final String? lang;
  final bool? isActive;
  final bool? isAdded;
  final bool? isPinned;
  final bool? isNsfw;
  final String? sourceCode;
  final String? sourceCodeUrl;
  final String? typeSource;
  final String? iconUrl;
  final bool? isFullData;
  final bool? hasCloudflare;
  final bool? lastUsed;
  final String? dateFormat;
  final String? dateFormatLocale;
  final String? apiUrl;
  final String? version;
  final String? versionLast;
  final String? headers;
  final bool? isManga;
  final ItemType itemType;
  final String? appMinVerReq;
  final String? additionalParams;
  final bool? isLocal;
  final bool? isObsolete;
  final SourceCodeLanguage sourceCodeLanguage;
  final Repo? repo;

  const MangayomiBackupExtension({
    this.id = 0,
    this.name = '',
    this.baseUrl = '',
    this.lang = '',
    this.typeSource = '',
    this.iconUrl = '',
    this.dateFormat = '',
    this.dateFormatLocale = '',
    this.isActive = true,
    this.isAdded = false,
    this.isNsfw = false,
    this.isFullData = false,
    this.hasCloudflare = false,
    this.isPinned = false,
    this.lastUsed = false,
    this.apiUrl = '',
    this.sourceCodeUrl = '',
    this.version = '0.0.1',
    this.versionLast = '0.0.1',
    this.sourceCode = '',
    this.headers = '',
    this.isManga,
    this.itemType = ItemType.manga,
    this.appMinVerReq = '',
    this.additionalParams = '',
    this.isLocal = false,
    this.isObsolete = false,
    this.repo,
    this.sourceCodeLanguage = SourceCodeLanguage.dart,
  });

  static const MangayomiBackupExtension Function(Map<String, dynamic> map) fromMap =
      MangayomiBackupExtensionMapper.fromMap;
  static const MangayomiBackupExtension Function(String json) fromJson = MangayomiBackupExtensionMapper.fromJson;
}

@MappableEnum(mode: ValuesMode.indexed, caseStyle: CaseStyle.camelCase)
enum SourceCodeLanguage { dart, javascript }

@MappableClass(includeCustomMappers: <MapperBase<Object>>[SecondsEpochDateTimeMapper()], caseStyle: CaseStyle.camelCase)
class MangayomiBackupExtensionPreferences with MangayomiBackupExtensionPreferencesMappable {
  final int? id;
  final int? sourceId;
  final String? key;
  final EditTextPreference? editTextPreference;
  final ListPreference? listPreference;
  final SwitchPreferenceCompat? switchPreferenceCompat;
  final MultiSelectListPreference? multiSelectListPreference;

  const MangayomiBackupExtensionPreferences({
    this.id,
    this.sourceId,
    this.key,
    this.editTextPreference,
    this.listPreference,
    this.switchPreferenceCompat,
    this.multiSelectListPreference,
  });

  static const MangayomiBackupExtensionPreferences Function(Map<String, dynamic> map) fromMap =
      MangayomiBackupExtensionPreferencesMapper.fromMap;
  static const MangayomiBackupExtensionPreferences Function(String json) fromJson =
      MangayomiBackupExtensionPreferencesMapper.fromJson;
}

@MappableClass(includeCustomMappers: <MapperBase<Object>>[SecondsEpochDateTimeMapper()], caseStyle: CaseStyle.camelCase)
class EditTextPreference with EditTextPreferenceMappable {
  final String? title;
  final String? summary;
  final String? value;
  final String? dialogTitle;
  final String? dialogMessage;
  final String? text;

  const EditTextPreference({this.title, this.summary, this.value, this.dialogTitle, this.dialogMessage, this.text});

  static const EditTextPreference Function(Map<String, dynamic> map) fromMap = EditTextPreferenceMapper.fromMap;
  static const EditTextPreference Function(String json) fromJson = EditTextPreferenceMapper.fromJson;
}

@MappableClass(includeCustomMappers: <MapperBase<Object>>[SecondsEpochDateTimeMapper()], caseStyle: CaseStyle.camelCase)
class ListPreference with ListPreferenceMappable {
  final String? title;
  final String? summary;
  final int? valueIndex;
  final List<String>? entries;
  final List<String>? entryValues;

  const ListPreference({this.title, this.summary, this.valueIndex, this.entries, this.entryValues});

  static const ListPreference Function(Map<String, dynamic> map) fromMap = ListPreferenceMapper.fromMap;
  static const ListPreference Function(String json) fromJson = ListPreferenceMapper.fromJson;
}

@MappableClass(includeCustomMappers: <MapperBase<Object>>[SecondsEpochDateTimeMapper()], caseStyle: CaseStyle.camelCase)
class SwitchPreferenceCompat with SwitchPreferenceCompatMappable {
  final String? title;
  final String? summary;
  final bool? value;

  const SwitchPreferenceCompat({this.title, this.summary, this.value});

  static const SwitchPreferenceCompat Function(Map<String, dynamic> map) fromMap = SwitchPreferenceCompatMapper.fromMap;
  static const SwitchPreferenceCompat Function(String json) fromJson = SwitchPreferenceCompatMapper.fromJson;
}

@MappableClass(includeCustomMappers: <MapperBase<Object>>[SecondsEpochDateTimeMapper()], caseStyle: CaseStyle.camelCase)
class MultiSelectListPreference with MultiSelectListPreferenceMappable {
  final String? title;
  final String? summary;
  final List<String>? entries;
  final List<String>? entryValues;
  final List<String>? values;

  const MultiSelectListPreference({this.title, this.summary, this.values, this.entries, this.entryValues});

  static const MultiSelectListPreference Function(Map<String, dynamic> map) fromMap =
      MultiSelectListPreferenceMapper.fromMap;
  static const MultiSelectListPreference Function(String json) fromJson = MultiSelectListPreferenceMapper.fromJson;
}
