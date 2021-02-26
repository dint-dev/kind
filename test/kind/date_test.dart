// Copyright 2021 Gohilla Ltd.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:kind/kind.dart';
import 'package:test/test.dart';

void main() {
  group('Date', () {
    test('hashCode / equals', () {
      final value = Date(2020, 01, 01);
      final clone = Date(2020, 01, 01);
      final other0 = Date(2021, 01, 01);
      final other1 = Date(2020, 12, 01);
      final other2 = Date(2020, 01, 31);

      expect(value, clone);
      expect(value, isNot(other0));
      expect(value, isNot(other1));
      expect(value, isNot(other2));

      expect(value.hashCode, clone.hashCode);
      expect(value.hashCode, isNot(other0.hashCode));
      expect(value.hashCode, isNot(other1.hashCode));
      expect(value.hashCode, isNot(other2.hashCode));
    });

    test('implements Comparable', () {
      expect(Date.epoch, isA<Comparable<Date>>());
    });

    test('Date.fromDateTime(...)', () {
      expect(
        Date.fromDateTime(DateTime(2020, 12, 31)),
        Date(2020, 12, 31),
      );
    });

    test('Date.now()', () {
      // We assume the following method calls do are evaluated exactly at
      // midnight (+- some microseconds).
      //
      // The probability would be about 1 in million.
      final dateTime = DateTime.now();
      final dateNow = Date.now();

      expect(dateNow.year, dateTime.year);
      expect(dateNow.month, dateTime.month);
      expect(dateNow.day, dateTime.day);
    });

    test('Date.parse(...)', () {
      expect(
        Date.parse('2020-12-31'),
        Date(2020, 12, 31),
      );
    });

    test('compareTo(...)', () {
      expect(Date(2020, 01, 01).compareTo(Date(2020, 01, 01)), 0);

      // Non-equal year
      expect(Date(2019, 01, 01).compareTo(Date(2020, 01, 01)), -1);
      expect(Date(2021, 01, 01).compareTo(Date(2020, 01, 01)), 1);

      // Non-equal month
      expect(Date(2019, 01, 01).compareTo(Date(2020, 06, 01)), -1);
      expect(Date(2021, 12, 01).compareTo(Date(2020, 06, 01)), 1);

      // Non-equal day
      expect(Date(2020, 01, 01).compareTo(Date(2020, 01, 15)), -1);
      expect(Date(2020, 01, 31).compareTo(Date(2020, 01, 15)), 1);
    });

    test('toDateTime', () {
      expect(Date(2020, 1, 1).toDateTime(), DateTime(2020, 1, 1));
      expect(Date(2020, 12, 31).toDateTime(), DateTime(2020, 12, 31));
    });

    test('toString', () {
      expect(Date(2020, 1, 1).toString(), '2020-01-01');
      expect(Date(2020, 12, 31).toString(), '2020-12-31');
    });
  });
}
