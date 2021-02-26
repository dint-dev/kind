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
  group('Uuid', () {
    test('== / hashCode', () {
      final value = Uuid('f81d4fae-7dec-11d0-a765-00a0c91e6bf6');
      final clone = Uuid('f81d4fae-7dec-11d0-a765-00a0c91e6bf6');
      final other = Uuid('f81d4fae-7dec-11d0-0000-00a0c91e6bf6');

      expect(value, clone);
      expect(value, isNot(other));

      expect(value.hashCode, clone.hashCode);
      expect(value.hashCode, isNot(other.hashCode));
    });

    test('implements Comparable', () {
      expect(Uuid.random(), isA<Comparable<Uuid>>());
    });

    test('Uuid(...) rejects invalid-looking strings', () {
      expect(() => Uuid('abcd'), throwsArgumentError);
    });

    test('Uuid.random()', () {
      final uuids = List<Uuid>.generate(1000, (i) => Uuid.random());
      for (var uuid in uuids) {
        expect(uuid.canonicalString, hasLength(36));
      }
      final byteSets = List<Set<int>>.generate(
          16, (i) => uuids.map((e) => e.toBytes()[i]).toSet());
      // Every byte has at least 196 different values.
      for (var i = 0; i < 16; i++) {
        expect(byteSets[i], hasLength(greaterThan(5)));
      }
    });

    test('toBytes()', () {
      final value = Uuid('f81d4fae-7dec-11d0-a765-00a0c91e6bf6');
      expect(value.toBytes()[0], 0xf8);
      expect(value.toBytes()[15], 0xf6);
    });
  });
}
