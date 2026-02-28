abstract class MangaConverterException implements Exception {
  const MangaConverterException([this.message, this.cause, this.stackTrace]);

  final Object? message;

  /// The underlying error that caused this exception, if any.
  final Object? cause;

  /// The stack trace of the [cause], if available.
  final StackTrace? stackTrace;
}
