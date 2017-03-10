@HtmlImport('tz_calendar.html')
library at_calendar;

import 'dart:html';

import 'package:polymer/polymer.dart';
import 'package:tzolkin/src/utils.dart';
import 'package:tzolkin/tz_day.dart';
import 'package:web_components/web_components.dart' show HtmlImport;

//ignore: unused_import
import "package:polymer_elements/iron_flex_layout.dart";

//ignore: unused_import
import "package:polymer_elements/paper_icon_button.dart";

//ignore: unused_import
import "package:polymer_elements/iron_icons.dart";

@PolymerRegister(TzCalendar.tag)
class TzCalendar extends PolymerElement {
  static const String tag = 'tz-calendar';

  @Property()
  String _title;

  String get title => get('_title');
  void set title(String t) {
    set('_title', t);
  }

  @Property()
  List<String> _weekdays;

  List<String> get weekdays => get('_weekdays');
  void set weekdays(List<String> t) {
    set('_weekdays', t);
  }

  @Property()
  List<List<DayProxy>> _days;

  List<List<DayProxy>> get days => get('_days');
  void set days(List<List<DayProxy>> t) {
    set('_days', t);
  }

  @Property()
  bool hideOtherWeeks = true;

  DateTime _currentWeek;
  DataSource _dataSource;

  DateTime _selectedDate;

  factory TzCalendar() => new TzCalendar._internal();
  factory TzCalendar._internal() => new Element.tag(TzCalendar.tag);
  TzCalendar.created() : super.created();

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    _currentWeek = _selectedDate;
  }

  void displayWeek(DateTime week, [DataSource source]) {
    _currentWeek = week;
    _dataSource = source;
    _render();
  }

  void _render() {
    title = Utils.formatMonth(_currentWeek);
    weekdays = Utils.weekdays;
    days = _daysForMonth(_currentWeek, _dataSource);
  }

  List<List<DayProxy>> _daysForMonth(month, DataSource source) {
    var days = Utils.daysInMonth(month);
    List<List<DayProxy>> result = [];
    // the current week;
    List<DayProxy> week = [];

    for (var day in days) {
      if (!_shouldRenderDay(day)) {
        continue;
      }

      var proxy = new DayProxy(day, source?.progressForDay(day), Utils.isSameDay(_selectedDate, day));
      week.add(proxy);
      if (week.length >= 7) {
        result.add(week);
        week = [];
      }
    }
    return result;
  }

  bool _shouldRenderDay(DateTime day) {
    if (!hideOtherWeeks) {
      return true;
    }

    if (_selectedDate == null) {
      return true;
    }

    if (Utils.isSameWeek(day, _currentWeek)) {
      return true;
    }

    return false;
  }

  @reflectable
  void handleDayTapped(CustomEvent e, DayProxy d) {
    _selectedDate = d.date;
    _currentWeek = _selectedDate;
    _render();
  }

  @reflectable
  void handleToggleWeek(e, d) {
    set('hideOtherWeeks', !hideOtherWeeks);
    _render();
  }

  @reflectable
  void handlePrevious(e, d) {
    if (hideOtherWeeks) {
      _currentWeek = Utils.previousWeek(_currentWeek);
    } else {
      _currentWeek = Utils.previousMonth(_currentWeek);
    }
    _render();
  }

  @reflectable
  void handleNext(e, d) {
    if(hideOtherWeeks) {
      _currentWeek = Utils.nextWeek(_currentWeek);
    } else {
      _currentWeek = Utils.nextMonth(_currentWeek);
    }
    _render();
  }
}

abstract class DataSource {
  int progressForDay(DateTime day);
}
