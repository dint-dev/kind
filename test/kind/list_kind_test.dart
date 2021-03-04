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

    test('ListKind.kind', () {
      // ignore: invalid_use_of_protected_member
      final kind = ListKind.kind;
      expect(kind.name, 'ListKind');

      expect(
        kind.jsonTreeEncode(const ListKind(StringKind())),
        {
          'itemsKind': {'type': 'StringKind'},
        },
      );
      expect(
        kind.jsonTreeDecode({
          'itemsKind': {'type': 'StringKind'},
        }),
        const ListKind(StringKind()),
      );

      expect(
        kind.jsonTreeEncode(const ListKind(
          StringKind(maxLengthInUtf8: 2),
          minLength: 3,
          maxLength: 4,
        )),
        {
          'itemsKind': {'type': 'StringKind', 'maxLengthInUtf8': 2.0},
          'minLength': 3,
          'maxLength': 4,
        },
      );
      expect(
        kind.jsonTreeDecode({
          'itemsKind': {'type': 'StringKind', 'maxLengthInUtf8': 2.0},
          'minLength': 3,
          'maxLength': 4,
        }),
        const ListKind(
          StringKind(maxLengthInUtf8: 2),
          minLength: 3,
          maxLength: 4,
        ),
      );
    });

    test('== / hashCode', () {
      // Prevents `const` suggestions from the analyzer.
      // Constants could reduce test coverage.
      final two = 2;

      final object = ListKind(
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

      expect(object, clone);
      expect(object, isNot(other0));
      expect(object, isNot(other1));
      expect(object, isNot(other2));

      expect(object.hashCode, clone.hashCode);
      expect(object.hashCode, isNot(other0.hashCode));
      expect(object.hashCode, isNot(other1.hashCode));
      expect(object.hashCode, isNot(other2.hashCode));
    });

    test('newInstance()', () {
      final instance = const ListKind(StringKind()).newInstance();
      expect(instance, isA<ReactiveList>());
      instance.add('abc');
      expect(instance, hasLength(1));
    });

    group('randomExample()', () {
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
