@HtmlImport('tz_calendar.html')
library at_calendar;

import 'dart:async';
import 'dart:html';

import 'package:polymer/polymer.dart';
import 'package:tzolkin/date_range.dart';
import 'package:date_utils/date_utils.dart';
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

  DateRange _dateRange;
  StreamController<DateRange> _dateRangeSink = new StreamController.broadcast();

  DateRange get dateRange => _dateRange;
  Stream<DateRange> get onDateRangeChanged => _dateRangeSink.stream;

  String get title => get('_title');
  void set title(String t) {
    set('_title', t);
  }

  List<String> get weekdays => get('_weekdays');
  void set weekdays(List<String> t) {
    set('_weekdays', t);
  }

  List<List<DayProxy>> get days => get('_days');
  void set days(List<List<DayProxy>> t) {
    set('_days', t);
  }

  @Property()
  bool hideOtherWeeks = true;

  DateTime _currentWeek;
  DataSource _dataSource;

  @property
  String expandIcon;

  String get selectedDateLabel => get('_selectedDateLabel');
  void set selectedDateLabel(String t) {
    set('_selectedDateLabel', t);
  }

  DateTime _selectedDate;

  factory TzCalendar() => new TzCalendar._internal();
  factory TzCalendar._internal() => new Element.tag(TzCalendar.tag);
  TzCalendar.created() : super.created();

  DateTime get selectedDate => _selectedDate;

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    _currentWeek = _selectedDate;
    fire('day-selected', detail: Utils.apiDayFormat(date));
    selectedDateLabel = Utils.fullDayFormat(date);
  }

  void displayWeek(DateTime week, [DataSource source]) {
    _currentWeek = week;
    _dataSource = source;
    render();
  }

  void render() {
    title = Utils.formatMonth(_currentWeek);
    weekdays = Utils.weekdays;
    days = _daysForMonth(_currentWeek, _dataSource);
    set('expandIcon', _expandIconValue());
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

      var config = source?.configurationForDay(day);
      var proxy = new DayProxy(day, config?.progress ?? -1,
          Utils.isSameDay(_selectedDate, day), config?.color, config?.dotColor);
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

  String _expandIconValue() {
    if (hideOtherWeeks) {
      return 'icons:expand-more';
    } else {
      return 'icons:expand-less';
    }
  }

  @reflectable
  void handleDayTapped(CustomEvent e, DayProxy d) {
    setSelectedDate(d.date);
    render();
  }

  @reflectable
  void handleToggleWeek(e, d) {
    set('hideOtherWeeks', !hideOtherWeeks);
    set('expandIcon', _expandIconValue());

    emitRangeEvent();
    render();
  }

  @reflectable
  void handlePrevious(e, d) {
    if (hideOtherWeeks) {
      _currentWeek = Utils.previousWeek(_currentWeek);
    } else {
      _currentWeek = Utils.previousMonth(_currentWeek);
    }
    setSelectedDate(_currentWeek);
    emitRangeEvent();
    render();
  }

  @reflectable
  void handleNext(e, d) {
    if (hideOtherWeeks) {
      _currentWeek = Utils.nextWeek(_currentWeek);
    } else {
      _currentWeek = Utils.nextMonth(_currentWeek);
    }
    setSelectedDate(_currentWeek);
    emitRangeEvent();
    render();
  }

  void emitRangeEvent() {
    if (hideOtherWeeks) {
      _dateRange = new DateRange(Utils.firstDayOfWeek(_currentWeek),
          Utils.lastDayOfWeek(_currentWeek));
      _dateRangeSink.add(dateRange);
    } else {
      var days = Utils.daysInMonth(_currentWeek);
      _dateRange = new DateRange(days.first, days.last);
      _dateRangeSink.add(_dateRange);
    }
  }
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
