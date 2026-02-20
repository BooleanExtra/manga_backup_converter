/// A language entry from an Aidoku source manifest's `languages` array.
/// Mirrors Swift's LanguageInfo in Source.swift.
class LanguageInfo {
  const LanguageInfo({required this.code, this.value, this.isDefault});

  /// BCP-47 language code, e.g. "en".
  final String code;

  /// Display/filter value; falls back to [code] when absent.
  final String? value;

  /// Whether this language is pre-selected by default.
  final bool? isDefault;

  /// Returns [value] if non-null, otherwise [code].
  String get effectiveValue => value ?? code;

  factory LanguageInfo.fromJson(Object raw) {
    if (raw is String) return LanguageInfo(code: raw, value: raw);
    final Map<String, dynamic> m = raw as Map<String, dynamic>;
    return LanguageInfo(
      code: m['code'] as String,
      value: m['value'] as String?,
      isDefault: m['default'] as bool?,
    );
  }
}
