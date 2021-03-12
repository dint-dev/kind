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
///   * [buildPrimitiveKind]
///   * [name]
///   * [instanceFromPrimitive]
///   * [instanceToPrimitive]
///
/// # Example: a simple case
/// ```
/// import 'package:kind/kind.dart';
///
/// // Weight.
/// class Weight {
///   static final Kind<Weight> kind = CompositePrimitiveKind.simple<Weight, double>(
///     name: 'Weight',
///     primitiveKind: const Float64Kind(min: 0.0),
///     toPrimitive: (weight) => arg.inKilograms,
///     fromPrimitive: (string) => Weight(string),
///   );
///
///   // Weight in kilograms.
///   final double inKilograms;
///
///   const Weight(this.inKilograms);
///
///   // ...
/// }
/// ```
///
/// ## Example: extending class
/// ```
/// import 'package:kind/kind.dart';
///
/// class PhoneNumber {
///   final String value;
///   PhoneNumber(this.value);
/// }
///
/// class PhoneNumberKind extends CompositeKind<PhoneNumber, String> {
///   final int maxLength;
///   PhoneNumberKind({this.maxLength=64});
///
///   @override
///   String get name => 'PhoneNumber';
///
///   @override
///   StringKind buildKind() {
///     return const StringKind(
///       maxLength: maxLength,
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

  CompositePrimitiveKind();

  /// A convenience mehtod for constructing simple kinds.
  ///
  /// # Example
  /// ```
  /// import 'package:kind/kind.dart';
  ///
  /// // Weight.
  /// class Weight {
  ///   static final Kind<Weight> kind = CompositePrimitiveKind.simple<Weight, double>(
  ///     name: 'Weight',
  ///     primitiveKind: const Float64Kind(min: 0.0),
  ///     toPrimitive: (weight) => arg.inKilograms,
  ///     fromPrimitive: (string) => Weight(string),
  ///   );
  ///
  ///   // Weight in kilograms.
  ///   final double inKilograms;
  ///
  ///   const Weight(this.inKilograms);
  ///
  ///   // ...
  /// }
  /// ```
  factory CompositePrimitiveKind.simple({
    required String name,
    required PrimitiveKind<E> primitiveKind,
    required T Function(E primitive) fromPrimitive,
    required E Function(T instance) toPrimitive,
  }) {
    late _SimpleCompositePrimitiveKind<T, E> returnedKind;
    returnedKind = _SimpleCompositePrimitiveKind<T, E>(
      name: name,
      primitiveKindArgument: primitiveKind,
      toPrimitive: toPrimitive,
      fromPrimitive: fromPrimitive,
      kind: EntityKind<_SimpleCompositePrimitiveKind>(
        name: '_${name}Kind',
        define: (c) {
          c.constructor = () => returnedKind;
        },
      ),
    );
    return returnedKind;
  }

  /// Name of the kind (for debugging purposes).
  ///
  /// Subclasses also need to implement:
  ///   * [buildPrimitiveKind]
  ///   * [instanceFromPrimitive]
  ///   * [instanceToPrimitive]
  @override
  String get name;

  /// Returns [PrimitiveKind] that will be used for serialization and
  /// persistence.
  ///
  /// The value is constructed with [buildPrimitiveKind] when this field is first
  /// used.
  @nonVirtual
  PrimitiveKind<E> get primitiveKind => _composedKind ??= buildPrimitiveKind();

  @override
  int get protobufFieldType {
    return primitiveKind.protobufFieldType;
  }

  /// Builds [PrimitiveKind] that will be used for serialization and
  /// persistence.
  ///
  /// Subclasses also need to implement:
  ///   * [name]
  ///   * [instanceFromPrimitive]
  ///   * [instanceToPrimitive]
  @protected
  PrimitiveKind<E> buildPrimitiveKind();

  /// Maps an instance of this kind to an instance of the base type.
  ///
  /// Subclasses also need to implement:
  ///   * [buildPrimitiveKind]
  ///   * [name]
  ///   * [instanceToPrimitive]
  @protected
  T instanceFromPrimitive(E value);

  /// Maps an instance of the [primitiveKind] to an instance of this kind.
  ///
  /// Subclasses also need to implement:
  ///   * [buildPrimitiveKind]
  ///   * [name]
  ///   * [instanceFromPrimitive]
  @protected
  E instanceToPrimitive(T value);

  /// Calls [instanceToPrimitive] and validates the mapped value with
  /// [primitiveKind].
  ///
  /// Mapping may be expensive so you may want to override the default
  /// implementation.
  @override
  void instanceValidateConstraints(ValidateContext context, T value) {
    primitiveKind.instanceValidateConstraints(
        context, instanceToPrimitive(value));
    super.instanceValidateConstraints(context, value);
  }

  @override
  T jsonTreeDecode(Object? json, {JsonDecodingContext? context}) {
    return instanceFromPrimitive(primitiveKind.jsonTreeDecode(
      json,
      context: context,
    ));
  }

  @override
  Object? jsonTreeEncode(T instance, {JsonEncodingContext? context}) {
    return primitiveKind.jsonTreeEncode(
      instanceToPrimitive(instance),
      context: context,
    );
  }

  @override
  T newInstance() {
    return instanceFromPrimitive(primitiveKind.newInstance());
  }

  @override
  T protobufTreeDecode(Object? protobufValue,
      {ProtobufDecodingContext? context}) {
    return instanceFromPrimitive(primitiveKind.protobufTreeDecode(
      protobufValue,
      context: context,
    ));
  }

  @override
  Object protobufTreeEncode(T instance, {ProtobufEncodingContext? context}) {
    return primitiveKind.protobufTreeEncode(
      instanceToPrimitive(instance),
      context: context,
    );
  }
}

/// Used by [CompositePrimitiveKind.simple].
class _SimpleCompositePrimitiveKind<T, E> extends CompositePrimitiveKind<T, E> {
  final PrimitiveKind<E> primitiveKindArgument;
  final EntityKind<_SimpleCompositePrimitiveKind> kind;
  final E Function(T instance) toPrimitive;
  final T Function(E primitive) fromPrimitive;

  @override
  final String name;

  _SimpleCompositePrimitiveKind({
    required this.name,
    required this.primitiveKindArgument,
    required this.kind,
    required this.toPrimitive,
    required this.fromPrimitive,
  });

  @override
  PrimitiveKind<E> buildPrimitiveKind() => primitiveKindArgument;

  @override
  EntityKind<_SimpleCompositePrimitiveKind> getKind() => kind;

  @override
  T instanceFromPrimitive(E primitive) {
    return fromPrimitive(primitive);
  }

  @override
  E instanceToPrimitive(T instance) {
    return toPrimitive(instance);
  }
}
