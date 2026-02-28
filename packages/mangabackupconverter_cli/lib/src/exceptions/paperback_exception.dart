import 'package:mangabackupconverter_cli/src/exceptions/base_exception.dart';

class PaperbackException extends MangaConverterException {
  const PaperbackException([super.message, super.cause, super.stackTrace]);

  @override
  String toString() {
    final Object? message = this.message;
    if (message == null) return 'PaperbackException';
    return 'PaperbackException: $message';
  }
}
