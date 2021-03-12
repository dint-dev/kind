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

/// [Kind] for [DateTimeWithTimeZone].
///
/// ## Example
/// ```
/// import 'package:kind/kind.dart';
///
/// const example = DateTimeWithTimeZoneKind();
/// ```
///
/// ## Generating random values
/// You can generate random examples with the methods [randomExample()] and
/// [randomExampleList()].
///
/// Currently [randomExample] returns random values between years 1950 and 2020.
/// This is an implementation detail that could be changed in future.
class DateTimeWithTimeZoneKind extends PrimitiveKind<DateTimeWithTimeZone> {
  @protected
  static final EntityKind<DateTimeWithTimeZoneKind> kind =
      EntityKind<DateTimeWithTimeZoneKind>(
    name: 'DateTimeWithTimeZoneKind',
    define: (c) {
      c.constructor = () => const DateTimeWithTimeZoneKind();
    },
  );

  @literal
  const DateTimeWithTimeZoneKind();

  @override
  int get hashCode => (DateTimeWithTimeZoneKind).hashCode;

  @override
  String get name => 'DateTimeWithTimeZone';

  @override
  int get protobufFieldType {
    return const DateTimeKind().protobufFieldType;
  }

  @override
  bool operator ==(other) {
    return other is DateTimeWithTimeZoneKind;
  }

  @override
  EntityKind<DateTimeWithTimeZoneKind> getKind() => kind;

  @override
  DateTimeWithTimeZone jsonTreeDecode(Object? json,
      {JsonDecodingContext? context}) {
    if (json is String) {
      final dateTimeWithTimeZone = DateTimeWithTimeZone.tryParse(json);
      if (dateTimeWithTimeZone == null) {
        context ??= JsonDecodingContext();
        throw context.newGraphNodeError(
          value: json,
          reason: 'Invalid format',
        );
      }
      return dateTimeWithTimeZone;
    } else {
      context ??= JsonDecodingContext();
      throw context.newGraphNodeError(
        value: json,
        reason: 'Expected JSON string.',
      );
    }
  }

  @override
  Object jsonTreeEncode(DateTimeWithTimeZone value,
      {JsonEncodingContext? context}) {
    return value.toIso8601String();
  }

  @override
  DateTimeWithTimeZone newInstance() {
    return DateTimeWithTimeZone.epoch;
  }

  @override
  Object? protobufNewInstance() {
    return const DateTimeKind().protobufNewInstance();
  }

  @override
  DateTimeWithTimeZone protobufTreeDecode(
    Object? value, {
    ProtobufDecodingContext? context,
  }) {
    // TODO: How to serialize timezone in Protocol Buffers?
    context ??= ProtobufDecodingContext();
    final dateTime = context.decode(value, kind: const DateTimeKind());
    return DateTimeWithTimeZone.fromDateTime(dateTime);
  }

  @override
  Object protobufTreeEncode(DateTimeWithTimeZone value,
      {ProtobufEncodingContext? context}) {
    // TODO: How to serialize timezone in Protocol Buffers?
    final dateTime = value.toDateTime(utc: true);
    context ??= ProtobufEncodingContext();
    return context.encode(dateTime, kind: const DateTimeKind());
  }

  @override
  String toString() {
    return 'DateTimeWithTimeZoneKind()';
  }
}
