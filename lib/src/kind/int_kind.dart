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

import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:fixnum/fixnum.dart' show Int64;
import 'package:kind/kind.dart';
import 'package:meta/meta.dart';
import 'package:protobuf/protobuf.dart' as protobuf;

import 'int_kind_impl_not_js.dart' if (dart.library.js) 'int_kind_impl_js.dart';

/// [Kind] for 16-bit signed integers.
///
/// ## Serialization
/// ### JSON
/// You can encode/decode JSON with [jsonEncode] and [jsonDecode].
///
/// The JSON representation is JSON number.
///
/// ### Protocol Buffers
/// Instances are encoded as variable-length 16-bit signed integers (_sint16_).
///
/// See documentation of Protocol Buffers types at
/// [Protocol Buffers website](https://developers.google.com/protocol-buffers/docs/proto3).
///
/// ## Generating random values
/// You can generate random values with the methods [randomExample()] and
/// [randomExampleList()].
///
/// If [min] and [max] are non-null, the random values will be in the range.
/// Otherwise values are in some range near zero.
///
/// This behavior may be changed in future.
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
class Int16Kind extends IntKindBase {
  /// Minimum possible value (`-(2^16)`).
  static const int minPossible = -maxPossible - 1;

  /// Maximum possible value (`2^16 - 1`).
  static const int maxPossible = 0x7FFF;

  /// [Kind] for [Int16Kind].
  ///
  /// The purpose of annotation `@protected` is reducing accidental use.
  @protected
  static final EntityKind<Int16Kind> kind = EntityKind<Int16Kind>(
    name: 'Int16Kind',
    define: (c) {
      final min = c.optionalInt32(
        id: 1,
        name: 'min',
        getter: (t) => t.min,
      );
      final max = c.optionalInt32(
        id: 2,
        name: 'max',
        getter: (t) => t.max,
      );
      c.constructorFromData = (data) => Int16Kind(
            min: data.get(min),
            max: data.get(max),
          );
    },
  );

  @literal
  const Int16Kind({
    UnitOfMeasurement? unitOfMeasurement,
    int? min,
    int? max,
  }) : super(
          unitOfMeasurement: unitOfMeasurement,
          min: min,
          max: max,
        );

  @override
  int get bitsPerListElement => 16;

  @override
  int get hashCode => (Int16Kind).hashCode ^ super.hashCode;

  @override
  String get name => '${PrimitiveKind.namePrefixForNonClasses}Int16';

  @override
  int get protobufFieldType {
    return const Int32Kind().protobufFieldType;
  }

  @override
  bool get unsigned => false;

  @override
  bool operator ==(other) => other is Int16Kind && super == other;

  @override
  EntityKind<Int16Kind> getKind() => kind;

  @override
  void instanceValidateConstraints(ValidateContext context, int value) {
    if (value < minPossible || value > maxPossible) {
      context.invalid(
        value: value,
        message: 'Not a signed 16-bit integer.',
      );
    }
    super.instanceValidateConstraints(context, value);
  }

  @override
  List<int> newList(int length, {bool growable = false, bool reactive = true}) {
    if (growable) {
      return super.newList(
        length,
        growable: growable,
        reactive: reactive,
      );
    }
    final list = Int16List(length);
    if (reactive && length != 0) {
      return ReactiveList<int>.wrap(list);
    }
    return list;
  }
}

/// [Kind] for 32-bit signed integers.
///
/// ## Serialization
/// ### JSON
/// You can encode/decode JSON with [jsonEncode] and [jsonDecode].
///
/// The JSON representation is JSON number.
///
/// ### Protocol Buffers / GRPC
/// Instances are encoded as variable-length 32-bit signed integers (_sint32_).
///
/// See documentation of Protocol Buffers types at
/// [Protocol Buffers website](https://developers.google.com/protocol-buffers/docs/proto3).
///
/// ## Generating random values
/// You can generate random values with the methods [randomExample()] and
/// [randomExampleList()].
///
/// If [min] and [max] are non-null, the random values will be in the range.
/// Otherwise values are in some range near zero.
///
/// This behavior may be changed in future.
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
class Int32Kind extends IntKindBase {
  /// Minimum possible value (`-2^32`).
  static const int minPossible = -maxPossible - 1;

