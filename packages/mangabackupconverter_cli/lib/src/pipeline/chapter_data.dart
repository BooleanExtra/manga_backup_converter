abstract interface class ChapterData {
  String get chapterId;
  String? get title;
  double? get chapterNumber;
  double? get volumeNumber;
  String? get scanlator;
  String? get language;
  DateTime? get dateUploaded;
  String? get url;
  int get sourceOrder;
}
