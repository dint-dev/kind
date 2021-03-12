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

import 'package:kind/kind.dart';
import 'package:meta/meta.dart';

/// [Kind] for JSON trees.
///
/// ## Serialization
///   * In JSON, the JSON tree is serialized without changes.
///   * In Protocol Buffers, string is used.
@sealed
class JsonKind extends PrimitiveKind<Object?> {
  /// [Kind] for [JsonKind].
  ///
  /// The purpose of annotation `@protected` is reducing accidental use.
  @protected
  static final EntityKind<JsonKind> kind = EntityKind<JsonKind>(
    name: 'JsonKind',
    define: (c) {
      c.constructor = () => const JsonKind();
    },
  );

  @literal
  const JsonKind();

  @override
  int get hashCode => (JsonKind).hashCode;

  @override
  String get name => 'Json';

  @override
  int get protobufFieldType {
    return const StringKind().protobufFieldType;
  }

  @override
  bool operator ==(other) => other is JsonKind;

  @override
  EntityKind<JsonKind> getKind() => kind;

  @override
  void instanceValidateConstraints(ValidateContext context, Object? value) {
    _validateConstraints(context, [], value);
    super.instanceValidateConstraints(context, value);
  }

  @override
  Object? jsonTreeDecode(Object? json, {JsonDecodingContext? context}) {
    return json;
  }

  @override
  Object? jsonTreeEncode(Object? value, {JsonEncodingContext? context}) {
    return value;
  }

  @override
  Object? newInstance() {
    return null;
  }

  @override
  Object? protobufTreeDecode(Object? value,
      {ProtobufDecodingContext? context}) {
    context ??= ProtobufDecodingContext();
    final s = context.decode(value, kind: const StringKind());
    return jsonDecode(s);
  }

  @override
  Object protobufTreeEncode(Object? value,
      {ProtobufEncodingContext? context}) {
    final s = jsonEncode(value);
    context ??= ProtobufEncodingContext();
    return context.encode(s, kind: const StringKind());
  }

  @override
  String toString() {
    return 'JsonKind()';
  }

  void _validateConstraints(
      ValidateContext context, List stack, Object? value) {
    if (value == null || value is bool || value is num || value is String) {
      // Ignore
    } else if (value is List) {
      // Check for cycles
      if (stack.any((element) => identical(element, value))) {
        context.invalid(
          value: value,
          message: 'Cyclic JSON',
        );
        return;
      }

      stack.add(value);
      for (var i = 0; i < value.length; i++) {
        context.validateIndex(i, value[i], kind: this);
      }
      stack.removeLast();
    } else if (value is Map) {
      // Check for cycles
      if (stack.any((element) => identical(element, value))) {
        context.invalid(
          value: value,
          message: 'Cyclic JSON',
        );

        return;
      }

      stack.add(value);
      for (var entry in value.entries) {
        final key = entry.key;
        if (key is String) {
          context.validateProp(key, entry.value, kind: this);
        } else {
          context.invalid(
            value: key,
            message: 'JSON object keys must be strings',
          );
          return;
        }
      }
      stack.removeLast();
    } else {
      context.invalid(
        value: value,
        message: 'Not a valid JSON value',
      );
    }
  }
}
