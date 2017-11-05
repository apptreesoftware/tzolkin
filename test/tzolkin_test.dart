// Copyright (c) 2017, john. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:tzolkin/src/utils.dart';
import 'package:test/test.dart';

void main() {
  group('Months', () {
    test('lastDayInMonth', () {
      var date = new DateTime(2017, 3);
      var lastDay = Utils.lastDayOfMonth(date);
      var expected = new DateTime(2017, 3, 31);
      expect(lastDay, expected);
    });

    test('daysInMonth', () {
      var date = new DateTime(2017, 3);
      var days = Utils.daysInMonth(date);
      expect(days, hasLength(35));
    });

    test('daysInMonthWithTimeChangeFallBack', () {
      var date = new DateTime(2017, 11);
      var days = Utils.daysInMonth(date);
      expect(days, hasLength(35));
    });

    test('daysInMonthWithTimeChangeSpringForward', () {
      var date = new DateTime(2018, 4);
      var days = Utils.daysInMonth(date);
      expect(days, hasLength(42));
    });

    test('isSameWeek', () {
      expect(
          Utils.isSameWeek(new DateTime(2017, 3, 4), new DateTime(2017, 3, 5)),
          false);
      expect(
          Utils.isSameWeek(new DateTime(2017, 3, 5), new DateTime(2017, 3, 6)),
          true);
      expect(
          Utils.isSameWeek(new DateTime(2017, 2, 26), new DateTime(2017, 3, 4)),
          true);
      expect(
          Utils.isSameWeek(new DateTime(2017, 3, 4), new DateTime(2017, 3, 10)),
          false);
      expect(
          Utils.isSameWeek(new DateTime(2017, 3, 3), new DateTime(2017, 3, 10)),
          false);
      expect(
          Utils.isSameWeek(
              new DateTime(2017, 3, 10), new DateTime(2017, 3, 10)),
          true);
    });
  });
}
