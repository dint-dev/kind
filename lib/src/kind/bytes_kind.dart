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
import 'dart:typed_data';

import 'package:kind/kind.dart';
import 'package:meta/meta.dart';
import 'package:protobuf/protobuf.dart' as protobuf;

/// [Kind] for immutable lists of unsigned 8-bit integers (`List<int>`).
///
/// ## Constraints
///   * Number of bytes ([minLength], [maxLength])
///
/// ## Serialization
/// ### JSON
/// By default, base64 strings are used. You can customize this by specifying
/// [jsonCodec].
/// Decoder method always returns immutable byte lists.
///
/// ## Protocol Buffers
/// By default, bytes are used.
/// Decoder method always returns immutable byte lists.
///
@sealed
class BytesKind extends PrimitiveKind<List<int>> {
  /// [Kind] for [BytesKind].
  ///
  /// The purpose of annotation `@protected` is reducing accidental use.
  @protected
  static final EntityKind<BytesKind> kind = EntityKind<BytesKind>(
    name: 'BytesKind',
    build: (c) {
      c.constructor = () => const BytesKind();
    },
  );

  static final List<int> _empty = UnmodifiableUint8ListView(Uint8List(0));

  /// Minimum length.
  final int minLength;

  /// Maximum length.
  final int? maxLength;

  /// Codec used for encoding bytes in JSON. By default, [base64].
  final Codec<List<int>, String> jsonCodec;

  @literal
  const BytesKind({
    this.minLength = 0,
    this.maxLength,
    this.jsonCodec = base64,
  })  : assert(minLength >= 0),
        assert(maxLength == null || maxLength >= minLength);

  @override
  int get hashCode =>
      (BytesKind).hashCode ^ minLength.hashCode ^ maxLength.hashCode;

  @override
  String get name => 'bytes';

  @override
  int get protobufFieldType {
    return protobuf.PbFieldType.OY;
  }

  @override
  bool operator ==(other) {
    return other is BytesKind &&
        minLength == other.minLength &&
        maxLength == other.maxLength &&
        jsonCodec == other.jsonCodec;
  }

  @override
  EntityKind<BytesKind> getKind() => kind;

  @override
  bool instanceIsDefaultValue(Object? value) {
    return value is List<int> && value.isEmpty;
  }

  @override
  void instanceValidateConstraints(ValidateContext context, List<int> value) {
    context.validateLength(
      value: value,
      length: value.length,
      minLength: minLength,
      maxLength: maxLength,
    );
    super.instanceValidateConstraints(context, value);
  }

  @override
  List<int> jsonTreeDecode(Object? json, {JsonDecodingContext? context}) {
    if (json is String) {
      final result = jsonCodec.decode(json);
      return List<int>.unmodifiable(result);
    } else {
      context ??= JsonDecodingContext();
      throw context.newGraphNodeError(
        value: json,
        reason: 'Expected JSON string.',
      );
    }
  }

  @override
  Object? jsonTreeEncode(List<int> value, {JsonEncodingContext? context}) {
    return jsonCodec.encode(value);
  }

  @override
  List<int> newInstance() {
    return _empty;
  }

  @override
  List<int> protobufTreeDecode(Object? value,
      {ProtobufDecodingContext? context}) {
    if (value is List<int>) {
      return List<int>.unmodifiable(value);
    } else {
      context ??= ProtobufDecodingContext();
      throw context.newUnsupportedTypeError(json);
    }
  }

  @override
  Object? protobufTreeEncode(List<int> instance,
      {ProtobufEncodingContext? context}) {
    return Uint8List.fromList(instance);
  }

  @override
  String toString() {
    final arguments = <String>[];
    if (minLength != 0) {
      arguments.add('minLength: $minLength');
    }
    if (maxLength != null) {
      arguments.add('maxLength: $maxLength');
    }
    if (jsonCodec != base64) {
      arguments.add('jsonCodec: ...');
    }
    return 'BytesKind(${arguments.join(', ')})';
  }
}
