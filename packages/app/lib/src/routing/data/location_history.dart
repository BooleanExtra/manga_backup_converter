import 'package:dart_mappable/dart_mappable.dart';

part 'location_history.mapper.dart';

/// Source: @cgestes https://github.com/flutter/flutter/issues/115353#issuecomment-1675808675
@MappableClass()
class LocationHistory with LocationHistoryMappable {
  @MappableField()
  final List<Uri> history;
  @MappableField()
  final List<Uri> popped;

  /// Source: @cgestes https://github.com/flutter/flutter/issues/115353#issuecomment-1675808675
  const LocationHistory({
    this.history = const <Uri>[],
    this.popped = const <Uri>[],
  });

  bool hasForward() {
    return popped.isNotEmpty;
  }

  bool hasBackward() {
    return history.length > 1;
  }

  static const LocationHistory Function(Map<String, dynamic> map) fromMap =
      LocationHistoryMapper.fromMap;
  static const LocationHistory Function(String json) fromJson =
      LocationHistoryMapper.fromJson;
}
