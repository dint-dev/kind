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
  group('GraphEquality', () {
    group('equals', () {
      test('string field', () {
        final value = _Example()..name = 'a';
        final clone = _Example()..name = 'a';
        final other0 = _Example()..name = 'OTHER';

        expect(value == Object(), isFalse);
        expect(value, clone);
        expect(value, isNot(other0));

        expect(value.hashCode, clone.hashCode);
        expect(value.hashCode, isNot(other0.hashCode));
      });

      test('complex object', () {
        final value = _Example()
          ..name = 'a'
          ..example = _Example()
          ..listOfExamples.addAll([_Example()]);
        final clone = _Example()
          ..name = 'a'
          ..example = _Example()
          ..listOfExamples.addAll([_Example()]);
        final nonPrimitiveListDifferences = _Example()
          ..name = 'a'
          ..example = _Example()
          ..listOfExamples.addAll([_Example()..name = 'OTHER']);
        final other0 = _Example()
          ..name = 'OTHER'
          ..example = _Example()
          ..listOfExamples.addAll([_Example()]);
        final other1 = _Example()
          ..name = 'OTHER'
          ..example = _Example()
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

      test('cyclic graph', () {
        final value = _Example()
          ..name = 'a'
          ..listOfExamples.add(_Example());
        value.listOfExamples.add(value);
        final clone = _Example()
          ..name = 'a'
          ..listOfExamples.add(_Example());
        clone.listOfExamples.add(clone);

        expect(value, clone);
        expect(value.hashCode, clone.hashCode);
      });
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
        getter: (t) => t.name,
        setter: (t, v) => t.name = v,
      );
      c.optional<_Example>(
        id: 2,
        name: 'example',
        kind: _Example.kind,
        getter: (t) => t.example,
        setter: (t, v) => t.example = v,
      );
      c.requiredList<String>(
        id: 3,
        name: 'listOfStrings',
        itemsKind: const StringKind(),
        getter: (t) => t.listOfStrings,
        setter: (t, v) => t.listOfStrings = v,
      );
      c.requiredList<_Example>(
        id: 4,
        name: 'listOfExamples',
        itemsKind: _Example.kind,
        getter: (t) => t.listOfExamples,
        setter: (t, v) => t.listOfExamples = v,
      );
      c.requiredSet<_Example>(
        id: 5,
        name: 'setOfExamples',
        itemsKind: _Example.kind,
        getter: (t) => t.setOfExamples,
        setter: (t, v) => t.setOfExamples = v,
      );
    },
  );

  String name = '';

  _Example? example;

  List<String> listOfStrings = [];

  List<_Example> listOfExamples = [];

  Set<_Example> setOfExamples = {};

  @override
  int get hashCode => GraphEquality().hash(this);

  @override
  bool operator ==(other) => GraphEquality().equals(this, other);

  @override
  EntityKind getKind() => kind;
}
