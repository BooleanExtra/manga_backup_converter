import 'package:mangabackupconverter_cli/src/exceptions/base_exeption.dart';

class MangayomiException extends MangaConverterException {
  const MangayomiException([super.message]);

  @override
  String toString() {
    final Object? message = this.message;
    if (message == null) return 'MangayomiException';
    return 'MangayomiException: $message';
  }
}
