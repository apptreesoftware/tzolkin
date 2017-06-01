library calendar_example;

import 'dart:async';

import 'dart:html';
import 'package:polymer/polymer.dart';

// ignore: unused_import
import 'package:tzolkin/tz_calendar.dart';

Future<Null> main() async {
  await initPolymer();

  var calendar = querySelector("#calendar") as TzCalendar;
  calendar.set('hideOtherWeeks', true);
  var date = new DateTime(2017, 3, 10);
  calendar.setSelectedDate(date);
  calendar.displayWeek(date, new MockDataSource());
  calendar.on['day-selected'].listen((Event e) {
    print("Selected Day: ${calendar.selectedDate}");
  });
}

class MockDataSource implements DataSource {
  @override
  DateConfiguration configurationForDay(DateTime day) {
    if (day.day == 1) {
      return new DateConfiguration(40, "blue", "red");
    }

    if (day.day == 2) {
      return new DateConfiguration(40, null, "green");
    }

    return new DateConfiguration(-1, null, null);
  }
}
