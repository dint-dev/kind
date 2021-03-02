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

import 'package:fixnum/fixnum.dart';
import 'package:kind/kind.dart';
import 'package:test/test.dart';
import 'package:protobuf/protobuf.dart' as protobuf;

void main() {
  group('Int64FixNumKind', () {
    test('name', () {
      expect(const Int64FixNumKind().name, 'Int64FixNum');
    });

    test('== / hashCode', () {
      // Helper for eliminating suggestions to use constants.
      final two = 2;

      final value = Int64FixNumKind(
        min: Int64(two),
        max: Int64(3),
      );
      final clone = Int64FixNumKind(
        min: Int64(two),
        max: Int64(3),
      );
      final other0 = Int64FixNumKind(
        fixed: true,
        min: Int64(two),
        max: Int64(3),
      );
      final other1 = Int64FixNumKind(
        unsigned: true,
        min: Int64(two),
        max: Int64(3),
      );
      final other2 = Int64FixNumKind(
        min: Int64(two + 9999),
        max: Int64(3),
      );
      final other3 = Int64FixNumKind(
        min: Int64(two),
        max: Int64(3 + 9999),
      );

      expect(value, clone);
      expect(value, isNot(other0));
      expect(value, isNot(other1));
      expect(value, isNot(other2));
      expect(value, isNot(other3));

      expect(value.hashCode, clone.hashCode);
      expect(value.hashCode, isNot(other0.hashCode));
      expect(value.hashCode, isNot(other1.hashCode));
      expect(value.hashCode, isNot(other2.hashCode));
      expect(value.hashCode, isNot(other3.hashCode));
    });

    test('newInstance()', () {
      expect(const Int64FixNumKind().newInstance(), same(Int64.ZERO));
    });

    test('newList(2)', () {
      expect(const Int64FixNumKind().newList(2), isA<List<Int64>>());
    });

    test('protobufFieldType', () {
      expect(
        const Int64FixNumKind().protobufFieldType,
        protobuf.PbFieldType.OS6,
      );
      expect(
        const Int64FixNumKind(unsigned: true).protobufFieldType,
        protobuf.PbFieldType.O6,
      );
      expect(
        const Int64FixNumKind(fixed: true).protobufFieldType,
        protobuf.PbFieldType.QS6,
      );
      expect(
        const Int64FixNumKind(fixed: true, unsigned: true).protobufFieldType,
        protobuf.PbFieldType.Q6,
      );
    });

    group('randomExample', () {
      const n = 1000;

      test('no constraints', () {
        const kind = Int64Kind();
        final set = <int>{};
        for (var i = 0; i < n; i++) {
          set.add(kind.randomExample());
        }
        expect(set.toList()..sort(), hasLength(greaterThan(5)));
      });

      test('min:100', () {
        const kind = Int64Kind(min: 100);
        final set = <int>{};
        for (var i = 0; i < n; i++) {
          set.add(kind.randomExample());
        }
        expect(set.toList()..sort(), hasLength(greaterThan(5)));
      });

      test('max:100', () {
        const kind = Int64Kind(max: 100);
        final set = <int>{};
        for (var i = 0; i < n; i++) {
          set.add(kind.randomExample());
        }
        expect(set.toList()..sort(), hasLength(greaterThan(5)));
      });

      test('min:-3, max:3', () {
        const kind = Int64Kind(min: -3, max: 3);
        final set = <int>{};
        for (var i = 0; i < n; i++) {
          set.add(kind.randomExample());
        }
        expect(set.toList()..sort(), hasLength(7));
      });
    });

    group('validation:', () {
      test('no constraints', () {
        final kind = const Int64FixNumKind();
        expect(
          kind.instanceIsValid(0),
          isFalse,
        );
        expect(
          kind.instanceIsValid(Int64(-3)),
          isTrue,
        );
        expect(
          kind.instanceIsValid(Int64(3)),
          isTrue,
        );
      });

      test('min: 3', () {
        final kind = Int64FixNumKind(min: Int64(3));
        expect(
          kind.instanceIsValid(Int64(-3)),
          isFalse,
        );
        expect(
          kind.instanceIsValid(Int64(2)),
          isFalse,
        );
        expect(
          kind.instanceIsValid(Int64(3)),
          isTrue,
        );
        expect(
          kind.instanceIsValid(Int64(4)),
          isTrue,
        );
      });

      test('max: 3', () {
        final kind = Int64FixNumKind(max: Int64(3));
        expect(
          kind.instanceIsValid(Int64(-4)),
          isTrue,
        );
        expect(
          kind.instanceIsValid(Int64(2)),
          isTrue,
        );
        expect(
          kind.instanceIsValid(Int64(3)),
          isTrue,
        );
        expect(
          kind.instanceIsValid(Int64(4)),
          isFalse,
        );
      });
    });
  });
}
