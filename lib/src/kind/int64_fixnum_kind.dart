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

import 'dart:math' as math;

import 'package:fixnum/fixnum.dart' show Int64;
import 'package:kind/kind.dart';
import 'package:meta/meta.dart';
import 'package:protobuf/protobuf.dart' as protobuf;

/// [Kind] for [Int64] ([package:fixnum](https://pub.dev/packages/fixnum)),
/// which is a browser-compatible 64-bit signed integer.
///
/// ## Dangerous parameters
/// Do not change values of the following fields in existing code:
///   * [unsigned]
///   * [fixed]
///
/// This is because changes in these fields affect Protocol Buffers
/// serialization in backwards-incompatible ways.
///
/// ## Serialization
/// ### JSON
/// In JSON, base-10 strings ("123") will be used.
///
/// ### Protocol Buffers
///   * If [fixed] is `false` (default):
///     * If [unsigned] is `false` (default), _sint64_
///       (signed variable-length integer) will be used.
///     * If [unsigned] is `true`, _int64_
///       (unsigned variable-length integer) will be used.
///   * If [fixed] is `true`:
///     * If [unsigned] is `false` (default), _sfixed64_
///       (signed fixed-length 64-bit integer) will be used.
///     * If [unsigned] is `true`, _fixed64_
///       (unsigned fixed-length 64-bit integer) will be used.
///
/// See documentation of Protocol Buffers types at
/// [Protocol Buffers website](https://developers.google.com/protocol-buffers/docs/proto3).
///
/// ## All available integer kinds
///   * Signed integers
///     * [Int8Kind]
///     * [Int16Kind]
///     * [Int32Kind]
///     * [Int64Kind]
///   * Unsigned integers
///     * [Uint8Kind]
///     * [Uint16Kind]
///     * [Uint32Kind]
///     * [Uint64Kind]
///   * Cross-platform 64-bit integers
///     * [Int64FixNumKind]
@sealed
class Int64FixNumKind extends NumericKind<Int64> {
  /// [Kind] for [Int64FixNumKind].
  ///
  /// The purpose of annotation `@protected` is reducing accidental use.
  @protected
  static final EntityKind<Int64FixNumKind> kind = EntityKind<Int64FixNumKind>(
    name: 'Int64FixNumKind',
    build: (c) {
      final minProp = c.optionalInt64FixNum(
        id: 1,
        name: 'min',
        getter: (t) => t.min,
      );
      final maxProp = c.optionalInt64FixNum(
        id: 2,
        name: 'max',
        getter: (t) => t.max,
      );
      final unsigned = c.requiredBool(
        id: 3,
        name: 'unsigned',
        getter: (t) => t.unsigned,
      );
      final fixed = c.requiredBool(
        id: 4,
        name: 'fixed',
        getter: (t) => t.fixed,
      );
      c.constructorFromData = (data) => Int64FixNumKind(
            min: data.get(minProp),
            max: data.get(maxProp),
            unsigned: data.get(unsigned),
            fixed: data.get(fixed),
          );
    },
  );

  @override
  final Int64? min;

  @override
  final Int64? max;

  /// Whether to use unsigned values in Protocol Buffers.
  ///
  /// Note that negative values are allowed even when [unsigned] is `true`.
  /// If you want to disallow negative values, specify [min].
  final bool unsigned;

  /// Whether to use fixed-length values in Protocol Buffers.
  final bool fixed;

  /// See [Int64FixNumKind] class documentation.
  @literal
  const Int64FixNumKind({
    Int64? min,
    this.max,
    this.unsigned = false,
    this.fixed = false,
  }) : min = min ?? (unsigned ? Int64.ZERO : null);

  @override
  int get hashCode =>
      (Int64FixNumKind).hashCode ^
      min.hashCode ^
      max.hashCode ^
      (fixed.hashCode << 1) ^
      unsigned.hashCode;

  @override
  String get name => 'Int64FixNum';

  @override
  int get protobufFieldType {
    if (fixed) {
      if (unsigned) {
        return protobuf.PbFieldType.Q6;
      }
      return protobuf.PbFieldType.QS6;
    } else {
      if (unsigned) {
        return protobuf.PbFieldType.O6;
      }
      return protobuf.PbFieldType.OS6;
    }
  }

  @override
  bool operator ==(other) =>
      other is Int64FixNumKind &&
      min == other.min &&
      max == other.max &&
      fixed == other.fixed &&
      unsigned == other.unsigned;

  @override
  void instanceValidateConstraints(ValidateContext context, Int64 value) {
    final min = this.min;
    if (min != null && value < min) {
      context.invalid(
          value: value, message: 'Value must be greater than or equal to $min');
    }
    final max = this.max;
    if (max != null && value > max) {
      context.invalid(
          value: value, message: 'Value must be less than or equal to $max');
    }
    super.instanceValidateConstraints(context, value);
  }

  @override
  EntityKind<Int64FixNumKind> getKind() => kind;

  @override
  Int64 jsonTreeDecode(Object? value, {JsonDecodingContext? context}) {
    if (value is String) {
      try {
        return Int64.parseInt(value);
      } on FormatException {
        context ??= JsonDecodingContext();
        throw context.newGraphNodeError(
          value: value,
          reason: 'The string does not contain a 64-bit integer.',
        );
      }
    } else {
      context ??= JsonDecodingContext();
      throw context.newGraphNodeError(
        value: value,
        reason: 'Expected JSON string.',
      );
    }
  }

  @override
  Object? jsonTreeEncode(Int64 value, {JsonEncodingContext? context}) {
    return value.toString();
  }

  @override
  Int64 newInstance() => Int64.ZERO;

  @override
  Int64 protobufTreeDecode(Object? value, {ProtobufDecodingContext? context}) {
    if (value is Int64) {
      return value;
    } else {
      context ??= ProtobufDecodingContext();
      throw context.newUnsupportedTypeError(value);
    }
  }

  @override
  Object? protobufTreeEncode(Int64 value, {ProtobufEncodingContext? context}) {
    return value;
  }

  @override
  Int64 randomExample({RandomExampleContext? context}) {
    var min = this.min?.toInt() ?? -100;
    var max = this.max?.toInt() ?? (math.max(0, min) + 100);
    if (min > max) {
      return super.randomExample(context: context);
    }
    if (min == max) {
      return Int64(min);
    }
    context ??= RandomExampleContext();
    return Int64(min + context.random.nextInt(max + 1 - min));
  }

  @override
  String toString() {
    final arguments = <String>[];
    if (fixed) {
      arguments.add('fixed: true');
    }
    if (unsigned) {
      arguments.add('unsigned: true');
    }
    if (min != null) {
      arguments.add('min: $min');
    }
    if (max != null) {
      arguments.add('max: $max');
    }
    return 'Int64FixNumKind(${arguments.join(', ')})';
  }
}