  /// Maximum possible value (`-(2^32)-1`).
  static const int maxPossible = 0x7FFFFFFF;

  /// [Kind] for [Int32Kind].
  ///
  /// The purpose of annotation `@protected` is reducing accidental use.
  @protected
  static final EntityKind<Int32Kind> kind = EntityKind<Int32Kind>(
    name: 'Int32Kind',
    define: (c) {
      final min = c.optionalInt32(
        id: 1,
        name: 'min',
        getter: (t) => t.min,
      );
      final max = c.optionalInt32(
        id: 2,
        name: 'max',
        getter: (t) => t.max,
      );
      c.constructorFromData = (data) => Int32Kind(
            min: data.get(min),
            max: data.get(max),
          );
    },
  );

  @literal
  const Int32Kind({
    UnitOfMeasurement? unitOfMeasurement,
    int? min,
    int? max,
  }) : super(
          unitOfMeasurement: unitOfMeasurement,
          min: min,
          max: max,
        );

  @override
  int get bitsPerListElement => 32;

  @override
  int get hashCode => (Int32Kind).hashCode ^ super.hashCode;

  @override
  String get name => '${PrimitiveKind.namePrefixForNonClasses}Int32';

  @override
  int get protobufFieldType {
    return protobuf.PbFieldType.OS3;
  }

  @override
  bool get unsigned => false;

  @override
  bool operator ==(other) => other is Int32Kind && super == other;

  @override
  EntityKind<Int32Kind> getKind() => kind;

  @override
  void instanceValidateConstraints(ValidateContext context, int value) {
    if (value < minPossible || value > maxPossible) {
      context.invalid(
        value: value,
        message: 'Not a signed 32-bit integer.',
      );
    }
    super.instanceValidateConstraints(context, value);
  }

  @override
  List<int> newList(int length, {bool growable = false, bool reactive = true}) {
    if (growable) {
      return super.newList(
        length,
        growable: growable,
        reactive: reactive,
      );
    }
    final list = Int32List(length);
    if (reactive && length != 0) {
      return ReactiveList<int>.wrap(list);
    }
    return list;
  }
}

/// [Kind] for 64-bit signed integers.
///
/// In browsers [int] is actually [double], which means that integers with more
/// than 52 bits can't be reliably stored / handled. Use [Int64FixNumKind] if
/// you want to avoid this issue.
///
/// ## Serialization
/// ### JSON
/// You can encode/decode JSON with [jsonEncode] and [jsonDecode].
///
/// The JSON representation is JSON number. You will run into precision issues
/// if your integer has more than 52 bits.
///
/// ### Protocol Buffers / GRPC
/// Instances are encoded as variable-length 64-bit signed integers (_sint64_).
///
/// See documentation of Protocol Buffers types at
/// [Protocol Buffers website](https://developers.google.com/protocol-buffers/docs/proto3).
///
/// ## Generating random values
/// You can generate random values with the methods [randomExample()] and
/// [randomExampleList()].
///
/// If [min] and [max] are non-null, the random values will be in the range.
/// Otherwise values are in some range near zero.
///
/// This behavior may be changed in future.
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
class Int64Kind extends IntKindBase {
  /// Minimum safe value in Javascript (`-(2^53) - 1`).
  static const int minSafeInJs = -maxSafeInJs;

  /// Maximum safe value in Javascript (`2^53 - 1`).
  static const int maxSafeInJs = 0xFFFFFFFFFFFFF;

  /// [Kind] for [Int64Kind].
  ///
  /// The purpose of annotation `@protected` is reducing accidental use.
  @protected
  static final EntityKind<Int64Kind> kind = EntityKind<Int64Kind>(
    name: 'Int64Kind',
    define: (c) {
      final min = c.optionalInt64(
        id: 1,
        name: 'min',
        getter: (t) => t.min,
      );
      final max = c.optionalInt64(
        id: 2,
        name: 'max',
        getter: (t) => t.max,
      );
      final safeInJs = c.requiredBool(
        id: 3,
        name: 'safeInJs',
        getter: (t) => t.safeInJs,
      );
      c.constructorFromData = (data) => Int64Kind(
            min: data.get(min),
            max: data.get(max),
            safeInJs: data.get(safeInJs),
          );
    },
  );

