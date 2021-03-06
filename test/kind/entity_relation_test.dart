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
  group('EntityRelation', () {
    test('== / hashCode', () {
      final value = EntityRelation(
        localPropNames: ['a', 'b'],
        junctions: [
          EntityJunction(
            tableName: 'exampleTable',
            localPropNames: ['c', 'd'],
            foreignPropNames: ['e', 'f'],
          ),
        ],
        foreignPropNames: ['g', 'h'],
      );
      final clone = EntityRelation(
        localPropNames: ['a', 'b'],
        junctions: [
          EntityJunction(
            tableName: 'exampleTable',
            localPropNames: ['c', 'd'],
            foreignPropNames: ['e', 'f'],
          ),
        ],
        foreignPropNames: ['g', 'h'],
      );
      final other0 = EntityRelation(
        localPropNames: ['a', 'OTHER'],
        junctions: [
          EntityJunction(
            tableName: 'exampleTable',
            localPropNames: ['c', 'd'],
            foreignPropNames: ['e', 'f'],
          ),
        ],
        foreignPropNames: ['g', 'h'],
      );
      final other1 = EntityRelation(
        localPropNames: ['a', 'b'],
        junctions: [
          EntityJunction(
            tableName: 'OTHER',
            localPropNames: ['c', 'd'],
            foreignPropNames: ['e', 'f'],
          ),
        ],
        foreignPropNames: ['g', 'h'],
      );
      final other2 = EntityRelation(
        localPropNames: ['a', 'b'],
        junctions: [
          EntityJunction(
            tableName: 'exampleTable',
            localPropNames: ['c', 'd'],
            foreignPropNames: ['e', 'f'],
          ),
        ],
        foreignPropNames: ['g', 'OTHER'],
      );

      expect(value, clone);
      expect(value, isNot(other0));
      expect(value, isNot(other1));
      expect(value, isNot(other2));

      expect(value.hashCode, clone.hashCode);
      expect(value.hashCode, isNot(other0.hashCode));
    });

    test('toString', () {
      final value = EntityRelation(
        localPropNames: ['a', 'b'],
        foreignPropNames: ['c', 'd'],
      );
      expect(
        value.toString(),
        'EntityRelation(\n'
        '  localPropNames: ["a", "b"],\n'
        '  foreignPropNames: ["c", "d"],\n'
        ')',
      );
    });
  });
}
