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

/// Describes a relation of two tables in a relational database.
///
/// ## Examples
/// See:
///   * [EntityRelation.oneToOne]
///   * [EntityRelation.oneToMany]
///   * [EntityRelation.manyToMany]
class EntityRelation extends Entity {
  static final EntityKind<EntityRelation> kind = EntityKind<EntityRelation>(
    name: 'EntityRelation',
    build: (c) {
      final localKey = c.requiredList<String>(
        id: 1,
        name: 'localPropNames',
        itemsKind: const StringKind(minLengthInUtf8: 1, maxLengthInUtf8: 63),
        getter: (t) => t.localPropNames,
      );
      final junctions = c.requiredList<EntityJunction>(
        id: 2,
        name: 'junctions',
        itemsKind: EntityJunction.kind,
        maxLength: 4,
        getter: (t) => t.junctions,
      );
      final foreignTableName = c.optionalString(
        id: 3,
        name: 'foreignTableName',
        minLengthInUtf8: 1,
        maxLengthInUtf8: 63,
        getter: (t) => t.foreignTableName,
      );
      final foreignKey = c.requiredList<String>(
        id: 4,
        name: 'foreignPropNames',
        itemsKind: const StringKind(minLengthInUtf8: 1, maxLengthInUtf8: 63),
        getter: (t) => t.foreignPropNames,
      );
      c.constructorFromData = (data) {
        return EntityRelation(
          localPropNames: data.get(localKey),
          junctions: data.get(junctions),
          foreignTableName: data.get(foreignTableName),
          foreignPropNames: data.get(foreignKey),
        );
      };
    },
  );

  final List<String> localPropNames;
  final List<EntityJunction> junctions;
  final String? foreignTableName;
  final List<String> foreignPropNames;

  EntityRelation({
    required this.localPropNames,
    this.junctions = const [],
    this.foreignTableName,
    required this.foreignPropNames,
  }) {
    if (junctions.isEmpty) {
      if (localPropNames.length != foreignPropNames.length) {
        throw ArgumentError(
            'Database keys have inconsistent number of columns.');
      }
    } else {
      if (localPropNames.length != junctions.first.localPropNames.length) {
        throw ArgumentError(
            'Database keys have inconsistent number of columns.');
      }
      var previousAssociation = junctions.first;
      for (var association in junctions.skip(1)) {
        if (association.localPropNames.length !=
            previousAssociation.foreignPropNames.length) {
          throw ArgumentError(
              'Database keys have inconsistent number of columns.');
        }
        previousAssociation = association;
      }
      if (foreignPropNames.length !=
          previousAssociation.foreignPropNames.length) {
        throw ArgumentError(
            'Database keys have inconsistent number of columns.');
      }
    }
  }

  /// Constructs an instance of many-to-many relation.
  ///
  /// # Example
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
  ///         relation: EntityRelation.manyToMany(
  ///           tableName: 'Friendship'
  ///           localPropName: 'from_friend_id',
  ///           foreignPropName: 'to_friend_id'),
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
  factory EntityRelation.manyToMany({
    String originName = 'id',
    required String tableName,
    required String localPropName,
    required String foreignPropName,
    String destinationName = 'id',
  }) {
    return EntityRelation(
      localPropNames: [originName],
      junctions: [
        EntityJunction(
          tableName: tableName,
          localPropNames: [localPropName],
          foreignPropNames: [foreignPropName],
        ),
      ],
      foreignPropNames: [destinationName],
    );
  }

  /// Constructs an instance of one-to-many relation.
  ///
  /// # Example
  /// ```
  /// import 'package:kind/kind.dart';
  ///
  /// class Company extends Entity {
  ///   static final EntityKind<Company> kind = EntityKind<Company>(
  ///     name: 'Company',
  ///     builder: (c) {
  ///       // ...
  ///       c.requiredSet<Employee>(
  ///         id: 2,
  ///         name: employees',
  ///         itemsKind: Employee.kind,
  ///         field: (company) => company.employees,
  ///         relation: EntityRelation.oneToOne('id', 'company_id'),
  ///       );
  ///       // ...
  ///     },
  ///   );
  ///
  ///   late final Field<Employee?> bestEmployee = Field<Employee?>();
  /// }
  /// ```
  factory EntityRelation.oneToMany(
      String localPropName, String foreignPropName) {
    return EntityRelation(
      localPropNames: [localPropName],
      foreignPropNames: [foreignPropName],
    );
  }

  /// Constructs an instance of one-to-one relation.
  ///
  /// # Example
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
  ///         name: 'bestEmployee',
  ///         itemsKind: Employee.kind,
  ///         field: (company) => company.bestEmployee,
  ///         relation: EntityRelation.oneToOne('best_employee_id', 'id'),
  ///       );
  ///       // ...
  ///     },
  ///   );
  ///
  ///   late final Field<Employee?> bestEmployee = Field<Employee?>();
  /// }
  /// ```
  factory EntityRelation.oneToOne(
      String localPropName, String foreignPropName) {
    return EntityRelation(
      localPropNames: [localPropName],
      foreignPropNames: [foreignPropName],
    );
  }

  @override
  EntityKind<EntityRelation> getKind() => kind;
}
