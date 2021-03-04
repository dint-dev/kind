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

import 'dart:typed_data';

import 'package:kind/kind.dart';
import 'package:protobuf/protobuf.dart' as protobuf;
import 'package:test/test.dart';

void main() {
  group('Float64Kind', () {
    test('Float64Kind.kind', () {
      // ignore: invalid_use_of_protected_member
      final kind = Float64Kind.kind;
      expect(kind.name, 'Float64Kind');
      expect(
        kind.jsonTreeEncode(const Float64Kind()),
        {},
      );
      expect(
        kind.jsonTreeEncode(const Float64Kind(specialValues: true)),
        {'specialValues': true},
      );
      expect(
        kind.jsonTreeEncode(const Float64Kind(min: 2.0)),
        {'min': 2.0},
      );
      expect(
        kind.jsonTreeEncode(const Float64Kind(min: 2.0, exclusiveMin: true)),
        {'min': 2.0, 'exclusiveMin': true},
      );
      expect(
        kind.jsonTreeEncode(const Float64Kind(max: 2.0)),
        {'max': 2.0},
      );
      expect(
        kind.jsonTreeEncode(const Float64Kind(max: 2.0, exclusiveMax: true)),
        {'max': 2.0, 'exclusiveMax': true},
      );
    });

    test('name', () {
      expect(const Float64Kind().name, 'Float64');
    });

    test('toString()', () {
      expect(const Float64Kind().toString(), 'Float64Kind()');
    });

    test('== / hashCode', () {
      const two = 2.0;
      const three = 3.0;
      // ignore: non_const_call_to_literal_constructor
      final object = Float64Kind(
        min: two,
        max: three,
      );
      final clone = const Float64Kind(
        min: two,
        max: three,
      );
      final other0 = const Float64Kind(
        specialValues: true,
        min: two,
        max: three,
      );
      final other1 = const Float64Kind(
        min: two + 9999.0,
        max: three,
      );
      final other2 = const Float64Kind(
        min: two,
        max: three + 9999.0,
      );
      final other3 = const Float64Kind(
        min: two,
        max: three,
        exclusiveMin: true,
      );
      final other4 = const Float64Kind(
        min: two,
        max: three,
        exclusiveMax: true,
      );

      expect(object, clone);
      expect(object, isNot(other0));
      expect(object, isNot(other1));
      expect(object, isNot(other2));
      expect(object, isNot(other3));
      expect(object, isNot(other4));

      expect(object.hashCode, clone.hashCode);
      expect(object.hashCode, isNot(other0.hashCode));
      expect(object.hashCode, isNot(other1.hashCode));
      expect(object.hashCode, isNot(other2.hashCode));
      expect(object.hashCode, isNot(other3.hashCode));
      expect(object.hashCode, isNot(other4.hashCode));
    });

    test('newInstance()', () {
      expect(const Float64Kind().newInstance(), 0.0);
    });

    test('newList(reactive:false)', () {
      final list = const Float64Kind().newList(2, reactive: false);
      expect(list, isA<Float64List>());
      expect(list, hasLength(2));
    });

    test('protobufFieldType', () {
      expect(
        const Float64Kind().protobufFieldType,
        protobuf.PbFieldType.OD,
      );
    });
  });
}
