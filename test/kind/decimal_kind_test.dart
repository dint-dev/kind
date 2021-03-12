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
  group('DecimalKind', () {
    test('DecimalKind.kind', () {
      // ignore: invalid_use_of_protected_member
      final kind = DecimalKind.kind;

      expect(
        kind.name,
        'DecimalKind',
      );

      expect(
        kind.jsonTreeEncode(const DecimalKind()),
        {},
      );

      expect(
        kind.jsonTreeEncode(DecimalKind(
          min: Decimal('3.0'),
        )),
        {'min': '3.0'},
      );

      expect(
        kind.jsonTreeEncode(DecimalKind(
          min: Decimal('3.0'),
          exclusiveMin: true,
        )),
        {'min': '3.0', 'exclusiveMin': true},
      );

      expect(
        kind.jsonTreeEncode(DecimalKind(
          max: Decimal('3.0'),
        )),
        {'max': '3.0'},
      );

      expect(
        kind.jsonTreeEncode(DecimalKind(
          max: Decimal('3.0'),
          exclusiveMax: true,
        )),
        {'max': '3.0', 'exclusiveMax': true},
      );
    });

    test('name', () {
      expect(const DecimalKind().name, 'Decimal');
    });

    test('toString()', () {
      expect(const DecimalKind().toString(), 'DecimalKind()');
    });

    test('== / hashCode', () {
      final two = Decimal('2.0');
      final three = Decimal('3.0');

      final object = DecimalKind(
        min: two,
        max: three,
      );
      final clone = DecimalKind(
        min: Decimal('2.0'),
        max: Decimal('3.0'),
      );

      final other0 = DecimalKind(
        min: two + Decimal('9999.0'),
        max: three,
      );
      final other1 = DecimalKind(
        min: two,
        max: three + Decimal('9999.0'),
      );
      final other2 = DecimalKind(
        min: two,
        max: three,
        exclusiveMin: true,
      );
      final other3 = DecimalKind(
        min: two,
        max: three,
        exclusiveMax: true,
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
      expect(object.hashCode, isNot(other3.hashCode));
    });

    test('newInstance()', () {
      expect(const DecimalKind().newInstance(), Decimal.zero);
    });

    test('newList(reactive:false)', () {
      final list = const DecimalKind().newList(2, reactive: false);
      expect(list, isA<List<Decimal>>());
      expect(list, hasLength(2));
    });

    test('protobufFieldType', () {
      expect(
        const DecimalKind().protobufFieldType,
        const StringKind().protobufFieldType,
      );
    });
  });
}
