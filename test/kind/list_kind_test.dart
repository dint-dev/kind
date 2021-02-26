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
  group('ListKind', () {
    test('name', () {
      expect(const ListKind(StringKind()).name, 'List');
    });

    test('== / hashCode', () {
      // Helper for eliminating suggestions to use constants.
      final two = 2;

      final value = ListKind(
        StringKind(minLengthInUtf8: two),
        minLength: two,
        maxLength: 3,
      );
      final clone = ListKind(
        StringKind(minLengthInUtf8: two),
        minLength: two,
        maxLength: 3,
      );
      final other0 = ListKind(
        BytesKind(minLength: two),
        minLength: two,
        maxLength: 3,
      );
      final other1 = ListKind(
        StringKind(minLengthInUtf8: two),
        minLength: 0,
        maxLength: 3,
      );
      final other2 = ListKind(
        StringKind(minLengthInUtf8: two),
        minLength: two,
        maxLength: 99999,
      );

      expect(value, clone);
      expect(value, isNot(other0));
      expect(value, isNot(other1));
      expect(value, isNot(other2));

      expect(value.hashCode, clone.hashCode);
      expect(value.hashCode, isNot(other0.hashCode));
      expect(value.hashCode, isNot(other1.hashCode));
      expect(value.hashCode, isNot(other2.hashCode));
    });

    group('randomExample', () {
      const n = 1000;
      const itemsKind = Int32Kind(min: -10000000, max: 10000000);

      test('simple case', () {
        const kind = ListKind(itemsKind);
        final list = kind.randomExampleList(n);
        expect(list.where((e) => e.isEmpty), hasLength(greaterThan(n ~/ 10)));
        expect(
          list.where((e) => e.length == 1),
          hasLength(greaterThan(n ~/ 10)),
        );
        expect(
          list.where((e) => e.length == 2),
          hasLength(greaterThan(n ~/ 10)),
        );
        expect(list.where((e) => e.length == 3), isEmpty);
        expect(list.map((e) => e.length).toSet(), hasLength(3));
        expect(list.expand((e) => e).toSet(), hasLength(greaterThan(n ~/ 10)));
      });

      test('minLength:2', () {
        const kind = ListKind(itemsKind, minLength: 2);
        final list = kind.randomExampleList(n);
        expect(list.map((e) => e.length).toSet(), hasLength(3));
        expect(list, everyElement(hasLength(greaterThanOrEqualTo(2))));
      });

      test('maxLength:2', () {
        const kind = ListKind(itemsKind, maxLength: 2);
        final list = kind.randomExampleList(n);
        expect(list.map((e) => e.length).toSet(), hasLength(3));
        expect(list, everyElement(hasLength(lessThanOrEqualTo(2))));
      });

      test('depth == depthMax', () {
        const kind = ListKind(itemsKind);
        final context = RandomExampleContext(depthMax: 9);
        context.depth = 9;
        final list = kind.randomExampleList(n, context: context);
        expect(list, everyElement(isEmpty));
      });

      test('nonPrimitivesCount == nonPrimitivesCountMax', () {
        const kind = ListKind(itemsKind);
        final context = RandomExampleContext(nonPrimitivesCountMax: 9);
        context.nonPrimitivesCount = 9;
        final list = kind.randomExampleList(n, context: context);
        expect(list, everyElement(isEmpty));
      });
    });
  });
}
