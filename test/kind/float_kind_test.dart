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

import 'dart:typed_data';

import 'package:kind/kind.dart';
import 'package:protobuf/protobuf.dart' as protobuf;
import 'package:test/test.dart';

void main() {
  group('FloatKindBase', () {
    group('randomExample', () {
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
        final set = <double>{};
        var nans = 0;
        var infs = 0;
        var negativeInfs = 0;
        for (var i = 0; i < n; i++) {
          final x = kind.randomExample();
          set.add(x);
          if (x.isNaN) {
            nans++;
          }
          if (x == double.infinity) {
            infs++;
          }
          if (x == double.negativeInfinity) {
            negativeInfs++;
          }
        }
        expect(set.toList()..sort(), hasLength(greaterThan(n ~/ 2)));
        expect(nans, greaterThan(n ~/ 100));
        expect(infs, greaterThan(n ~/ 100));
        expect(negativeInfs, greaterThan(n ~/ 100));
      });

      test('min:100', () {
        const kind = Float32Kind(specialValues:false, min: 100.0);
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
        const kind = Float32Kind(specialValues:false, max: 100.0);
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
        const kind = Float32Kind(specialValues:false, min: -3.0, max: 3.0);
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
  });

  group('Float32Kind', () {
    test('name', () {
      expect(const Float32Kind().name, 'Float32');
    });

    test('toString()', () {
      expect(const Float32Kind().toString(), 'Float32Kind()');
    });

    test('== / hashCode', () {
      // Helpers for eliminating suggestions to use constants.
      final two = 2.0;
      final three = 3.0;

      final value = Float32Kind(
        min: two,
        max: three,
      );
      final clone = Float32Kind(
        min: two,
        max: three,
      );
      final other0 = Float32Kind(
        specialValues: true,
        min: two,
        max: three,
      );
      final other1 = Float32Kind(
        min: two + 9999.0,
        max: three,
      );
      final other2 = Float32Kind(
        min: two,
        max: three + 9999.0,
      );
      final other3 = Float32Kind(
        min: two,
        max: three,
        exclusiveMin: true,
      );
      final other4 = Float32Kind(
        min: two,
        max: three,
        exclusiveMax: true,
      );

      expect(value, clone);
      expect(value, isNot(other0));
      expect(value, isNot(other1));
      expect(value, isNot(other2));
      expect(value, isNot(other3));
      expect(value, isNot(other4));

      expect(value.hashCode, clone.hashCode);
      expect(value.hashCode, isNot(other0.hashCode));
      expect(value.hashCode, isNot(other1.hashCode));
      expect(value.hashCode, isNot(other2.hashCode));
      expect(value.hashCode, isNot(other3.hashCode));
      expect(value.hashCode, isNot(other4.hashCode));
    });

    test('newInstance()', () {
      expect(const Float32Kind().newInstance(), 0.0);
    });

    test('newList(reactive:false)', () {
      final list = const Float32Kind().newList(2, reactive: false);
      expect(list, isA<Float32List>());
      expect(list, hasLength(2));
    });

    test('protobufFieldType', () {
      expect(
        const Float32Kind().protobufFieldType,
        protobuf.PbFieldType.OF,
      );
    });

    test('validation', () {
      const kind = Float32Kind();
      expect(kind.instanceIsValid(double.nan), isFalse);
      expect(kind.instanceIsValid(double.infinity), isFalse);
      expect(kind.instanceIsValid(double.negativeInfinity), isFalse);
      expect(kind.instanceIsValid(-2.0), isTrue);
      expect(kind.instanceIsValid(0.0), isTrue);
      expect(kind.instanceIsValid(2.0), isTrue);
    });

    test('validation, special:true', () {
      const kind = Float32Kind();
      expect(kind.instanceIsValid(double.nan), isFalse);
      expect(kind.instanceIsValid(double.infinity), isFalse);
      expect(kind.instanceIsValid(double.negativeInfinity), isFalse);
      expect(kind.instanceIsValid(-2.0), isTrue);
      expect(kind.instanceIsValid(0.0), isTrue);
      expect(kind.instanceIsValid(2.0), isTrue);
    });

    test('validation, min:2.0', () {
      const kind = Float32Kind(min: 2.0);
      expect(kind.instanceIsValid(1.9), isFalse);
      expect(kind.instanceIsValid(2.0), isTrue);
      expect(kind.instanceIsValid(2.1), isTrue);
    });

    test('validation, max:3.0', () {
      const kind = Float32Kind(max: 3.0);
      expect(kind.instanceIsValid(2.9), isTrue);
      expect(kind.instanceIsValid(3.0), isTrue);
      expect(kind.instanceIsValid(3.1), isFalse);
    });

    test('validation, min, max', () {
      const kind = Float32Kind(min: 2.0, max: 3.0);
      expect(kind.instanceIsValid(1.9), isFalse);
      expect(kind.instanceIsValid(2.0), isTrue);
      expect(kind.instanceIsValid(3.0), isTrue);
      expect(kind.instanceIsValid(4.1), isFalse);
    });
  });

  group('Float64Kind', () {
    test('name', () {
      expect(const Float64Kind().name, 'Float64');
    });

    test('toString()', () {
      expect(const Float64Kind().toString(), 'Float64Kind()');
    });

    test('== / hashCode', () {
      // Helpers for eliminating suggestions to use constants.
      final two = 2.0;
      final three = 3.0;

      final value = Float64Kind(
        min: two,
        max: three,
      );
      final clone = Float64Kind(
        min: two,
        max: three,
      );
      final other0 = Float64Kind(
        specialValues: true,
        min: two,
        max: three,
      );
      final other1 = Float64Kind(
        min: two + 9999.0,
        max: three,
      );
      final other2 = Float64Kind(
        min: two,
        max: three + 9999.0,
      );
      final other3 = Float64Kind(
        min: two,
        max: three,
        exclusiveMin: true,
      );
      final other4 = Float64Kind(
        min: two,
        max: three,
        exclusiveMax: true,
      );

      expect(value, clone);
      expect(value, isNot(other0));
      expect(value, isNot(other1));
      expect(value, isNot(other2));
      expect(value, isNot(other3));
      expect(value, isNot(other4));

      expect(value.hashCode, clone.hashCode);
      expect(value.hashCode, isNot(other0.hashCode));
      expect(value.hashCode, isNot(other1.hashCode));
      expect(value.hashCode, isNot(other2.hashCode));
      expect(value.hashCode, isNot(other3.hashCode));
      expect(value.hashCode, isNot(other4.hashCode));
    });

    test('newInstance()', () {
      expect(const Float64Kind().newInstance(), 0.0);
    });

    test('newList(reactive:false)', () {
      final list = const Float64Kind().newList(2, reactive: false);
      expect(list, isA<Float64List>());
      expect(list, hasLength(2));
    });

    test('protobufFieldType', () {
      expect(
        const Float64Kind().protobufFieldType,
        protobuf.PbFieldType.OD,
      );
    });
  });
}
