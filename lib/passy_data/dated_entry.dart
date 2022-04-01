import 'package:passy/passy_data/json_convertable.dart';

abstract class DatedEntry<T> implements JsonConvertable {
  final DateTime creationDate;
  int compareTo(T other);

  DatedEntry(this.creationDate);
}