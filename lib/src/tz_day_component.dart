import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:date_utils/date_utils.dart';
import 'package:tzolkin/src/models.dart';

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
  String dateLabel;
  bool hasProgress;
  int progress;

  @ViewChild('dotElement')
  DivElement dotElement;

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

    renderColors(v);
    renderSelected(v.selected);
  }

  renderColors(Day v) {
    if (day.color != null) {
      dotElement.style.backgroundColor = day.color;
    } else {
      dotElement.style.backgroundColor = "#00000000";
    }
  }

  renderSelected(bool selected) {
    if (selected) {
      hostElement.style.backgroundColor = "#bbdefb";
    } else {
      hostElement.style.backgroundColor = "white";
    }
  }
}


