import 'dart:typed_data';
import '../models/filter.dart';
import '../models/manga.dart';
import '../models/source_info.dart';
import 'aix_parser.dart';

class AidokuPlugin {
  AidokuPlugin._(this.sourceInfo);

  final SourceInfo sourceInfo;

  /// Loads a plugin from raw .aix file bytes.
  static Future<AidokuPlugin> fromAix(Uint8List aixBytes) async {
    final bundle = AixParser.parse(aixBytes);
    // WasmRunner integration implemented in Task 7/8 after ABI discovery.
    return AidokuPlugin._(bundle.sourceInfo);
  }

  /// Search for manga matching [query] on the source.
  Future<MangaPageResult> searchManga(
    String query,
    int page, {
    List<FilterValue> filters = const [],
  }) async {
    throw UnimplementedError('searchManga — implement after Task 6 ABI discovery');
  }

  /// Fetch manga details for a given [key] (manga ID on the source).
  Future<Manga?> getMangaDetails(String key) async {
    throw UnimplementedError('getMangaDetails — implement after Task 6 ABI discovery');
  }
}
