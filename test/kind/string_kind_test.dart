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
  group('StringKind', () {
    test('name', () {
      expect(const StringKind().name, 'String');
    });

    test('StringKind.kind', () {
      // ignore: invalid_use_of_protected_member
      final kind = StringKind.kind;
      expect(kind.name, 'StringKind');
      expect(
        kind.jsonTreeEncode(const StringKind()),
        {},
      );
      expect(
        kind.jsonTreeEncode(const StringKind(minLengthInUtf8: 2)),
        {'minLengthInUtf8': 2.0},
      );
      expect(
        kind.jsonTreeEncode(const StringKind(maxLengthInUtf8: 2)),
        {'maxLengthInUtf8': 2.0},
      );
      expect(
        kind.jsonTreeEncode(
         const StringKind(singleLine: true),
        ),
        {'singleLine': true},
      );
      expect(
        kind.jsonTreeEncode(
          StringKind(
            regExpProvider: () => RegExp('abc'),
          ),
        ),
        {'pattern': 'abc'},
      );
    });

    test('== / hashCode', () {
      // Prevents `const` suggestions by the analyzer.
      final one = 1;
      final value = StringKind(
        minLengthInUtf8: one,
        maxLengthInUtf8: 2,
        singleLine: true,
        examples: ['example'],
      );
      final clone = StringKind(
        minLengthInUtf8: one,
        maxLengthInUtf8: 2,
        singleLine: true,
        examples: ['example'],
      );
      final other0 = StringKind(
        minLengthInUtf8: 9999,
        maxLengthInUtf8: one + 1,
        singleLine: true,
        examples: ['example'],
      );
      final other1 = StringKind(
        minLengthInUtf8: one,
        maxLengthInUtf8: 99999,
        singleLine: true,
        examples: ['example'],
      );
      final other2 = StringKind(
        minLengthInUtf8: one,
        maxLengthInUtf8: 2,
        singleLine: false,
        examples: ['example'],
      );
      final other3 = StringKind(
        minLengthInUtf8: one,
        maxLengthInUtf8: 2,
        singleLine: true,
        examples: ['other'],
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
    });

    test('newInstance()', () {
      expect(const StringKind().newInstance(), '');
    });

    group('validation', () {
      test('minLengthInUtf8: 3', () {
        const kind = StringKind(minLengthInUtf8: 3);
        expect(kind.instanceIsValid(''), isFalse);

        expect(kind.instanceIsValid('ab'), isFalse);
        expect(kind.instanceIsValid('abc'), isTrue);
        expect(kind.instanceIsValid('abcd'), isTrue);

        expect(kind.instanceIsValid('ö'), isFalse);
        expect(kind.instanceIsValid('öö'), isTrue);

        expect(kind.instanceIsValid('😃'), isTrue);
      });

      test('maxLengthInUtf8: 3', () {
        const kind = StringKind(maxLengthInUtf8: 3);
        expect(kind.instanceIsValid(''), isTrue);

        expect(kind.instanceIsValid('ab'), isTrue);
        expect(kind.instanceIsValid('abc'), isTrue);
        expect(kind.instanceIsValid('abcd'), isFalse);

        expect(kind.instanceIsValid('ö'), isTrue);
        expect(kind.instanceIsValid('öö'), isFalse);

        expect(kind.instanceIsValid('😃'), isFalse);
      });

      test('singleLine: true', () {
        const kind = StringKind(singleLine: true);
        expect(kind.instanceIsValid(''), isTrue);
        expect(kind.instanceIsValid('abc'), isTrue);

        expect(kind.instanceIsValid('\n'), isFalse);
        expect(kind.instanceIsValid('\n\n'), isFalse);
        expect(kind.instanceIsValid('\n\n\n'), isFalse);
        expect(kind.instanceIsValid(' \n'), isFalse);
        expect(kind.instanceIsValid('abc\n'), isFalse);
        expect(kind.instanceIsValid('abc\ndef'), isFalse);
      });

      test('regExp: RegExp("^[a-z]+\$")', () {
        final kind = StringKind(
          regExpProvider: () => RegExp(r'^[a-z]+$'),
        );
        expect(kind.instanceIsValid('az'), isTrue);
        expect(kind.instanceIsValid('AZ'), isFalse);
      });
    });

    group('randomExample()', () {
      test('lorem ipsum', () {
        const kind = StringKind();
        expect(
            kind.randomExampleList(1000).toSet(), hasLength(greaterThan(100)));
      });

      test('when examples are present', () {
        const kind = StringKind(examples: ['a', 'b', 'c']);
        expect(kind.randomExampleList(1000).toSet(), hasLength(3));
      });

      test('when generating function is defined', () {
        var i = 0;
        final kind =
            StringKind(randomExample: (context) => (i += 1).toString());
        expect(kind.randomExampleList(1000).toSet(), hasLength(1000));
      });
    });
  });
}
