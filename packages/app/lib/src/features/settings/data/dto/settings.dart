import 'package:dart_mappable/dart_mappable.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:mangabackupconverter/src/features/settings/data/dto/flex_scheme_data.dart';
import 'package:mangabackupconverter/src/features/settings/data/dto/theme_type.dart';

part 'settings.mapper.dart';

@MappableClass(
  includeCustomMappers: <MapperBase<Object>>[FlexSchemeDataMapper()],
)
class Settings with SettingsMappable {
  @MappableField()
  final bool bannerEnabled;

  @MappableField()
  final ThemeType themeType;

  @MappableField()
  final FlexSchemeData lightTheme;

  @MappableField()
  final FlexSchemeData darkTheme;

  @MappableField()
  final List<FlexSchemeData> customThemes;

  const Settings({
    this.bannerEnabled = true,
    this.themeType = ThemeType.system,
    this.lightTheme = FlexColor.flutterDash,
    this.darkTheme = FlexColor.bahamaBlue,
    this.customThemes = const <FlexSchemeData>[],
  });

  static const Settings Function(Map<String, dynamic> map) fromMap =
      SettingsMapper.fromMap;
  static const Settings Function(String json) fromJson =
      SettingsMapper.fromJson;
}
