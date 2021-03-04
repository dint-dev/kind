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
  group('EntityKind', () {
    test('name', () {
      final kind = EntityKind(
        name: 'x',
        build: (c) {},
      );
      expect(kind.name, 'x');
    });

    test('EntityKind.kind', () {
      // ignore: invalid_use_of_protected_member
      final kind = EntityKind.kind;
      expect(kind.name, 'EntityKind');

      final entityKind = EntityKind(
        name: 'Example',
        build: (c) {
          c.requiredString(
            id: 1,
            name: 'x',
            minLengthInUtf8: 1,
            getter: (t) => throw UnimplementedError(),
            setter: (t, v) => throw UnimplementedError(),
          );
        },
      );
      final json = {
        'name': 'Example',
        'props': [
          {
            'id': 1.0,
            'name': 'x',
            'kind': {
              'type': 'StringKind',
              'minLengthInUtf8': 1.0,
            },
          },
        ],
      };
      expect(kind.jsonTreeEncode(entityKind), json);
      expect(
        kind.jsonTreeDecode(json),
        EntityKind<EntityData>(
          name: 'Example',
          build: (c) {
            c.requiredString(
              id: 1,
              name: 'x',
              minLengthInUtf8: 1,
              getter: (t) => throw UnimplementedError(),
              setter: (t, v) => throw UnimplementedError(),
            );
          },
        ),
      );
    });

    test('== / hashCode', () {
      final object = EntityKind<_Person>(
        name: 'Example',
        build: (c) {
          c.optionalString(
            id: 1,
            name: 'prop1',
            getter: (t) => throw UnimplementedError(),
          );
          c.constructor = () => throw UnimplementedError();
        },
      );
      final clone = EntityKind<_Person>(
        name: 'Example',
        build: (c) {
          c.optionalString(
            id: 1,
            name: 'prop1',
            getter: (t) => throw UnimplementedError(),
          );
          c.constructor = () => throw UnimplementedError();
        },
      );
      final other0 = EntityKind<_Person>(
        name: 'OTHER',
        build: (c) {
          c.optionalString(
            id: 1,
            name: 'prop1',
            getter: (t) => throw UnimplementedError(),
          );
          c.constructor = () => throw UnimplementedError();
        },
      );
      final other1 = EntityKind<_Person>(
        name: 'Example',
        build: (c) {
          c.optionalString(
            id: 1,
            name: 'OTHER',
            getter: (t) => throw UnimplementedError(),
          );
          c.constructor = () => throw UnimplementedError();
        },
      );

      expect(object, clone);
      expect(object, isNot(other0));
      expect(object, isNot(other1));

      expect(object.hashCode, clone.hashCode);
      expect(object.hashCode, isNot(other0.hashCode));
      expect(object.hashCode, isNot(other1.hashCode));
    });

    test('instanceIsDefault', () {
      var getterCallCounter = 0;
      final kind = EntityKind<_Person>(
        name: 'Kind for instanceIsDefault test',
        build: (c) {
          c.optionalString(
            id: 1,
            name: 'name',
            getter: (t) {
              getterCallCounter++;
              return t.name;
            },
          );
          c.constructor = () {
            fail('Should not be called');
          };
        },
      );
      final person = _Person();
      person.birthDate = Date(2020, 1, 1); // <-- This should be ignored

      // Default value
      expect(kind.instanceIsDefaultValue(person), isTrue);
      expect(getterCallCounter, 1);

      // Not default value
      person.name = 'Something else';
      expect(kind.instanceIsDefaultValue(person), isFalse);
      expect(getterCallCounter, 2);
    });

    test('instanceIsValid', () {
      var getterCallCounter = 0;
      final kind = EntityKind<_Person>(
        name: 'Kind for instanceIsValid test',
        build: (c) {
          c.optionalString(
            id: 1,
            name: 'name',
            minLengthInUtf8: 2,
            getter: (t) {
              getterCallCounter++;
              return t.name;
            },
          );

          c.constructor = () {
            fail('Should not be called');
          };
        },
      );
      final person = _Person();

      // Invalid name
      person.name = '';
      expect(kind.props.single.kind.instanceIsValid(''), isFalse);
      expect(kind.instanceIsValid(person), isFalse);
      expect(getterCallCounter, 1);

      // Valid name
      person.name = 'John Doe';
      expect(kind.props.single.kind.instanceIsValid('John Doe'), isTrue);
      expect(kind.instanceIsValid(person), isTrue);
      expect(getterCallCounter, 2);
    });

    test('Inheritance', () {
      final customerKind = _Customer.kind;
      expect(customerKind.props, hasLength(1));

      final personKind = _Person.kind;
      expect(personKind.props, hasLength(2));
    });

    group('JSON encoding', () {
      test('context without `context.namer`', () {
        final kind = _Person.kind;
        final personJson = kind.jsonTreeEncode(
          _Person()..birthDate = Date(2020, 1, 1),
          context: JsonEncodingContext(),
        );
        expect(personJson, {'birthDate': '2020-01-01'});
      });

      test('context with `context.namer`', () {
        final namer = UnderscoreNamer();
        final kind = _Person.kind;
        final personJson = kind.jsonTreeEncode(
          _Person()..birthDate = Date(2020, 1, 1),
          context: JsonEncodingContext(namer: namer),
        );
        expect(personJson, {'birth_date': '2020-01-01'});
      });
    });

    group('JSON decoding', () {
      test('context without `context.namer`', () {
        final kind = _Person.kind;
        final person = kind.jsonTreeDecode(
          {'birthDate': '2020-01-01'},
          context: JsonDecodingContext(),
        );
        expect(person.birthDate, Date(2020, 1, 1));
      });

      test('context with `context.namer`', () {
        final namer = UnderscoreNamer();
        final kind = _Person.kind;
        final person = kind.jsonTreeDecode(
          {'birth_date': '2020-01-01'},
          context: JsonDecodingContext(namer: namer),
        );
        expect(person.birthDate, Date(2020, 1, 1));
      });
    });
  });
}

class _Customer {
  static final EntityKind<_Customer> kind = EntityKind<_Customer>(
    name: 'Customer',
    build: (c) {
      c.optionalString(
        id: 1,
        name: 'name',
        getter: (t) => t.name,
        setter: (t, v) => t.name = v,
      );
    },
  );

  String? name;
}

class _Person extends _Customer {
  static final EntityKind<_Person> kind = EntityKind<_Person>(
    name: 'Person',
    extendsClause: EntityKindExtendsClause(kind: _Customer.kind),
    build: (c) {
      c.optionalDate(
        id: 2,
        name: 'birthDate',
        getter: (t) => t.birthDate,
        setter: (t, v) => t.birthDate = v,
      );
      c.constructor = () => _Person();
    },
  );

  Date? birthDate;
}
