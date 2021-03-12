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

/// [StringKind] for URLs.
///
/// **We may modify the validation rules in future**.
///
/// ## Example
/// ```
/// import 'package:kind/kind.dart';
/// import 'package:kind/strings.dart';
///
/// class Organization extend Entity {
///   static final EntityKind<Organization> kind = EntityKind<Organization>(
///     name: 'Organization',
///     builder: (c) {
///       c.optional<String>(
///         id: 1,
///         name: 'url',
///         kind: stringKindForUrl,
///         getter: (t) => t.url,
///         setter: (t,v) => t.url = v,
///       );
///       c.constructor = () => Organization();
///     },
///   );
///
///   String? url;
///
///   @override
///   EntityKind<Organization> getKind() => kind;
/// }
/// ```
@experimental
const StringKind stringKindForUrl = StringKind(
  name: 'url',
  isSingleLine: true,
  minLengthInUtf8: 5,
  maxLengthInUtf8: 4096,
  regExpProvider: _urlRegExpProvider,
  examples: [
    'https://google.com',
  ],
);
final _urlRegExp = RegExp(r'^[a-zA-Z0-9][a-zA-Z0-9_+\-]*://\S+$');
RegExp _urlRegExpProvider() => _urlRegExp;
