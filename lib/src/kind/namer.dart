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

/// A [Namer] that translates names to various camel case naming conventions.
class CamelCaseNamer extends Namer {
  final Map<String, String> rules;
  final bool upperCaseProps;

  CamelCaseNamer({
    this.rules = const {},
    this.upperCaseProps = false,
  });

  @override
  String fromEntityKindPropName(
      EntityKind<Object> kind, Prop<Object, dynamic> prop, String name) {
    if (upperCaseProps && name.isNotEmpty) {
      return name.substring(0, 1).toUpperCase() + name.substring(1);
    }
    return super.fromEntityKindPropName(kind, prop, name);
  }

  @override
  String fromName(String name) {
    final newName = rules[name];
    if (newName != null) {
      return newName;
    }
    return super.fromName(name);
  }
}

/// Translates names of things.
///
/// # Example
/// ```
/// import 'package:kind/kind.dart';
///
/// void main() {
///   // Our naming policy
///   final namer = UnderscoreNamer(
///     // We can define arbitrary naming rules when needed.
///     rules: {
///       "URL": "url", // <-- Without this, "URL" would be "u_r_l"
///     },
///   );
///
///   // Let's assume we have kind `Person` that has a property `fullName`.
///   final kind = Person.kind;
///
///   // Decode JSON
///   final person = kind.jsonTreeDecode(
///     {
///       "full_name": "John Doe",
///     },
///     context: JsonDecodingContext(
///       namer: namer, // <-- The decoder will look for "full_name" instead of "fullName".
///     ),
///   );
/// }
/// ```
abstract class Namer {
  const Namer();
  String fromEntityKindPropName(EntityKind kind, Prop prop, String name) {
    return fromName(name);
  }

  String fromEnumKindEntryName(
      EnumKind kind, EnumKindEntry entry, String name) {
    return fromName(name);
  }

  String fromKindName(Kind kind, String name) {
    return fromName(name);
  }

  String fromName(String name) => name;
}

/// A [Namer] that translates names to underscore naming convention.
///
/// For example, "marketing_website_url" will be used instead of
/// "marketingWebsiteUrl".
///
/// Underscore naming convention is also known as "snake case".
///
/// # Example
/// ```
/// import 'package:kind/kind.dart';
///
/// void main() {
///   // Our naming policy
///   final namer = UnderscoreNamer(
///     // We can define arbitrary naming rules when needed.
///     rules: {
///       "URL": "url", // <-- Without this, "URL" would be "u_r_l"
///     },
///   );
///
///   // Let's assume we have kind `Person` that has a property `fullName`.
///   final kind = Person.kind;
///
///   // Decode JSON
///   final person = kind.jsonTreeDecode(
///     {
///       "full_name": "John Doe",
///     },
///     context: JsonDecodingContext(
///       namer: namer, // <-- The decoder will look for "full_name" instead of "fullName".
///     ),
///   );
/// }
/// ```
class UnderscoreNamer extends Namer {
  final Map<String, String> _cache = {};

  UnderscoreNamer({Map<String, String>? rules}) {
    if (rules != null) {
      _cache.addAll(rules);
    }
  }

  @override
  String fromName(String name) {
    final cached = _cache[name];
    if (cached != null) {
      return cached;
    }
    final sb = StringBuffer();
    for (var i = 0; i < name.length; i++) {
      final s = name.substring(i, i + 1);
      final lowerCasedS = s.toLowerCase();
      if (lowerCasedS != s) {
        sb.write('_');
      }
      sb.write(lowerCasedS);
    }
    final newName = sb.toString();
    _cache[name] = newName;
    return newName;
  }
}
