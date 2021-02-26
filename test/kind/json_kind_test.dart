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
  group('JsonKind', () {
    test('== / hashCode', () {
      // ignore: non_const_call_to_literal_constructor
      final value = JsonKind();
      // ignore: non_const_call_to_literal_constructor
      final clone = JsonKind();
      // ignore: non_const_call_to_literal_constructor
      final other = StringKind();

      expect(value, clone);
      expect(value, isNot(other));

      expect(value.hashCode, clone.hashCode);
      expect(value.hashCode, isNot(other.hashCode));
    });

    test('defaultValue', () {
      expect(const JsonKind().newInstance(), isNull);
    });

    test('validation', () {
      const kind = JsonKind();
      expect(kind.instanceIsValid(DateTime(2020)), isFalse);
      expect(kind.instanceIsValid(<int>{}), isFalse);
      expect(
        kind.instanceIsValid({
          'key': [
            {'forbidden': DateTime(2020)}
          ],
        }),
        isFalse,
      );

      expect(kind.instanceIsValid(null), isTrue);
      expect(kind.instanceIsValid(false), isTrue);
      expect(kind.instanceIsValid(true), isTrue);
      expect(kind.instanceIsValid(-2), isTrue);
      expect(kind.instanceIsValid(0), isTrue);
      expect(kind.instanceIsValid(2), isTrue);
      expect(kind.instanceIsValid(-2.0), isTrue);
      expect(kind.instanceIsValid(0.0), isTrue);
      expect(kind.instanceIsValid(2.0), isTrue);
      expect(kind.instanceIsValid('abc'), isTrue);
      expect(kind.instanceIsValid(['a', 'b', 'c']), isTrue);
      expect(kind.instanceIsValid({'k0': 'v0'}), isTrue);
      expect(
        kind.instanceIsValid({
          'key': [
            {'key': 'value'}
          ]
        }),
        isTrue,
      );
    });
  });
}
