import 'dart:convert';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

class FlexSchemeDataMapper extends SimpleMapper<FlexSchemeData> {
  const FlexSchemeDataMapper();

  @override
  FlexSchemeData decode(Object value) {
    return FlexSchemeDataConverter.fromJson(value as String);
  }

  @override
  dynamic encode(FlexSchemeData self) {
    return self.toJson();
  }
}

extension FlexSchemeDataConverterExtension on FlexSchemeData {
  String toJson() {
    return FlexSchemeDataConverter(this).toJson();
  }

  Map<String, dynamic> toMap() {
    return FlexSchemeDataConverter(this).toMap();
  }
}

class FlexSchemeDataConverter {
  const FlexSchemeDataConverter(this.schemeData);
  final FlexSchemeData schemeData;

  String toJson() => jsonEncode(toMap());

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': schemeData.name,
      'description': schemeData.description,
      'light': FlexSchemeColorConverter(schemeData.light).toJson(),
      'dark': FlexSchemeColorConverter(schemeData.dark).toJson(),
    };
  }

  static FlexSchemeData fromJson(String json) =>
      fromMap(jsonDecode(json) as Map<dynamic, dynamic>);

  static FlexSchemeData fromMap(Map<dynamic, dynamic> map) {
    return FlexSchemeData(
      name: map['name'] as String,
      description: map['description'] as String,
      light: FlexSchemeColorConverter.fromMap(
        map['light'] as Map<dynamic, dynamic>,
      ),
      dark: FlexSchemeColorConverter.fromMap(
        map['dark'] as Map<dynamic, dynamic>,
      ),
    );
  }
}

class FlexSchemeColorConverter {
  const FlexSchemeColorConverter(this.schemeColor);
  final FlexSchemeColor schemeColor;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'primary': schemeColor.primary.toJson(),
      'primaryContainer': schemeColor.primaryContainer..toJson(),
      'secondary': schemeColor.secondary..toJson(),
      'secondaryContainer': schemeColor.secondaryContainer..toJson(),
      'tertiary': schemeColor.tertiary..toJson(),
      'tertiaryContainer': schemeColor.tertiaryContainer..toJson(),
      'appBarColor': schemeColor.appBarColor?..toJson(),
      'error': schemeColor.error?..toJson(),
      'errorContainer': schemeColor.errorContainer?..toJson(),
      'swapOnMaterial3': schemeColor.swapOnMaterial3,
    };
  }

  static FlexSchemeColor fromMap(Map<dynamic, dynamic> map) {
    return FlexSchemeColor(
      primary: _colorFromJson(map['primary'] as ColorJson),
      primaryContainer: _colorFromJson(map['primaryContainer'] as ColorJson),
      secondary: _colorFromJson(map['secondary'] as ColorJson),
      secondaryContainer: _colorFromJson(
        map['secondaryContainer'] as ColorJson,
      ),
      tertiary: _colorFromJson(map['tertiary'] as ColorJson),
      tertiaryContainer: _colorFromJson(map['tertiaryContainer'] as ColorJson),
      appBarColor:
          map['appBarColor'] == null
              ? null
              : _colorFromJson(map['appBarColor'] as ColorJson),
      error:
          map['error'] == null
              ? null
              : _colorFromJson(map['error'] as ColorJson),
      errorContainer:
          map['errorContainer'] == null
              ? null
              : _colorFromJson(map['errorContainer'] as ColorJson),
      swapOnMaterial3: map['swapOnMaterial3'] as bool,
    );
  }
}

typedef ColorJson = Map<String, double>;

Color _colorFromJson(ColorJson json) {
  return Color.from(
    red: json['r'] ?? 255,
    green: json['g'] ?? 255,
    blue: json['b'] ?? 255,
    alpha: json['a'] ?? 255,
  );
}

extension _ColorJsonExtension on Color {
  ColorJson toJson() {
    return {'r': r, 'g': g, 'b': b, 'a': a};
  }
}
