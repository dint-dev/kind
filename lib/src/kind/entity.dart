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

/// An object with properties.
///
/// Entity has [getKind()], which returns the correct [EntityKind].
///
/// If you extend [Entity], you get default implementations of [hashCode] and
/// operator [==].
///
/// ## Interpretation in different contexts
///   * In databases, interpreted as a table.
///   * In JSON serialization, serialized as JSON object.
///   * In Protocol Buffers serialization, serialized as message.
///
/// ## Examples
/// See documentation of [EntityKind].
///
abstract class Entity {
  const Entity();

  @override
  int get hashCode => getKind().instanceHash(this);

  @override
  bool operator ==(Object other) {
    return getKind().instanceEquals(this, other);
  }

  /// Returns [Kind] of this entity.
  ///
  /// ## Example
  /// ```
  /// class Person extends Entity {
  ///   static final EntityKind<Person> kind = EntityKind<Person>(
  ///     name: 'Person',
  ///     build: (b) {
  ///       // ...
  ///     },
  ///   );
  ///
  ///   @override
  ///   getKind() => kind;
  /// }
  /// ```
  EntityKind getKind();

  @override
  String toString() => getKind().instanceToString(this);
}
