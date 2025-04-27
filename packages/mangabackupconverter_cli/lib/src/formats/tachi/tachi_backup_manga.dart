import 'package:dart_mappable/dart_mappable.dart';
import 'package:mangabackupconverter_cli/src/formats/tachi/neko_backup_merge_manga.dart';
import 'package:mangabackupconverter_cli/src/formats/tachi/tachi_backup_chapter.dart';
import 'package:mangabackupconverter_cli/src/formats/tachi/tachi_backup_history.dart';
import 'package:mangabackupconverter_cli/src/formats/tachi/tachi_backup_tracking.dart';
import 'package:mangabackupconverter_cli/src/formats/tachi/tachi_update_strategy.dart';
import 'package:mangabackupconverter_cli/src/proto/schema_j2k.proto/proto/schema_j2k.pb.dart' as j2k;
import 'package:mangabackupconverter_cli/src/proto/schema_mihon.proto/proto/schema_mihon.pb.dart' as mihon;
import 'package:mangabackupconverter_cli/src/proto/schema_neko.proto/proto/schema_neko.pb.dart' as neko;
import 'package:mangabackupconverter_cli/src/proto/schema_sy.proto/proto/schema_sy.pb.dart' as sy;
import 'package:mangabackupconverter_cli/src/proto/schema_yokai.proto/proto/schema_yokai.pb.dart' as yokai;

part 'tachi_backup_manga.mapper.dart';

@MappableClass()
class TachiBackupManga with TachiBackupMangaMappable {
  final int source;
  final String url;
  final String title;
  final String artist;
  final String author;
  final String description;
  final List<String> genre;
  final int status;
  final String thumbnailUrl;
  final int dateAdded;
  final int viewer;
  final List<TachiBackupChapter> chapters;
  final List<int> categories;
  final List<TachiBackupTracking> tracking;
  final bool favorite;
  final int chapterFlags;
  final List<TachiBackupHistory> brokenHistory;
  final int viewerFlags;
  final List<TachiBackupHistory> history;
  final TachiUpdateStrategy updateStrategy;
  final int? lastModifiedAt;
  final int? favoriteModifiedAt;
  final List<String>? excludedScanlators;
  final int? version;

  /// SY, J2K and Yokai only
  final int? customStatus;

  /// SY only
  final String? customThumbnailUrl;

  /// SY, J2K and Yokai only
  final String? customTitle;

  /// SY, J2K and Yokai only
  final String? customArtist;

  /// SY, J2K and Yokai only
  final String? customAuthor;

  /// SY, J2K and Yokai only
  final String? customDescription;

  /// SY, J2K and Yokai only
  final List<String>? customGenre;

  /// Neko only
  final String? scanlatorFilter;

  /// Neko only
  final String? alternativeArtwork;

  /// Neko only
  final List<NekoBackupMergeManga>? mergeMangaList;

  const TachiBackupManga({
    required this.source,
    required this.url,
    required this.title,
    required this.artist,
    required this.author,
    required this.description,
    required this.genre,
    required this.status,
    required this.thumbnailUrl,
    required this.dateAdded,
    required this.viewer,
    required this.chapters,
    required this.categories,
    required this.tracking,
    required this.favorite,
    required this.chapterFlags,
    required this.viewerFlags,
    required this.history,
    this.brokenHistory = const [],
    this.updateStrategy = TachiUpdateStrategy.alwaysUpdate,
    this.lastModifiedAt,
    this.favoriteModifiedAt,
    this.excludedScanlators,
    this.version,
    this.customStatus,
    this.customThumbnailUrl,
    this.customTitle,
    this.customArtist,
    this.customAuthor,
    this.customDescription,
    this.customGenre,
    this.scanlatorFilter,
    this.alternativeArtwork,
    this.mergeMangaList,
  });

  factory TachiBackupManga.fromMihon(mihon.BackupManga backupManga) {
    return TachiBackupManga(
      source: backupManga.source.toInt(),
      url: backupManga.url,
      title: backupManga.title,
      artist: backupManga.artist,
      author: backupManga.author,
      description: backupManga.description,
      genre: backupManga.genre,
      status: backupManga.status,
      thumbnailUrl: backupManga.thumbnailUrl,
      dateAdded: backupManga.dateAdded.toInt(),
      viewer: backupManga.viewer,
      chapters: backupManga.chapters.map(TachiBackupChapter.fromMihon).toList(),
      categories: backupManga.categories.map((i) => i.toInt()).toList(),
      tracking: backupManga.tracking.map(TachiBackupTracking.fromMihon).toList(),
      favorite: backupManga.favorite,
      chapterFlags: backupManga.chapterFlags,
      viewerFlags: backupManga.viewerFlags,
      history: backupManga.history.map(TachiBackupHistory.fromMihon).toList(),
      updateStrategy: TachiUpdateStrategyMapper.fromValue(backupManga.updateStrategy.value),
      lastModifiedAt: backupManga.lastModifiedAt.toInt(),
      favoriteModifiedAt: backupManga.favoriteModifiedAt.toInt(),
      excludedScanlators: backupManga.excludedScanlators,
      version: backupManga.version.toInt(),
    );
  }

