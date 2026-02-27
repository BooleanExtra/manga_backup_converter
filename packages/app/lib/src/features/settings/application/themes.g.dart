// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'themes.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(themes)
const themesProvider = ThemesProvider._();

final class ThemesProvider
    extends
        $FunctionalProvider<
          List<FlexSchemeData>,
          List<FlexSchemeData>,
          List<FlexSchemeData>
        >
    with $Provider<List<FlexSchemeData>> {
  const ThemesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themesHash();

  @$internal
  @override
  $ProviderElement<List<FlexSchemeData>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<FlexSchemeData> create(Ref ref) {
    return themes(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<FlexSchemeData> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<FlexSchemeData>>(value),
    );
  }
}

String _$themesHash() => r'7e6d99d7f799b4167616cc7aa1bca779f7869d7b';
