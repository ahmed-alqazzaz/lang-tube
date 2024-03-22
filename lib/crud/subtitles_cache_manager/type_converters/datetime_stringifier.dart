import 'package:floor/floor.dart';

class DateTimeStringifier extends TypeConverter<DateTime?, String> {
  @override
  DateTime decode(String databaseValue) => DateTime.parse(databaseValue);

  @override
  String encode(DateTime? value) => (value ?? DateTime.now()).toIso8601String();
}
