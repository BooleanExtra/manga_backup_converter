import 'package:mangabackupconverter_cli/src/exceptions/base_exception.dart';

class TachimangaException extends MangaConverterException {
  const TachimangaException([super.message, super.cause, super.stackTrace]);

  @override
  String toString() {
    final Object? message = this.message;
    if (message == null) return 'TachimangaException';
    return 'TachimangaException: $message';
  }
}
