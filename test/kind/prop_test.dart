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
  group('Prop', () {
    test('Prop.kind_', () {
      // ignore: invalid_use_of_protected_member
      final kind = Prop.kind_;
      expect(kind.name, 'Prop');

      final prop = Prop(
        id: 1,
        name: 'x',
        kind: const StringKind(
          minLengthInUtf8: 1,
        ),
        meanings: [
          PropMeaning.schemaOrg('schemaKindName', 'schemaPropName'),
        ],
        relation: EntityRelation.oneToOne('local_key', 'foreign_key'),
        getter: (t) => throw UnimplementedError(),
      );
      final json = {
        'id': 1.0,
        'name': 'x',
        'kind': {
          'type': 'StringKind',
          'minLengthInUtf8': 1.0,
        },
        'meanings': [
          {
            'schemaUrl': 'https://schema.org/',
            'kindName': 'schemaKindName',
            'propName': 'schemaPropName',
          },
        ],
        'relation': {
          'localPropNames': ['local_key'],
          'foreignPropNames': ['foreign_key'],
        },
      };
      expect(kind.jsonTreeEncode(prop), json);
      expect(kind.jsonTreeDecode(json), prop);
    });

    test('== / hashCode', () {
      // Helper for eliminating suggestions to use constants.
      final one = 1;

      final value = Prop(
        id: 1,
        name: 'x',
        kind: StringKind(minLengthInUtf8: one),
        getter: (t) => throw UnimplementedError(),
      );
      final clone = Prop(
        id: 1,
        name: 'x',
        kind: StringKind(minLengthInUtf8: one),
        getter: (t) => throw UnimplementedError(),
      );
      final other0 = Prop(
        id: 9999999,
        name: 'x',
        kind: StringKind(minLengthInUtf8: one),
        getter: (t) => throw UnimplementedError(),
      );
      final other1 = Prop(
        id: 1,
        name: 'OTHER',
        kind: StringKind(minLengthInUtf8: one),
        getter: (t) => throw UnimplementedError(),
      );
      final other2 = Prop(
        id: 1,
        name: 'x',
        kind: StringKind(minLengthInUtf8: one + 999999),
        getter: (t) => throw UnimplementedError(),
      );

      expect(value, clone);
      expect(value, isNot(other0));
      expect(value, isNot(other1));
      expect(value, isNot(other2));

      expect(value.hashCode, clone.hashCode);
      expect(value.hashCode, isNot(other0.hashCode));
      expect(value.hashCode, isNot(other1.hashCode));
      expect(value.hashCode, isNot(other2.hashCode));
    });

    test('`getter` or `field` must be non-null', () {
      try {
        Prop(
          id: 1,
          name: 'x',
          kind: const StringKind(),
        );
        fail('Should have thrown');
      } on ArgumentError catch (e) {
        expect(
          e.toString(),
          'Invalid argument(s): Property "x" (id: 1) defines neither `getter` or `field`.',
        );
      }
    });

    test('toString', () {
      late EntityKind kind;
      kind = EntityKind<Object>(
        name: 'Example',
        define: (c) {
          c.addProp(Prop<Object, Object?>(
            id: 2,
            name: 'example',
            kind: kind.toNullable(),
            getter: (t) => throw UnimplementedError(),
          ));
        },
      );
      expect(
        kind.props.single.toString(),
        'Prop(\n'
        '  id: 2,\n'
        '  name: "example",\n'
        '  kind: NullableKind(Example.kind),\n'
        '  getter: ...,\n'
        ')',
      );
    });
  });
}
