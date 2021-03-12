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
import 'package:test/test.dart';

void main() {
  group('EntityKindDefineContext:', () {
    late EntityKindDefineContext builder;
    setUp(() {
      builder = EntityKindDefineContext();
    });

    test('optionalBool()', () {
      final prop = builder.optionalBool(
        id: 2,
        name: 'x',
        getter: (t) => throw UnimplementedError(),
      );
      expect(prop.id, 2);
      expect(prop.name, 'x');
      expect(prop.kind, const NullableKind(BoolKind()));
    });

    test('optionalUint32()', () {
      final prop = builder.optionalUint32(
        id: 2,
        name: 'x',
        getter: (t) => throw UnimplementedError(),
      );
      expect(prop.id, 2);
      expect(prop.name, 'x');
      expect(prop.kind, const NullableKind(Uint32Kind()));
      expect(builder.propList, hasLength(1));
      expect(builder.propList.single, same(prop));
    });

    test('optionalUint64()', () {
      final prop = builder.optionalUint64(
        id: 2,
        name: 'x',
        getter: (t) => throw UnimplementedError(),
      );
      expect(prop.id, 2);
      expect(prop.name, 'x');
      expect(prop.kind, const NullableKind(Uint64Kind()));
      expect(builder.propList, hasLength(1));
      expect(builder.propList.single, same(prop));
    });

    test('optionalInt32()', () {
      final prop = builder.optionalInt32(
        id: 2,
        name: 'x',
        getter: (t) => throw UnimplementedError(),
      );
      expect(prop.id, 2);
      expect(prop.name, 'x');
      expect(prop.kind, const NullableKind(Int32Kind()));
      expect(builder.propList, hasLength(1));
      expect(builder.propList.single, same(prop));
    });

    test('optionalInt64()', () {
      final prop = builder.optionalInt64(
        id: 2,
        name: 'x',
        getter: (t) => throw UnimplementedError(),
      );
      expect(prop.id, 2);
      expect(prop.name, 'x');
      expect(prop.kind, const NullableKind(Int64Kind()));
      expect(builder.propList, hasLength(1));
      expect(builder.propList.single, same(prop));
    });

    test('optionalFloat32()', () {
      final prop = builder.optionalFloat32(
        id: 2,
        name: 'x',
        getter: (t) => throw UnimplementedError(),
      );
      expect(prop.id, 2);
      expect(prop.name, 'x');
      expect(prop.kind, const NullableKind(Float32Kind()));
      expect(builder.propList, hasLength(1));
      expect(builder.propList.single, same(prop));
    });

    test('optionalFloat64()', () {
      final prop = builder.optionalFloat64(
        id: 2,
        name: 'x',
        getter: (t) => throw UnimplementedError(),
      );
      expect(prop.id, 2);
      expect(prop.name, 'x');
      expect(prop.kind, const NullableKind(Float64Kind()));
      expect(builder.propList, hasLength(1));
      expect(builder.propList.single, same(prop));
    });

    test('optionalDate()', () {
      final prop = builder.optionalDate(
        id: 2,
        name: 'x',
        getter: (t) => throw UnimplementedError(),
      );
      expect(prop.id, 2);
      expect(prop.name, 'x');
      expect(prop.kind, const NullableKind(DateKind()));
      expect(builder.propList, hasLength(1));
      expect(builder.propList.single, same(prop));
    });

    test('optionalDateTime()', () {
      final prop = builder.optionalDateTime(
        id: 2,
        name: 'x',
        getter: (t) => throw UnimplementedError(),
      );
      expect(prop.id, 2);
      expect(prop.name, 'x');
      expect(prop.kind, const NullableKind(DateTimeKind()));
      expect(builder.propList, hasLength(1));
      expect(builder.propList.single, same(prop));
    });

    test('optionalDateTimeWithTimeZone()', () {
      final prop = builder.optionalDateTimeWithTimeZone(
        id: 2,
        name: 'x',
        getter: (t) => throw UnimplementedError(),
      );
      expect(prop.id, 2);
      expect(prop.name, 'x');
      expect(prop.kind, const NullableKind(DateTimeWithTimeZoneKind()));
      expect(builder.propList, hasLength(1));
      expect(builder.propList.single, same(prop));
    });

    test('optionalString()', () {
      final prop = builder.optionalString(
        id: 2,
        name: 'x',
        getter: (t) => throw UnimplementedError(),
      );
      expect(prop.id, 2);
      expect(prop.name, 'x');
      expect(prop.kind, const NullableKind(StringKind()));
      expect(builder.propList, hasLength(1));
      expect(builder.propList.single, same(prop));
    });

    test('optionalBytes()', () {
      final prop = builder.optionalBytes(
        id: 2,
        name: 'x',
        getter: (t) => throw UnimplementedError(),
      );
      expect(prop.id, 2);
      expect(prop.name, 'x');
      expect(prop.kind, const NullableKind(BytesKind()));
      expect(builder.propList, hasLength(1));
      expect(builder.propList.single, same(prop));
    });

    test('optionalList()', () {
      final prop = builder.optionalList(
        id: 2,
        name: 'x',
        itemsKind: const StringKind(),
        getter: (t) => throw UnimplementedError(),
      );
      expect(prop.id, 2);
      expect(prop.name, 'x');
      expect(prop.kind, const NullableKind(ListKind(StringKind())));
      expect(builder.propList, hasLength(1));
      expect(builder.propList.single, same(prop));
    });

    test('optionalSet()', () {
      final prop = builder.optionalSet(
        id: 2,
        name: 'x',
        itemsKind: const StringKind(),
        getter: (t) => throw UnimplementedError(),
      );
      expect(prop.id, 2);
      expect(prop.name, 'x');
      expect(prop.kind, const NullableKind(SetKind(StringKind())));
      expect(builder.propList, hasLength(1));
      expect(builder.propList.single, same(prop));
    });

    test('conflicting IDs are prevented', () {
      builder.optionalBool(
        id: 1,
        name: 'name',
        getter: (t) => throw UnimplementedError(),
      );
      expect(
        () => builder.optionalBool(
          id: 1,
          name: 'some other name',
          getter: (t) => throw UnimplementedError(),
        ),
        throwsStateError,
      );
    });

    test('conflicting names are prevented', () {
      builder.optionalBool(
        id: 1,
        name: 'name',
        getter: (t) => throw UnimplementedError(),
      );
      expect(
        () => builder.optionalBool(
          id: 2,
          name: 'name',
          getter: (t) => throw UnimplementedError(),
        ),
        throwsStateError,
      );
    });

    test('`getter` or `field` must be defined', () {
      expect(
        () => builder.optionalBool(
          id: 1,
          name: 'failure',
        ),
        throwsArgumentError,
      );
      builder.optionalBool(
        id: 2,
        name: 'succeedsWithGetter',
        getter: (t) => throw UnimplementedError(),
      );
      builder.optionalBool(
        id: 3,
        name: 'succeedsWithField',
        field: (t) => throw UnimplementedError(),
      );
    });
  });
}
