enum BackupType {
  aidoku(['.aib']),
  paperback(['.pas4']),
  tachi(['.tachibk', '.proto.gz']),
  tachimanga(['.tmb']),
  mangayomi(['.backup'])
  ;

  const BackupType(this.extensions);

  final List<String> extensions;

  static List<String> get validExtensions => values.expand((e) => e.extensions).toList();

  static BackupType? byExtension(String extension) {
    for (final type in values) {
      if (type.extensions.contains(extension)) {
        return type;
      }
    }
    return null;
  }
}
