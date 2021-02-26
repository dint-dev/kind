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

/// [Kind] for [Date].
///
/// By default, must be 0001-01-01 to 9999-12-31 (inclusive).
///
/// ## Example
/// ```
/// import 'package:kind/kind.dart';
///
/// const example = DateKind();
/// ```
///
/// ## Generating random values
/// You can generate random examples with the methods [randomExample()] and
/// [randomExampleList()].
///
/// Currently method [randomExample] returns random dates between years 1950 and
/// 2020.
///
/// This behavior may be changed in future.
@sealed
class DateKind extends PrimitiveKind<Date> {
  /// [Kind] for [DateKind].
  @protected
  static final EntityKind<DateKind> kind = EntityKind<DateKind>(
    name: 'DateKind',
    build: (c) {
      c.constructor = () => const DateKind();
    },
  );

  @literal
  const DateKind();

  @override
  int get hashCode => (DateKind).hashCode;

  @override
  String get name => 'Date';

  @override
  int get protobufFieldType {
    return const StringKind().protobufFieldType;
  }

  @override
  bool operator ==(other) {
    return other is DateKind;
  }

  @override
  EntityKind<DateKind> getKind() => kind;

  @override
  Date jsonTreeDecode(Object? json, {JsonDecodingContext? context}) {
    if (json is String) {
      final result = Date.tryParse(json);
      if (result == null) {
        context ??= JsonDecodingContext();
        throw context.newGraphNodeError(
          value: json,
          reason: 'Invalid format',
        );
      }
      return result;
    } else {
      context ??= JsonDecodingContext();
      throw context.newGraphNodeError(
        value: json,
        reason: 'Expected JSON string.',
      );
    }
  }

  @override
  Object? jsonTreeEncode(Date value, {JsonEncodingContext? context}) {
    return value.toString();
  }

  @override
  Date newInstance() {
    return Date.epoch;
  }

  @override
  Date protobufTreeDecode(Object? value, {ProtobufDecodingContext? context}) {
    if (value is String) {
      return Date.parse(value);
    } else {
      context ??= ProtobufDecodingContext();
      throw context.newUnsupportedTypeError(value);
    }
  }

  @override
  Object? protobufTreeEncode(Date value, {ProtobufEncodingContext? context}) {
    return value.toString();
  }

  @override
  Date randomExample({RandomExampleContext? context}) {
    context ??= RandomExampleContext();
    final random = context.random;
    final year = 1950 + random.nextInt(70);
    final month = 1 + random.nextInt(12);
    final day = 1 + random.nextInt(27);
    return Date(year, month, day);
  }

  @override
  String toString() {
    return 'DateKind()';
  }
}
