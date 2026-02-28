import 'dart:typed_data';

import 'package:aidoku_plugin_loader/src/codec/postcard_writer.dart';

sealed class SettingItem {
  const SettingItem({
    this.key,
    this.title,
    this.subtitle,
    this.footer,
    this.requires,
    this.requiresFalse,
  });

  final String? key;
  final String? title;
  final String? subtitle;
  final String? footer;
  final String? requires;
  final String? requiresFalse;

  factory SettingItem.fromJson(Map<String, dynamic> json) {
    final String type = json['type'] as String? ?? '';
    final key = json['key'] as String?;
    final title = json['title'] as String?;
    final subtitle = json['subtitle'] as String?;
    final footer = json['footer'] as String?;
    final requires = json['requires'] as String?;
    final requiresFalse = json['requiresFalse'] as String?;

    switch (type) {
      case 'switch':
      case 'toggle':
        return SwitchSetting(
          defaultValue: (json['default'] as bool?) ?? false,
          key: key,
          title: title,
          subtitle: subtitle,
          footer: footer,
          requires: requires,
          requiresFalse: requiresFalse,
        );
      case 'select':
        final List<String> values = _stringList(json['values']);
        final List<String> titles = _stringList(json['titles'] ?? json['cases']);
        return SelectSetting(
          values: values,
          titles: titles,
          key: key,
          title: title,
          subtitle: subtitle,
          footer: footer,
          requires: requires,
          requiresFalse: requiresFalse,
          defaultValue: json['default'] as String?,
        );
      case 'segment':
        final List<String> values = _stringList(json['values']);
        final List<String> titles = _stringList(json['titles'] ?? json['cases']);
        return SegmentSetting(
          values: values,
          titles: titles,
          defaultValue: (json['default'] as int?) ?? 0,
          key: key,
          title: title,
          subtitle: subtitle,
          footer: footer,
          requires: requires,
          requiresFalse: requiresFalse,
        );
      case 'multi-select':
      case 'multiSelect':
        return MultiSelectSetting(
          values: _stringList(json['values']),
          defaultValue: _stringList(json['default']),
          key: key,
          title: title,
          subtitle: subtitle,
          footer: footer,
          requires: requires,
          requiresFalse: requiresFalse,
        );
      case 'stepper':
        return StepperSetting(
          min: (json['minimumValue'] as num?)?.toDouble() ?? 0,
          max: (json['maximumValue'] as num?)?.toDouble() ?? 10,
          step: (json['stepValue'] as num?)?.toDouble() ?? 1,
          defaultValue: (json['default'] as num?)?.toDouble() ?? 0,
          key: key,
          title: title,
          subtitle: subtitle,
          footer: footer,
          requires: requires,
          requiresFalse: requiresFalse,
        );
      case 'text':
        return TextSetting(
          defaultValue: json['default'] as String? ?? '',
          key: key,
          title: title,
          subtitle: subtitle,
          footer: footer,
          requires: requires,
          requiresFalse: requiresFalse,
        );
      case 'group':
        return GroupSetting(
          items: _parseItems(json['items']),
          key: key,
          title: title,
          subtitle: subtitle,
          footer: footer,
          requires: requires,
          requiresFalse: requiresFalse,
        );
      case 'page':
        return PageSetting(
          items: _parseItems(json['items']),
          key: key,
          title: title,
          subtitle: subtitle,
          footer: footer,
          requires: requires,
          requiresFalse: requiresFalse,
        );
      default:
        return UnknownSetting(
          type: type,
          key: key,
          title: title,
          subtitle: subtitle,
          footer: footer,
          requires: requires,
          requiresFalse: requiresFalse,
        );
    }
  }

  /// Returns (key, seedValue) for pre-seeding HostStore.defaults, or null.
  ({String key, Object value})? get defaultEntry => null;
}

// ---------------------------------------------------------------------------
// Concrete subtypes
// ---------------------------------------------------------------------------

class SwitchSetting extends SettingItem {
  const SwitchSetting({
    required this.defaultValue,
    super.key,
    super.title,
    super.subtitle,
    super.footer,
    super.requires,
    super.requiresFalse,
  });

  final bool defaultValue;

  @override
  ({String key, Object value})? get defaultEntry {
    final String? k = key;
    if (k == null) return null;
    return (key: k, value: (PostcardWriter()..writeBool(defaultValue)).bytes);
  }
}

class SelectSetting extends SettingItem {
  const SelectSetting({
    required this.values,
    required this.titles,
    super.key,
    super.title,
    super.subtitle,
    super.footer,
    super.requires,
    super.requiresFalse,
    this.defaultValue,
  });

