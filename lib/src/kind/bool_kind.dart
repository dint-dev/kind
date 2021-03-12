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
import 'package:protobuf/protobuf.dart' as protobuf;

/// [Kind] for [bool].
@sealed
class BoolKind extends PrimitiveKind<bool> {
  /// [Kind] for [BoolKind].
  ///
  /// The purpose of annotation `@protected` is reducing accidental use.
  @protected
  static final EntityKind<BoolKind> kind = EntityKind<BoolKind>(
    name: 'BoolKind',
    define: (c) {
      c.constructor = () => const BoolKind();
    },
  );

  @literal
  const BoolKind();

  @override
  int get bitsPerListElement => 1;

  @override
  int get hashCode => (BoolKind).hashCode;

  @override
  String get name => 'bool';

  @override
  int get protobufFieldType {
    return protobuf.PbFieldType.OB;
  }

  @override
  bool operator ==(other) {
    return other is BoolKind;
  }

  @override
  EntityKind<BoolKind> getKind() => kind;

  @override
  bool jsonTreeDecode(Object? json, {JsonDecodingContext? context}) {
    if (json is bool) {
      return json;
    } else {
      context ??= JsonDecodingContext();
      throw context.newGraphNodeError(
        value: json,
        reason: 'Expected JSON boolean',
      );
    }
  }

  @override
  Object? jsonTreeEncode(bool instance, {JsonEncodingContext? context}) {
    return instance;
  }

  @override
  bool newInstance() {
    return false;
  }

  @override
  bool protobufTreeDecode(Object? value, {ProtobufDecodingContext? context}) {
    if (value is bool) {
      return value;
    } else {
      context ??= ProtobufDecodingContext();
      throw context.newUnsupportedTypeError(value);
    }
  }

  @override
  bool protobufTreeEncode(bool instance, {ProtobufEncodingContext? context}) {
    return instance;
  }

  @override
  bool randomExample({RandomExampleContext? context}) {
    context ??= RandomExampleContext();
    return context.random.nextBool();
  }

  @override
  String toString() {
    return 'BoolKind()';
  }
}
