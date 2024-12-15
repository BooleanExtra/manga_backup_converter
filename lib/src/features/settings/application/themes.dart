import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'themes.g.dart';

@riverpod
List<FlexSchemeData> themes(Ref ref) {
  return FlexColor.schemesList;
}
