import 'package:mangabackupconverter_cli/src/common/backup_type.dart';
import 'package:mangabackupconverter_cli/src/common/extensions.dart';
import 'package:mangabackupconverter_cli/src/formats/tachi/tachi_fork.dart';
import 'package:meta/meta.dart';

@immutable
sealed class BackupFormat {
  const BackupFormat();

  factory BackupFormat.from(BackupType type, [TachiFork? fork]) {
    return switch (type) {
      BackupType.aidoku => const Aidoku(),
      BackupType.paperback => const Paperback(),
      BackupType.tachi => switch (fork) {
        TachiFork.mihon || null => const Mihon(),
        TachiFork.sy => const TachiSy(),
        TachiFork.j2k => const TachiJ2k(),
        TachiFork.yokai => const TachiYokai(),
        TachiFork.neko => const TachiNeko(),
      },
      BackupType.tachimanga => const Tachimanga(),
      BackupType.mangayomi => const Mangayomi(),
    };
  }

  BackupType get backupType;
  List<String> get extensions;
  ExtensionType get extensionType;
}

@immutable
class Aidoku extends BackupFormat {
  const Aidoku();

  @override
  BackupType get backupType => BackupType.aidoku;

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

@immutable
class Paperback extends BackupFormat {
  const Paperback();

  @override
  BackupType get backupType => BackupType.paperback;

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

sealed class Tachiyomi extends BackupFormat {
  const Tachiyomi();

  TachiFork get fork;

  @override
  BackupType get backupType => BackupType.tachi;

  @override
  List<String> get extensions => const <String>['.tachibk', '.proto.gz'];

  @override
  ExtensionType get extensionType => ExtensionType.tachi;
}

@immutable
class Mihon extends Tachiyomi {
  const Mihon();

  @override
  TachiFork get fork => TachiFork.mihon;

  @override
  bool operator ==(Object other) => other is Mihon;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'Mihon';
}

@immutable
class TachiSy extends Tachiyomi {
  const TachiSy();

  @override
  TachiFork get fork => TachiFork.sy;

  @override
  bool operator ==(Object other) => other is TachiSy;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'TachiSy';
}

@immutable
class TachiJ2k extends Tachiyomi {
  const TachiJ2k();

  @override
  TachiFork get fork => TachiFork.j2k;

  @override
  bool operator ==(Object other) => other is TachiJ2k;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'TachiJ2k';
}

@immutable
class TachiYokai extends Tachiyomi {
  const TachiYokai();

  @override
  TachiFork get fork => TachiFork.yokai;

  @override
  bool operator ==(Object other) => other is TachiYokai;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'TachiYokai';
}

@immutable
class TachiNeko extends Tachiyomi {
  const TachiNeko();

  @override
  TachiFork get fork => TachiFork.neko;

  @override
  bool operator ==(Object other) => other is TachiNeko;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'TachiNeko';
}

@immutable
class Mangayomi extends Tachiyomi {
  const Mangayomi();

  @override
  TachiFork get fork => TachiFork.mihon;

  @override
  BackupType get backupType => BackupType.mangayomi;

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

@immutable
class Tachimanga extends BackupFormat {
  const Tachimanga();

  @override
  BackupType get backupType => BackupType.tachimanga;

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
