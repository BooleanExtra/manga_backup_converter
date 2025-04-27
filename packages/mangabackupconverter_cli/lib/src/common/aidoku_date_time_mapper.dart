import 'package:dart_mappable/dart_mappable.dart';

class AidokuDateTimeMapper extends SimpleMapper<DateTime> {
  const AidokuDateTimeMapper();

  @override
  DateTime decode(Object value) {
    if (value is num) {
      return DateTime.fromMillisecondsSinceEpoch((value * 1000).round());
    } else if (value is String) {
      return DateTime.parse(value);
    } else if (value is DateTime) {
      return value;
    }
    return DateTime.now();
  }

  @override
  dynamic encode(DateTime self) {
    return self;
  }
}