  /// Whether the value must be between [minSafeInJs] and
  /// [maxSafeInJs].
  final bool safeInJs;

  @literal
  const Int64Kind({
    UnitOfMeasurement? unitOfMeasurement,
    int? min,
    int? max,
    this.safeInJs = false,
  }) : super(
          unitOfMeasurement: unitOfMeasurement,
          min: min,
          max: max,
        );

  @override
  int get bitsPerListElement => 64;

  @override
  int get hashCode => (Int64Kind).hashCode ^ super.hashCode;

  @override
  String get name => '${PrimitiveKind.namePrefixForNonClasses}Int64';

  @override
  int get protobufFieldType {
    return protobuf.PbFieldType.OS6;
  }

  @override
  bool get unsigned => false;

  @override
  bool operator ==(other) => other is Int64Kind && super == other;

  @override
  EntityKind<Int64Kind> getKind() => kind;

  @override
  void instanceValidateConstraints(ValidateContext context, int value) {
    if (safeInJs && !(value >= minSafeInJs && value <= maxSafeInJs)) {
      context.invalid(
        value: value,
        message: 'Value is outside the safe range in Javascript (52 bits)',
      );
    }
    super.instanceValidateConstraints(context, value);
  }

  @override
  List<int> newList(int length, {bool growable = false, bool reactive = true}) {
    if (growable) {
      return super.newList(
        length,
        growable: growable,
        reactive: reactive,
      );
    }
    // Use platform-dependent constructor.
    // (Javascript doesn't support Uint64List)
    final list = newInt64List(length);
    if (reactive && length != 0) {
      return ReactiveList<int>.wrap(list);
    }
    return list;
  }
}

/// [Kind] for 8-bit signed integers.
///
/// ## Serialization
/// ### JSON
/// You can encode/decode JSON with [jsonEncode] and [jsonDecode].
///
/// The JSON representation is JSON number.
///
/// ### Protocol Buffers / GRPC
/// Type _int8_ (variable-length unsigned integer) will be used.
///
/// See documentation of Protocol Buffers types at
/// [Protocol Buffers website](https://developers.google.com/protocol-buffers/docs/proto3).
///
/// ## Generating random values
/// You can generate random values with the methods [randomExample()] and
/// [randomExampleList()].
///
/// If [min] and [max] are non-null, the random values will be in the range.
/// Otherwise values are in some range near zero.
///
/// This behavior may be changed in future.
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
class Int8Kind extends IntKindBase {
  /// Minimum possible value (`-(2^8)`).
  static const int minPossible = -maxPossible - 1;

  /// Maximum possible value (`2^7 - 1`).
  static const int maxPossible = 0x7F;

  /// [Kind] for [Int8Kind].
  ///
  /// The purpose of annotation `@protected` is reducing accidental use.
  @protected
  static final EntityKind<Int8Kind> kind = EntityKind<Int8Kind>(
    name: 'Int8Kind',
    define: (c) {
      final min = c.optionalInt32(
        id: 1,
        name: 'min',
        getter: (t) => t.min,
      );
      final max = c.optionalInt32(
        id: 2,
        name: 'max',
        getter: (t) => t.max,
      );
      c.constructorFromData = (data) => Int8Kind(
            min: data.get(min),
            max: data.get(max),
          );
    },
  );

  @literal
  const Int8Kind({
    UnitOfMeasurement? unitOfMeasurement,
    int? min,
    int? max,
  }) : super(
          unitOfMeasurement: unitOfMeasurement,
          min: min,
          max: max,
        );

  @override
  int get bitsPerListElement => 8;

  @override
  int get hashCode => (Int8Kind).hashCode ^ super.hashCode;

  @override
  String get name => '${PrimitiveKind.namePrefixForNonClasses}Int8';

  @override
  int get protobufFieldType {
    return protobuf.PbFieldType.OS3;
  }

  @override
  bool get unsigned => false;

  @override
  bool operator ==(other) => other is Int8Kind && super == other;

  @override
  EntityKind<Int8Kind> getKind() => kind;

