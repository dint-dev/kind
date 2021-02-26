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
  group('KeyProps', () {
    test('== / hashCode', () {
      final value = KeyProps(['a', 'b']);
      final clone = KeyProps(['a', 'b']);
      final other = KeyProps(['a', 'OTHER']);

      expect(value, clone);
      expect(value, isNot(other));

      expect(value.hashCode, clone.hashCode);
      expect(value.hashCode, isNot(other.hashCode));
    });

    test('toString', () {
      final value = KeyProps(['a', 'b']);
      expect(value.toString(), "KeyProps(['a', 'b'])");
    });
  });

  group('OneToOne', () {
    test('== / hashCode', () {
      final value = OneToOne(
        localKey: KeyProps(['a', 'b']),
        foreignKey: KeyProps(['c', 'd']),
      );
      final clone = OneToOne(
        localKey: KeyProps(['a', 'b']),
        foreignKey: KeyProps(['c', 'd']),
      );
      final other = OneToOne(
        localKey: KeyProps(['a', 'b']),
        foreignKey: KeyProps(['c', 'OTHER']),
      );

      expect(value, clone);
      expect(value, isNot(other));

      expect(value.hashCode, clone.hashCode);
      expect(value.hashCode, isNot(other.hashCode));
    });

    test('toString', () {
      final value = OneToOne(
        localKey: KeyProps(['a', 'b']),
        foreignKey: KeyProps(['c', 'd']),
      );
      expect(
        value.toString(),
        'OneToOne(\n'
        "  localKey: KeyProps(['a', 'b']),\n"
        "  foreignKey: KeyProps(['c', 'd']),\n"
        ')',
      );
    });
  });

  group('OneToMany', () {
    test('== / hashCode', () {
      final value = OneToMany(
        localKey: KeyProps(['a', 'b']),
        foreignKey: KeyProps(['c', 'd']),
      );
      final clone = OneToMany(
        localKey: KeyProps(['a', 'b']),
        foreignKey: KeyProps(['c', 'd']),
      );
      final other = OneToMany(
        localKey: KeyProps(['a', 'b']),
        foreignKey: KeyProps(['c', 'OTHER']),
      );

      expect(value, clone);
      expect(value, isNot(other));

      expect(value.hashCode, clone.hashCode);
      expect(value.hashCode, isNot(other.hashCode));
    });

    test('toString', () {
      final value = OneToMany(
        localKey: KeyProps(['a', 'b']),
        foreignKey: KeyProps(['c', 'd']),
      );
      expect(
        value.toString(),
        'OneToMany(\n'
        "  localKey: KeyProps(['a', 'b']),\n"
        "  foreignKey: KeyProps(['c', 'd']),\n"
        ')',
      );
    });
  });

  group('ManyToMany', () {
    test('== / hashCode', () {
      final value = ManyToMany(
        localKey: KeyProps(['a', 'b']),
        associateTableName: 'Associate',
        associateTableLocalKey: KeyProps(['c', 'd']),
        associateTableForeignKey: KeyProps(['e', 'f']),
        foreignKey: KeyProps(['g', 'h']),
      );
      final clone = ManyToMany(
        localKey: KeyProps(['a', 'b']),
        associateTableName: 'Associate',
        associateTableLocalKey: KeyProps(['c', 'd']),
        associateTableForeignKey: KeyProps(['e', 'f']),
        foreignKey: KeyProps(['g', 'h']),
      );
      final other0 = ManyToMany(
        localKey: KeyProps(['a', 'OTHER']),
        associateTableName: 'Associate',
        associateTableLocalKey: KeyProps(['c', 'd']),
        associateTableForeignKey: KeyProps(['e', 'f']),
        foreignKey: KeyProps(['g', 'h']),
      );
      final other1 = ManyToMany(
        localKey: KeyProps(['a', 'b']),
        associateTableName: 'OTHER',
        associateTableLocalKey: KeyProps(['c', 'd']),
        associateTableForeignKey: KeyProps(['e', 'f']),
        foreignKey: KeyProps(['g', 'h']),
      );
      final other2 = ManyToMany(
        localKey: KeyProps(['a', 'b']),
        associateTableName: 'Associate',
        associateTableLocalKey: KeyProps(['c', 'OTHER']),
        associateTableForeignKey: KeyProps(['e', 'f']),
        foreignKey: KeyProps(['g', 'h']),
      );
      final other3 = ManyToMany(
        localKey: KeyProps(['a', 'b']),
        associateTableName: 'Associate',
        associateTableLocalKey: KeyProps(['c', 'd']),
        associateTableForeignKey: KeyProps(['e', 'OTHER']),
        foreignKey: KeyProps(['g', 'h']),
      );
      final other4 = ManyToMany(
        localKey: KeyProps(['a', 'b']),
        associateTableName: 'Associate',
        associateTableLocalKey: KeyProps(['c', 'd']),
        associateTableForeignKey: KeyProps(['e', 'f']),
        foreignKey: KeyProps(['g', 'OTHER']),
      );

      expect(value, clone);
      expect(value, isNot(other0));
      expect(value, isNot(other1));
      expect(value, isNot(other2));
      expect(value, isNot(other3));
      expect(value, isNot(other4));

      expect(value.hashCode, clone.hashCode);
      expect(value.hashCode, isNot(other0.hashCode));
      expect(value.hashCode, isNot(other1.hashCode));
      expect(value.hashCode, isNot(other4.hashCode));
    });
  });
}
