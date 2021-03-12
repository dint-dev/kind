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
  group('Decimal:', () {
    test('== / hashCode', () {
      final object = Decimal.fromDouble(3.14, fractionDigits: 2);
      final clone = Decimal('3.14');
      final other0 = Decimal.fromDouble(1.2, fractionDigits: 1);
      final other1 = Decimal.fromDouble(3.14, fractionDigits: 1);
      final other2 = Decimal.fromDouble(3.14, fractionDigits: 3);
      final other3 = Decimal('3.140');

      expect(object, clone);
      expect(object, isNot(other0));
      expect(object, isNot(other1));
      expect(object, isNot(other2));
      expect(object, isNot(other3));

      expect(clone, object);
      expect(other0, isNot(object));
      expect(other1, isNot(object));

      expect(object.hashCode, clone.hashCode);
      expect(object.hashCode, isNot(other0.hashCode));
      expect(object.hashCode, isNot(other1.hashCode));
      expect(object.hashCode, isNot(other2.hashCode));
      expect(object.hashCode, isNot(other3.hashCode));
    });

    test('0, -0', () {
      // 0 == 0
      expect(Decimal('0').compareTo(Decimal('0')), 0);
      expect(Decimal('0').compareTo(Decimal('0.0')), 0);
      expect(Decimal('0').compareTo(Decimal('0.00')), 0);
      expect(Decimal('0.0').compareTo(Decimal('0')), 0);
      expect(Decimal('0.0').compareTo(Decimal('0.0')), 0);
      expect(Decimal('0.0').compareTo(Decimal('0.00')), 0);
      expect(Decimal('0.00').compareTo(Decimal('0')), 0);
      expect(Decimal('0.00').compareTo(Decimal('0.0')), 0);
      expect(Decimal('0.00').compareTo(Decimal('0.00')), 0);

      // 0 == -0
      expect(Decimal('0').compareTo(Decimal('-0')), 0);
      expect(Decimal('0').compareTo(Decimal('-0.0')), 0);
      expect(Decimal('0').compareTo(Decimal('-0.00')), 0);
      expect(Decimal('0.0').compareTo(Decimal('-0')), 0);
      expect(Decimal('0.0').compareTo(Decimal('-0.0')), 0);
      expect(Decimal('0.00').compareTo(Decimal('-0')), 0);

      // -0 = -0
      expect(Decimal('-0').compareTo(Decimal('-0')), 0);
      expect(Decimal('-0').compareTo(Decimal('-0.0')), 0);
      expect(Decimal('-0.0').compareTo(Decimal('-0')), 0);
      expect(Decimal('-0.0').compareTo(Decimal('-0.0')), 0);
      expect(Decimal('-0.00').compareTo(Decimal('-0')), 0);

      // -0 == 0
      expect(Decimal('-0').compareTo(Decimal('0')), 0);
      expect(Decimal('-0').compareTo(Decimal('0.0')), 0);
      expect(Decimal('-0.0').compareTo(Decimal('0')), 0);
      expect(Decimal('-0.0').compareTo(Decimal('0.0')), 0);
      expect(Decimal('-0.00').compareTo(Decimal('0')), 0);

      // comparison is true
      expect(Decimal('-0') <= Decimal('0'), isTrue);
      expect(Decimal('-0') >= Decimal('0'), isTrue);
      expect(Decimal('0') <= Decimal('-0'), isTrue);
      expect(Decimal('0') >= Decimal('-0'), isTrue);

      // comparison is false
      expect(Decimal('-0') < Decimal('0'), isFalse);
      expect(Decimal('-0') > Decimal('0'), isFalse);
      expect(Decimal('0') < Decimal('-0'), isFalse);
      expect(Decimal('0') > Decimal('-0'), isFalse);
    });

    test('compareTo', () {
      // result: 0
      expect(Decimal('-2').compareTo(Decimal('-2')), 0);
      expect(Decimal('2').compareTo(Decimal('2')), 0);
      expect(Decimal('-2.99').compareTo(Decimal('-2.99')), 0);
      expect(Decimal('2.99').compareTo(Decimal('2.99')), 0);
      expect(Decimal('-2.990').compareTo(Decimal('-2.99')), 0);
      expect(Decimal('-2.9900').compareTo(Decimal('-2.99')), 0);
      expect(Decimal('-2.99000').compareTo(Decimal('-2.99')), 0);
      expect(Decimal('2.99').compareTo(Decimal('2.990')), 0);
      expect(Decimal('2.99').compareTo(Decimal('2.9900')), 0);
      expect(Decimal('2.99').compareTo(Decimal('2.99000')), 0);

      // result: -1
      expect(Decimal('-3').compareTo(Decimal('-2')), -1);
      expect(Decimal('-3').compareTo(Decimal('-2.99')), -1);
      expect(Decimal('-3').compareTo(Decimal('99')), -1);
      expect(Decimal('-1').compareTo(Decimal('-0')), -1);
      expect(Decimal('-1').compareTo(Decimal('0')), -1);
      expect(Decimal('2').compareTo(Decimal('3')), -1);
      expect(Decimal('2').compareTo(Decimal('2.01')), -1);
      expect(Decimal('2').compareTo(Decimal('99')), -1);

      // result: 1
      expect(Decimal('-2').compareTo(Decimal('-3')), 1);
      expect(Decimal('-2').compareTo(Decimal('-2.01')), 1);
      expect(Decimal('-2.0').compareTo(Decimal('-2.01')), 1);
      expect(Decimal('-2.00').compareTo(Decimal('-2.01')), 1);
      expect(Decimal('-2.000').compareTo(Decimal('-2.01')), 1);
      expect(Decimal('3').compareTo(Decimal('2')), 1);
      expect(Decimal('2.01').compareTo(Decimal('2')), 1);
      expect(Decimal('2.01').compareTo(Decimal('2.0')), 1);
      expect(Decimal('2.01').compareTo(Decimal('2.00')), 1);
      expect(Decimal('2.01').compareTo(Decimal('2.000')), 1);
    });

    test('a < b', () {
      expect(Decimal('-4') < Decimal('3'), isTrue);
      expect(Decimal('2') < Decimal('3'), isTrue);
      expect(Decimal('3') < Decimal('3'), isFalse);
      expect(Decimal('4') < Decimal('3'), isFalse);
    });

    test('a <= b', () {
      expect(Decimal('-4') <= Decimal('3'), isTrue);
      expect(Decimal('2') <= Decimal('3'), isTrue);
      expect(Decimal('3') <= Decimal('3'), isTrue);
      expect(Decimal('4') < Decimal('3'), isFalse);
    });

    test('a > b', () {
      expect(Decimal('-4') > Decimal('3'), isFalse);
      expect(Decimal('2') > Decimal('3'), isFalse);
      expect(Decimal('3') > Decimal('3'), isFalse);
      expect(Decimal('4') > Decimal('3'), isTrue);
    });

    test('a >= b', () {
      expect(Decimal('-4') >= Decimal('3'), isFalse);
      expect(Decimal('2') >= Decimal('3'), isFalse);
      expect(Decimal('3') >= Decimal('3'), isTrue);
      expect(Decimal('4') >= Decimal('3'), isTrue);
    });

    test('isNegative', () {
      expect(
        Decimal('-9.9').isNegative,
        isTrue,
      );
      expect(
        Decimal('-1').isNegative,
        isTrue,
      );
      expect(
        Decimal('-0').isNegative,
        isFalse,
      );
      expect(
        Decimal('0').isNegative,
        isFalse,
      );
      expect(
        Decimal('1').isNegative,
        isFalse,
      );
      expect(
        Decimal('9.9').isNegative,
        isFalse,
      );
    });

    group('-a', () {
      test('-(-123456789.123456789)', () {
        expect(
          -Decimal('-123456789.123456789'),
          Decimal('123456789.123456789'),
        );
      });
      test('-123456789.123456789', () {
        expect(
          -Decimal('123456789.123456789'),
          Decimal('-123456789.123456789'),
        );
      });
    });

    group('a + b', () {
      test('-12.34 + 0.0 | FF', () {
        final a = Decimal.fromDouble(-12.34, fractionDigits: 2);
        final b = Decimal.fromDouble(0.0, fractionDigits: 1);
        final c = Decimal.fromDouble(-12.34, fractionDigits: 2);
        expect(a + b, c);
      });
      test('12.34 + 0.0 | FF', () {
        final a = Decimal.fromDouble(12.34, fractionDigits: 2);
        final b = Decimal.fromDouble(0.0, fractionDigits: 1);
        final c = Decimal.fromDouble(12.34, fractionDigits: 2);
        expect(a + b, c);
      });

      test('7.6 + 1.3 | FF', () {
        final a = Decimal.fromDouble(7.6, fractionDigits: 1);
        final b = Decimal.fromDouble(1.3, fractionDigits: 1);
        final c = Decimal.fromDouble(8.9, fractionDigits: 1);
        expect(a + b, c);
      });

      test('12.34 + 0.0 | SS', () {
        final a = Decimal('-12.34');
        final b = Decimal('0.0');
        final c = Decimal('-12.34');
        expect(a + b, c);
      });

      test('7.6 + 1.3 | SS', () {
        final a = Decimal('7.6');
        final b = Decimal('1.3');
        final c = Decimal('8.9');
        expect(a + b, c);
      });
    });

    group('a - b', () {
      test('a - b', () {
        final a = Decimal.fromDouble(12.34, fractionDigits: 2);
        final b = Decimal.fromDouble(0.0, fractionDigits: 1);
        final c = Decimal.fromDouble(12.34, fractionDigits: 2);
        expect(a - b, c);
      });

      test('8.9 - 1.3 | FF', () {
        final a = Decimal.fromDouble(8.9, fractionDigits: 1);
        final b = Decimal.fromDouble(1.3, fractionDigits: 1);
        final c = Decimal.fromDouble(7.6, fractionDigits: 1);
        expect(a - b, c);
      });

      test('12.32 - 0.0 | SS', () {
        final a = Decimal('-12.34');
        final b = Decimal('0.0');
        final c = Decimal('-12.34');
        expect(a - b, c);
      });

      test('8.9 - 1.3 | SS', () {
        final a = Decimal('8.9');
        final b = Decimal('1.3');
        final c = Decimal('7.6');
        expect(a - b, c);
      });
    });

    group('a * b', () {
      test('2 * 3 | FF', () {
        final a = Decimal.fromDouble(2, fractionDigits: 2);
        final b = Decimal.fromDouble(3, fractionDigits: 1);
        final c = Decimal.fromDouble(6, fractionDigits: 2);
        expect(a * b, c);
      });
      test('2 * 3 | SS', () {
        final a = Decimal('2.0');
        final b = Decimal('3.0');
        final c = Decimal('6.0');
        expect(a * b, c);
      });
      test('1.5 * 3 | FF', () {
        final a = Decimal.fromDouble(1.5, fractionDigits: 2);
        final b = Decimal.fromDouble(3, fractionDigits: 1);
        final c = Decimal.fromDouble(4.5, fractionDigits: 2);
        expect(a * b, c);
      });
      test('1.5 * 3 | SS', () {
        final a = Decimal('1.5');
        final b = Decimal('3.0');
        final c = Decimal('4.5');
        expect(a * b, c);
      });
    });

    group('a / b', () {
      test('2 / 3 | FF', () {
        final a = Decimal.fromDouble(2, fractionDigits: 2);
        final b = Decimal.fromDouble(3, fractionDigits: 1);
        final c = Decimal('0.67');
        expect(a / b, c);
        expect((a / b).toString(), c.toString());
      });

      test('1.5 / 3 | SF', () {
        final a = Decimal('1.50');
        final b = Decimal.fromDouble(3, fractionDigits: 1);
        final c = Decimal('0.50');
        expect(a / b, c);
        expect((a / b).toString(), c.toString());
      });

      test('1.5 / 3 | SS', () {
        final a = Decimal('1.50');
        final b = Decimal('3.0');
        final c = Decimal('0.50');
        expect(a / b, c);
        expect((a / b).toString(), c.toString());
      });

      test('3 / 1.5 | SS', () {
        final a = Decimal('3');
        final b = Decimal('1.50');
        final c = Decimal('2.00');
        expect(a / b, c);
        expect((a / b).toString(), c.toString());
      });
    });

    test('scale', () {
      expect(
        Decimal.fromDouble(12.3, fractionDigits: 1).scale(2.0),
        Decimal.fromDouble(24.6, fractionDigits: 1),
      );
      expect(
        Decimal('4.0').scale(1.5),
        Decimal('6.0'),
      );
      expect(
        Decimal('12.30').scale(2.0),
        Decimal('24.60'),
      );
    });

    test('round', () {
      expect(Decimal.fromDouble(0, fractionDigits: 2).round(), isA<int>());

      expect(Decimal.fromDouble(-9.00, fractionDigits: 2).round(), -9);
      expect(Decimal.fromDouble(-9.49, fractionDigits: 2).round(), -9);
      expect(Decimal.fromDouble(-9.50, fractionDigits: 2).round(), -10);
      expect(Decimal.fromDouble(-9.99, fractionDigits: 2).round(), -10);

      expect(Decimal.fromDouble(9.00, fractionDigits: 2).round(), 9);
      expect(Decimal.fromDouble(9.49, fractionDigits: 2).round(), 9);
      expect(Decimal.fromDouble(9.50, fractionDigits: 2).round(), 10);
      expect(Decimal.fromDouble(9.99, fractionDigits: 2).round(), 10);

      expect(Decimal('0.0').round(), isA<int>());

      expect(Decimal('-9.00').round(), -9);
      expect(Decimal('-9.49').round(), -9);
      expect(Decimal('-9.50').round(), -10);
      expect(Decimal('-9.99').round(), -10);

      expect(Decimal('9.00').round(), 9);
      expect(Decimal('9.49').round(), 9);
      expect(Decimal('9.50').round(), 10);
      expect(Decimal('9.99').round(), 10);
    });
  });
}