  @override
  void instanceValidateConstraints(ValidateContext context, int value) {
    if (value < minPossible || value > maxPossible) {
      context.invalid(
        value: value,
        message: 'Not an unsigned 8-bit integer.',
      );
    }
    super.instanceValidateConstraints(context, value);
  }

  @override
  List<int> newList(int length, {bool growable = false, bool reactive = true}) {
    if (growable) {
      return super.newList(
        length,
        growable: growable,
        reactive: reactive,
      );
    }
    final list = Int8List(length);
    if (reactive && length != 0) {
      return ReactiveList<int>.wrap(list);
    }
    return list;
  }
}

/// Abstract base class for integer kinds.
///
/// ## Serialization
/// ### JSON
/// You can encode/decode JSON with [jsonEncode] and [jsonDecode].
///
/// The JSON representation is JSON number.
///
/// ### Protocol Buffers / GRPC
/// See subclass documentation.
///
/// ## Generating random values
/// You can generate random values with the methods [randomExample()] and
/// [randomExampleList()].
///
/// If [min] and [max] are non-null, the random values will be in the range.
/// Otherwise values are in some range near zero.
///
/// This behavior may be changed in future.
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
abstract class IntKindBase extends NumericKind<int> {
  @literal
  const IntKindBase({
    required UnitOfMeasurement? unitOfMeasurement,
    required int? min,
    required int? max,
  }) : super(
          unitOfMeasurement: unitOfMeasurement,
          min: min,
          max: max,
        );

  @mustCallSuper
  @override
  int get hashCode => min.hashCode ^ max.hashCode;

  /// Whether the kind is unsigned ([Uint32Kind], etc.).
  bool get unsigned;

  @mustCallSuper
  @override
  bool operator ==(other) =>
      other is IntKindBase && min == other.min && max == other.max;

  @override
  void instanceValidateConstraints(ValidateContext context, int value) {
    final min = this.min;
    if (min != null && value < min) {
      context.invalid(value: value);
    }
    final max = this.max;
    if (max != null && value > max) {
      context.invalid(value: value);
    }
    super.instanceValidateConstraints(context, value);
  }

  @override
  int jsonTreeDecode(Object? value, {JsonDecodingContext? context}) {
    if (value is num) {
      return value.toInt();
    } else {
      context ??= JsonDecodingContext();
      throw context.newGraphNodeError(
        value: json,
        reason: 'Expected JSON number.',
      );
    }
  }

  @override
  Object? jsonTreeEncode(int instance, {JsonEncodingContext? context}) {
    return instance.toDouble();
  }

  @override
  int newInstance() {
    return 0;
  }

  @override
  int protobufTreeDecode(Object? value, {ProtobufDecodingContext? context}) {
    if (value is int) {
      return value;
    } else if (value is Int64) {
      return value.toInt();
    } else {
      context ??= ProtobufDecodingContext();
      throw context.newUnsupportedTypeError(value);
    }
  }

  @override
  int protobufTreeEncode(int instance, {ProtobufEncodingContext? context}) {
    return instance;
  }

  @override
  int randomExample({RandomExampleContext? context}) {
    var min = this.min ?? -100;
    var max = this.max ?? (math.max(0, min) + 100);
    if (min > max) {
      return super.randomExample(context: context);
    }
    if (min == max) {
      return min;
    }
    context ??= RandomExampleContext();
    return min + context.random.nextInt(max + 1 - min);
  }

  @override
  String toString() {
    final arguments = <String>[];
    if (min != null) {
      arguments.add('min: $min');
    }
    if (max != null) {
      arguments.add('max: $max');
    }
    final joinedArguments = arguments.join(', ');
    if (unsigned) {
      return 'Uint${bitsPerListElement}Kind($joinedArguments)';
    }
    return 'Int${bitsPerListElement}Kind($joinedArguments)';
  }
}

