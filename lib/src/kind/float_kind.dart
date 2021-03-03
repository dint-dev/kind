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
import 'dart:typed_data';

import 'package:kind/kind.dart';
import 'package:meta/meta.dart';
import 'package:protobuf/protobuf.dart' as protobuf;

/// [Kind] for 32-bit floating-point values ([double] in Dart).
///
/// ## Generating random values
/// You can generate random examples with the methods [randomExample()] and
/// [randomExampleList()].
///
/// If [min] and [max] are non-null, the random examples will be in the range.
/// Otherwise values are in some range near zero.
///
/// This behavior may be changed in future.
///
/// ## All available floating-point kinds
///   * [Float32Kind]
///   * [Float64Kind]
class Float32Kind extends FloatKindBase {
  static final Float32List _float32list = Float32List(1);

  /// [Kind] for [Float32Kind].
  ///
  /// The purpose of annotation `@protected` is reducing accidental use.
  static final EntityKind<Float32Kind> kind = EntityKind<Float32Kind>(
    name: 'Float32Kind',
    build: (c) {
      final specialValues = c.requiredBool(
        id: 1,
        name: 'specialValues',
        getter: (t) => t.specialValues,
      );
      final min = c.optionalFloat32(
        id: 2,
        name: 'min',
        getter: (t) => t.min,
      );
      final max = c.optionalFloat32(
        id: 3,
        name: 'max',
        getter: (t) => t.max,
      );
      final exclusiveMin = c.requiredBool(
        id: 4,
        name: 'exclusiveMin',
        getter: (t) => t.exclusiveMin,
      );
      final exclusiveMax = c.requiredBool(
        id: 5,
        name: 'exclusiveMax',
        getter: (t) => t.exclusiveMax,
      );
      c.constructorFromData = (data) {
        return Float32Kind(
          specialValues: data.get(specialValues),
          min: data.get(min),
          max: data.get(max),
          exclusiveMin: data.get(exclusiveMin),
          exclusiveMax: data.get(exclusiveMax),
        );
      };
    },
  );

  @literal
  const Float32Kind({
    bool specialValues = false,
    double? min,
    double? max,
    bool exclusiveMin = false,
    bool exclusiveMax = false,
  }) : super(
          min: min,
          max: max,
          exclusiveMin: exclusiveMin,
          exclusiveMax: exclusiveMax,
          specialValues: specialValues,
        );

  @override
  int get bitsPerListElement => 32;

  @override
  int get hashCode => (Float32Kind).hashCode ^ super.hashCode;

  @override
  String get name => 'Float32';

  @override
  int get protobufFieldType {
    return protobuf.PbFieldType.OF;
  }

  @override
  bool operator ==(other) {
    return other is Float32Kind &&
        specialValues == other.specialValues &&
        min == other.min &&
        max == other.max &&
        exclusiveMin == other.exclusiveMin &&
        exclusiveMax == other.exclusiveMax;
  }

  @override
  EntityKind<Float32Kind> getKind() => kind;

  @override
  List<double> newList(int length,
      {bool growable = false, bool reactive = true}) {
    if (growable) {
      return super.newList(length, growable: growable, reactive: reactive);
    }
    final list = Float32List(length);
    if (reactive) {
      return ReactiveList<double>.wrap(list);
    }
    return list;
  }

  @override
  String toString() => 'Float32Kind()';

  /// Reduces precision of (64-bit) [double] to 32-bit floating point value.
  static double losePrecision(double value) {
    final list = _float32list;
    list[0] = value;
    return list[0];
  }
}

/// [Kind] for 64-bit floating-point values ([double] in Dart).
///
/// ## Generating random values
/// You can generate random examples with the methods [randomExample()] and
/// [randomExampleList()].
///
/// If [min] and [max] are non-null, the random examples will be in the range.
/// Otherwise values are in some range near zero.
///
/// This behavior may be changed in future.
///
/// ## All available floating-point kinds
///   * [Float32Kind]
///   * [Float64Kind]
@sealed
class Float64Kind extends FloatKindBase {
  /// [Kind] for [Float64Kind].
  ///
  /// The purpose of annotation `@protected` is reducing accidental use.
  static final EntityKind<Float64Kind> kind = EntityKind<Float64Kind>(
    name: 'Float64Kind',
    build: (c) {
      final specialValues = c.requiredBool(
        id: 1,
        name: 'specialValues',
        getter: (t) => t.specialValues,
      );
      final min = c.optionalFloat64(
        id: 2,
        name: 'min',
        getter: (t) => t.min,
      );
      final max = c.optionalFloat64(
        id: 3,
        name: 'max',
        getter: (t) => t.max,
      );
      final exclusiveMin = c.requiredBool(
        id: 4,
        name: 'exclusiveMin',
        getter: (t) => t.exclusiveMin,
      );
      final exclusiveMax = c.requiredBool(
        id: 5,
        name: 'exclusiveMax',
        getter: (t) => t.exclusiveMax,
      );
      c.constructorFromData = (data) {
        return Float64Kind(
          specialValues: data.get(specialValues),
          min: data.get(min),
          max: data.get(max),
          exclusiveMin: data.get(exclusiveMin),
          exclusiveMax: data.get(exclusiveMax),
        );
      };
    },
  );

  @literal
  const Float64Kind({
    bool specialValues = false,
    double? min,
    double? max,
    bool exclusiveMin = false,
    bool exclusiveMax = false,
  }) : super(
          specialValues: specialValues,
          min: min,
          max: max,
          exclusiveMin: exclusiveMin,
          exclusiveMax: exclusiveMax,
        );

