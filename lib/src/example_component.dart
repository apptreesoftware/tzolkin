import 'package:angular/angular.dart';
import 'package:tzolkin/date_range.dart';
import 'package:tzolkin/tz_calendar_component.dart';

@Component(
  selector: 'example-component',
  templateUrl: 'example_component.html',
  styleUrls: [
    'example_component.css',
  ],
  directives: [
    TzCalendar,
  ],
)
class ExampleComponent {
  DateTime startDate = new DateTime(2018,9,26);
  DataSource dataSource = new MockDataSource();

  void handleSelectedDateChanged(DateTime date) {
    print("Selected date: $date");
  }
  void handleDateRangeChanged(DateRange dateRange) {
    print("DateRange changed: $dateRange");
  }
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