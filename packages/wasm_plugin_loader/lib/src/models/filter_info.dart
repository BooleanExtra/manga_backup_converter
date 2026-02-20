import 'package:wasm_plugin_loader/src/models/filter.dart';

class FilterInfo {
  const FilterInfo({
    required this.type,
    this.name,
    this.defaultValue,
    this.options = const <String>[],
    this.canExclude = false,
    this.canAscend = false,
    this.items = const <FilterInfo>[],
  });

  final String type;
  final String? name;
  final Object? defaultValue; // bool for check, int for select/sort/segment
  final List<String> options;
  final bool canExclude;
  final bool canAscend;
  final List<FilterInfo> items;

  factory FilterInfo.fromJson(Map<String, dynamic> json) {
    final String type = json['type'] as String? ?? '';
    final String? name = json['name'] as String?;
    final bool canExclude = json['canExclude'] as bool? ?? false;
    final bool canAscend = json['canAscend'] as bool? ?? false;
    final List<String> options = _stringList(json['options'] ?? json['cases'] ?? json['values']);

    Object? defaultValue;
    switch (type) {
      case 'check':
        defaultValue = json['default'] as bool? ?? false;
      case 'select':
      case 'segment':
        final Object? rawDefault = json['default'];
        defaultValue = rawDefault is int ? rawDefault : 0;
      case 'sort':
        // Sort default can be an int index or a Map {index: int, ascending: bool}.
        final Object? rawDefault = json['default'];
        if (rawDefault is int) {
          defaultValue = rawDefault;
        } else if (rawDefault is Map) {
          defaultValue = (rawDefault['index'] as int?) ?? 0;
        } else {
          defaultValue = 0;
        }
    }

    final Object? rawItems = json['filters'] ?? json['items'];
    final List<FilterInfo> items = rawItems is List
        ? rawItems.whereType<Map<String, dynamic>>().map(FilterInfo.fromJson).toList()
        : const <FilterInfo>[];

    return FilterInfo(
      type: type,
      name: name,
      defaultValue: defaultValue,
      options: options,
      canExclude: canExclude,
      canAscend: canAscend,
      items: items,
    );
  }

  /// Convert to a [FilterValue] representing this filter's default state.
  /// Returns null for filter types that have no meaningful default.
  FilterValue? toDefaultFilterValue() {
    final String? n = name;
    switch (type) {
      case 'check':
        if (n == null) return null;
        return FilterValue(
          type: FilterType.check,
          name: n,
          value: (defaultValue as bool?) ?? false,
        );
      case 'select':
      case 'segment':
        if (n == null) return null;
        return FilterValue(
          type: FilterType.select,
          name: n,
          value: (defaultValue as int?) ?? 0,
        );
      case 'sort':
        if (n == null) return null;
        return FilterValue(
          type: FilterType.sort,
          name: n,
          value: (defaultValue as int?) ?? 0,
        );
      default:
        return null;
    }
  }
}

List<String> _stringList(Object? raw) {
  if (raw is List) return raw.cast<String>();
  return const <String>[];
}
