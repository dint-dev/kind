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

import 'dart:convert' show utf8;

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
          const StringKind(isSingleLine: true),
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
      // ignore: non_const_call_to_literal_constructor
      final object = StringKind(
        minLengthInUtf8: 2,
        maxLengthInUtf8: 3,
        isSingleLine: true,
        examples: ['example'],
      );
      final clone = const StringKind(
        minLengthInUtf8: 2,
        maxLengthInUtf8: 3,
        isSingleLine: true,
        examples: ['example'],
      );
      final other0 = const StringKind(
        minLengthInUtf8: 0,
        maxLengthInUtf8: 3,
        isSingleLine: true,
        examples: ['example'],
      );
      final other1 = const StringKind(
        minLengthInUtf8: 2,
        maxLengthInUtf8: 99999,
        isSingleLine: true,
        examples: ['example'],
      );
      final other2 = const StringKind(
        minLengthInUtf8: 2,
        maxLengthInUtf8: 3,
        isSingleLine: false,
        examples: ['example'],
      );
      final other3 = const StringKind(
        minLengthInUtf8: 2,
        maxLengthInUtf8: 3,
        isSingleLine: true,
        examples: ['other'],
      );

      expect(object, clone);
      expect(object, isNot(other0));
      expect(object, isNot(other1));
      expect(object, isNot(other2));
      expect(object, isNot(other3));

      expect(object.hashCode, clone.hashCode);
      expect(object.hashCode, isNot(other0.hashCode));
      expect(object.hashCode, isNot(other1.hashCode));
      expect(object.hashCode, isNot(other2.hashCode));
    });

    test('newInstance()', () {
      expect(const StringKind().newInstance(), '');
    });

    group('validation', () {
      test('minLengthInUtf8: 3', () {
        const kind = StringKind(minLengthInUtf8: 3);
        expect(kind.instanceIsValid(''), isFalse);

        // Runes that take 1 byte in UTF-8
        expect(kind.instanceIsValid('ab'), isFalse);
        expect(kind.instanceIsValid('abc'), isTrue);
        expect(kind.instanceIsValid('abcd'), isTrue);

        // Runes that take 2 bytes in UTF-8
        expect(kind.instanceIsValid('ö'), isFalse);
        expect(kind.instanceIsValid('öö'), isTrue);

        // Rune that takes 4 bytes in UTF-8
        final emoji = '😃';
        expect(emoji.length, 2);
        expect(utf8.encode(emoji).length, 4);
        expect(kind.instanceIsValid(emoji), isTrue);
      });

      test('maxLengthInUtf8: 3', () {
        const kind = StringKind(maxLengthInUtf8: 3);
        expect(kind.instanceIsValid(''), isTrue);

        // Runes that take 1 byte in UTF-8
        expect(kind.instanceIsValid('ab'), isTrue);
        expect(kind.instanceIsValid('abc'), isTrue);
        expect(kind.instanceIsValid('abcd'), isFalse);

        // Runes that take 2 bytes in UTF-8
        expect(kind.instanceIsValid('ö'), isTrue);
        expect(kind.instanceIsValid('öö'), isFalse);

        // Rune that takes 4 bytes in UTF-8
        final emoji = '😃';
        expect(emoji.length, 2);
        expect(utf8.encode(emoji).length, 4);
        expect(kind.instanceIsValid(emoji), isFalse);
      });

      test('singleLine: false', () {
        const kind = StringKind(isSingleLine: false);

        // Valid examples
        expect(kind.instanceIsValid(''), isTrue);
        expect(kind.instanceIsValid('abc'), isTrue);
        expect(kind.instanceIsValid(' 😃 '), isTrue);
        expect(kind.instanceIsValid('\n'), isTrue);
        expect(kind.instanceIsValid('\n\n'), isTrue);
        expect(kind.instanceIsValid('\n\n\n'), isTrue);
        expect(kind.instanceIsValid(' \n'), isTrue);
      });

      test('singleLine: true', () {
        const kind = StringKind(isSingleLine: true);

        // Valid examples
        expect(kind.instanceIsValid(''), isTrue);
        expect(kind.instanceIsValid('abc'), isTrue);
        expect(kind.instanceIsValid(' 😃 '), isTrue);

        // Invalid examples
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
