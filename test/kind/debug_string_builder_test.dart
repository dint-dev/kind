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
  group('DebugStringBuilder', () {
    test('only non-default values are printed', () {
      final value = _Example()..name.value = 'a';
      expect(
        value.toString(),
        '_Example(\n'
        '  name: "a",\n'
        ')',
      );
    });

    test('does not enter possible cycles (entity field)', () {
      final value = _Example()..name.value = 'a';
      value.example.value = value;
      value.listOfExamples.add(value);
      expect(
        value.toString(),
        '_Example(\n'
        '  name: "a",\n'
        '  example: << _Example >>,\n'
        '  listOfExamples: [<< _Example >>],\n'
        ')',
      );
    });

    test('does not enter possible cycles (list field)', () {
      final value = _Example()..name.value = 'a';
      value.example.value = value;
      value.listOfExamples.add(value);
      expect(
        value.toString(),
        '_Example(\n'
        '  name: "a",\n'
        '  example: << _Example >>,\n'
        '  listOfExamples: [<< _Example >>],\n'
        ')',
      );
    });

    test('shows short lists', () {
      final value = _Example();
      value.listOfStrings.addAll(['a', 'b', 'c']);
      expect(
        value.toString(),
        '_Example(\n'
        '  listOfStrings: ["a", "b", "c"],\n'
        ')',
      );
    });

    test('shows only a summary of long lists', () {
      final value = _Example();
      for (var i = 0; i < 30; i++) {
        value.listOfExamples.add(value);
      }
      expect(
        value.toString(),
        '_Example(\n'
        '  listOfExamples: << _ReactiveList<_Example> with 30 items >>,\n'
        ')',
      );
    });

    test('shows only a summary of long sets', () {
      final value = _Example();
      for (var i = 0; i < 30; i++) {
        value.setOfExamples.add(value);
      }
      expect(
        value.toString(),
        '_Example(\n'
        '  setOfExamples: << _ReactiveSet<_Example> with 30 items >>,\n'
        ')',
      );
    });
  });
}

class _Example extends Entity {
  static final EntityKind<_Example> kind = EntityKind<_Example>(
    name: '_Example',
    define: (c) {
      c.requiredString(
        id: 1,
        name: 'name',
        field: (t) => t.name,
      );
      c.optional<_Example>(
        id: 2,
        name: 'example',
        kind: _Example.kind,
        field: (t) => t.example,
      );
      c.requiredList<String>(
        id: 3,
        name: 'listOfStrings',
        itemsKind: const StringKind(),
        field: (t) => t.listOfStrings,
      );
      c.requiredList<_Example>(
        id: 4,
        name: 'listOfExamples',
        itemsKind: _Example.kind,
        field: (t) => t.listOfExamples,
      );
      c.requiredSet<_Example>(
        id: 5,
        name: 'setOfExamples',
        itemsKind: _Example.kind,
        field: (t) => t.setOfExamples,
      );
    },
  );

  late final Field<String> name = Field<String>(this);

  late final Field<_Example?> example = Field<_Example?>(this);

  late final ListField<String> listOfStrings = ListField<String>(this);

  late final ListField<_Example> listOfExamples = ListField<_Example>(this);

  late final SetField<_Example> setOfExamples = SetField<_Example>(this);

  @override
  EntityKind getKind() => kind;
}
