@HtmlImport('tz_day.html')
library at_calendar;

import 'dart:html';

import 'package:polymer/polymer.dart';
import 'package:tzolkin/src/utils.dart';
import 'package:web_components/web_components.dart' show HtmlImport;

//ignore: unused_import
import 'package:polymer_elements/color.dart';

//ignore: unused_import
import 'package:polymer_elements/paper_progress.dart';

@PolymerRegister(TzDay.tag)
class TzDay extends PolymerElement {
  static const String tag = 'tz-day';

  @Property(observer: "handleDayChanged")
  DayProxy day;

  String get dateLabel => get('_dateLabel');
  void set dateLabel(String t) {
    set('_dateLabel', t);
  }

  bool get hasProgress => get('_hasProgress');
  void set hasProgress(bool t) {
    set('_hasProgress', t);
  }

  int get progress => get('_progress');
  void set progress(int t) {
    set('_progress', t);
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

    if (v.progress >= 0) {
      hasProgress = true;
      progress = v.progress;
    } else {
      hasProgress = false;
    }

    renderColors(v);
    renderSelected(v.selected);
  }

  renderColors(DayProxy day) {
    if (day.color != null) {
      customStyle['--tz-progress-color'] = day.color;
    } else {
      customStyle['--tz-progress-color'] = 'var(--tz-primary-color)';
    }
    if (day.dotColor != null) {
      customStyle['--tz-dot-color'] = day.dotColor;
    } else {
      customStyle['--tz-dot-color'] = 'rgba(0, 0, 0, 0.0)';
    }
    updateStyles();
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
  final String color;

  @reflectable
  final String dotColor;

  @reflectable
  DayProxy(this.date, this.progress, this.selected, this.color, this.dotColor);
}
