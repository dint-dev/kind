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

/// Describes meaning of a [Prop] in some structured data vocabulary.
///
/// ## Example
/// In this example, we refer to
/// [schema.org/birthDate](https://schema.org/birthDate):
/// ```
/// import 'package:kind/kind.dart';
///
/// class Person extends Entity {
///   static final EntityKind<Person> kind = EntityKind<Person>(
///     name: 'Person',
///     builder: (c) {
///       // ...
///       c.addProp(Prop<Person,Date?>(
///         id: 2,
///         name: 'birthDate',
///         kind: const DateKind(),
///         meanings: [
///           PropMeaning.schemaOrg('Person', 'birthDate'),
///         ],
///       ));
///       // ...
///     },
///   );
///   // ...
/// }
/// ```
class PropMeaning {
  final String schemaUrl;
  final String kindName;
  final String propName;

  /// Defines URL of the namespace, kind name in the namespace (can be blank),
  /// and property in the namespace.
  const PropMeaning(this.schemaUrl, this.kindName, this.propName);

  /// Shorthand for [schema.org](https://schema.org) meanings.
  ///
  /// ## Example
  /// In this example, we refer to
  /// [schema.org/birthDate](https://schema.org/birthDate):
  /// ```
  /// PropMeaning.schemaOrg('Person', 'birthDate')
  /// ```
  const PropMeaning.schemaOrg(String kindName, String propName)
      : this('https://schema.org/', kindName, propName);

  @override
  int get hashCode =>
      schemaUrl.hashCode ^ kindName.hashCode ^ propName.hashCode;

  String get microDataSchemaUrl {
    if (kindName == '') {
      return schemaUrl;
    }
    return '$schemaUrl$kindName';
  }

  @override
  bool operator ==(other) =>
      other is PropMeaning &&
      schemaUrl == other.schemaUrl &&
      kindName == other.kindName &&
      propName == other.propName;

  @override
  String toString() => "PropMeaning('$schemaUrl', '$kindName', '$propName')";
}
