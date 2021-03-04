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
import 'package:test/test.dart';

void main() {
  // Load 'late' static fields
  _Example.kind.props;

  group('Protocol Buffers support', () {
    group('empty message', () {
      final value = _Example();
      const message = <int>[];

      test('encode', () {
        final result = _Example.kind.protobufTreeEncode(value).writeToBuffer();
        expect(result, message);
      });

      test('decode', () {
        final result = _Example.kind.protobufBytesDecode(message);
        expect(result.boolValue, value.boolValue);
        expect(result.boolValueOrNull, value.boolValueOrNull);
        expect(result.uint32Value, value.uint32Value);
        expect(result.uint64Value, value.uint64Value);
        expect(result.int32Value, value.int32Value);
        expect(result.int64Value, value.int64Value);
        expect(result.float32Value, value.float32Value);
        expect(result.float64Value, value.float64Value);
        expect(result.dateTimeValue, value.dateTimeValue);
        expect(result.stringValue, value.stringValue);
        expect(result.bytesValue, value.bytesValue);
        expect(result.example, value.example);
        expect(result, value);
      });
    });

    group('bool field', () {
      final value = _Example()..boolValue = true;
      final message = <int>[
        (_Example._boolProp.id << 3) | 0,
        1,
      ];

      test('encode', () {
        final result = _Example.kind.protobufTreeEncode(value).writeToBuffer();
        expect(result, message);
      });

      test('decode', () {
        final result = _Example.kind.protobufBytesDecode(message);
        expect(result.boolValue, value.boolValue);
        expect(result.boolValueOrNull, value.boolValueOrNull);
        expect(result.uint32Value, value.uint32Value);
        expect(result.uint64Value, value.uint64Value);
        expect(result.int32Value, value.int32Value);
        expect(result.int64Value, value.int64Value);
        expect(result.float32Value, value.float32Value);
        expect(result.float64Value, value.float64Value);
        expect(result.dateTimeValue, value.dateTimeValue);
        expect(result.stringValue, value.stringValue);
        expect(result.bytesValue, value.bytesValue);
        expect(result.example, value.example);
        expect(result, value);
      });
    });

    group('bool field (nullable)', () {
      final value = _Example()..boolValueOrNull = true;
      final message = <int>[
        (_Example._boolOrNullProp.id << 3) | 0,
        1,
      ];

      test('encode', () {
        final result = _Example.kind.protobufTreeEncode(value).writeToBuffer();
        expect(result, message);
      });

      test('decode', () {
        final result = _Example.kind.protobufBytesDecode(message);
        expect(result.boolValue, value.boolValue);
        expect(result.boolValueOrNull, value.boolValueOrNull);
        expect(result.uint32Value, value.uint32Value);
        expect(result.uint64Value, value.uint64Value);
        expect(result.int32Value, value.int32Value);
        expect(result.int64Value, value.int64Value);
        expect(result.float32Value, value.float32Value);
        expect(result.float64Value, value.float64Value);
        expect(result.dateTimeValue, value.dateTimeValue);
        expect(result.stringValue, value.stringValue);
        expect(result.bytesValue, value.bytesValue);
        expect(result.example, value.example);
        expect(result, value);
      });
    });

    group('uint32 field', () {
      final value = _Example()..uint32Value = 2;
      final message = <int>[
        (_Example._uint32Prop.id << 3) | 0,
        2,
      ];

      test('encode', () {
        final result = _Example.kind.protobufTreeEncode(value).writeToBuffer();
        expect(result, message);
      });

      test('decode', () {
        final result = _Example.kind.protobufBytesDecode(message);
        expect(result.boolValue, value.boolValue);
        expect(result.boolValueOrNull, value.boolValueOrNull);
        expect(result.uint32Value, value.uint32Value);
        expect(result.uint64Value, value.uint64Value);
        expect(result.int32Value, value.int32Value);
        expect(result.int64Value, value.int64Value);
        expect(result.float32Value, value.float32Value);
        expect(result.float64Value, value.float64Value);
        expect(result.dateTimeValue, value.dateTimeValue);
        expect(result.stringValue, value.stringValue);
        expect(result.bytesValue, value.bytesValue);
        expect(result.example, value.example);
        expect(result, value);
      });
    });

    group('uint64 field', () {
      final value = _Example()..uint64Value = 2;
      final message = <int>[
        (_Example._uint64Prop.id << 3) | 0,
        2,
      ];

      test('encode', () {
        final result = _Example.kind.protobufTreeEncode(value).writeToBuffer();
        expect(result, message);
      });

      test('decode', () {
        final result = _Example.kind.protobufBytesDecode(message);
        expect(result.boolValue, value.boolValue);
        expect(result.boolValueOrNull, value.boolValueOrNull);
        expect(result.uint32Value, value.uint32Value);
        expect(result.uint64Value, value.uint64Value);
        expect(result.int32Value, value.int32Value);
        expect(result.int64Value, value.int64Value);
        expect(result.float32Value, value.float32Value);
        expect(result.float64Value, value.float64Value);
        expect(result.dateTimeValue, value.dateTimeValue);
        expect(result.stringValue, value.stringValue);
        expect(result.bytesValue, value.bytesValue);
        expect(result.example, value.example);
        expect(result, value);
      });
    });

    group('int32 field', () {
      final value = _Example()..int32Value = 2;
      final message = <int>[
        (_Example._int32Prop.id << 3) | 0,
        4,
      ];

      test('encode', () {
        final result = _Example.kind.protobufTreeEncode(value).writeToBuffer();
        expect(result, message);
      });

      test('decode', () {
        final result = _Example.kind.protobufBytesDecode(message);
        expect(result.boolValue, value.boolValue);
        expect(result.boolValueOrNull, value.boolValueOrNull);
        expect(result.uint32Value, value.uint32Value);
        expect(result.uint64Value, value.uint64Value);
        expect(result.int32Value, value.int32Value);
        expect(result.int64Value, value.int64Value);
        expect(result.float32Value, value.float32Value);
        expect(result.float64Value, value.float64Value);
        expect(result.dateTimeValue, value.dateTimeValue);
        expect(result.stringValue, value.stringValue);
        expect(result.bytesValue, value.bytesValue);
        expect(result.example, value.example);
        expect(result, value);
      });
    });

    group('int64 field', () {
      final value = _Example()..int64Value = 2;
      final message = <int>[
        (_Example._int64Prop.id << 3) | 0,
        4,
      ];

      test('encode', () {
        final result = _Example.kind.protobufTreeEncode(value).writeToBuffer();
        expect(result, message);
      });

      test('decode', () {
        final result = _Example.kind.protobufBytesDecode(message);
        expect(result.boolValue, value.boolValue);
        expect(result.boolValueOrNull, value.boolValueOrNull);
        expect(result.uint32Value, value.uint32Value);
        expect(result.uint64Value, value.uint64Value);
        expect(result.int32Value, value.int32Value);
        expect(result.int64Value, value.int64Value);
        expect(result.float32Value, value.float32Value);
        expect(result.float64Value, value.float64Value);
        expect(result.dateTimeValue, value.dateTimeValue);
        expect(result.stringValue, value.stringValue);
        expect(result.bytesValue, value.bytesValue);
        expect(result.example, value.example);
        expect(result, value);
      });
    });

    group('int64FixNum field', () {
      final value = _Example()..int64FixNumValue = Int64(2);
      final message = <int>[
        (_Example._int64FixNumProp.id << 3) | 0,
        4,
      ];

      test('encode', () {
        final result = _Example.kind.protobufTreeEncode(value).writeToBuffer();
        expect(result, message);
      });

      test('decode', () {
        final result = _Example.kind.protobufBytesDecode(message);
        expect(result.boolValue, value.boolValue);
        expect(result.boolValueOrNull, value.boolValueOrNull);
        expect(result.uint32Value, value.uint32Value);
        expect(result.uint64Value, value.uint64Value);
        expect(result.int32Value, value.int32Value);
        expect(result.int64Value, value.int64Value);
        expect(result.int64FixNumValue, value.int64FixNumValue);
        expect(result.float32Value, value.float32Value);
        expect(result.float64Value, value.float64Value);
        expect(result.dateTimeValue, value.dateTimeValue);
        expect(result.stringValue, value.stringValue);
        expect(result.bytesValue, value.bytesValue);
        expect(result.example, value.example);
        expect(result, value);
      });
    });

    group('float32 field', () {
      final value = _Example()..float32Value = 2.0;
      final message = <int>[
        (_Example._float32Prop.id << 3) | 5,
        0,
        0,
        0,
        64,
      ];

      test('encode', () {
        final result = _Example.kind.protobufTreeEncode(value).writeToBuffer();
        expect(result, message);
      });

      test('decode', () {
        final result = _Example.kind.protobufBytesDecode(message);
        expect(result.boolValue, value.boolValue);
        expect(result.boolValueOrNull, value.boolValueOrNull);
        expect(result.uint32Value, value.uint32Value);
        expect(result.uint64Value, value.uint64Value);
        expect(result.int32Value, value.int32Value);
        expect(result.int64Value, value.int64Value);
        expect(result.int64FixNumValue, value.int64FixNumValue);
        expect(result.float32Value, value.float32Value);
        expect(result.float64Value, value.float64Value);
        expect(result.dateTimeValue, value.dateTimeValue);
        expect(result.stringValue, value.stringValue);
        expect(result.bytesValue, value.bytesValue);
        expect(result.example, value.example);
        expect(result, value);
      });
    });

    group('float64 field', () {
      final value = _Example()..float64Value = 2.0;
      final message = <int>[
        (_Example._float64Prop.id << 3) | 1,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        64,
      ];

      test('encode', () {
        final result = _Example.kind.protobufTreeEncode(value).writeToBuffer();
        expect(result, message);
      });

      test('decode', () {
        final result = _Example.kind.protobufBytesDecode(message);
        expect(result.boolValue, value.boolValue);
        expect(result.boolValueOrNull, value.boolValueOrNull);
        expect(result.uint32Value, value.uint32Value);
        expect(result.uint64Value, value.uint64Value);
        expect(result.int32Value, value.int32Value);
        expect(result.int64Value, value.int64Value);
        expect(result.int64FixNumValue, value.int64FixNumValue);
        expect(result.float32Value, value.float32Value);
        expect(result.float64Value, value.float64Value);
        expect(result.dateTimeValue, value.dateTimeValue);
        expect(result.stringValue, value.stringValue);
        expect(result.bytesValue, value.bytesValue);
        expect(result.example, value.example);
        expect(result, value);
      });
    });

    group('DateTime field', () {
      final dateTime = DateTime.fromMillisecondsSinceEpoch(0, isUtc: true)
          .add(const Duration(
        seconds: 9,
        milliseconds: 7,
      ));

      final value = _Example()..dateTimeValue = dateTime;
      final message = <int>[
        (_Example._dateTimeProp.id << 3) | 2,
        7,
        (1 << 3) | 0,
        18,
        (2 << 3) | 0,
        192,
        159,
        171,
        3,
      ];

      test('encode', () {
        final result = _Example.kind.protobufTreeEncode(value).writeToBuffer();
        expect(result, message);
      });

      test('decode', () {
        final result = _Example.kind.protobufBytesDecode(message);
        expect(result.boolValue, value.boolValue);
        expect(result.boolValueOrNull, value.boolValueOrNull);
        expect(result.uint32Value, value.uint32Value);
        expect(result.uint64Value, value.uint64Value);
        expect(result.int32Value, value.int32Value);
        expect(result.int64Value, value.int64Value);
        expect(result.int64FixNumValue, value.int64FixNumValue);
        expect(result.float32Value, value.float32Value);
        expect(result.float64Value, value.float64Value);
        expect(result.dateTimeValue, value.dateTimeValue);
        expect(result.stringValue, value.stringValue);
        expect(result.bytesValue, value.bytesValue);
        expect(result.example, value.example);
        expect(result, value);
      });
    });

    group('DateTimeWithTimeZone field', () {
      final timestamap = DateTimeWithTimeZone.epoch.add(const Duration(
        seconds: 9,
        milliseconds: 7,
      ));

      final value = _Example()..dateTimeWithTimeZoneValue = timestamap;
      final message = <int>[
        (_Example._dateTimeWithTimeZoneProp.id << 3) | 2,
        7,
        (1 << 3) | 0,
        18,
        (2 << 3) | 0,
        192,
        159,
        171,
        3,
      ];

      test('encode', () {
        final result = _Example.kind.protobufTreeEncode(value).writeToBuffer();
        expect(result, message);
      });

      test('decode', () {
        final result = _Example.kind.protobufBytesDecode(message);
        expect(result.boolValue, value.boolValue);
        expect(result.boolValueOrNull, value.boolValueOrNull);
        expect(result.uint32Value, value.uint32Value);
        expect(result.uint64Value, value.uint64Value);
        expect(result.int32Value, value.int32Value);
        expect(result.int64Value, value.int64Value);
        expect(result.int64FixNumValue, value.int64FixNumValue);
        expect(result.float32Value, value.float32Value);
        expect(result.float64Value, value.float64Value);
        expect(result.dateTimeValue, value.dateTimeValue);
        expect(result.stringValue, value.stringValue);
        expect(result.bytesValue, value.bytesValue);
        expect(result.example, value.example);
        expect(result, value);
      });
    });

    group('DateTime field (negative from epoch)', () {
      final dateTime = DateTime.fromMillisecondsSinceEpoch(0, isUtc: true)
          .add(const Duration(seconds: -9));

      final value = _Example()..dateTimeValue = dateTime;
      final message = <int>[
        (_Example._dateTimeProp.id << 3) | 2,
        2,
        (1 << 3) | 0,
        17,
      ];

      test('encode', () {
        final result = _Example.kind.protobufTreeEncode(value).writeToBuffer();
        expect(result, message);
      });

      test('decode', () {
        final result = _Example.kind.protobufBytesDecode(message);
        expect(result.boolValue, value.boolValue);
        expect(result.boolValueOrNull, value.boolValueOrNull);
        expect(result.uint32Value, value.uint32Value);
        expect(result.uint64Value, value.uint64Value);
        expect(result.int32Value, value.int32Value);
        expect(result.int64Value, value.int64Value);
        expect(result.int64FixNumValue, value.int64FixNumValue);
        expect(result.float32Value, value.float32Value);
        expect(result.float64Value, value.float64Value);
        expect(result.dateTimeValue, value.dateTimeValue);
        expect(result.stringValue, value.stringValue);
        expect(result.bytesValue, value.bytesValue);
        expect(result.example, value.example);
        expect(result, value);
      });
    });

    group('string field', () {
      final value = _Example()..stringValue = 'ab';
      final message = <int>[
        (_Example._stringProp.id << 3) | 2,
        2,
        ...'ab'.codeUnits,
      ];

      test('encode', () {
        final result = _Example.kind.protobufTreeEncode(value).writeToBuffer();
        expect(result, message);
      });

      test('decode', () {
        final result = _Example.kind.protobufBytesDecode(message);
        expect(result.boolValue, value.boolValue);
        expect(result.boolValueOrNull, value.boolValueOrNull);
        expect(result.uint32Value, value.uint32Value);
        expect(result.uint64Value, value.uint64Value);
        expect(result.int32Value, value.int32Value);
        expect(result.int64Value, value.int64Value);
        expect(result.int64FixNumValue, value.int64FixNumValue);
        expect(result.float32Value, value.float32Value);
        expect(result.float64Value, value.float64Value);
        expect(result.dateTimeValue, value.dateTimeValue);
        expect(result.stringValue, value.stringValue);
        expect(result.bytesValue, value.bytesValue);
        expect(result.example, value.example);
        expect(result, value);
      });
    });

    group('bytes field', () {
      final value = _Example()..bytesValue = [9, 8, 7];
      final message = <int>[
        (_Example._bytesProp.id << 3) | 2,
        3,
        9,
        8,
        7,
      ];

      test('encode', () {
        final result = _Example.kind.protobufTreeEncode(value).writeToBuffer();
        expect(result, message);
      });

      test('decode', () {
        final result = _Example.kind.protobufBytesDecode(message);
        expect(result.boolValue, value.boolValue);
        expect(result.boolValueOrNull, value.boolValueOrNull);
        expect(result.uint32Value, value.uint32Value);
        expect(result.uint64Value, value.uint64Value);
        expect(result.int32Value, value.int32Value);
        expect(result.int64Value, value.int64Value);
        expect(result.int64FixNumValue, value.int64FixNumValue);
        expect(result.float32Value, value.float32Value);
        expect(result.float64Value, value.float64Value);
        expect(result.dateTimeValue, value.dateTimeValue);
        expect(result.stringValue, value.stringValue);
        expect(result.bytesValue, value.bytesValue);
        expect(result.example, value.example);
        expect(result, value);
      });
    });

    group('example field', () {
      final value = _Example()..example = (_Example()..boolValue = true);
      final message = <int>[
        (_Example._exampleProp.id << 3) | 2,
        2,
        8,
        1,
      ];

      test('encode', () {
        final result = _Example.kind.protobufTreeEncode(value).writeToBuffer();
        expect(result, message);
      });

      test('decode', () {
        final result = _Example.kind.protobufBytesDecode(message);
        expect(result.boolValue, value.boolValue);
        expect(result.boolValueOrNull, value.boolValueOrNull);
        expect(result.uint32Value, value.uint32Value);
        expect(result.uint64Value, value.uint64Value);
        expect(result.int32Value, value.int32Value);
        expect(result.int64Value, value.int64Value);
        expect(result.float32Value, value.float32Value);
        expect(result.float64Value, value.float64Value);
        expect(result.dateTimeValue, value.dateTimeValue);
        expect(result.stringValue, value.stringValue);
        expect(result.bytesValue, value.bytesValue);
        expect(result.example, value.example);
        expect(result, value);
      });
    });

    group('multiple field', () {
      final value = _Example()
        ..boolValue = true
        ..int32Value = 5;
      final message = <int>[
        (_Example._boolProp.id << 3) | 0,
        1,
        (_Example._int32Prop.id << 3) | 0,
        5 << 1,
      ];

      test('encode', () {
        final result = _Example.kind.protobufTreeEncode(value).writeToBuffer();
        expect(result, message);
      });

      test('decode', () {
        final result = _Example.kind.protobufBytesDecode(message);
        expect(result.boolValue, value.boolValue);
        expect(result.boolValueOrNull, value.boolValueOrNull);
        expect(result.int32Value, value.int32Value);
        expect(result.int64Value, value.int64Value);
        expect(result.float32Value, value.float32Value);
        expect(result.float64Value, value.float64Value);
        expect(result.dateTimeValue, value.dateTimeValue);
        expect(result.stringValue, value.stringValue);
        expect(result.bytesValue, value.bytesValue);
        expect(result.example, value.example);
        expect(result, value);
      });
    });
  });
}

