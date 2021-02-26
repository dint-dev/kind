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
  group('DateKind', () {
    test('name', () {
      expect(const DateKind().name, 'Date');
    });

    test('== / hashCode', () {
      // ignore: non_const_call_to_literal_constructor
      final value = DateKind();
      // ignore: non_const_call_to_literal_constructor
      final clone = DateKind();
      // ignore: non_const_call_to_literal_constructor
      final other = StringKind();

      expect(value, clone);
      expect(value, isNot(other));

      expect(value.hashCode, clone.hashCode);
      expect(value.hashCode, isNot(other.hashCode));
    });

    test('newInstance()', () {
      expect(const DateKind().newInstance(), same(Date.epoch));
    });

    test('randomExample() returns dates between 1950 and 2020', () {
      const n = 1000;
      final list = const DateKind().randomExampleList(n);
      for (var element in list) {
        expect(element.isAfter(Date(1949, 12, 31)), isTrue, reason: '$element');
        expect(element.isBefore(Date(2021, 1, 1)), isTrue, reason: '$element');
      }
      expect(list.toSet(), hasLength(greaterThan(n ~/ 100)));
    });
  });
}
