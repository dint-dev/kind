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

/// [StringKind] for Markdown content.
///
/// The kind does not do any kind of validation. This is purely a marker.
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
///         name: 'description',
///         kind: stringKindForMarkdown,
///         getter: (t) => t.description,
///         setter: (t,v) => t.description = v,
///       );
///       c.constructor = () => Organization();
///     },
///   );
///
///   String? description;
///
///   @override
///   EntityKind<Organization> getKind() => kind;
/// }
/// ```
const StringKind stringKindForMarkdown = StringKind(
  name: 'markdown',
  examples: <String>[
    '# Heading #1\n'
        '## Heading #2\n'
        '### Heading #3\n'
        'Paragraph with _italics_, **emphasis**, an [internal link],\n'
        'and an [external link](https://google.com/).\n'
        '  * Item #1\n'
        '  * Item #2\n',
  ],
);
