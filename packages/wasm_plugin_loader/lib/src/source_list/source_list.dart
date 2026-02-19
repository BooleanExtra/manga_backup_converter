import 'source_entry.dart';

class RemoteSourceList {
  const RemoteSourceList({
    required this.url,
    required this.name,
    required this.sources,
  });

  /// The URL this list was fetched from.
  final String url;

  /// The "name" field from the JSON payload.
  final String name;

  final List<SourceEntry> sources;
}
