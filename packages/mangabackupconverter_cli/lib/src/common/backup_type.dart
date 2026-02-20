enum BackupType {
  aidoku(<String>['.aib']),
  paperback(<String>['.pas4']),
  tachi(<String>['.tachibk', '.proto.gz']),
  tachimanga(<String>['.tmb']),
  mangayomi(<String>['.backup'])
  ;

  const BackupType(this.extensions);

  final List<String> extensions;

  static List<String> get validExtensions => values.expand((BackupType e) => e.extensions).toList();

  static BackupType? byExtension(String extension) {
    for (final BackupType type in values) {
      if (type.extensions.contains(extension)) {
        return type;
      }
    }
    return null;
  }
}