/// [Kind] for 16-bit unsigned integers.
///
/// ## Serialization
/// ### JSON
/// You can encode/decode JSON with [jsonEncode] and [jsonDecode].
///
/// The JSON representation is JSON number.
///
/// ### Protocol Buffers / GRPC
/// Instances are encoded as variable-length 16-bit unsigned integers (_int16_).
///
/// See documentation of Protocol Buffers types at
/// [Protocol Buffers website](https://developers.google.com/protocol-buffers/docs/proto3).
///
/// ## Generating random values
/// You can generate random values with the methods [randomExample()] and
/// [randomExampleList()].
///
/// If [min] and [max] are non-null, the random values will be in the range.
/// Otherwise values are in some range near zero.
///
/// This behavior may be changed in future.
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
class Uint16Kind extends IntKindBase {
  /// Maximum possible value (`2^17 - 1`).
  static const int maxPossible = 0xFFFF;

  /// [Kind] for [Int16Kind].
  ///
  /// The purpose of annotation `@protected` is reducing accidental use.
  @protected
  static final EntityKind<Uint16Kind> kind = EntityKind<Uint16Kind>(
    name: 'Uint16Kind',
    define: (c) {
      final min = c.optionalUint32(
        id: 1,
        name: 'min',
        getter: (t) => t.min,
      );
      final max = c.optionalUint32(
        id: 2,
        name: 'max',
        getter: (t) => t.max,
      );
      c.constructorFromData = (data) => Uint16Kind(
            min: data.get(min),
            max: data.get(max),
          );
    },
  );

  @literal
  const Uint16Kind({
    UnitOfMeasurement? unitOfMeasurement,
    int? min,
    int? max,
  }) : super(
          unitOfMeasurement: unitOfMeasurement,
          min: min,
          max: max,
        );

  @override
  int get bitsPerListElement => 16;

  @override
  int get hashCode => (Uint16Kind).hashCode ^ super.hashCode;

  @override
  String get name => '${PrimitiveKind.namePrefixForNonClasses}Uint16';

  @override
  int get protobufFieldType {
    return const Uint32Kind().protobufFieldType;
  }

  @override
  bool get unsigned => true;

  @override
  bool operator ==(other) => other is Uint16Kind && super == other;

  @override
  EntityKind<Uint16Kind> getKind() => kind;

  @override
  void instanceValidateConstraints(ValidateContext context, int value) {
    if (value < 0 || value > maxPossible) {
      context.invalid(
        value: value,
        message: 'Not an unsigned 32-bit integer.',
      );
    }
    super.instanceValidateConstraints(context, value);
  }

  @override
  List<int> newList(int length, {bool growable = false, bool reactive = true}) {
    if (growable) {
      return super.newList(
        length,
        growable: growable,
        reactive: reactive,
      );
    }
    final list = Uint16List(length);
    if (reactive && length != 0) {
      return ReactiveList<int>.wrap(list);
    }
    return list;
  }
}

/// [Kind] for 32-bit unsigned integers.
///
/// ## Serialization
/// ### JSON
/// You can encode/decode JSON with [jsonEncode(object)] and [jsonDecode(source)].
///
/// The JSON representation is JSON number.
///
/// ### Protocol Buffers / GRPC
/// Instances are encoded as variable-length 32-bit unsigned integers (_int32_).
///
/// See documentation of Protocol Buffers types at
/// [Protocol Buffers website](https://developers.google.com/protocol-buffers/docs/proto3).
///
/// ## Generating random values
/// You can generate random values with the methods [randomExample()] and
/// [randomExampleList()].
///
/// If [min] and [max] are non-null, the random values will be in the range.
/// Otherwise values are in some range near zero.
///
/// This behavior may be changed in future.
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
class Uint32Kind extends IntKindBase {
  /// Maximum possible value (`2^33-1`).
  static const int maxPossible = 0xFFFFFFFF;

  /// [Kind] for [Uint32Kind].
  ///
  /// The purpose of annotation `@protected` is reducing accidental use.
  @protected
  static final EntityKind<Uint32Kind> kind = EntityKind<Uint32Kind>(
    name: 'Uint32Kind',
    define: (c) {
      final min = c.optionalUint32(
        id: 1,
        name: 'min',
        getter: (t) => t.min,
      );
      final max = c.optionalUint32(
        id: 2,
        name: 'max',
        getter: (t) => t.max,
      );
      c.constructorFromData = (data) => Uint32Kind(
            min: data.get(min),
            max: data.get(max),
          );
    },
  );

