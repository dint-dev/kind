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

/// Optional superclass for entities.
///
/// This class gives you automatic implementations of:
///   * `hashCode` (implementation uses [GraphEquality])
///   * `==` (implementation uses [GraphEquality])
///   * `toString()` (implementation uses [EntityDebugStringBuilder])
///
/// You must implement [getKind()].
///
/// # Example
/// ```
/// import 'package:kind/kind.dart';
///
/// class Person extends Entity {
///   static final EntityKind<Person> kind = EntityKind<Person>(
///     name: 'Person',
///     define: (c) {
///       // ...
///     },
///   );
///
///   @override
///   EntityKind<Person> getKind() => kind;
/// }
/// ```
abstract class Entity {
  const Entity();

  @override
  int get hashCode {
    return const GraphEquality().hashEntity(
      this,
      kind: getKind(),
    );
  }

  @override
  bool operator ==(Object other) {
    return const GraphEquality().equalsEntity(
      this,
      other,
      kind: getKind(),
      stack: null,
    );
  }

  /// Returns [Kind] of this entity.
  ///
  /// # Example
  ///
  /// See documentation for the class [Entity].
  ///
  EntityKind getKind();

  @override
  String toString() {
    final builder = EntityDebugStringBuilder();
    builder.writeDartEntity(this, kind: getKind());
    return builder.toString();
  }
}

/// Optional mixin for entities (alternative to extending [Entity]).
///
/// This class gives you automatic implementations of:
///   * `hashCode` (implementation uses [GraphEquality])
///   * `==` (implementation uses [GraphEquality])
///   * `toString()` (implementation uses [EntityDebugStringBuilder])
///
/// You must implement [getKind()].
///
/// # Example
/// ```
/// import 'package:kind/kind.dart';
///
/// class Person extends SomeClass with EntityMixin {
///   static final EntityKind<Person> kind = EntityKind<Person>(
///     name: 'Person',
///     define: (c) {
///       // ...
///     },
///   );
///
///   @override
///   EntityKind<Person> getKind() => kind;
/// }
/// ```
mixin EntityMixin implements Entity {
  @override
  int get hashCode {
    return const GraphEquality().hashEntity(
      this,
      kind: getKind(),
    );
  }

  @override
  bool operator ==(Object other) {
    return const GraphEquality().equalsEntity(
      this,
      other,
      kind: getKind(),
      stack: null,
    );
  }

  @override
  String toString() {
    final builder = EntityDebugStringBuilder();
    builder.writeDartEntity(this, kind: getKind());
    return builder.toString();
  }
}
