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
  group('ReactiveMixin', () {
    late _Example example;
    late int oldReadCount;
    late int oldWriteCount;
    late ReactiveSystem system;

    setUp(() {
      final oldSystem = ReactiveSystem.instance;
      addTearDown(() {
        ReactiveSystem.instance = oldSystem;
      });
      system = ReactiveSystem(noOptimizations: true);
      ReactiveSystem.instance = system;
      oldReadCount = system.readCount;
      oldWriteCount = system.writeCount;
      example = _Example();
    });

    test('beforeFieldGet(...)', () {
      // ignore: invalid_use_of_protected_member
      example.beforeFieldGet(null);
      expect(system.readCount, oldReadCount + 1);
      expect(system.writeCount, oldWriteCount);
      // ignore: invalid_use_of_protected_member
      example.beforeFieldGet(null);
      expect(system.readCount, oldReadCount + 2);
      expect(system.writeCount, oldWriteCount);
    });

    test('beforeFieldSet(...)', () {
      // ignore: invalid_use_of_protected_member
      example.beforeFieldSet(3, 3);
      expect(system.readCount, oldReadCount);
      expect(system.writeCount, oldWriteCount);

      // ignore: invalid_use_of_protected_member
      example.beforeFieldSet(3, 4);
      expect(system.readCount, oldReadCount);
      expect(system.writeCount, oldWriteCount + 1);

      // ignore: invalid_use_of_protected_member
      example.beforeFieldSet(3, 4);
      expect(system.readCount, oldReadCount);
      expect(system.writeCount, oldWriteCount + 2);
    });

    test('beforeMethodThatReads()', () {
      // ignore: invalid_use_of_protected_member
      example.beforeMethodThatReads();
      expect(system.readCount, oldReadCount + 1);
      expect(system.writeCount, oldWriteCount);
    });

    test('beforeMethodThatWrites()', () {
      // ignore: invalid_use_of_protected_member
      example.beforeMethodThatWrites();
      expect(system.readCount, oldReadCount);
      expect(system.writeCount, oldWriteCount + 1);
    });

    test('beforeMethodThatReadsAndWrites()', () {
      // ignore: invalid_use_of_protected_member
      example.beforeMethodThatsReadsAndWrites();
      expect(system.readCount, oldReadCount + 1);
      expect(system.writeCount, oldWriteCount + 1);
    });
  });
}

class _Example with ReactiveMixin {}
