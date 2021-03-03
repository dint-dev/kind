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
  group('UuidKind', () {
    test('name', () {
      expect(const UuidKind().name, 'Uuid');
    });

    test('UuidKind.kind', () {
      // ignore: invalid_use_of_protected_member
      final kind = UuidKind.kind;
      expect(kind.name, 'UuidKind');

      expect(kind.jsonTreeEncode(const UuidKind()), {});
      expect(kind.jsonTreeDecode({}), const UuidKind());
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

    test('newInstance() returns empty, unmodifiable list', () {
      final kind = const BytesKind();
      final value = kind.newInstance();
      expect(value, []);
      expect(() => value.add(1), throwsUnsupportedError);
    });
  });
}
