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
  group('Entity', () {
    test('== / hashCode', () {
      final value = _Example()
        ..name.value = 'a'
        ..example.value = _Example()
        ..listOfExamples.addAll([_Example()]);
      final clone = _Example()
        ..name.value = 'a'
        ..example.value = _Example()
        ..listOfExamples.addAll([_Example()]);
      final nonPrimitiveListDifferences = _Example()
        ..name.value = 'a'
        ..example.value = _Example()
        ..listOfExamples.addAll([_Example()..name.value = 'OTHER']);
      final other0 = _Example()
        ..name.value = 'OTHER'
        ..example.value = _Example()
        ..listOfExamples.addAll([_Example()]);
      final other1 = _Example()
        ..name.value = 'OTHER'
        ..example.value = _Example()
        ..listOfExamples.addAll([]);

      expect(value == Object(), isFalse);
      expect(value, clone);
      expect(value, isNot(nonPrimitiveListDifferences));
      expect(value, isNot(other0));
      expect(value, isNot(other1));

      expect(value.hashCode, clone.hashCode);
      expect(value.hashCode, nonPrimitiveListDifferences.hashCode);
      expect(value.hashCode, isNot(other0.hashCode));
      expect(value.hashCode, isNot(other1.hashCode));
    });

    test('== / hashCode, recursive', () {
      // A small cyclic graph
      final value = _Example()
        ..name.value = 'a'
        ..listOfExamples.add(_Example());
      value.listOfExamples.add(value);
      final clone = _Example()
        ..name.value = 'a'
        ..listOfExamples.add(_Example());
      clone.listOfExamples.add(clone);

      expect(value, clone);
      expect(value.hashCode, clone.hashCode);
    });

    test('toString()', () {
      final value = _Example()..name.value = 'a';
      expect(
        value.toString(),
        '_Example(\n'
        '  name: "a",\n'
        ')',
      );
    });

    test('toString(), recursive list', () {
      final value = _Example()..name.value = 'a';
      value.example.value = value;
      value.listOfExamples.add(value);
      expect(
        value.toString(),
        '_Example(\n'
        '  name: "a",\n'
        '  example: << _Example >>,\n'
        '  listOfExamples: [...],\n'
        ')',
      );
    });
  });
}

class _Example extends Entity {
  static final EntityKind<_Example> kind = EntityKind<_Example>(
    name: '_Example',
    build: (b) {
      b.requiredString(
        id: 1,
        name: 'name',
        field: (t) => t.name,
      );
      b.optional<_Example>(
        id: 2,
        name: 'example',
        kind: _Example.kind,
        field: (t) => t.example,
      );
      b.requiredList<_Example>(
        id: 3,
        name: 'listOfExamples',
        itemsKind: _Example.kind,
        field: (t) => t.listOfExamples,
      );
    },
  );

  late final Field<String> name = Field<String>(this);

  late final Field<_Example?> example = Field<_Example?>(this);

  late final ListField<_Example> listOfExamples = ListField<_Example>(this);

  @override
  EntityKind getKind() => kind;
}
