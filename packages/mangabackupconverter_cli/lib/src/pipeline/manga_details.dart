abstract interface class MangaDetails {
  String get title;
  List<String> get altTitles;
  List<String> get authors;
  List<String> get artists;
  List<String> get tagNames;
  String? get description;
  int? get chaptersCount;
  double? get latestChapterNum;
  String? get coverImageUrl;
  List<String> get languages;
}
