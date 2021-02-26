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
  group('DateTimeWithTimeZone', () {
    test('name', () {
      expect(const DateTimeWithTimeZoneKind().name, 'DateTimeWithTimeZone');
    });

    test('== / hashCode', () {
      // ignore: non_const_call_to_literal_constructor
      final value =
          DateTimeWithTimeZone.fromMicrosecondsSinceEpoch(3, Timezone.utc);
      // ignore: non_const_call_to_literal_constructor
      final clone =
          DateTimeWithTimeZone.fromMicrosecondsSinceEpoch(3, Timezone.utc);
      // ignore: non_const_call_to_literal_constructor
      final other0 =
          DateTimeWithTimeZone.fromMicrosecondsSinceEpoch(9999, Timezone.utc);
      // ignore: non_const_call_to_literal_constructor
      final other1 = DateTimeWithTimeZone.fromMicrosecondsSinceEpoch(
        3,
        Timezone.fromDifferenceToUtc(const Duration(hours: 1)),
      );

      expect(value, clone);
      expect(value, isNot(other0));
      expect(value, isNot(other1));

      expect(value.hashCode, clone.hashCode);
      expect(value.hashCode, isNot(other0.hashCode));
      expect(value.hashCode, isNot(other1.hashCode));
    });

    test('isAfter', () {
      final a = DateTimeWithTimeZone.fromMicrosecondsSinceEpoch(2);
      final b = DateTimeWithTimeZone.fromMicrosecondsSinceEpoch(3);
      expect(a.isAfter(b), isFalse);
      expect(b.isAfter(a), isTrue);
    });

    test('isBefore', () {
      final a = DateTimeWithTimeZone.fromMicrosecondsSinceEpoch(2);
      final b = DateTimeWithTimeZone.fromMicrosecondsSinceEpoch(3);
      expect(a.isBefore(b), isTrue);
      expect(b.isBefore(a), isFalse);
    });

    test('now', () {
      final now = DateTimeWithTimeZone.now();
      expect(now.toDateTime().isAfter(DateTime.now()), isFalse);
    });

    test('toIso8601String', () {
      expect(DateTimeWithTimeZone.epoch.toIso8601String(),
          '1970-01-01T02:00:00.000Z');
    });

    test('parse (no timezone)', () {
      final s = '1970-01-01T02:00:00.009';
      final parsed = DateTimeWithTimeZone.parse(s);
      expect(parsed.microsecondsSinceEpochInUtc, 9000);
      expect(
        parsed.timezone,
        Timezone.utc,
      );
    });

    test('parse (...z)', () {
      final s = '1970-01-01T02:00:00.009z';
      final parsed = DateTimeWithTimeZone.parse(s);
      expect(parsed.microsecondsSinceEpochInUtc, 9000);
      expect(parsed.timezone, Timezone.utc);
    });

    test('parse (...Z)', () {
      final s = '1970-01-01T02:00:00.009Z';
      final parsed = DateTimeWithTimeZone.parse(s);
      expect(parsed.microsecondsSinceEpochInUtc, 9000);
      expect(parsed.timezone, Timezone.utc);
    });

    test('parse (...+00)', () {
      final s = '1970-01-01T02:00:00.009+00';
      final parsed = DateTimeWithTimeZone.parse(s);
      expect(parsed.microsecondsSinceEpochInUtc, 9000);
      expect(parsed.timezone, Timezone.utc);
    });

    test('parse (...+00:00)', () {
      final s = '1970-01-01T02:00:00.009+00:00';
      final parsed = DateTimeWithTimeZone.parse(s);
      expect(parsed.microsecondsSinceEpochInUtc, 9000);
      expect(parsed.timezone, Timezone.utc);
    });

    test('parse (...-05)', () {
      final s = '1970-01-01T02:00:00.009-05';
      final parsed = DateTimeWithTimeZone.parse(s);
      expect(parsed.microsecondsSinceEpochInUtc, 9000);
      expect(
        parsed.timezone,
        Timezone.fromDifferenceToUtc(-const Duration(hours: 5)),
      );
    });

    test('parse (...+05)', () {
      final s = '1970-01-01T02:00:00.009+05';
      final parsed = DateTimeWithTimeZone.parse(s);
      expect(parsed.microsecondsSinceEpochInUtc, 9000);
      expect(
        parsed.timezone,
        Timezone.fromDifferenceToUtc(const Duration(hours: 5)),
      );
    });

    test('parse (...-05:30)', () {
      final s = '1970-01-01T02:00:00.009-05:30';
      final parsed = DateTimeWithTimeZone.parse(s);
      expect(
        parsed.microsecondsSinceEpochInUtc,
        9000,
      );
      expect(
        parsed.timezone,
        Timezone.fromDifferenceToUtc(-const Duration(hours: 5, minutes: 30)),
      );
    });

    test('parse (...+05:30)', () {
      final s = '1970-01-01T02:00:00.009+05:30';
      final parsed = DateTimeWithTimeZone.parse(s);
      expect(
        parsed.microsecondsSinceEpochInUtc,
        9000,
      );
      expect(
        parsed.timezone,
        Timezone.fromDifferenceToUtc(const Duration(hours: 5, minutes: 30)),
      );
    });
  });

  group('Timezone', () {
    test('parse "" throws FormatException', () {
      expect(() => Timezone.parse(''), throwsFormatException);
    });
    test('parse "z"', () {
      final tz = Timezone.parse('z');
      expect(tz.differenceToUtc, const Duration());
    });
    test('parse "Z"', () {
      final tz = Timezone.parse('Z');
      expect(tz.differenceToUtc, const Duration());
    });
    test('parse "-09"', () {
      final tz = Timezone.parse('-09:00');
      expect(tz.differenceToUtc, -const Duration(hours: 9));
    });
    test('parse "+09"', () {
      final tz = Timezone.parse('+09:30');
      expect(tz.differenceToUtc, const Duration(hours: 9, minutes: 30));
    });
    test('parse "-09:00"', () {
      final tz = Timezone.parse('-09:00');
      expect(tz.differenceToUtc, -const Duration(hours: 9));
    });
    test('parse "+09:30"', () {
      final tz = Timezone.parse('+09:30');
      expect(tz.differenceToUtc, const Duration(hours: 9, minutes: 30));
    });
    test('parse different values', () {
      for (var v = -12; v <= 12; v++) {
        final prefix = v < 0 ? '' : '+';
        final s = '$prefix${v.toString().padLeft(2, '0')}';
        {
          final tz = Timezone.parse(s);
          expect(tz.differenceToUtc, Duration(hours: v));
        }
        {
          final tz = Timezone.parse('$s:00');
          expect(tz.differenceToUtc, Duration(hours: v));
        }
        {
          final tz = Timezone.parse('$s:30');
          expect(tz.differenceToUtc, Duration(hours: v, minutes: v.sign * 30));
        }
        {
          final tz = Timezone.parse('$s:45');
          expect(tz.differenceToUtc, Duration(hours: v, minutes: v.sign * 45));
        }
      }
    });
  });
}