class _Example extends Entity {
  static late Prop _boolProp;
  static late Prop _boolOrNullProp;
  static late Prop _uint32Prop;
  static late Prop _uint64Prop;
  static late Prop _int32Prop;
  static late Prop _int64Prop;
  static late Prop _int64FixNumProp;
  static late Prop _float32Prop;
  static late Prop _float64Prop;
  static late Prop _dateTimeProp;
  static late Prop _dateTimeWithTimeZoneProp;
  static late Prop _stringProp;
  static late Prop _bytesProp;
  static late Prop _exampleProp;
  static final EntityKind<_Example> kind = EntityKind<_Example>(
    name: '_Example',
    build: (c) {
      c.constructor = () => _Example();

      _boolProp = c.requiredBool(
        id: 1,
        name: 'boolValue',
        getter: (e) => e.boolValue,
        setter: (e, v) => e.boolValue = v,
      );

      _boolOrNullProp = c.optionalBool(
        id: 2,
        name: 'boolValueOrNull',
        getter: (e) => e.boolValueOrNull,
        setter: (e, v) => e.boolValueOrNull = v,
      );

      _uint32Prop = c.requiredUint32(
        id: 3,
        name: 'uint32Value',
        getter: (e) => e.uint32Value,
        setter: (e, v) => e.uint32Value = v,
      );

      _uint64Prop = c.requiredUint64(
        id: 4,
        name: 'uint64Value',
        getter: (e) => e.uint64Value,
        setter: (e, v) => e.uint64Value = v,
      );

      _int32Prop = c.requiredInt32(
        id: 5,
        name: 'int32Value',
        getter: (e) => e.int32Value,
        setter: (e, v) => e.int32Value = v,
      );

      _int64Prop = c.requiredInt64(
        id: 6,
        name: 'int64Value',
        getter: (e) => e.int64Value,
        setter: (e, v) => e.int64Value = v,
      );

      _int64FixNumProp = c.requiredInt64FixNum(
        id: 7,
        name: 'int64FixNumValue',
        getter: (e) => e.int64FixNumValue,
        setter: (e, v) => e.int64FixNumValue = v,
      );

      _float32Prop = c.requiredFloat32(
        id: 8,
        name: 'float32Value',
        getter: (e) => e.float32Value,
        setter: (e, v) => e.float32Value = v,
      );

      _float64Prop = c.requiredFloat64(
        id: 9,
        name: 'float64Value',
        getter: (e) => e.float64Value,
        setter: (e, v) => e.float64Value = v,
      );

      _dateTimeProp = c.requiredDateTime(
        id: 10,
        name: 'dateTimeValue',
        getter: (e) => e.dateTimeValue,
        setter: (e, v) => e.dateTimeValue = v,
      );

      _dateTimeWithTimeZoneProp = c.requiredDateTimeWithTimeZone(
        id: 11,
        name: 'dateTimeWithTimeZoneValue',
        getter: (e) => e.dateTimeWithTimeZoneValue,
        setter: (e, v) => e.dateTimeWithTimeZoneValue = v,
      );

      _stringProp = c.requiredString(
        id: 12,
        name: 'stringValue',
        getter: (e) => e.stringValue,
        setter: (e, v) => e.stringValue = v,
      );

      _bytesProp = c.requiredBytes(
        id: 13,
        name: 'bytesValue',
        getter: (e) => e.bytesValue,
        setter: (e, v) => e.bytesValue = v,
      );

      _exampleProp = c.optional<_Example?>(
        id: 14,
        name: 'exampleValueOrNull',
        kind: _Example.kind,
        getter: (e) => e.example,
        setter: (e, v) => e.example = v,
      );
    },
  );

  bool boolValue = false;
  bool? boolValueOrNull;
  int uint32Value = 0;
  int uint64Value = 0;
  int int32Value = 0;
  int int64Value = 0;
  Int64 int64FixNumValue = Int64.ZERO;
  double float32Value = 0.0;
  double float64Value = 0.0;
  DateTime dateTimeValue = DateTimeKind.epoch;
  DateTimeWithTimeZone dateTimeWithTimeZoneValue = DateTimeWithTimeZone.epoch;
  String stringValue = '';
  List<int> bytesValue = [];
  _Example? example;

  @override
  EntityKind<Object> getKind() => kind;
}
