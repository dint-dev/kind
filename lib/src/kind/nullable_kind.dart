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

/// [Kind] for nullable values (`T?`).
///
/// ## Example
/// ```
/// import 'package:kind/kind.dart';
///
/// const Kind<String?> example = NullableKind(StringKind());
/// ```
///
/// ## Generating random values
/// You can generate random examples with the methods [randomExample()] and
/// [randomExampleList()].
///
/// By default `null` values have probably of 1/3.
/// This may be changed in future.
@sealed
class NullableKind<T> extends Kind<T?> {
  static final EntityKind<NullableKind> kind = EntityKind<NullableKind>(
    name: 'NullableKind',
    build: (c) {
      final wrappedKindProp = c.required<Kind>(
        id: 1,
        name: 'wrapped',
        kind: Kind.kind,
        getter: (t) => t.wrapped,
      );
      final probabilityProp = c.requiredFloat64(
        id: 2,
        name: 'probability',
        getter: (t) => t.probability,
      );
      c.constructorFromData = (data) => NullableKind(
            data.get(wrappedKindProp),
            probability: data.get(probabilityProp),
          );
    },
  );
  final Kind<T> wrapped;
  final double probability;

  @literal
  const NullableKind(this.wrapped, {this.probability = 0.33});

  @override
  int get hashCode => (NullableKind).hashCode ^ wrapped.hashCode;

  @override
  String get name => '${wrapped.name}?';

  @override
  int get protobufFieldType {
    final wrapped = this.wrapped;
    if (wrapped is Iterable) {
      throw UnsupportedError(
          'Nullable iterables are unsupported in Protocol Buffers');
    }
    return wrapped.protobufFieldType;
  }

  @override
  EntityKind<NullableKind> getKind() => kind;

  @override
  bool instanceIsValid(Object? value) {
    if (value == null) {
      return true;
    }
    return wrapped.instanceIsValid(value);
  }

  @override
  void instanceValidateConstraints(ValidateContext context, T? value) {
    if (value != null) {
      wrapped.instanceValidateConstraints(context, value);
    }
    super.instanceValidateConstraints(context, value);
  }

  @override
  // ignore: invalid_override_of_non_virtual_member
  void instanceValidateOrThrow(Object? value) {
    if (value != null) {
      return wrapped.instanceValidateOrThrow(value);
    }
  }

  @override
  T? jsonTreeDecode(Object? json, {JsonDecodingContext? context}) {
    if (json == null) {
      return null;
    }
    context ??= JsonDecodingContext();
    return context.decode(json, kind: wrapped);
  }

  @override
  Object? jsonTreeEncode(T? value, {JsonEncodingContext? context}) {
    if (value == null) {
      return null;
    }
    context ??= JsonEncodingContext();
    return context.encode(value, kind: wrapped);
  }

  @override
  T? newInstance() => null;

  @override
  T? protobufTreeDecode(Object? value, {ProtobufDecodingContext? context}) {
    if (value == null) {
      return null;
    }
    context ??= ProtobufDecodingContext();
    return context.decode<T>(value, kind: wrapped);
  }

  @override
  Object? protobufTreeEncode(T? value, {ProtobufEncodingContext? context}) {
    if (value == null) {
      return null;
    }
    context ??= ProtobufEncodingContext();
    return context.encode<T>(value, kind: wrapped);
  }

  @override
  T? randomExample({RandomExampleContext? context}) {
    context ??= RandomExampleContext();
    if (context.minimizeNewInstances) {
      return null;
    }
    final isNull = context.random.nextDouble() < probability;
    if (isNull) {
      return null;
    }
    return wrapped.randomExample();
  }

  @override
  Kind<T> toNonNullable() => wrapped;

  @override
  NullableKind<T?> toNullable() => this;

  @override
  String toString() {
    return 'NullableKind($wrapped)';
  }
}
