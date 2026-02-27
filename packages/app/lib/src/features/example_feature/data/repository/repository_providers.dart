import 'package:http/http.dart' as http;
import 'package:mangabackupconverter/src/features/example_feature/data/data_source/weather_api.dart';
import 'package:mangabackupconverter/src/features/example_feature/data/repository/weather_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repository_providers.g.dart';

@riverpod
HttpWeatherRepository weatherRepository(Ref ref) {
  return HttpWeatherRepository(
    api: OpenWeatherMapAPI(''),
    client: http.Client(),
  );
}
