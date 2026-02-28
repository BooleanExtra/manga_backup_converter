import 'package:mangabackupconverter_cli/src/exceptions/base_exception.dart';

class TachiException extends MangaConverterException {
  const TachiException([super.message, super.cause, super.stackTrace]);

  @override
  String toString() {
    final Object? message = this.message;
    if (message == null) return 'TachiException';
    return 'TachiException: $message';
  }
}
