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
  group('DateTimeWithTimeZoneKind', () {
    test('DateTimeWithTimeZoneKind.kind', () {
      // ignore: invalid_use_of_protected_member
      final kind = DateTimeWithTimeZoneKind.kind;
      expect(kind.name, 'DateTimeWithTimeZoneKind');

      expect(kind.jsonTreeEncode(const DateTimeWithTimeZoneKind()), {});
      expect(kind.jsonTreeDecode({}), const DateTimeWithTimeZoneKind());
    });

    test('name', () {
      expect(const DateTimeWithTimeZoneKind().name, 'DateTimeWithTimeZone');
    });

    test('== / hashCode', () {
      // ignore: non_const_call_to_literal_constructor
      final object = DateTimeWithTimeZoneKind();
      final clone = const DateTimeWithTimeZoneKind();
      final other = const StringKind();

      expect(object, clone);
      expect(object, isNot(other));

      expect(object.hashCode, clone.hashCode);
      expect(object.hashCode, isNot(other.hashCode));
    });

    test('implements Comparable', () {
      expect(
          DateTimeWithTimeZone.epoch, isA<Comparable<DateTimeWithTimeZone>>());
    });

    test('newInstance()', () {
      expect(const DateTimeWithTimeZoneKind().newInstance(),
          same(DateTimeWithTimeZone.epoch));
    });
  });
}
