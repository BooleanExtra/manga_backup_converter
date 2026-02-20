import 'package:mangabackupconverter_cli/src/common/extensions.dart';
import 'package:mangabackupconverter_cli/src/pipeline/manga_details.dart';
import 'package:mangabackupconverter_cli/src/pipeline/plugin_source.dart';
import 'package:wasm_plugin_loader/wasm_plugin_loader.dart';

abstract interface class MigrationCallbacks {
  Future<List<ExtensionRepo>> selectRepos(
    ExtensionType targetType,
    List<ExtensionRepo> available,
  );

  Future<List<SourceEntry>> selectExtensions(List<SourceEntry> available);

  Future<List<MangaMatchConfirmation>> confirmMatches(
    List<MangaMatchProposal> proposals,
  );

  void onProgress(int current, int total, String message);
}

class MangaMatchProposal {
  const MangaMatchProposal({required this.sourceManga, required this.candidates, this.bestMatch});

  final MangaDetails sourceManga;
  final List<PluginSearchResult> candidates;
  final PluginSearchResult? bestMatch;
}

class MangaMatchConfirmation {
  const MangaMatchConfirmation({required this.sourceManga, this.confirmedMatch});

  final MangaDetails sourceManga;
  final PluginSearchResult? confirmedMatch;
}
