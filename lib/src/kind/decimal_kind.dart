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

/// [Kind] for [Decimal].
///
/// # JSON and Protocol Buffers serialization
/// Decimal is serialized as string.
class DecimalKind extends NumericKind<Decimal> {
  @protected
  static final EntityKind<DecimalKind> kind = EntityKind<DecimalKind>(
    name: 'DecimalKind',
    define: (c) {
      final min = c.optional<Decimal>(
        id: 1,
        name: 'min',
        kind: const DecimalKind(),
        getter: (t) => t.min,
      );
      final max = c.optional<Decimal>(
        id: 2,
        name: 'max',
        kind: const DecimalKind(),
        getter: (t) => t.max,
      );
      final exclusiveMin = c.requiredBool(
        id: 3,
        name: 'exclusiveMin',
        getter: (t) => t.exclusiveMin,
      );
      final exclusiveMax = c.requiredBool(
        id: 4,
        name: 'exclusiveMax',
        getter: (t) => t.exclusiveMax,
      );
      final fractionDigits = c.optionalUint32(
        id: 5,
        name: 'fractionDigits',
        getter: (t) => t.fractionDigits,
      );
      final unitOfMeasurement = c.optional<UnitOfMeasurement>(
        id: 6,
        name: 'unitOfMeasurement',
        kind: UnitOfMeasurement.kind,
        getter: (t) => t.unitOfMeasurement,
      );
      c.constructorFromData = (data) {
        return DecimalKind(
          min: data.get(min),
          max: data.get(max),
          exclusiveMin: data.get(exclusiveMin),
          exclusiveMax: data.get(exclusiveMax),
          fractionDigits: data.get(fractionDigits),
          unitOfMeasurement: data.get(unitOfMeasurement),
        );
      };
    },
  );

  final int? fractionDigits;
  final bool exclusiveMin;
  final bool exclusiveMax;

  @literal
  const DecimalKind({
    UnitOfMeasurement? unitOfMeasurement,
    Decimal? min,
    Decimal? max,
    this.exclusiveMin = false,
    this.exclusiveMax = false,
    this.fractionDigits,
  }) : super(
          unitOfMeasurement: unitOfMeasurement,
          min: min,
          max: max,
        );

  @override
  String get name => 'Decimal';

  @override
  int get protobufFieldType => const StringKind().protobufFieldType;

  @override
  EntityKind<Object> getKind() {
    return kind;
  }

  @override
  Decimal jsonTreeDecode(Object? json, {JsonDecodingContext? context}) {
    final string = const StringKind().jsonTreeDecode(
      json,
      context: context,
    );
    return Decimal(string);
  }

  @override
  Object? jsonTreeEncode(Decimal instance, {JsonEncodingContext? context}) {
    return instance.toString();
  }

  @override
  Decimal newInstance() {
    return Decimal.zero;
  }

  @override
  Decimal protobufTreeDecode(Object? value,
      {ProtobufDecodingContext? context}) {
    final string = const StringKind().protobufTreeDecode(
      value,
      context: context,
    );
    return Decimal(string);
  }

  @override
  Object protobufTreeEncode(Decimal instance,
      {ProtobufEncodingContext? context}) {
    return instance.toString();
  }

  @override
  Decimal randomExample({RandomExampleContext? context}) {
    final doubleValue = const Float64Kind().randomExample(
      context: context,
    );
    return Decimal.fromDouble(
      doubleValue,
      fractionDigits: fractionDigits ?? 9,
    );
  }
}
