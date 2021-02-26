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
    late ReactiveIterable<String?> iterable;
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

      final state = Object();
      iterable = ReactiveIterable<String?>.wrap(<String?>['v0', 'v1'],
          wrappedState: state);
      oldReadCount = system.readCount;
      oldWriteCount = system.writeCount;
    });

    test('length', () {
      iterable.length;
      expect(system.readCount, oldReadCount + 1);
      expect(system.writeCount, oldWriteCount);
    });

    test('first', () {
      iterable.first;
      expect(system.readCount, oldReadCount + 1);
      expect(system.writeCount, oldWriteCount);
    });

    test('last', () {
      iterable.first;
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
      final iterator = iterable.iterator;
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
