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
  group('NullableKind', () {
    test('== / hashCode', () {
      // ignore: non_const_call_to_literal_constructor
      final object = NullableKind(StringKind());
      final clone = const NullableKind(StringKind());
      final other = const NullableKind(Int64Kind());

      expect(object, clone);
      expect(object, isNot(other));

      expect(object.hashCode, clone.hashCode);
      expect(object.hashCode, isNot(other.hashCode));
    });

    test('instanceIsDefaultValue', () {
      const kind = NullableKind(StringKind());
      expect(kind.instanceIsDefaultValue(null), isTrue);
      expect(kind.instanceIsDefaultValue(''), isFalse);
    });

    test('newInstance()', () {
      const kind = NullableKind(StringKind());
      expect(kind.newInstance(), isNull);
    });

    group('randomExample()', () {
      test('simple case', () {
        const kind = NullableKind(Int32Kind());
        const n = 1000;
        final list = kind.randomExampleList(n);
        expect(list.where((e) => e == null).length, lessThan(n * 19 ~/ 20));
        expect(list.where((e) => e == null).length, greaterThan(n ~/ 20));
      });

      test('depth == depthMax', () {
        const kind = NullableKind(Int32Kind());
        const n = 1000;
        final context = RandomExampleContext(depthMax: 9);
        context.depth = 9;
        final list = kind.randomExampleList(n, context: context);
        expect(list, everyElement(isNull));
      });

      test('nonPrimitivesCount == nonPrimitivesCountMax', () {
        const kind = NullableKind(Int32Kind());
        const n = 1000;
        final context = RandomExampleContext(nonPrimitivesCountMax: 9);
        context.nonPrimitivesCount = 9;
        final list = kind.randomExampleList(n, context: context);
        expect(list, everyElement(isNull));
      });
    });

    test('toNullable(...) / toNonNullable(...)', () {
      final kind = const StringKind();
      expect(kind.toNonNullable(), same(kind));

      final nullableKind = kind.toNullable();
      expect(nullableKind, isA<NullableKind<String>>());
      expect(nullableKind.toNullable(), same(nullableKind));
      expect(nullableKind.toNonNullable(), same(kind));
    });
  });
}
