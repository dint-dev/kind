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

/// [Kind] for `void`.
///
/// # Example
/// ```
/// import 'package:kind/kind.dart';
///
/// void main() {
///   final kind = FutureKind(VoidKind()));
/// }
/// ```
class VoidKind extends Kind<void> {
  @protected
  static final EntityKind<VoidKind> kind = EntityKind<VoidKind>(
    name: 'VoidKind',
    define: (c) {
      c.constructor = () => const VoidKind();
    },
  );

  @literal
  const VoidKind();

  @override
  String get name => 'Void';

  @override
  int get protobufFieldType => const Uint32Kind().protobufFieldType;

  @override
  EntityKind<Object> getKind() {
    return kind;
  }

  @override
  bool instanceIsDefaultValue(Object? value) {
    return value == null;
  }

  @override
  Object? jsonTreeDecode(Object? value, {JsonDecodingContext? context}) {
    return null;
  }

  @override
  Object? jsonTreeEncode(void instance, {JsonEncodingContext? context}) {
    return null;
  }

  @override
  void newInstance() {
    return null;
  }

  @override
  void protobufTreeDecode(Object? value, {ProtobufDecodingContext? context}) {
    return null;
  }

  @override
  Object protobufTreeEncode(void instance, {ProtobufEncodingContext? context}) {
    return 0;
  }
}
