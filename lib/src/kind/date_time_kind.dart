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

import 'package:fixnum/fixnum.dart';
import 'package:kind/kind.dart';
import 'package:meta/meta.dart';
import 'package:protobuf/protobuf.dart' as protobuf;
import 'package:protobuf/protobuf.dart';

/// [Kind] for [DateTime].
///
/// Values must in the range from 0001-01-01T00:00:00Z to 9999-12-31T23:59:59Z.
///
/// ## Example
/// ```
/// import 'package:kind/kind.dart';
///
/// const example = DateTimeKind();
/// ```
///
/// ## Generating random values
/// You can generate random examples with the methods [randomExample()] and
/// [randomExampleList()].
///
/// Currently [randomExample] returns random values between years 1950 and 2020.
/// This is an implementation detail that could be changed in future.
@sealed
class DateTimeKind extends PrimitiveKind<DateTime> {
  /// [Kind] for [DateTimeKind].
  @protected
  static final EntityKind<DateTimeKind> kind = EntityKind<DateTimeKind>(
    name: 'DateTimeKind',
    define: (c) {
      c.constructor = () => const DateTimeKind();
    },
  );

  static final epoch = DateTime.utc(1970, 1, 1, 0, 0, 0);
  static final _examples = List<DateTime>.unmodifiable([
    DateTime.utc(1950),
    DateTime.utc(2020, 12, 31, 59, 59, 59, 999, 999),
  ]);

  const DateTimeKind();

  @override
  List<DateTime> get declaredExamples => _examples;

  @override
  int get hashCode => (DateTimeKind).hashCode;

  @override
  String get name => 'DateTime';

  @override
  int get protobufFieldType {
    return protobuf.PbFieldType.OM;
  }

  @override
  bool operator ==(other) {
    return other is DateTimeKind;
  }

  @override
  EntityKind<DateTimeKind> getKind() => kind;

  @override
  DateTime jsonTreeDecode(Object? json, {JsonDecodingContext? context}) {
    if (json is String) {
      if (json.length < 17) {
        throw ArgumentError.value(json, 'argument', 'Too short to be valid');
      }
      final result = DateTime.tryParse(json);
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
  Object? jsonTreeEncode(DateTime value, {JsonEncodingContext? context}) {
    return value.toIso8601String();
  }

  @override
  DateTime newInstance() {
    return epoch;
  }

  @override
  Object? protobufNewInstance() {
    return protobufTreeEncode(epoch);
  }

  @override
  DateTime protobufTreeDecode(
    Object? value, {
    ProtobufDecodingContext? context,
  }) {
    if (value is GeneratedMessage) {
      final secondsAsUint64 = (value.getField(1) ?? Int64.ZERO) as Int64;
      final seconds = secondsAsUint64.toInt();
      final nanos = (value.getField(2) ?? 0) as int;
      const million = 1000000;
      if (nanos % million == 0) {
        return DateTime.fromMillisecondsSinceEpoch(
          seconds.toInt() * 1000 + (seconds.sign) * ((nanos ~/ million) % 1000),
          isUtc: true,
        );
      }
      return DateTime.fromMicrosecondsSinceEpoch(
        seconds * million + (seconds.sign) * ((nanos ~/ 1000) % million),
        isUtc: true,
      );
    }
    context ??= ProtobufDecodingContext();
    throw context.newUnsupportedTypeError(value);
  }

  @override
  protobuf.GeneratedMessage protobufTreeEncode(
    DateTime value, {
    ProtobufEncodingContext? context,
  }) {
    value = value.toUtc();
    final message = _DateTimeGeneratedMessage();
    final seconds = value.millisecondsSinceEpoch ~/ 1000;
    if (seconds != 0) {
      message.setField(1, Int64(seconds));
    }
    final nanos = (value.microsecondsSinceEpoch % 1000000).abs() * 1000;
    if (nanos != 0) {
      message.setField(2, nanos);
    }
    return message;
  }

  @override
  DateTime randomExample({RandomExampleContext? context}) {
    context ??= RandomExampleContext();
    final random = context.random;
    final duration = Duration(
      days: random.nextInt(70 * 364),
      hours: random.nextInt(24),
      minutes: random.nextInt(60),
      seconds: random.nextInt(60),
      microseconds: random.nextInt(1000000),
    );
    return DateTime(1950).add(duration);
  }
}

// "Timestamp" in "well-known types" of Protocol Buffers:
//     https://developers.google.com/protocol-buffers/docs/reference/google.protobuf#google.protobuf.Timestamp
class _DateTimeGeneratedMessage extends GeneratedMessage {
  static final BuilderInfo _info = () {
    final builderInfo = BuilderInfo(
      // Protocol Buffers message declaration name.
      'Timestamp',
      createEmptyInstance: () => _DateTimeGeneratedMessage(),
    );
    builderInfo.a(1, 'seconds', PbFieldType.OS6);
    builderInfo.a(2, 'nanos', PbFieldType.O3);
    return builderInfo;
  }();

  @override
  BuilderInfo get info_ => _info;

  @override
  GeneratedMessage clone() {
    return _DateTimeGeneratedMessage()..mergeFromMessage(this);
  }

  @override
  GeneratedMessage createEmptyInstance() {
    return _DateTimeGeneratedMessage();
  }
}
