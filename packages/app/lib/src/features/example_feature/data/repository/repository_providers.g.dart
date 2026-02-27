// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repository_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(weatherRepository)
const weatherRepositoryProvider = WeatherRepositoryProvider._();

final class WeatherRepositoryProvider
    extends
        $FunctionalProvider<
          HttpWeatherRepository,
          HttpWeatherRepository,
          HttpWeatherRepository
        >
    with $Provider<HttpWeatherRepository> {
  const WeatherRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weatherRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weatherRepositoryHash();

  @$internal
  @override
  $ProviderElement<HttpWeatherRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  HttpWeatherRepository create(Ref ref) {
    return weatherRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HttpWeatherRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HttpWeatherRepository>(value),
    );
  }
}

String _$weatherRepositoryHash() => r'61cf2b4c513d2c41baad1b3e281909f5a6e8b816';
