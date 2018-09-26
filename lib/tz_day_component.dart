library at_calendar;

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:date_utils/date_utils.dart';
import 'package:meta/meta.dart';

@Component(
  selector: 'tz-day',
  templateUrl: 'tz_day_component.html',
  styleUrls: [
    'tz_day_component.css',
  ],
  directives: [
    coreDirectives,
    MaterialProgressComponent,
  ],
)
class TzDay {
  StreamController<Day> _onDayTappedSink = new StreamController.broadcast();
  Day _day;
  HtmlElement hostElement;

  TzDay(HtmlElement ref) {
    hostElement = ref;
  }

  Day get day => _day;
  @Input()
  void set day(Day day) {
    var oldDay = _day;
    _day = day;
    handleDayChanged(_day, oldDay);
  }

  String dateLabel;
  bool hasProgress;
  int progress;

  @Output()
  Stream get onDayTapped => _onDayTappedSink.stream;

  void handleTap() {
    _onDayTappedSink.add(day);
  }

  void handleDayChanged(Day v, Day old) {
    if (Utils.isFirstDayOfMonth(v.date)) {
      dateLabel = Utils.formatFirstDay(this.day.date);
    } else {
      dateLabel = Utils.formatDay(this.day.date);
    }

    if (v.progress >= 0) {
      hasProgress = true;
      progress = v.progress;
    } else {
      hasProgress = false;
    }

    renderSelected(v.selected);
  }

  renderSelected(bool selected) {
    if (selected) {
      hostElement.style.backgroundColor = "#bbdefb";
    } else {
      hostElement.style.backgroundColor = "white";
    }
  }
}

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
