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
  group('OneOfKind', () {
    test('== / hashCode', () {
      // Prevents `const` suggestions from the analyzer.
      // Constants could reduce test coverage.
      final two = 2;

      final object = OneOfKind(
        discriminatorName: 'type',
        primitiveValueName: 'value',
        entries: [
          OneOfKindEntry(
            id: 1,
            name: '1',
            kind: Int64Kind(min: two),
          ),
          OneOfKindEntry(
            id: 2,
            name: '2',
            kind: StringKind(minLengthInUtf8: two),
          ),
        ],
      );
      final clone = OneOfKind(
        discriminatorName: 'type',
        primitiveValueName: 'value',
        entries: [
          OneOfKindEntry(
            id: 1,
            name: '1',
            kind: Int64Kind(min: two),
          ),
          OneOfKindEntry(
            id: 2,
            name: '2',
            kind: StringKind(minLengthInUtf8: two),
          ),
        ],
      );
      final other0 = OneOfKind(
        discriminatorName: 'type',
        primitiveValueName: 'value',
        entries: [
          OneOfKindEntry(
            id: 1,
            name: '1',
            kind: Int64Kind(min: two),
          ),
          OneOfKindEntry(
            id: 9999,
            name: '2',
            kind: StringKind(minLengthInUtf8: two),
          ),
        ],
      );
      final other1 = OneOfKind(
        discriminatorName: 'type',
        primitiveValueName: 'value',
        entries: [
          OneOfKindEntry(
            id: 1,
            name: '1',
            kind: Int64Kind(min: two),
          ),
          OneOfKindEntry(
            id: 2,
            name: 'OTHER',
            kind: StringKind(minLengthInUtf8: two),
          ),
        ],
      );
      final other2 = OneOfKind(
        discriminatorName: 'type',
        primitiveValueName: 'value',
        entries: [
          OneOfKindEntry(
            id: 1,
            name: '1',
            kind: Int64Kind(min: two),
          ),
          OneOfKindEntry(
            id: 2,
            name: '2',
            kind: Int32Kind(min: two),
          ),
        ],
      );

      expect(object, clone);
      expect(object, isNot(other0));
      expect(object, isNot(other1));
      expect(object, isNot(other2));

      expect(object.hashCode, clone.hashCode);
      // expect(value.hashCode, isNot(other0.hashCode));
      // expect(value.hashCode, isNot(other1.hashCode));
      // expect(value.hashCode, isNot(other2.hashCode));
    });

    const intTypeName = 'IntTypeNameInEntry';
    const stringTypeName = 'StringTypeNameInEntry';
    final kind = OneOfKind(
      discriminatorName: 'type',
      primitiveValueName: 'value',
      entries: [
        OneOfKindEntry(
          id: 1,
          name: intTypeName,
          kind: const Int32Kind(),
        ),
        OneOfKindEntry(
          id: 2,
          name: stringTypeName,
          kind: const StringKind(),
        ),
        OneOfKindEntry(
          id: 3,
          name: 'Example0TypeNameInEntry',
          kind: _Example0.kind,
        ),
        OneOfKindEntry(
          id: 4,
          name: 'Example1TypeNameInEntry',
          kind: _Example1.kind,
        ),
      ],
    );

    group('decodeJson', () {
      test('primitives', () {
        expect(
          kind.jsonTreeDecode({
            'type': 'IntTypeNameInEntry',
            'value': 9,
          }),
          9,
        );
        expect(
          kind.jsonTreeDecode({
            'type': 'StringTypeNameInEntry',
            'value': 'abc',
          }),
          'abc',
        );
      });

      test('entities', () {
        expect(
          kind.jsonTreeDecode({
            'type': 'Example0TypeNameInEntry',
            'name': 'abc',
          }),
          _Example0()..name.value = 'abc',
        );
        expect(
          kind.jsonTreeDecode({
            'type': 'Example1TypeNameInEntry',
            'name': 'abc',
          }),
          _Example1()..name.value = 'abc',
        );
      });

      test('Not JSON object', () {
        try {
          kind.jsonTreeDecode([1, 2, 3]);
          fail('Should have thrown');
        } on GraphNodeError catch (e) {
          expect(e.pathEdges, []);
          expect(e.node, [1, 2, 3]);
          expect(e.reason, 'Expected JSON object.');
        }
      });

      test('Missing discriminator property', () {
        try {
          kind.jsonTreeDecode({
            'value': 9,
          });
          fail('Should have thrown');
        } on GraphNodeError catch (e) {
          expect(e.pathEdges, []);
          expect(e.node, {'value': 9});
          expect(e.reason,
              'JSON object does not have discriminator property "type".');
        }
      });

      test('Invalid discriminator property', () {
        try {
          kind.jsonTreeDecode({
            'type': 12345,
            'value': 9,
          });
          fail('Should have thrown');
        } on GraphNodeError catch (e) {
          expect(e.pathEdges, ['type']);
          expect(e.node, {'type': 12345, 'value': 9});
          expect(e.reason,
              'Expected JSON object discriminator property "type" to be JSON string.');
        }
      });

      test('Unknown type', () {
        try {
          kind.jsonTreeDecode({
            'type': 'some string',
            'value': 9,
          });
          fail('Should have thrown');
        } on GraphNodeError catch (e) {
          expect(e.pathEdges, ['type']);
          expect(e.node, 'some string');
          expect(
            e.reason,
            'Expected JSON object discriminator property "type" value "value" to be one of the following:\n'
            '  * "IntTypeNameInEntry"\n'
            '  * "StringTypeNameInEntry"\n'
            '  * "Example0TypeNameInEntry"\n'
            '  * "Example1TypeNameInEntry"\n',
          );
        }
      });
    });

    group('encodeJson', () {
      test('primitives', () {
        expect(
          kind.jsonTreeEncode(9),
          {
            'type': 'IntTypeNameInEntry',
            'value': 9,
          },
        );
        expect(
          kind.jsonTreeEncode('abc'),
          {
            'type': 'StringTypeNameInEntry',
            'value': 'abc',
          },
        );
      });
      test('entities', () {
        expect(
          kind.jsonTreeEncode(_Example0()..name.value = 'abc'),
          {
            'type': 'Example0TypeNameInEntry',
            'name': 'abc',
          },
        );
        expect(
          kind.jsonTreeEncode(_Example1()..name.value = 'abc'),
          {
            'type': 'Example1TypeNameInEntry',
            'name': 'abc',
          },
        );
      });

      test('unknown type', () {
        try {
          kind.jsonTreeEncode([1, 2, 3]);
          fail('Should have thrown');
        } on GraphNodeError catch (e) {
          expect(e.pathEdges, []);
          expect(e.node, [1, 2, 3]);
          expect(e.reason, 'Values of the given type are unsupported.');
        }
      });
    });

    test('validation', () {
      final kind = OneOfKind(
        entries: [
          OneOfKindEntry(
            id: 1,
            name: 'entry1',
            kind: StringKind(regExpProvider: () => RegExp(r'^value1$')),
          ),
          OneOfKindEntry(
            id: 2,
            name: 'entry2',
            kind: const DateTimeKind(),
          ),
          OneOfKindEntry(
            id: 3,
            name: 'entry3',
            kind: StringKind(regExpProvider: () => RegExp(r'^value3$')),
          ),
        ],
      );

      expect(kind.instanceIsValid(null), isFalse);
      expect(kind.instanceIsValid(''), isFalse);
      expect(kind.instanceIsValid('other'), isFalse);
      expect(kind.instanceIsValid('value1'), isTrue);
      expect(kind.instanceIsValid(DateTime(2020)), isTrue);
      expect(kind.instanceIsValid('value3'), isTrue);

      expect(
        () => kind.instanceValidateOrThrow(null),
        throwsA(isA<ValidationError>()),
      );
      expect(
        () => kind.instanceValidateOrThrow(''),
        throwsA(isA<ValidationError>()),
      );
      kind.instanceValidateOrThrow('value1');
      kind.instanceValidateOrThrow(DateTime(2020));
      kind.instanceValidateOrThrow('value3');
    });
  });
}

class _Example0 extends Entity {
  static final EntityKind<_Example0> kind = EntityKind<_Example0>(
    name: 'Example',
    define: (c) {
      c.requiredString(id: 1, name: 'name', field: (e) => e.name);
      c.constructor = () => _Example0();
    },
  );

  late final Field<String> name = Field<String>(this);

  @override
  EntityKind getKind() {
    return kind;
  }
}

class _Example1 extends Entity {
  static final EntityKind<_Example1> kind = EntityKind<_Example1>(
    name: 'Example',
    define: (c) {
      c.requiredString(id: 1, name: 'name', field: (e) => e.name);
      c.constructor = () => _Example1();
    },
  );

  late final Field<String> name = Field<String>(this);

  @override
  EntityKind getKind() {
    return kind;
  }
}
