import 'package:stock/stock.dart';

class FutureStore {
  const FutureStore();
  _LocalDatabaseApi get _local => const _LocalDatabaseApi();

  /// Fetches new data from the network
  Fetcher<String, List<String>> get futureFetcher => Fetcher.ofFuture(
    (String userId) async => <String>[' _api.getUserTweets(userId)'],
  );
  Stock<String, List<String>> get stock => Stock<String, List<String>>(
    fetcher: futureFetcher,
    sourceOfTruth: _local.sourceOfTruthExample,
  );
}

class StreamStore {
  const StreamStore();
  _LocalDatabaseApi get _local => const _LocalDatabaseApi();

  /// Fetches new data from the network
  Fetcher<String, List<String>> get streamFetcher =>
      Fetcher.ofStream((String userId) async* {
        yield <String>[' _api.getUserTweets(userId)'];
      });
  Stock<String, List<String>> get stock => Stock<String, List<String>>(
    fetcher: streamFetcher,
    sourceOfTruth: _local.sourceOfTruthExample,
  );
}

class _LocalDatabaseApi {
  const _LocalDatabaseApi();

  /// Local database access for endpoint
  SourceOfTruth<String, List<String>> get sourceOfTruthExample =>
      SourceOfTruth<String, List<String>>(
        reader: (String userId) => const Stream<List<String>>.empty(),
        writer: (String userId, List<String>? tweets) => Future<void>.value(),
        delete: (String userId) => Future<void>.value(), // this is optional
        deleteAll: Future<void>.value, // this is optional
      );
}
