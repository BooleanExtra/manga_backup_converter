import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:mangabackupconverter/src/features/settings/data/dto/human_name_enum.dart';

part 'theme_type.mapper.dart';

@MappableEnum()
enum ThemeType implements HumanReadableEnum {
  light('Light'),

  dark('Dark'),

  system('System')
  ;

  const ThemeType(this.humanName);

  @override
  final String humanName;

  ThemeMode toThemeMode() {
    switch (this) {
      case ThemeType.light:
        return ThemeMode.light;
      case ThemeType.dark:
        return ThemeMode.dark;
      case ThemeType.system:
        return ThemeMode.system;
    }
  }
}