  @override
  int get bitsPerListElement => 64;

  @override
  int get hashCode => (Float64Kind).hashCode ^ super.hashCode;

  @override
  String get name => 'Float64';

  @override
  int get protobufFieldType {
    return protobuf.PbFieldType.OD;
  }

  @override
  bool operator ==(other) {
    return other is Float64Kind &&
        specialValues == other.specialValues &&
        min == other.min &&
        max == other.max &&
        exclusiveMin == other.exclusiveMin &&
        exclusiveMax == other.exclusiveMax;
  }

  @override
  EntityKind<Float64Kind> getKind() => kind;

  @override
  List<double> newList(int length,
      {bool growable = false, bool reactive = true}) {
    if (growable) {
      return super.newList(length, growable: growable, reactive: reactive);
    }
    final list = Float64List(length);
    if (reactive) {
      return ReactiveList<double>.wrap(list);
    }
    return list;
  }

  @override
  String toString() => 'Float64Kind()';
}

/// Base class for floating-point kinds ([Float32Kind] and [Float64Kind]).
abstract class FloatKindBase extends NumericKind<double> {
  @override
  final double? min;
  @override
  final double? max;
  final bool exclusiveMin;
  final bool exclusiveMax;
  final bool specialValues;

  @literal
  const FloatKindBase({
    this.specialValues = false,
    this.min,
    this.max,
    this.exclusiveMin = false,
    this.exclusiveMax = false,
  });

  @override
  int get hashCode =>
      specialValues.hashCode ^
      min.hashCode ^
      max.hashCode ^
      (exclusiveMin.hashCode << 1) ^
      (exclusiveMax.hashCode << 2);

  @override
  void instanceValidateConstraints(ValidateContext context, double value) {
    if (value.isNaN || value.isInfinite) {
      if (specialValues) {
        return;
      }
      context.invalid(value: value, message: '$value is not allowed');
      return;
    }
    final min = this.min;
    if (min != null) {
      if (exclusiveMin) {
        if (!(value > min)) {
          context.invalid(value: value);
        }
      } else {
        if (!(value >= min)) {
          context.invalid(value: value);
        }
      }
    }
    final max = this.max;
    if (max != null) {
      if (exclusiveMax) {
        if (!(value < max)) {
          context.invalid(value: value);
        }
      } else {
        if (!(value <= max)) {
          context.invalid(value: value);
        }
      }
    }
    super.instanceValidateConstraints(context, value);
  }

  @override
  double jsonTreeDecode(Object? json, {JsonDecodingContext? context}) {
    if (json is double) {
      return json;
    }
    context ??= JsonDecodingContext();
    if (json is String) {
      final settings = context.jsonSettings;
      if (json == settings.nan) {
        return double.nan;
      }
      if (json == settings.negativeInfinity) {
        return double.negativeInfinity;
      }
      if (json == settings.infinity) {
        return double.infinity;
      }
    }
    throw context.newGraphNodeError(
      value: json,
      reason: 'Expected JSON number',
    );
  }

  @override
  Object? jsonTreeEncode(double value, {JsonEncodingContext? context}) {
    if (value.isNaN) {
      context ??= JsonEncodingContext();
      final settings = context.jsonSettings;
      final s = settings.nan;
      if (s != null) {
        return s;
      }
      throw context.newGraphNodeError(
        value: value,
        reason: 'JSON does not support `double.nan`.',
      );
    }
    if (value == double.negativeInfinity) {
      context ??= JsonEncodingContext();
      final settings = context.jsonSettings;
      final s = settings.negativeInfinity;
      if (s != null) {
        return s;
      }
      throw context.newGraphNodeError(
        value: value,
        reason: 'JSON does not support `double.negativeInfinity`.',
      );
    }
    if (value == double.infinity) {
      context ??= JsonEncodingContext();
      final settings = context.jsonSettings;
      final s = settings.infinity;
      if (s != null) {
        return s;
      }
      throw context.newGraphNodeError(
        value: value,
        reason: 'JSON does not support `double.infinity`.',
      );
    }
    return value;
  }

  @override
  double newInstance() {
    return 0.0;
  }

  @override
  double protobufTreeDecode(Object? value, {ProtobufDecodingContext? context}) {
    if (value is double) {
      return value;
    } else {
      context ??= ProtobufDecodingContext();
      throw context.newUnsupportedTypeError(value);
    }
  }

  @override
  Object? protobufTreeEncode(double value, {ProtobufEncodingContext? context}) {
    return value;
  }

  @override
  double randomExample({RandomExampleContext? context}) {
    context ??= RandomExampleContext();
    if (specialValues) {
      const p = 0.1;
      final r = context.random.nextDouble();
      if (r < p) {
        if (r < p / 3.0) {
          return double.nan;
        }
        if (r < p * 2.0 / 3.0) {
          return double.infinity;
        }
        return double.negativeInfinity;
      }
    }
    var min = this.min;
    var max = this.max;
    if (min == null || min.isNaN || min.isInfinite) {
      min = -100.0;
    }
    if (max == null || max.isNaN || max.isInfinite) {
      max = math.max<double>(0.0, min) + 100.0;
    }
    var randomValue = context.random.nextDouble();
    if (randomValue == 0.0 && exclusiveMin) {
      randomValue = min + (max - min) / 2.0;
    }
    return min + randomValue * (max - min);
  }
}