  final List<String> values;
  final List<String> titles;
  final String? defaultValue;

  @override
  ({String key, Object value})? get defaultEntry {
    final String? k = key;
    if (k == null) return null;
    final int idx = defaultValue != null ? values.indexOf(defaultValue!) : -1;
    return (key: k, value: (PostcardWriter()..writeSignedVarInt(idx >= 0 ? idx : 0)).bytes);
  }
}

class SegmentSetting extends SettingItem {
  const SegmentSetting({
    required this.values,
    required this.titles,
    required this.defaultValue,
    super.key,
    super.title,
    super.subtitle,
    super.footer,
    super.requires,
    super.requiresFalse,
  });

  final List<String> values;
  final List<String> titles;
  final int defaultValue;

  @override
  ({String key, Object value})? get defaultEntry {
    final String? k = key;
    if (k == null) return null;
    return (key: k, value: (PostcardWriter()..writeSignedVarInt(defaultValue)).bytes);
  }
}

class MultiSelectSetting extends SettingItem {
  const MultiSelectSetting({
    required this.values,
    required this.defaultValue,
    super.key,
    super.title,
    super.subtitle,
    super.footer,
    super.requires,
    super.requiresFalse,
  });

  final List<String> values;
  final List<String> defaultValue;

  @override
  ({String key, Object value})? get defaultEntry {
    final String? k = key;
    if (k == null) return null;
    return (key: k, value: _postcardEncodeStringList(defaultValue));
  }
}

class StepperSetting extends SettingItem {
  const StepperSetting({
    required this.min,
    required this.max,
    required this.step,
    required this.defaultValue,
    super.key,
    super.title,
    super.subtitle,
    super.footer,
    super.requires,
    super.requiresFalse,
  });

  final double min;
  final double max;
  final double step;
  final double defaultValue;

  @override
  ({String key, Object value})? get defaultEntry {
    final String? k = key;
    if (k == null) return null;
    return (key: k, value: (PostcardWriter()..writeSignedVarInt(defaultValue.round())).bytes);
  }
}

class TextSetting extends SettingItem {
  const TextSetting({
    required this.defaultValue,
    super.key,
    super.title,
    super.subtitle,
    super.footer,
    super.requires,
    super.requiresFalse,
  });

  final String defaultValue;

  @override
  ({String key, Object value})? get defaultEntry {
    final String? k = key;
    if (k == null) return null;
    return (key: k, value: (PostcardWriter()..writeString(defaultValue)).bytes);
  }
}

class GroupSetting extends SettingItem {
  const GroupSetting({
    required this.items,
    super.key,
    super.title,
    super.subtitle,
    super.footer,
    super.requires,
    super.requiresFalse,
  });

  final List<SettingItem> items;

  // GroupSetting itself has no defaultEntry; children are flattened by
  // flattenSettingDefaults.
}

class PageSetting extends SettingItem {
  const PageSetting({
    required this.items,
    super.key,
    super.title,
    super.subtitle,
    super.footer,
    super.requires,
    super.requiresFalse,
  });

  final List<SettingItem> items;
}

class UnknownSetting extends SettingItem {
  const UnknownSetting({
    required this.type,
    super.key,
    super.title,
    super.subtitle,
    super.footer,
    super.requires,
    super.requiresFalse,
  });

  final String type;
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Flatten a list of settings into key→seed-value pairs, recursing into groups.
/// If [sourceId] is provided, all keys are prefixed with `"$sourceId."`.
Map<String, Object> flattenSettingDefaults(
  List<SettingItem> items, {
  String? sourceId,
}) {
  final result = <String, Object>{};
  for (final item in items) {
    final ({String key, Object value})? entry = item.defaultEntry;
    if (entry != null) {
      final String key = sourceId != null ? '$sourceId.${entry.key}' : entry.key;
      result[key] = entry.value;
    }
    if (item is GroupSetting) {
      result.addAll(flattenSettingDefaults(item.items, sourceId: sourceId));
    } else if (item is PageSetting) {
      result.addAll(flattenSettingDefaults(item.items, sourceId: sourceId));
    }
  }
  return result;
}

List<String> _stringList(Object? raw) {
  if (raw is List) return raw.cast<String>();
  return const <String>[];
}

List<SettingItem> _parseItems(Object? raw) {
  if (raw is! List) return const <SettingItem>[];
  return raw.whereType<Map<String, dynamic>>().map(SettingItem.fromJson).toList();
}

Uint8List _postcardEncodeStringList(List<String> values) {
  final writer = PostcardWriter();
  writer.writeList(values, (String s, PostcardWriter w) => w.writeString(s));
  return writer.bytes;
}
