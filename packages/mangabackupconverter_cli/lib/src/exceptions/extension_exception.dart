import 'package:mangabackupconverter_cli/src/exceptions/base_exeption.dart';

class ExtensionException extends MangaConverterException {
  const ExtensionException([super.message]);

  @override
  String toString() {
    final Object? message = this.message;
    if (message == null) return 'ExtensionException';
    return 'ExtensionException: $message';
  }
}
