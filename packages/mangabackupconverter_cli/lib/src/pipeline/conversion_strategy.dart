import 'package:mangabackupconverter_cli/src/pipeline/backup_format.dart';

sealed class ConversionStrategy {
  const ConversionStrategy();
}

class DirectConversion extends ConversionStrategy {
  const DirectConversion();
}

class Migration extends ConversionStrategy {
  const Migration();
}

class Skip extends ConversionStrategy {
  const Skip();
}

ConversionStrategy determineStrategy(BackupFormat source, BackupFormat target) {
  if (source == target) return const Skip();
  if (source is Tachiyomi && target is Tachiyomi) return const Skip();
  if ((source is Tachiyomi && target is Tachimanga) || (source is Tachimanga && target is Tachiyomi)) {
    return const DirectConversion();
  }
  return const Migration();
}
