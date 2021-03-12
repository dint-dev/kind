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

/// [StringKind] for phone numbers.
///
/// **We may modify the validation rules in future**.
///
/// ## Examples of valid strings
///   * `"+1-541-754-3010"`
///   * `"123"`
///   * `"(541) 754 3010"`
///   * `"(089) / 636-48018"`
///
/// ## Example
/// ```
/// import 'package:kind/kind.dart';
/// import 'package:kind/strings.dart';
///
/// class Organization extend Entity {
///   static final EntityKind<Organization> kind = EntityKind<Organization>(
///     name: 'Organization',
///     define: (c) {
///       c.optional<String>(
///         id: 1,
///         name: 'description',
///         kind: stringKindForPhoneNumber,
///         getter: (t) => t.phoneNumber,
///         setter: (t,v) => t.phoneNumber = v,
///       );
///       c.constructor = () => Organization();
///     },
///   );
///
///   String? phoneNumber;
///
///   @override
///   EntityKind<Organization> getKind() => kind;
/// }
/// ```
@experimental
const StringKind stringKindForPhoneNumber = StringKind(
  name: 'phoneNumber',
  isSingleLine: true,
  minLengthInUtf8: 3,
  maxLengthInUtf8: 40,
  regExpProvider: _telephoneRegExpProvider,
  examples: [
    '+1-541-754-3010',
    '123',
    '(541) 754 3010',
    '(089) / 636-48018',
  ],
);
final _telephoneRegExp = RegExp(r'^[+/() 0-9\-]+$');
RegExp _telephoneRegExpProvider() => _telephoneRegExp;
