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
  group('FloatKindBase', () {
    group('random example generation:', () {
      const n = 1000;

      test('no constraints', () {
        const kind = Float32Kind();
        final set = <double>{};
        for (var i = 0; i < n; i++) {
          set.add(kind.randomExample());
        }
        expect(set.toList()..sort(), hasLength(greaterThan(n / 2)));
        expect(set, isNot(contains(double.nan)));
        expect(set, isNot(contains(double.infinity)));
        expect(set, isNot(contains(double.negativeInfinity)));
      });

      test('allow special values', () {
        const kind = Float32Kind(specialValues: true);
        final otherValues = <double>{};

        // Counts of special values
        var nans = 0;
        var infs = 0;
        var negativeInfs = 0;

        // Generate N values
        for (var i = 0; i < n; i++) {
          final x = kind.randomExample();
          if (x.isNaN) {
            nans++;
          } else if (x == double.infinity) {
            infs++;
          } else if (x == double.negativeInfinity) {
            negativeInfs++;
          } else {
            otherValues.add(x);
          }
        }

        // Check counts
        expect(nans, greaterThan(n ~/ 100));
        expect(infs, greaterThan(n ~/ 100));
        expect(negativeInfs, greaterThan(n ~/ 100));
        expect(otherValues.toList()..sort(), hasLength(greaterThan(n ~/ 2)));
      });

      test('min:100', () {
        const kind = Float32Kind(specialValues: false, min: 100.0);
        final set = <double>{};
        for (var i = 0; i < n; i++) {
          set.add(kind.randomExample());
        }
        expect(set.toList()..sort(), hasLength(greaterThan(n ~/ 2)));
        expect(set, everyElement(greaterThan(100)));
        expect(set, isNot(contains(double.nan)));
        expect(set, isNot(contains(double.infinity)));
        expect(set, isNot(contains(double.negativeInfinity)));
      });

      test('max:100', () {
        const kind = Float32Kind(specialValues: false, max: 100.0);
        final set = <double>{};
        for (var i = 0; i < n; i++) {
          set.add(kind.randomExample());
        }
        expect(set.toList()..sort(), hasLength(greaterThan(n ~/ 2)));
        expect(set, everyElement(lessThan(100)));
        expect(set, isNot(contains(double.nan)));
        expect(set, isNot(contains(double.infinity)));
        expect(set, isNot(contains(double.negativeInfinity)));
      });

      test('min:-3, max:3', () {
        const kind = Float32Kind(specialValues: false, min: -3.0, max: 3.0);
        final set = <double>{};
        for (var i = 0; i < n; i++) {
          set.add(kind.randomExample());
        }
        expect(set.toList()..sort(), hasLength(greaterThan(n ~/ 2)));
        expect(set, everyElement(inExclusiveRange(-3.0, 3.0)));
        expect(set, isNot(contains(double.nan)));
        expect(set, isNot(contains(double.infinity)));
        expect(set, isNot(contains(double.negativeInfinity)));
      });
    });

    group('validation:', () {
      test('default', () {
        const kind = Float32Kind();
        expect(kind.instanceIsValid(double.nan), isFalse);
        expect(kind.instanceIsValid(double.infinity), isFalse);
        expect(kind.instanceIsValid(double.negativeInfinity), isFalse);
        expect(kind.instanceIsValid(-2.0), isTrue);
        expect(kind.instanceIsValid(0.0), isTrue);
        expect(kind.instanceIsValid(2.0), isTrue);
      });

      test('special:true', () {
        const kind = Float32Kind(specialValues: true);
        expect(kind.instanceIsValid(double.nan), isTrue);
        expect(kind.instanceIsValid(double.infinity), isTrue);
        expect(kind.instanceIsValid(double.negativeInfinity), isTrue);
        expect(kind.instanceIsValid(-2.0), isTrue);
        expect(kind.instanceIsValid(0.0), isTrue);
        expect(kind.instanceIsValid(2.0), isTrue);
      });

      test('min:2.0', () {
        const kind = Float32Kind(min: 2.0);
        expect(kind.instanceIsValid(1.9), isFalse);
        expect(kind.instanceIsValid(2.0), isTrue);
        expect(kind.instanceIsValid(2.1), isTrue);
      });

      test('max:3.0', () {
        const kind = Float32Kind(max: 3.0);
        expect(kind.instanceIsValid(2.9), isTrue);
        expect(kind.instanceIsValid(3.0), isTrue);
        expect(kind.instanceIsValid(3.1), isFalse);
      });

      test('min:2.0, max:3.0', () {
        const kind = Float32Kind(min: 2.0, max: 3.0);
        expect(kind.instanceIsValid(1.9), isFalse);
        expect(kind.instanceIsValid(2.0), isTrue);
        expect(kind.instanceIsValid(3.0), isTrue);
        expect(kind.instanceIsValid(4.1), isFalse);
      });
    });
  });
}
