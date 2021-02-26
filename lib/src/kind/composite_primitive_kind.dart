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

/// Superclass for kinds that delegate operations to another [Kind].
///
/// Subclasses need to implement:
///   * [compose]
///   * [name]
///   * [instanceFromComposed]
///   * [instanceToComposed]
///
/// ## Example
/// ```
/// import 'package:kind/kind.dart';
///
/// class PhoneNumber {
///   final String value;
///   PhoneNumber(this.value);
/// }
///
/// class PhoneNumberKind extends CompositeKind<PhoneNumber, String> {
///   @override
///   String get name => 'PhoneNumber';
///
///   @override
///   StringKind buildKind() {
///     return const StringKind(
///       maxLength: 64,
///     );
///   }
///
///   @override
///   PhoneNumber valueFromBuiltKind(String value) {
///     return PhoneNumber(value);
///   }
///
///   @override
///   String valueToBuiltKind(PhoneNumber phoneNumber) {
///     return phoneNumber.value;
///   }
/// }
/// ```
abstract class CompositePrimitiveKind<T, E> extends PrimitiveKind<T> {
  PrimitiveKind<E>? _composedKind;

  /// Returns [PrimitiveKind] that will be used for serialization and
  /// persistence.
  ///
  /// The value is constructed with [compose] when this field is first
  /// used.
  @nonVirtual
  PrimitiveKind<E> get composedKind => _composedKind ??= compose();

  /// Name of the kind (for debugging purposes).
  ///
  /// Subclasses also need to implement:
  ///   * [compose]
  ///   * [instanceFromComposed]
  ///   * [instanceToComposed]
  @override
  String get name;

  @override
  int get protobufFieldType {
    return composedKind.protobufFieldType;
  }

  /// Builds [PrimitiveKind] that will be used for serialization and
  /// persistence.
  ///
  /// Subclasses also need to implement:
  ///   * [name]
  ///   * [instanceFromComposed]
  ///   * [instanceToComposed]
  @protected
  PrimitiveKind<E> compose();

  /// Maps an instance of this kind to an instance of the base type.
  ///
  /// Subclasses also need to implement:
  ///   * [compose]
  ///   * [name]
  ///   * [instanceToComposed]
  @protected
  T instanceFromComposed(E value);

  /// Maps an instance of the [composedKind] to an instance of this kind.
  ///
  /// Subclasses also need to implement:
  ///   * [compose]
  ///   * [name]
  ///   * [instanceFromComposed]
  @protected
  E instanceToComposed(T value);

  /// Calls [instanceToComposed] and validates the mapped value with
  /// [composedKind].
  ///
  /// Mapping may be expensive so you may want to override the default
  /// implementation.
  @override
  void instanceValidateConstraints(ValidateContext context, T value) {
    composedKind.instanceValidateConstraints(
        context, instanceToComposed(value));
    super.instanceValidateConstraints(context, value);
  }

  @override
  T jsonTreeDecode(Object? json, {JsonDecodingContext? context}) {
    return instanceFromComposed(composedKind.jsonTreeDecode(
      json,
      context: context,
    ));
  }

  @override
  Object? jsonTreeEncode(T instance, {JsonEncodingContext? context}) {
    return composedKind.jsonTreeEncode(
      instanceToComposed(instance),
      context: context,
    );
  }

  @override
  T newInstance() {
    return instanceFromComposed(composedKind.newInstance());
  }

  @override
  T protobufTreeDecode(Object? protobufValue,
      {ProtobufDecodingContext? context}) {
    return instanceFromComposed(composedKind.protobufTreeDecode(
      protobufValue,
      context: context,
    ));
  }

  @override
  Object? protobufTreeEncode(T instance, {ProtobufEncodingContext? context}) {
    return composedKind.protobufTreeEncode(
      instanceToComposed(instance),
      context: context,
    );
  }
}
