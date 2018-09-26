import 'package:meta/meta.dart';

class Day {
  final DateTime date;
  final int progress;
  final bool selected;
  final String color;
  final String dotColor;
  Day({
    @required this.date,
    @required this.progress,
    @required this.selected,
    @required this.color,
    @required this.dotColor,
  });
}

class DateRange {
  final DateTime start;
  final DateTime end;
  DateRange(this.start, this.end);
}

abstract class DataSource {
  DateConfiguration configurationForDay(DateTime day);
}

class DateConfiguration {
  final int progress;
  final String color;
  final String dotColor;
  DateConfiguration(this.progress, this.color, this.dotColor);
}