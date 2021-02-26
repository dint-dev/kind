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
  group('ReactiveList', () {
    late ReactiveList<String?> list;
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

      list = ReactiveList<String?>.wrap(<String?>['v0', 'v1']);
      oldReadCount = system.readCount;
      oldWriteCount = system.writeCount;
    });

    test('list[0]', () {
      list[0];
      expect(system.readCount, oldReadCount + 1);
      expect(system.writeCount, oldWriteCount);
    });

    test('list[0] = v', () {
      list[0] = 'value';
      expect(system.readCount, oldReadCount);
      expect(system.writeCount, oldWriteCount + 1);
    });

    test('length', () {
      list.length;
      expect(system.readCount, oldReadCount + 1);
      expect(system.writeCount, oldWriteCount);
    });

    test('length = 5', () {
      list.length = 5;
      expect(system.readCount, oldReadCount);
      expect(system.writeCount, oldWriteCount + 1);
    });

    test('add(...)', () {
      list.add('a');
      expect(system.readCount, oldReadCount);
      expect(system.writeCount, oldWriteCount + 1);
    });

    test('addAll(...)', () {
      list.addAll(['a', 'b']);
      expect(system.readCount, oldReadCount);
      expect(system.writeCount, oldWriteCount + 1);
    });

    test('remove(...)', () {
      list.remove('a');
      expect(system.readCount, oldReadCount + 1);
      expect(system.writeCount, oldWriteCount + 1);
    });

    test('removeLast()', () {
      list.removeLast();
      expect(system.readCount, oldReadCount + 1);
      expect(system.writeCount, oldWriteCount + 1);
    });

    test('clear()', () {
      list.clear();
      expect(system.readCount, oldReadCount);
      expect(system.writeCount, oldWriteCount + 1);
    });

    test('first', () {
      list.first;
      expect(system.readCount, oldReadCount + 1);
      expect(system.writeCount, oldWriteCount);
    });

    test('last', () {
      list.first;
      expect(system.readCount, oldReadCount + 1);
      expect(system.writeCount, oldWriteCount);
    });

    test('single', () {
      final list = ReactiveList<String>.from(['x']);
      list.single;
      expect(system.readCount, oldReadCount + 1);
      expect(system.writeCount, oldWriteCount);
    });

    test('iterator', () {
      final iterator = list.iterator;
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
