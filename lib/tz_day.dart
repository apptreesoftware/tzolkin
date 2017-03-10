@HtmlImport('tz_day.html')
library at_calendar;

import 'dart:html';

import 'package:polymer/polymer.dart';
import 'package:tzolkin/src/utils.dart';
import 'package:web_components/web_components.dart' show HtmlImport;

//ignore: unused_import
import 'package:polymer_elements/color.dart';

@PolymerRegister(TzDay.tag)
class TzDay extends PolymerElement {
  static const String tag = 'tz-day';

  @Property(observer: "handleDayChanged")
  DayProxy day;

  @Property()
  String _dateLabel;

  String get dateLabel => get('_dateLabel');
  void set dateLabel(String t) {
    set('_dateLabel', t);
  }

  factory TzDay() => new TzDay._internal();
  factory TzDay._internal() => new Element.tag(TzDay.tag);
  TzDay.created() : super.created();

  @reflectable
  void handleTap(e, d) {
    fire('day-tap', detail: day);
  }

  @reflectable
  handleDayChanged(DayProxy v, DayProxy old) {
    if (Utils.isFirstDayOfMonth(v.date)) {
      dateLabel = Utils.formatFirstDay(this.day.date);
    } else {
      dateLabel = Utils.formatDay(this.day.date);
    }

    renderSelected(v.selected);
  }

  renderSelected(bool b) {
    if (b) {
      customStyle['--background-color'] = "#bbdefb";
    } else {
      customStyle['--background-color'] = "white";
    }
    updateStyles();
  }
}


class DayProxy extends JsProxy {
  @reflectable
  final DateTime date;

  @reflectable
  final int progress;

  @reflectable
  final bool selected;

  @reflectable
  DayProxy(this.date, this.progress, this.selected);
}
