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

/// Kind for [Uuid].
class UuidKind extends PrimitiveKind<Uuid> {
  /// [Kind] for [UuidKind].
  ///
  /// The purpose of annotation `@protected` is reducing accidental use.
  @protected
  static final EntityKind<UuidKind> kind = EntityKind<UuidKind>(
    name: 'UuidKind',
    define: (c) {
      c.constructor = () => const UuidKind();
    },
  );

  @literal
  const UuidKind();

  @override
  List<Uuid> get declaredExamples => [
        Uuid('f81d4fae-7dec-11d0-a765-00a0c91e6bf6'),
      ];

  @override
  int get hashCode => (UuidKind).hashCode;

  @override
  String get name => 'Uuid';

  @override
  int get protobufFieldType {
    return const BytesKind().protobufFieldType;
  }

  @override
  bool operator ==(Object other) => other is UuidKind;

  @override
  EntityKind<UuidKind> getKind() => kind;

  @override
  Uuid jsonTreeDecode(Object? value, {JsonDecodingContext? context}) {
    if (value is! String) {
      throw ArgumentError.value(value, 'value', 'Must be string');
    }
    return Uuid(value);
  }

  @override
  Object? jsonTreeEncode(Uuid instance, {JsonEncodingContext? context}) {
    return instance.canonicalString;
  }

  @override
  Uuid newInstance() {
    return Uuid.zero;
  }

  @override
  Uuid protobufTreeDecode(Object? value, {ProtobufDecodingContext? context}) {
    final bytes = const BytesKind().protobufTreeDecode(value, context: context);
    return Uuid.fromBytes(bytes);
  }

  @override
  Object protobufTreeEncode(Uuid instance, {ProtobufEncodingContext? context}) {
    final bytes = instance.toBytes();
    return const BytesKind().protobufTreeEncode(bytes, context: context);
  }

  @override
  Uuid randomExample({RandomExampleContext? context}) {
    return Uuid.random();
  }

  @override
  String toString() {
    return 'UuidKind()';
  }
}
