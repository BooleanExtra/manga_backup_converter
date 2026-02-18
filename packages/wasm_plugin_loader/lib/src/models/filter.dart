enum FilterType { text, check, sort, select, range, group }

class FilterValue {
  const FilterValue({required this.type, required this.name, this.value});

  final FilterType type;
  final String name;
  final Object? value;
}
