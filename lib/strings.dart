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

/// Contains some common string kinds such as URL ([stringKindForUrl]).
///
/// ## Purpose of this library
///   * Enable better tooling (administration UIs, etc.).
///
/// ## Example
/// In this example, we use [stringKindForUrl].
/// ```
/// import 'package:kind/kind.dart';
/// import 'package:kind/strings.dart';
///
/// class Organization extend Entity {
///   // ...
/// }
///
/// class OrganizationProps extends Props<Organization> {
///   late Prop<Organization, String> url = declare.required<String>(
///     id: 1,
///     name: 'url',
///     kind: urlStringKind,
///   );
///
///   // ...
/// }
/// ```
library kind.strings;

import 'package:kind/strings.dart';

export 'src/strings/email.dart';
export 'src/strings/markdown.dart';
export 'src/strings/phone_number.dart';
export 'src/strings/url.dart';