  @literal
  const Uint32Kind({
    UnitOfMeasurement? unitOfMeasurement,
    int? min,
    int? max,
  }) : super(
          unitOfMeasurement: unitOfMeasurement,
          min: min,
          max: max,
        );

  @override
  int get bitsPerListElement => 32;

  @override
  int get hashCode => (Uint32Kind).hashCode ^ super.hashCode;

  @override
  String get name => '${PrimitiveKind.namePrefixForNonClasses}Uint32';

  @override
  int get protobufFieldType {
    return protobuf.PbFieldType.O3;
  }

  @override
  bool get unsigned => true;

  @override
  bool operator ==(other) => other is Uint32Kind && super == other;

  @override
  EntityKind<Uint32Kind> getKind() => kind;

  @override
  void instanceValidateConstraints(ValidateContext context, int value) {
    if (value < 0 || value > maxPossible) {
      context.invalid(
        value: value,
        message: 'Not an unsigned 32-bit integer.',
      );
    }
    super.instanceValidateConstraints(context, value);
  }

  @override
  List<int> newList(int length, {bool growable = false, bool reactive = true}) {
    if (growable) {
      return super.newList(
        length,
        growable: growable,
        reactive: reactive,
      );
    }
    final list = Uint32List(length);
    if (reactive && length != 0) {
      return ReactiveList<int>.wrap(list);
    }
    return list;
  }
}

/// [Kind] for 64-bit unsigned integers.
///
/// In browsers [int] is actually [double], which means that integers with more
/// than 52 bits can't be reliably stored / handled. Use [Int64FixNumKind] if
/// you want to avoid this issue.
///
/// ## Serialization
/// ### JSON
/// You can encode/decode JSON with [jsonEncode] and [jsonDecode].
///
/// The JSON representation is JSON number. You will run into precision issues
/// if your integer has more than 52 bits.
///
/// ### Protocol Buffers
/// Instances are encoded as variable-length 64-bit unsigned integers (_int64_).
///
/// See documentation of Protocol Buffers types at
/// [Protocol Buffers website](https://developers.google.com/protocol-buffers/docs/proto3).
///
/// ## Generating random values
/// You can generate random values with the methods [randomExample()] and
/// [randomExampleList()].
///
/// If [min] and [max] are non-null, the random values will be in the range.
/// Otherwise values are in some range near zero.
///
/// This behavior may be changed in future.
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
class Uint64Kind extends IntKindBase {
  /// Maximum safe value in Javascript (`2^53 - 1`).
  static const int maxSafeInJs = Int64Kind.maxSafeInJs;

  /// [Kind] for [Uint64Kind].
  ///
  /// The purpose of annotation `@protected` is reducing accidental use.
  @protected
  static final EntityKind<Uint64Kind> kind = EntityKind<Uint64Kind>(
    name: 'Uint64Kind',
    define: (c) {
      final min = c.optionalUint64(
        id: 1,
        name: 'min',
        getter: (t) => t.min,
      );
      final max = c.optionalUint64(
        id: 2,
        name: 'max',
        getter: (t) => t.max,
      );
      final safeInJs = c.requiredBool(
        id: 3,
        name: 'safeInJs',
        getter: (t) => t.safeInJs,
      );
      c.constructorFromData = (data) => Uint64Kind(
            min: data.get(min),
            max: data.get(max),
            safeInJs: data.get(safeInJs),
          );
    },
  );

  /// Whether the value must be between 0 and [maxSafeInJs].
  final bool safeInJs;

  @literal
  const Uint64Kind({
    UnitOfMeasurement? unitOfMeasurement,
    int? min,
    int? max,
    this.safeInJs = false,
  }) : super(
          unitOfMeasurement: unitOfMeasurement,
          min: min,
          max: max,
        );

  @override
  int get bitsPerListElement => 64;

  @override
  int get hashCode => (Uint64Kind).hashCode ^ super.hashCode;

  @override
  String get name => '${PrimitiveKind.namePrefixForNonClasses}Uint64';

  @override
  int get protobufFieldType {
    return protobuf.PbFieldType.O6;
  }

  @override
  bool get unsigned => true;

