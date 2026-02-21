/// A single page in a manga chapter, as returned by `getPageList`.
class Page {
  const Page({
    required this.index,
    this.url,
    this.base64,
    this.text,
  });

  /// 0-based page index within the chapter.
  final int index;

  /// Remote image URL, if provided by the source.
  final String? url;

  /// Base64-encoded image data, if provided by the source.
  final String? base64;

  /// Alt text / caption, if provided by the source.
  final String? text;

  @override
  String toString() => 'Page(index: $index, url: $url)';
}
