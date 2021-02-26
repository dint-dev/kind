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

/// [StringKind] for email addresses.
///
/// **We may modify the validation rules in future**.
///
/// ## Examples of valid strings
/// * `"example@tld.com"`
/// * `"a.b-c~box@tld.co.uk"`
///
/// ## Example
/// ```
/// import 'package:kind/kind.dart';
/// import 'package:kind/strings.dart';
///
/// class Organization extend Entity {
///   static final EntityKind<Organization> kind = EntityKind(
///     name: 'Organization',
///     builder: (c) {
///       c.addProp(Prop<Organization, String?>(
///         id: 1,
///         name: 'emailAddress',
///         kind: stringKindForEmailAddress.toNullable(),
///         // ...
///       );
///       // ...
///     },
///   );
///
///   // ...
/// }
/// ```
@experimental
const StringKind stringKindForEmailAddress = StringKind(
  name: 'EmailAddress',
  singleLine: true,
  minLengthInUtf8: 6,
  maxLengthInUtf8: 80,
  regExpProvider: _regExpProvider,
  examples: [
    'example@tld.com',
    'a.b-c~box@tld.co.uk',
  ],
);
final _regExp = RegExp(r'^[^\s,<>@]+@[^\s@]+(\.[^\s@]+)+$');
RegExp _regExpProvider() => _regExp;
