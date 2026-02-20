import 'package:dart_mappable/dart_mappable.dart';
import 'package:mangabackupconverter_cli/src/formats/aidoku/aidoku_enums.dart';
import 'package:mangabackupconverter_cli/src/pipeline/manga_details.dart';

part 'paperback_backup_manga_info.mapper.dart';

@MappableClass()
class PaperbackBackupMangaInfo with PaperbackBackupMangaInfoMappable, MangaSearchEntry {
  final List<PaperbackBackupMangaTag> tags;
  final String desc;
  final String? rating;
  final List<String> titles;
  final List<String> covers;
  final String? banner;
  final String author;
  final String image;
  final bool hentai;
  final PaperbackBackupMangaAdditionalInfo additionalInfo;
  final String artist;
  final String id;
  final String status;

  PaperbackBackupMangaInfo({
    required this.tags,
    required this.desc,
    required this.titles,
    required this.covers,
    required this.author,
    required this.image,
    required this.hentai,
    required this.additionalInfo,
    required this.artist,
    required this.id,
    required this.status,
    this.rating,
    this.banner,
  });

  static String statusFromAidoku(AidokuPublishingStatus aidokuStatus) {
    return switch (aidokuStatus) {
      AidokuPublishingStatus.ongoing => 'Ongoing',
      AidokuPublishingStatus.completed => 'Completed',
      AidokuPublishingStatus.cancelled => 'Finished',
      AidokuPublishingStatus.unknown => 'Ongoing',
      AidokuPublishingStatus.hiatus => 'Ongoing',
      AidokuPublishingStatus.notPublished => 'Ongoing',
    };
  }

  @override
  MangaSearchDetails toMangaSearchDetails() {
    return MangaSearchDetails(
      title: titles.first,
      altTitles: titles.length > 1 ? titles.sublist(1) : const <String>[],
      authors: <String>[author],
      artists: <String>[artist],
      tagNames: tags.map((PaperbackBackupMangaTag t) => t.label).toList(),
      description: desc,
      coverImageUrl: image,
    );
  }

  static const PaperbackBackupMangaInfo Function(Map<String, dynamic> map) fromMap =
      PaperbackBackupMangaInfoMapper.fromMap;
  static const PaperbackBackupMangaInfo Function(String json) fromJson = PaperbackBackupMangaInfoMapper.fromJson;
}

@MappableClass()
class PaperbackBackupMangaAdditionalInfo with PaperbackBackupMangaAdditionalInfoMappable {
  final String? langFlag;
  final String? avgRating;
  final String? views;
  final String? follows;
  final String? users;
  final String? langName;

  PaperbackBackupMangaAdditionalInfo({
    this.langFlag,
    this.avgRating,
    this.views,
    this.follows,
    this.users,
    this.langName,
  });

  static const PaperbackBackupMangaAdditionalInfo Function(Map<String, dynamic> map) fromMap =
      PaperbackBackupMangaAdditionalInfoMapper.fromMap;
  static const PaperbackBackupMangaAdditionalInfo Function(String json) fromJson =
      PaperbackBackupMangaAdditionalInfoMapper.fromJson;
}

@MappableClass()
class PaperbackBackupMangaTag with PaperbackBackupMangaTagMappable {
  final String id;
  final String label;
  final List<PaperbackBackupMangaTag> tags;

  PaperbackBackupMangaTag({required this.id, required this.label, this.tags = const <PaperbackBackupMangaTag>[]});

  static const PaperbackBackupMangaTag Function(Map<String, dynamic> map) fromMap =
      PaperbackBackupMangaTagMapper.fromMap;
  static const PaperbackBackupMangaTag Function(String json) fromJson = PaperbackBackupMangaTagMapper.fromJson;
}
