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
  group('EntityJunction', () {
    test('== / hashCode', () {
      final value = EntityJunction(
        tableName: 'Example',
        localPropNames: ['a', 'b'],
        foreignPropNames: ['c', 'd'],
      );
      final clone = EntityJunction(
        tableName: 'Example',
        localPropNames: ['a', 'b'],
        foreignPropNames: ['c', 'd'],
      );
      final other0 = EntityJunction(
        tableName: 'OTHER',
        localPropNames: ['a', 'b'],
        foreignPropNames: ['c', 'd'],
      );
      final other1 = EntityJunction(
        tableName: 'Example',
        localPropNames: ['a', 'OTHER'],
        foreignPropNames: ['c', 'd'],
      );
      final other2 = EntityJunction(
        tableName: 'Example',
        localPropNames: ['a', 'b'],
        foreignPropNames: ['c', 'OTHER'],
      );

      expect(value, clone);
      expect(value, isNot(other0));
      expect(value, isNot(other1));
      expect(value, isNot(other2));

      expect(value.hashCode, clone.hashCode);
      expect(value.hashCode, isNot(other0.hashCode));
      expect(value.hashCode, isNot(other1.hashCode));
      expect(value.hashCode, isNot(other2.hashCode));
    });
  });
}
