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
  group('ReactiveMap', () {
    late ReactiveMap<String, String> map;
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

      map = ReactiveMap<String, String>.wrap(<String, String>{'k0': 'v1'});
      oldReadCount = system.readCount;
      oldWriteCount = system.writeCount;
    });

    test("map['k0']", () {
      map['k0'];
      expect(system.readCount, oldReadCount + 1);
      expect(system.writeCount, oldWriteCount);
    });

    test("map['non-existing key']", () {
      map['non-existing key'];
      expect(system.readCount, oldReadCount + 1);
      expect(system.writeCount, oldWriteCount);
    });

    test("map['k0'] = v0", () {
      map['k0'] = 'v0';
      expect(system.readCount, oldReadCount);
      expect(system.writeCount, oldWriteCount + 1);
    });

    test("map['new key'] = 'new value'", () {
      map['new key'] = 'new value';
      expect(system.readCount, oldReadCount);
      expect(system.writeCount, oldWriteCount + 1);
    });

    test('map.length', () {
      map.length;
      expect(system.readCount, oldReadCount + 1);
      expect(system.writeCount, oldWriteCount);
    });
  });
}
