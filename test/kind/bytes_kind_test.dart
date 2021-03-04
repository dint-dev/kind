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

    test('name', () {
      final kind = const BytesKind();
      expect(kind.name, 'Bytes');
    });

    test('== / hashCode', () {
      // Helper for eliminating suggestions to use constants.
      const two = 2;
      const three = 3;

      // ignore: non_const_call_to_literal_constructor
      final object = BytesKind(
        minLength: two,
        maxLength: three,
      );
      final clone = const BytesKind(
        minLength: two,
        maxLength: three,
      );
      final other0 = const BytesKind(
        minLength: 0,
        maxLength: three,
      );
      final other1 = const BytesKind(
        minLength: two,
        maxLength: 99999,
      );
      final other2 = const BytesKind(
        minLength: two,
        maxLength: three,
        jsonCodec: base64Url,
      );

      expect(object, clone);
      expect(object, isNot(other0));
      expect(object, isNot(other1));
      expect(object, isNot(other2));

      expect(object.hashCode, clone.hashCode);
      expect(object.hashCode, isNot(other0.hashCode));
      expect(object.hashCode, isNot(other1.hashCode));
      expect(object.hashCode, other2.hashCode);
    });

    test('newInstance() returns empty, unmodifiable list', () {
      final kind = const BytesKind();
      final instance = kind.newInstance();
      expect(instance, []);
      expect(() => instance.add(1), throwsUnsupportedError);
    });

    test('instanceIsDefaultValue', () {
      final kind = const BytesKind();
      expect(
        kind.instanceIsDefaultValue(<int>[1, 2, 3]),
        isFalse,
      );
      expect(
        kind.instanceIsDefaultValue(<int>[]),
        isTrue,
      );
    });

    test('jsonTreeEncode()', () {
      final kind = const BytesKind();
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
      final kind = const BytesKind();
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
