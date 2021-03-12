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

import 'package:collection/collection.dart';
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
/// By default, [base64] strings are used. You can customize this by specifying
/// [jsonCodec]. In the following example, we use [base64Url]:
/// ```
/// import 'dart:convert' show base64Url;
/// import 'package:kind/kind.dart';
///
/// final example = BytesKind(jsonCodec: base64Url);
/// ```
///
/// Decoding method always returns immutable lists.
///
/// ## Protocol Buffers
/// Values are serialized as byte sequences.
///
/// Decoding method always returns immutable lists.
@sealed
class BytesKind extends PrimitiveKind<List<int>> {
  /// [Kind] for [BytesKind].
  ///
  /// The purpose of annotation `@protected` is reducing accidental use.
  @protected
  static final EntityKind<BytesKind> kind = EntityKind<BytesKind>(
    name: 'BytesKind',
    define: (c) {
      final minLength = c.requiredUint64(
        id: 1,
        name: 'minLength',
        getter: (t) => t.minLength,
      );
      final maxLength = c.optionalUint64(
        id: 2,
        name: 'maxLength',
        getter: (t) => t.maxLength,
      );
      final mediaTypes = c.optionalSet<String>(
        id: 3,
        name: 'mediaTypes',
        itemsKind: const StringKind(
          maxLengthInUtf8: 63,
          regExpProvider: _mediaTypeRegExpProvider,
        ),
        getter: (t) => t.mediaTypes,
      );
      final jsonCodecProp = c.required<String>(
        id: 4,
        name: 'jsonCodec',
        kind: EnumKind(entries: [
          EnumKindEntry(id: 1, name: 'base64', value: 'base64'),
          EnumKindEntry(id: 2, name: 'base64Url', value: 'base64Url'),
        ]),
        getter: (t) {
          final jsonCodec = t.jsonCodec;
          if (jsonCodec == base64) {
            return 'base64';
          }
          if (jsonCodec == base64Url) {
            return 'base64Url';
          }
          throw StateError('Unsupported JSON codec: $jsonCodec');
        },
      );
      final examples = c.requiredList(
        id: 5,
        name: 'examples',
        itemsKind: const BytesKind(),
        getter: (t) => t.examples,
      );
      c.constructorFromData = (data) {
        final jsonCodecString = data.get(jsonCodecProp);
        late Codec<List<int>, String> jsonCodec;
        if (jsonCodecString == 'base64') {
          jsonCodec = base64;
        } else if (jsonCodecString == 'base64uri') {
          jsonCodec = base64Url;
        } else {
          throw ArgumentError('Unsupported JSON codec: "$jsonCodecString"');
        }
        return BytesKind(
          minLength: data.get(minLength),
          maxLength: data.get(maxLength),
          mediaTypes: data.get(mediaTypes),
          jsonCodec: jsonCodec,
          examples: data.get(examples),
        );
      };
    },
  );

  static final List<int> _empty = UnmodifiableUint8ListView(Uint8List(0));

  /// Minimum length.
  final int minLength;

  /// Maximum length.
  final int? maxLength;

  /// Accepted media types ("image/jpeg", etc.).
  final Set<String>? mediaTypes;

  /// Codec used for encoding bytes in JSON. By default, [base64].
  final Codec<List<int>, String> jsonCodec;

  /// Examples of valid values.
  final List<List<int>> examples;

  @literal
  const BytesKind({
    this.minLength = 0,
    this.maxLength,
    this.mediaTypes,
    this.jsonCodec = base64,
    this.examples = const [],
  })  : assert(minLength >= 0),
        assert(maxLength == null || maxLength >= minLength);

  @override
  int get hashCode =>
      (BytesKind).hashCode ^ minLength.hashCode ^ maxLength.hashCode;

  @override
  String get name => '${PrimitiveKind.namePrefixForNonClasses}Bytes';

  @override
  int get protobufFieldType {
    return protobuf.PbFieldType.OY;
  }

  @override
  bool operator ==(other) {
    return other is BytesKind &&
        minLength == other.minLength &&
        maxLength == other.maxLength &&
        const SetEquality<String>().equals(mediaTypes, other.mediaTypes) &&
        jsonCodec == other.jsonCodec &&
        const ListEquality<List<int>>().equals(examples, other.examples);
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
  Uint8List protobufTreeEncode(List<int> instance,
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

  /// Regular expression for 'mediaTypes'.
  static RegExp _mediaTypeRegExpProvider() {
    return RegExp(r'^[a-z]+/[\-+.a-z0-9]+\$');
  }
}
