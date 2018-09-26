library at_calendar;

import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart' hide DateRange;
import 'package:tzolkin/date_range.dart';
import 'package:date_utils/date_utils.dart';
import 'package:tzolkin/tz_day_component.dart';

@Component(
  selector: 'tz-calendar',
  templateUrl: 'tz_calendar_component.html',
  styleUrls: ['tz_calendar_component.css'],
  directives: [
    coreDirectives,
    TzDay,
    MaterialButtonComponent,
    MaterialIconComponent,
  ],
)
class TzCalendar implements OnInit {
  DateRange _dateRange;
  StreamController<DateRange> _dateRangeSink = new StreamController.broadcast();
  StreamController<String> _daySelectedSink = new StreamController.broadcast();

  void ngOnInit() {
    displayWeek(_selectedDate);
  }

  DateRange get dateRange => _dateRange;
  @Output()
  Stream<DateRange> get onDateRangeChanged => _dateRangeSink.stream;

  String title;

  List<String> weekdays = [];

  List<List<Day>> days = [];

  @Input()
  bool hideOtherWeeks = true;

  DateTime _currentWeek;
  DataSource _dataSource;

  @Input()
  void set dataSource(DataSource dataSource) {
    _dataSource = dataSource;
  }

  @Input()
  String expandIcon;

  String selectedDateLabel;

  DateTime _selectedDate;

  DateTime get selectedDate => _selectedDate;
  @Input()
  void set selectedDate(DateTime date) {
    setSelectedDate(date);
  }

  Stream<String> get onDaySelected => _daySelectedSink.stream;

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    _currentWeek = _selectedDate;
    _daySelectedSink.add(Utils.apiDayFormat(date));
    selectedDateLabel = Utils.fullDayFormat(date);
  }

  void displayWeek(DateTime week) {
    _currentWeek = week;
    render();
  }

  void render() {
    title = Utils.formatMonth(_currentWeek);
    weekdays = Utils.weekdays;
    days = _daysForMonth(_currentWeek, _dataSource);
    expandIcon = _expandIconValue();
  }

  List<List<Day>> _daysForMonth(month, DataSource source) {
    var days = Utils.daysInMonth(month);
    List<List<Day>> result = [];
    // the current week;
    List<Day> week = [];

    for (var day in days) {
      if (!_shouldRenderDay(day)) {
        continue;
      }

      var config = source?.configurationForDay(day);
      var proxy = new Day(
          date: day,
          progress: config?.progress ?? -1,
          selected: Utils.isSameDay(_selectedDate, day),
          color: config?.color,
          dotColor: config?.dotColor);
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
      return 'expand_more';
    } else {
      return 'expand_less';
    }
  }

  void handleDayTapped(Day d) {
    setSelectedDate(d.date);
    render();
  }

  void handleToggleWeek() {
    hideOtherWeeks = !hideOtherWeeks;
    expandIcon = _expandIconValue();

    emitRangeEvent();
    render();
  }

  void handlePrevious() {
    if (hideOtherWeeks) {
      _currentWeek = Utils.previousWeek(_currentWeek);
    } else {
      _currentWeek = Utils.previousMonth(_currentWeek);
    }

    emitRangeEvent();
    render();
  }

  void handleNext() {
    if (hideOtherWeeks) {
      _currentWeek = Utils.nextWeek(_currentWeek);
    } else {
      _currentWeek = Utils.nextMonth(_currentWeek);
    }

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
