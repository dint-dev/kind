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
  group('ReactiveSet', () {
    late ReactiveSet<String?> set;
    late int oldReadCount;
    late int oldWriteCount;
    late ReactiveSystem system;

    setUp(() {
      final oldReactiveSystem = ReactiveSystem.instance;
      addTearDown(() {
        ReactiveSystem.instance = oldReactiveSystem;
      });
      system = ReactiveSystem(noOptimizations: true);
      ReactiveSystem.instance = system;

      set = ReactiveSet<String?>.wrap(<String?>{'v0', 'v1'});
      oldReadCount = system.readCount;
      oldWriteCount = system.writeCount;
    });

    test('add(...)', () {
      set.add('a');
      expect(system.readCount, oldReadCount + 1);
      expect(system.writeCount, oldWriteCount + 1);
    });

    test('addAll(...)', () {
      set.addAll(['a', 'b']);
      expect(system.readCount, oldReadCount);
      expect(system.writeCount, oldWriteCount + 1);
    });

    test('remove(...)', () {
      set.remove('a');
      expect(system.readCount, oldReadCount + 1);
      expect(system.writeCount, oldWriteCount + 1);
    });

    test('removeAll(...)', () {
      set.removeAll(['a', 'b']);
      expect(system.readCount, oldReadCount);
      expect(system.writeCount, oldWriteCount + 1);
    });

    test('clear()', () {
      set.clear();
      expect(system.readCount, oldReadCount);
      expect(system.writeCount, oldWriteCount + 1);
    });

    test('length', () {
      set.length;
      expect(system.readCount, oldReadCount + 1);
      expect(system.writeCount, oldWriteCount);
    });

    test('first', () {
      set.first;
      expect(system.readCount, oldReadCount + 1);
      expect(system.writeCount, oldWriteCount);
    });

    test('last', () {
      set.first;
      expect(system.readCount, oldReadCount + 1);
      expect(system.writeCount, oldWriteCount);
    });

    test('single', () {
      final set = ReactiveSet<String>.from({'x'});
      set.single;
      expect(system.readCount, oldReadCount + 1);
      expect(system.writeCount, oldWriteCount);
    });

    test('iterator', () {
      final iterator = set.iterator;
      expect(system.readCount, oldReadCount);
      expect(system.writeCount, oldWriteCount);

      iterator.moveNext();
      expect(system.readCount, oldReadCount + 1);
      expect(system.writeCount, oldWriteCount);
      // Prevent next read from being optimized.
      ReactiveSystem.instance.newReactiveStream(() => null).listen((event) {});

      iterator.current;
      expect(system.readCount, oldReadCount + 2);
      expect(system.writeCount, oldWriteCount);
      // Prevent next read from being optimized.
      ReactiveSystem.instance.newReactiveStream(() => null).listen((event) {});

      iterator.moveNext();
      expect(system.readCount, oldReadCount + 3);
      expect(system.writeCount, oldWriteCount);
      // Prevent next read from being optimized.
      ReactiveSystem.instance.newReactiveStream(() => null).listen((event) {});

      iterator.current;
      expect(system.readCount, oldReadCount + 4);
      expect(system.writeCount, oldWriteCount);
    });
  });
}
