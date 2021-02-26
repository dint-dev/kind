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

import 'package:collection/collection.dart';
import 'package:kind/kind.dart';

/// A sequence of [Prop] instances that uniquely identifies any row in the table.
///
/// # Example
/// ```
/// import 'package:kind/kind.dart';
///
/// final example = KeyProps(['country_code', 'phone_number']);
/// ```
class KeyProps {
  final List<String> columnNames;
  final List<PrimitiveKind>? kinds;

  const KeyProps(this.columnNames, {this.kinds});

  @override
  int get hashCode => const ListEquality<String>().hash(columnNames);

  @override
  bool operator ==(other) =>
      other is KeyProps &&
      const ListEquality<String>().equals(columnNames, other.columnNames) &&
      const ListEquality<PrimitiveKind>().equals(kinds, other.kinds);

  @override
  String toString() =>
      'KeyProps([${columnNames.map((e) => "'$e'").join(', ')}])';
}

/// Many-to-many relation in a relational database.
///
/// Many-to-many relationships require use of _associate table_.
///
/// ## Example
/// ```
/// import 'package:kind/kind.dart';
///
/// class Person extends Entity {
///   static final EntityKind<Person> kind = EntityKind<Person>(
///     name: 'Person',
///     builder: (c) {
///       // ...
///       c.addList<Person>(
///         id: 2,
///         name: 'friends',
///         itemsKind: Person.kind,
///         field: (person) => person.friends,
///         relation: ManyToMany(
///           localKey: KeyProps(['id']),
///           associateTableName: 'Friendship',
///           associateTableLocalKey: KeyProps(['from_friend_id']),
///           associateTableForeignKey: KeyProps(['to_friend_id']),
///           foreignKey: KeyProps(['id']),
///         ),
///       );
///       // ...
///     },
///   );
///
///   // ...
///
///   late final ListField<Person> friends = ListField<Person>();
/// }
/// ```
class ManyToMany extends Relation {
  final KeyProps? localKey;
  final String associateTableName;
  final KeyProps associateTableLocalKey;
  final KeyProps associateTableForeignKey;
  final KeyProps? foreignKey;

  ManyToMany({
    this.localKey,
    required this.associateTableName,
    required this.associateTableLocalKey,
    required this.associateTableForeignKey,
    this.foreignKey,
  });

  @override
  int get hashCode =>
      associateTableName.hashCode ^ localKey.hashCode ^ foreignKey.hashCode;

  @override
  bool operator ==(other) =>
      other is ManyToMany &&
      localKey == other.localKey &&
      associateTableName == other.associateTableName &&
      associateTableLocalKey == other.associateTableLocalKey &&
      associateTableForeignKey == other.associateTableForeignKey &&
      foreignKey == other.foreignKey;
}

/// One-to-many relation in a relational database.
///
/// ## Example
/// ```
/// import 'package:kind/kind.dart';
///
/// class Company extends Entity {
///   static final EntityKind<Company> kind = EntityKind<Company>(
///     name: 'Company',
///     builder: (c) {
///       // ...
///       c.requiredSet<Person>(
///         id: 2,
///         name: 'employees',
///         itemsKind: Employee.kind,
///         field: (company) => company.employees,
///         relation: OneToMany(
///           localKey: KeyProps(['id']),
///           foreignKey: KeyProps(['company_id']),
///         ),
///       );
///       // ...
///     },
///   );
///
///   // ...
///
///   late final SetField<Employee> employees = SetField<Employee>();
/// }
/// ```
class OneToMany extends Relation {
  final KeyProps localKey;
  final KeyProps foreignKey;

  OneToMany({
    required this.localKey,
    required this.foreignKey,
  });

  @override
  int get hashCode => localKey.hashCode ^ foreignKey.hashCode;

  @override
  bool operator ==(other) =>
      other is OneToMany &&
      localKey == other.localKey &&
      foreignKey == other.foreignKey;

  @override
  String toString() {
    return 'OneToMany(\n  localKey: $localKey,\n  foreignKey: $foreignKey,\n)';
  }
}

/// One-to-one relation in a relational database.
///
/// ## Example
/// ```
/// import 'package:kind/kind.dart';
///
/// class Company extends Entity {
///   static final EntityKind<Company> kind = EntityKind<Company>(
///     name: 'Company',
///     builder: (c) {
///       // ...
///       c.optional<Employee>(
///         id: 2,
///         name: 'managingDirector',
///         itemsKind: Employee.kind,
///         field: (company) => company.employees,
///         relation: OneToOne(
///           localKey: KeyProps(['managing_director_id']),
///           foreignKey: KeyProps(['id']),
///         ),
///       );
///       // ...
///     },
///   );
///
///   // ...
///
///   late final Field<Employee?> managingDirector = Field<Employee?>();
/// }
/// ```
class OneToOne extends Relation {
  final KeyProps localKey;
  final KeyProps foreignKey;
  OneToOne({
    required this.localKey,
    required this.foreignKey,
  });

  @override
  int get hashCode => localKey.hashCode ^ foreignKey.hashCode;

  @override
  bool operator ==(other) =>
      other is OneToOne &&
      localKey == other.localKey &&
      foreignKey == other.foreignKey;

  @override
  String toString() {
    return 'OneToOne(\n  localKey: $localKey,\n  foreignKey: $foreignKey,\n)';
  }
}

/// Relation of two tables in a relational database system.
///
/// ## Main relation types
///   * [OneToOne]
///   * [OneToMany]
///   * [ManyToMany]
///
abstract class Relation {}