  factory TachiBackupManga.fromSy(sy.BackupManga backupManga) {
    return TachiBackupManga(
      source: backupManga.source.toInt(),
      url: backupManga.url,
      title: backupManga.title,
      artist: backupManga.artist,
      author: backupManga.author,
      description: backupManga.description,
      genre: backupManga.genre,
      status: backupManga.status,
      thumbnailUrl: backupManga.thumbnailUrl,
      dateAdded: backupManga.dateAdded.toInt(),
      viewer: backupManga.viewer,
      chapters: backupManga.chapters.map(TachiBackupChapter.fromSy).toList(),
      categories: backupManga.categories.map((i) => i.toInt()).toList(),
      tracking: backupManga.tracking.map(TachiBackupTracking.fromSy).toList(),
      favorite: backupManga.favorite,
      chapterFlags: backupManga.chapterFlags,
      viewerFlags: backupManga.viewerFlags,
      history: backupManga.history.map(TachiBackupHistory.fromSy).toList(),
      updateStrategy: TachiUpdateStrategyMapper.fromValue(backupManga.updateStrategy.value),
      lastModifiedAt: backupManga.lastModifiedAt.toInt(),
      favoriteModifiedAt: backupManga.favoriteModifiedAt.toInt(),
      excludedScanlators: backupManga.excludedScanlators,
      version: backupManga.version.toInt(),
      customStatus: backupManga.customStatus,
      customThumbnailUrl: backupManga.customThumbnailUrl,
      customTitle: backupManga.customTitle,
      customArtist: backupManga.customArtist,
      customAuthor: backupManga.customAuthor,
      customDescription: backupManga.customDescription,
      customGenre: backupManga.customGenre,
    );
  }

  factory TachiBackupManga.fromJ2k(j2k.BackupManga backupManga) {
    return TachiBackupManga(
      source: backupManga.source.toInt(),
      url: backupManga.url,
      title: backupManga.title,
      artist: backupManga.artist,
      author: backupManga.author,
      description: backupManga.description,
      genre: backupManga.genre,
      status: backupManga.status,
      thumbnailUrl: backupManga.thumbnailUrl,
      dateAdded: backupManga.dateAdded.toInt(),
      viewer: backupManga.viewer,
      chapters: backupManga.chapters.map(TachiBackupChapter.fromJ2k).toList(),
      categories: backupManga.categories,
      tracking: backupManga.tracking.map(TachiBackupTracking.fromJ2k).toList(),
      favorite: backupManga.favorite,
      chapterFlags: backupManga.chapterFlags,
      brokenHistory: backupManga.brokenHistory.map(TachiBrokenBackupHistory.fromJ2k).toList(),
      viewerFlags: backupManga.viewerFlags,
      history: backupManga.history.map(TachiBackupHistory.fromJ2k).toList(),
      updateStrategy: TachiUpdateStrategyMapper.fromValue(backupManga.updateStrategy.value),
      customStatus: backupManga.customStatus,
      customTitle: backupManga.customTitle,
      customArtist: backupManga.customArtist,
      customAuthor: backupManga.customAuthor,
      customDescription: backupManga.customDescription,
      customGenre: backupManga.customGenre,
    );
  }

  factory TachiBackupManga.fromNeko(neko.BackupManga backupManga) {
    return TachiBackupManga(
      source: backupManga.source.toInt(),
      url: backupManga.url,
      title: backupManga.title,
      artist: backupManga.artist,
      author: backupManga.author,
      description: backupManga.description,
      genre: backupManga.genre,
      status: backupManga.status,
      thumbnailUrl: backupManga.thumbnailUrl,
      dateAdded: backupManga.dateAdded.toInt(),
      viewer: backupManga.viewer,
      chapters: backupManga.chapters.map(TachiBackupChapter.fromNeko).toList(),
      categories: backupManga.categories,
      tracking: backupManga.tracking.map(TachiBackupTracking.fromNeko).toList(),
      favorite: backupManga.favorite,
      chapterFlags: backupManga.chapterFlags,
      brokenHistory: backupManga.brokenHistory.map(TachiBrokenBackupHistory.fromNeko).toList(),
      viewerFlags: backupManga.viewerFlags,
      history: backupManga.history.map(TachiBackupHistory.fromNeko).toList(),
      scanlatorFilter: backupManga.scanlatorFilter,
      alternativeArtwork: backupManga.alternativeArtwork,
      mergeMangaList: backupManga.mergeMangaList.map(NekoBackupMergeManga.fromNeko).toList(),
    );
  }

  factory TachiBackupManga.fromYokai(yokai.BackupManga backupManga) {
    return TachiBackupManga(
      source: backupManga.source.toInt(),
      url: backupManga.url,
      title: backupManga.title,
      artist: backupManga.artist,
      author: backupManga.author,
      description: backupManga.description,
      genre: backupManga.genre,
      status: backupManga.status,
      thumbnailUrl: backupManga.thumbnailUrl,
      dateAdded: backupManga.dateAdded.toInt(),
      viewer: backupManga.viewer,
      chapters: backupManga.chapters.map(TachiBackupChapter.fromYokai).toList(),
      categories: backupManga.categories,
      tracking: backupManga.tracking.map(TachiBackupTracking.fromYokai).toList(),
      favorite: backupManga.favorite,
      chapterFlags: backupManga.chapterFlags,
      brokenHistory: backupManga.brokenHistory.map(TachiBrokenBackupHistory.fromYokai).toList(),
      viewerFlags: backupManga.viewerFlags,
      history: backupManga.history.map(TachiBackupHistory.fromYokai).toList(),
      updateStrategy: TachiUpdateStrategyMapper.fromValue(backupManga.updateStrategy.value),
      customStatus: backupManga.customStatus,
      customTitle: backupManga.customTitle,
      customArtist: backupManga.customArtist,
      customAuthor: backupManga.customAuthor,
      customDescription: backupManga.customDescription,
      customGenre: backupManga.customGenre,
    );
  }

  static const fromMap = TachiBackupMangaMapper.fromMap;
  static const fromJson = TachiBackupMangaMapper.fromJson;
}
