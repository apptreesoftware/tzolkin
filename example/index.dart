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

  int progressForDay(DateTime day) {
    if (day.weekday == 2) {
      return 40;
    }
    return -1;
  }
}