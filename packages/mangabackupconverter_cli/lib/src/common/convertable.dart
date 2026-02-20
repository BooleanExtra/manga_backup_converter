import 'dart:typed_data';

import 'package:mangabackupconverter_cli/src/pipeline/manga_details.dart';

abstract interface class ConvertableType<ReturnType, ArgumentType> {
  ReturnType toType(ArgumentType arg);
}

abstract interface class ConvertableBackup {
  Future<Uint8List> toData();
  // ignore: avoid_positional_boolean_parameters
  void verbosePrint(bool verbose);
  List<MangaSearchEntry> get mangaSearchEntries;
}
