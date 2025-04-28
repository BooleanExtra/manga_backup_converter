import 'package:dart_mappable/dart_mappable.dart';

part 'aidoku_enums.mapper.dart';

@MappableEnum(mode: ValuesMode.indexed, caseStyle: CaseStyle.camelCase)
enum AidokuMangaContentRating { safe, suggestive, nsfw }

@MappableEnum(mode: ValuesMode.indexed, caseStyle: CaseStyle.camelCase)
enum AidokuMangaViewer { defaultViewer, rtl, ltr, vertial, scroll }

@MappableEnum(mode: ValuesMode.indexed, caseStyle: CaseStyle.camelCase)
enum AidokuPublishingStatus {
  unknown,
  ongoing,
  completed,
  cancelled,
  hiatus,
  notPublished;

  const AidokuPublishingStatus();
}
