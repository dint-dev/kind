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
      // Helpers for eliminating suggestions to use constants.
      final one = 1;
      final two = 2;

      final value = NullableKind(StringKind(minLengthInUtf8: two));
      final clone = NullableKind(StringKind(minLengthInUtf8: two));
      final other = NullableKind(StringKind(minLengthInUtf8: one));

      expect(value, clone);
      expect(value, isNot(other));

      expect(value.hashCode, clone.hashCode);
      expect(value.hashCode, isNot(other.hashCode));
    });

    test('isDefaultValue', () {
      const kind = NullableKind(StringKind());
      expect(kind.instanceIsDefaultValue(null), isTrue);
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
      expect(kind.toNullable(), isA<NullableKind<String>>());
      expect(kind.toNullable().toNullable(), isA<NullableKind<String>>());
      expect(kind.toNullable().toNullable().toNonNullable(), isA<StringKind>());
    });
  });
}
