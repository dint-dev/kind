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
  setUpAll(() {
    final oldReactiveSystem = ReactiveSystem.instance;
    addTearDown(() {
      ReactiveSystem.instance = oldReactiveSystem;
    });

    // Use ReactiveSystem without optimizations that affect
    // operation counts.
    ReactiveSystem.instance = ReactiveSystem(
      noOptimizations: true,
    );
  });

  group('Field', () {
    test('Adds read events', () {
      final reactiveSystem = ReactiveSystem.instance;
      final oldReads = reactiveSystem.readCount;
      final oldWrites = reactiveSystem.writeCount;
      final example = Example();
      expect(reactiveSystem.readCount, oldReads);
      expect(reactiveSystem.writeCount, oldWrites);

      // View #1
      example.x.value;
      expect(reactiveSystem.readCount, oldReads + 1);
      expect(reactiveSystem.writeCount, oldWrites);

      // View #2
      example.x.value;
      expect(reactiveSystem.readCount, oldReads + 2);
      expect(reactiveSystem.writeCount, oldWrites);
    });

    test('Adds write events', () {
      final reactiveSystem = ReactiveSystem.instance;
      final oldReads = reactiveSystem.readCount;
      final oldWrites = reactiveSystem.writeCount;
      final example = Example();
      expect(reactiveSystem.readCount, oldReads);
      expect(reactiveSystem.writeCount, oldWrites);

      // Mutation #1
      example.x.value = 'value0';
      expect(reactiveSystem.readCount, oldReads);
      expect(reactiveSystem.writeCount, oldWrites + 1);

      // Mutation #2
      example.x.value = 'value0';
      expect(reactiveSystem.readCount, oldReads);
      expect(reactiveSystem.writeCount, oldWrites + 2);
    });
  });

  group('ListField', () {
    test('Adds read events', () {
      final reactiveSystem = ReactiveSystem.instance;
      final oldReads = reactiveSystem.readCount;
      final oldWrites = reactiveSystem.writeCount;
      final example = Example();
      final field = example.listField;

      // Listen
      final subscription = reactiveSystem
          .newReactiveStream(() => example.x.value)
          .listen((event) {});
      addTearDown(() {
        subscription.cancel();
      });

      expect(reactiveSystem.readCount, oldReads);
      expect(reactiveSystem.writeCount, oldWrites);

      // View #1
      field.length;
      expect(reactiveSystem.readCount, oldReads + 1);
      expect(reactiveSystem.writeCount, oldWrites);

      // View #2
      field.length;
      expect(reactiveSystem.readCount, oldReads + 2);
      expect(reactiveSystem.writeCount, oldWrites);
    });

    test('Adds write events', () {
      final reactiveSystem = ReactiveSystem.instance;
      final oldReads = reactiveSystem.readCount;
      final oldWrites = reactiveSystem.writeCount;
      final example = Example();
      final field = example.listField;

      final subscription = reactiveSystem
          .newReactiveStream(() => example.x.value)
          .listen((event) {});
      addTearDown(() {
        subscription.cancel();
      });

      expect(reactiveSystem.readCount, oldReads);
      expect(reactiveSystem.writeCount, oldWrites);

      // Mutation #1
      field.add('item0');
      expect(reactiveSystem.readCount, oldReads);
      expect(reactiveSystem.writeCount, oldWrites + 1);

      // Mutation #2
      field.add('item1');
      expect(reactiveSystem.readCount, oldReads);
      expect(reactiveSystem.writeCount, oldWrites + 2);
    });
  });

  group('SetField', () {
    test('Adds read events', () {
      final reactiveSystem = ReactiveSystem.instance;
      final oldReads = reactiveSystem.readCount;
      final oldWrites = reactiveSystem.writeCount;
      final example = Example();
      final field = example.setField;
      expect(reactiveSystem.readCount, oldReads);
      expect(reactiveSystem.writeCount, oldWrites);

      // View #1
      field.length;
      expect(reactiveSystem.readCount, oldReads + 1);
      expect(reactiveSystem.writeCount, oldWrites);

      // View #2
      field.length;
      expect(reactiveSystem.readCount, oldReads + 2);
      expect(reactiveSystem.writeCount, oldWrites);
    });

    test('Adds write events', () {
      final reactiveSystem = ReactiveSystem.instance;
      final oldReads = reactiveSystem.readCount;
      final oldWrites = reactiveSystem.writeCount;
      final example = Example();
      final field = example.setField;
      expect(reactiveSystem.readCount, oldReads);
      expect(reactiveSystem.writeCount, oldWrites);

      // Mutation #1
      field.add('item0');
      expect(reactiveSystem.readCount, oldReads + 1);
      expect(reactiveSystem.writeCount, oldWrites + 1);

      // Mutation #2
      field.add('item1');
      expect(reactiveSystem.readCount, oldReads + 2);
      expect(reactiveSystem.writeCount, oldWrites + 2);
    });
  });
}

class Example extends Entity {
  static final EntityKind<Example> kind = EntityKind<Example>(
      name: 'Example',
      define: (c) {
        c.requiredString(
          id: 1,
          name: 'x',
          field: (t) => t.x,
        );
        c.constructor = () => Example();
      });

  late final Field<String> x = Field<String>(this);
  late final ListField<String> listField = ListField<String>(this);
  late final SetField<String> setField = SetField<String>(this);

  @override
  EntityKind<Object> getKind() => kind;
}
