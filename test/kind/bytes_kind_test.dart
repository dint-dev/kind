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

import 'dart:convert';

import 'package:kind/kind.dart';
import 'package:test/test.dart';

void main() {
  group('BytesKind', () {
    final kind = const BytesKind();

    test('name', () {
      expect(kind.name, 'bytes');
    });

    test('== / hashCode', () {
      // Helper for eliminating suggestions to use constants.
      final two = 2;

      final value = BytesKind(
        minLength: two,
        maxLength: 3,
      );
      final clone = BytesKind(
        minLength: two,
        maxLength: 3,
      );
      final other0 = const BytesKind(
        minLength: 0,
        maxLength: 3,
      );
      final other1 = const BytesKind(
        minLength: 2,
        maxLength: 99999,
      );
      final other2 = const BytesKind(
        minLength: 2,
        maxLength: 3,
        jsonCodec: base64Url,
      );

      expect(value, clone);
      expect(value, isNot(other0));
      expect(value, isNot(other1));
      expect(value, isNot(other2));

      expect(value.hashCode, clone.hashCode);
      expect(value.hashCode, isNot(other0.hashCode));
      expect(value.hashCode, isNot(other1.hashCode));
      expect(value.hashCode, other2.hashCode);
    });

    test('BytesKind.kind', () {
      // ignore: invalid_use_of_protected_member
      final kind = BytesKind.kind;
      expect(
        kind.jsonTreeEncode(const BytesKind()),
        {},
      );
      expect(
        kind.jsonTreeEncode(const BytesKind(minLength: 2)),
        {'minLength': 2},
      );
      expect(
        kind.jsonTreeEncode(const BytesKind(maxLength: 2)),
        {'maxLength': 2},
      );
      expect(
        kind.jsonTreeEncode(const BytesKind(jsonCodec: base64Url)),
        {'jsonCodec': 'base64Url'},
      );
    });

    test('newInstance() returns empty, unmodifiable list', () {
      final value = kind.newInstance();
      expect(value, []);
      expect(() => value.add(1), throwsUnsupportedError);
    });

    test('instanceIsDefaultValue', () {
      expect(
        kind.instanceIsDefaultValue(<int>[]),
        isTrue,
      );
    });

    test('jsonTreeEncode()', () {
      expect(
        kind.jsonTreeEncode([1, 2, 3]),
        base64.encode([1, 2, 3]),
      );
    });

    test('jsonTreeEncode() when jsonCodec is different', () {
      final kind = const BytesKind(jsonCodec: Base64Codec.urlSafe());
      expect(
        kind.jsonTreeEncode([1, 2, 3]),
        Base64Codec.urlSafe().encode([1, 2, 3]),
      );
    });

    test('jsonTreeDecode()', () {
      expect(
        kind.jsonTreeDecode(base64.encode([1, 2, 3])),
        [1, 2, 3],
      );
    });

    test('jsonTreeDecode() when kind is different', () {
      final kind = const BytesKind(jsonCodec: Base64Codec.urlSafe());
      expect(
        kind.jsonTreeDecode(Base64Codec.urlSafe().encode([1, 2, 3])),
        [1, 2, 3],
      );
    });
  });
}