  @override
  bool operator ==(other) => other is Uint64Kind && super == other;

  @override
  EntityKind<Uint64Kind> getKind() => kind;

  @override
  void instanceValidateConstraints(ValidateContext context, int value) {
    if (value < 0 && !safeInJs) {
      final min = this.min;
      final max = this.max;
      if ((min == null || min < 0) && (max != null && max <= maxSafeInJs)) {
        context.invalid(
          value: value,
          message: 'Not an unsigned 64-bit integer.',
        );
        super.instanceValidateConstraints(context, value);
        return;
      }
    }
    if (safeInJs && !(value >= 0 && value <= maxSafeInJs)) {
      context.invalid(
        value: value,
        message: 'Value is outside the safe range in Javascript (52 bits)',
      );
    }
    super.instanceValidateConstraints(context, value);
  }

  @override
  List<int> newList(int length, {bool growable = false, bool reactive = true}) {
    if (growable) {
      return super.newList(
        length,
        growable: growable,
        reactive: reactive,
      );
    }
    // Use platform-dependent constructor.
    // (Javascript doesn't support Uint64List)
    final list = newUint64List(length);
    if (reactive && length != 0) {
      return ReactiveList<int>.wrap(list);
    }
    return list;
  }
}

/// [Kind] for 8-bit unsigned integers.
///
/// ## Serialization
/// ### JSON
/// You can encode/decode JSON with [jsonEncode] and [jsonDecode].
///
/// The JSON representation is JSON number.
///
/// ### Protocol Buffers / GRPC
/// Instances are encoded as variable-length 8-bit unsigned integers (_int8_).
///
/// See documentation of Protocol Buffers types at
/// [Protocol Buffers website](https://developers.google.com/protocol-buffers/docs/proto3).
///
/// ## Generating random values
/// You can generate random values with the methods [randomExample()] and
/// [randomExampleList()].
///
/// If [min] and [max] are non-null, the random values will be in the range.
/// Otherwise values are in some range near zero.
///
/// This behavior may be changed in future.
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
class Uint8Kind extends IntKindBase {
  /// Maximum possible value (`2^9 - 1`).
  static const int maxPossible = 0xFF;

  /// [Kind] for [Uint8Kind].
  ///
  /// The purpose of annotation `@protected` is reducing accidental use.
  @protected
  static final EntityKind<Uint8Kind> kind = EntityKind<Uint8Kind>(
    name: 'Uint8Kind',
    define: (c) {
      final min = c.optionalUint32(
        id: 1,
        name: 'min',
        getter: (t) => t.min,
      );
      final max = c.optionalUint32(
        id: 2,
        name: 'max',
        getter: (t) => t.max,
      );
      c.constructorFromData = (data) => Uint8Kind(
            min: data.get(min),
            max: data.get(max),
          );
    },
  );

  @literal
  const Uint8Kind({
    UnitOfMeasurement? unitOfMeasurement,
    int? min,
    int? max,
  }) : super(
          unitOfMeasurement: unitOfMeasurement,
          min: min,
          max: max,
        );

  @override
  int get bitsPerListElement => 8;

  @override
  int get hashCode => (Uint16Kind).hashCode ^ super.hashCode;

  @override
  String get name => '${PrimitiveKind.namePrefixForNonClasses}Uint8';

  @override
  int get protobufFieldType {
    return protobuf.PbFieldType.O3;
  }

  @override
  bool get unsigned => true;

  @override
  bool operator ==(other) => other is Uint8Kind && super == other;

  @override
  EntityKind<Uint8Kind> getKind() => kind;

  @override
  void instanceValidateConstraints(ValidateContext context, int value) {
    if (value < 0 || value > maxPossible) {
      context.invalid(
        value: value,
        message: 'Not an unsigned 8-bit integer.',
      );
    }
    super.instanceValidateConstraints(context, value);
  }

  @override
  List<int> newList(int length, {bool growable = false, bool reactive = true}) {
    if (growable) {
      return super.newList(
        length,
        growable: growable,
        reactive: reactive,
      );
    }
    final list = Uint8List(length);
    if (reactive && length != 0) {
      return ReactiveList<int>.wrap(list);
    }
    return list;
  }
}
