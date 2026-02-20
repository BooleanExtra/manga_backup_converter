import 'package:mangabackupconverter_cli/src/common/extensions.dart';
import 'package:mangabackupconverter_cli/src/pipeline/plugin_source.dart';

class StubPluginSource implements PluginSource {
  const StubPluginSource({required this.sourceId, required this.sourceName, required this.extensionType});

  @override
  final String sourceId;

  @override
  final String sourceName;

  @override
  final ExtensionType extensionType;

  @override
  Future<PluginSearchPageResult> search(String query, int page) {
    throw UnimplementedError('Search is not yet implemented for $extensionType sources');
  }

  @override
  void dispose() {}
}
