import 'package:dart_mappable/dart_mappable.dart';
import 'package:mangabackupconverter_cli/src/common/extensions.dart';
import 'package:meta/meta.dart';

part 'backup_format.mapper.dart';

@MappableClass(discriminatorKey: 'type')
@immutable
sealed class BackupFormat with BackupFormatMappable {
  const BackupFormat();

  String get alias;
  List<String> get extensions;
  ExtensionType get extensionType;

  static const List<BackupFormat> values = <BackupFormat>[
    Aidoku(),
    Paperback(),
    Mihon(),
    TachiSy(),
    TachiJ2k(),
    TachiYokai(),
    TachiNeko(),
    Tachimanga(),
    Mangayomi(),
  ];

  static BackupFormat byName(String alias) {
    for (final BackupFormat format in values) {
      if (format.alias == alias) return format;
    }
    throw ArgumentError.value(alias, 'alias', 'Unknown backup format alias');
  }

  static BackupFormat? byExtension(String ext) {
    for (final BackupFormat format in values) {
      if (format.extensions.contains(ext)) return format;
    }
    return null;
  }

  static List<String> get validExtensions => values.expand((BackupFormat f) => f.extensions).toSet().toList();
}

@MappableClass(discriminatorValue: 'aidoku')
@immutable
class Aidoku extends BackupFormat with AidokuMappable {
  const Aidoku();

  @override
  String get alias => 'aidoku';

  @override
  List<String> get extensions => const <String>['.aib'];

  @override
  ExtensionType get extensionType => ExtensionType.aidoku;

  @override
  bool operator ==(Object other) => other is Aidoku;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'Aidoku';
}

@MappableClass(discriminatorValue: 'paperback')
@immutable
class Paperback extends BackupFormat with PaperbackMappable {
  const Paperback();

  @override
  String get alias => 'paperback';

  @override
  List<String> get extensions => const <String>['.pas4'];

  @override
  ExtensionType get extensionType => ExtensionType.paperback;

  @override
  bool operator ==(Object other) => other is Paperback;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'Paperback';
}

@MappableClass()
sealed class Tachiyomi extends BackupFormat with TachiyomiMappable {
  const Tachiyomi();

  @override
  List<String> get extensions => const <String>['.tachibk', '.proto.gz'];

  @override
  ExtensionType get extensionType => ExtensionType.tachi;
}

@MappableClass(discriminatorValue: 'mihon')
@immutable
class Mihon extends Tachiyomi with MihonMappable {
  const Mihon();

  @override
  String get alias => 'mihon';

  @override
  bool operator ==(Object other) => other is Mihon;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'Mihon';
}

@MappableClass(discriminatorValue: 'sy')
@immutable
class TachiSy extends Tachiyomi with TachiSyMappable {
  const TachiSy();

  @override
  String get alias => 'sy';

  @override
  bool operator ==(Object other) => other is TachiSy;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'TachiSy';
}

@MappableClass(discriminatorValue: 'j2k')
@immutable
class TachiJ2k extends Tachiyomi with TachiJ2kMappable {
  const TachiJ2k();

  @override
  String get alias => 'j2k';

  @override
  bool operator ==(Object other) => other is TachiJ2k;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'TachiJ2k';
}

@MappableClass(discriminatorValue: 'yokai')
@immutable
class TachiYokai extends Tachiyomi with TachiYokaiMappable {
  const TachiYokai();

  @override
  String get alias => 'yokai';

  @override
  bool operator ==(Object other) => other is TachiYokai;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'TachiYokai';
}

@MappableClass(discriminatorValue: 'neko')
@immutable
class TachiNeko extends Tachiyomi with TachiNekoMappable {
  const TachiNeko();

  @override
  String get alias => 'neko';

  @override
  bool operator ==(Object other) => other is TachiNeko;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'TachiNeko';
}

@MappableClass(discriminatorValue: 'tachimanga')
@immutable
class Tachimanga extends BackupFormat with TachimangaMappable {
  const Tachimanga();

  @override
  String get alias => 'tachimanga';

  @override
  List<String> get extensions => const <String>['.tmb'];

  @override
  ExtensionType get extensionType => ExtensionType.tachi;

  @override
  bool operator ==(Object other) => other is Tachimanga;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'Tachimanga';
}

@MappableClass(discriminatorValue: 'mangayomi')
@immutable
class Mangayomi extends BackupFormat with MangayomiMappable {
  const Mangayomi();

  @override
  String get alias => 'mangayomi';

  @override
  List<String> get extensions => const <String>['.backup'];

  @override
  ExtensionType get extensionType => ExtensionType.mangayomi;

  @override
  bool operator ==(Object other) => other is Mangayomi;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'Mangayomi';
}
