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
import 'package:meta/meta.dart';

/// Describes meaning of a [EntityKind] in some structured data vocabulary.
///
/// ## Example
/// In this example, we refer to [schema.org/Person](https://schema.org/Person):
/// ```
/// import 'package:kind/kind.dart';
///
/// class Person extends Entity {
///   static final EntityKind<Person> kind = EntityKind<Person>(
///     // ...
///     meanings: [
///       KindMeaning.schemaOrg('Person'),
///     ],
///     // ...
///   );
///   // ...
/// }
/// ```
class KindMeaning {
  static final EntityKind<KindMeaning> kind_ = EntityKind<KindMeaning>(
    name: 'KindMeaning',
    define: (c) {
      final schemaUrl = c.requiredString(
        id: 1,
        name: 'schemaUrl',
        getter: (t) => t.schemaUrl,
      );
      final name = c.requiredString(
        id: 2,
        name: 'name',
        getter: (t) => t.name,
      );
      c.constructorFromData = (data) {
        return KindMeaning(data.get(schemaUrl), data.get(name));
      };
    },
  );

  /// [Kind] for [KindMeaning].
  ///
  /// The purpose of annotation `@protected` is reducing accidental use.
  @protected
  static final EntityKind<KindMeaning> kind = EntityKind<KindMeaning>(
    name: 'JsonKind',
    define: (c) {
      final schemaUrlProp = c.requiredString(
        id: 1,
        name: 'schemaUrl',
      );
      final name = c.requiredString(
        id: 2,
        name: 'name',
      );
      c.constructorFromData = (data) {
        return KindMeaning(
          data.get(schemaUrlProp),
          data.get(name),
        );
      };
    },
  );

  final String schemaUrl;
  final String name;

  /// Defines URL of the namespace and name in the namespace.
  const KindMeaning(this.schemaUrl, this.name);

  /// A shorthand for [schema.org](https://schema.org/) meanings.
  ///
  /// ## Example
  /// In this example, we refer to [schema.org/Person](https://schema.org/Person):
  /// ```
  /// KindMeaning.schemaOrg('Person')
  /// ```
  const KindMeaning.schemaOrg(String kindName)
      : this('https://schema.org/', kindName);

  @override
  int get hashCode => schemaUrl.hashCode ^ name.hashCode;

  String get microDataSchemaUrl {
    if (name == '') {
      return schemaUrl;
    }
    return '$schemaUrl$name';
  }

  @override
  bool operator ==(other) =>
      other is KindMeaning &&
      schemaUrl == other.schemaUrl &&
      name == other.name;

  @override
  String toString() => "KindMeaning('$schemaUrl', '$name')";
}
