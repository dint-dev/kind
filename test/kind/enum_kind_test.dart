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
  group('EnumKind', () {
    test('== / hashCode', () {
      final object = EnumKind(
        entries: [
          EnumKindEntry(
            id: 1,
            name: 'entry1',
            value: 'value1',
          ),
          EnumKindEntry(
            id: 2,
            name: 'entry2',
            value: 'value2',
          ),
        ],
      );
      final clone = EnumKind(
        entries: [
          EnumKindEntry(
            id: 1,
            name: 'entry1',
            value: 'value1',
          ),
          EnumKindEntry(
            id: 2,
            name: 'entry2',
            value: 'value2',
          ),
        ],
      );
      final other0 = EnumKind(
        entries: [
          EnumKindEntry(
            id: 99999,
            name: 'entry1',
            value: 'value1',
          ),
          EnumKindEntry(
            id: 2,
            name: 'entry2',
            value: 'value2',
          ),
        ],
      );
      final other1 = EnumKind(
        entries: [
          EnumKindEntry(
            id: 1,
            name: 'OTHER',
            value: 'value1',
          ),
          EnumKindEntry(
            id: 2,
            name: 'entry2',
            value: 'value2',
          ),
        ],
      );
      final other2 = EnumKind(
        entries: [
          EnumKindEntry(
            id: 1,
            name: 'entry1',
            value: 'OTHER',
          ),
          EnumKindEntry(
            id: 2,
            name: 'entry2',
            value: 'value2',
          ),
        ],
      );

      expect(object, clone);
      expect(object, isNot(other0));
      expect(object, isNot(other1));
      expect(object, isNot(other2));

      expect(object.hashCode, clone.hashCode);
      expect(object.hashCode, isNot(other0.hashCode));
      // expect(value.hashCode, isNot(other1.hashCode));
      // expect(value.hashCode, isNot(other2.hashCode));
    });

    test('JSON encoding', () {
      final kind = EnumKind(
        entries: [
          EnumKindEntry(
            id: 1,
            name: 'entry1',
            value: 'value1',
          ),
          EnumKindEntry(
            id: 2,
            name: 'entry2',
            value: 'value2',
          ),
        ],
      );
      try {
        kind.jsonTreeEncode('OTHER');
        fail('Should have thrown');
      } on GraphNodeError catch (e) {
        expect(e.name, 'JSON serialization error');
        expect(e.reason, 'Not one of the 2 supported values.');
      }
      expect(
        kind.jsonTreeEncode('value1'),
        'entry1',
      );
      expect(
        kind.jsonTreeEncode('value2'),
        'entry2',
      );
    });

    test('JSON decoding', () {
      final kind = EnumKind(
        entries: [
          EnumKindEntry(
            id: 1,
            name: 'entry1',
            value: 'value1',
          ),
          EnumKindEntry(
            id: 2,
            name: 'entry2',
            value: 'value2',
          ),
        ],
      );
      try {
        kind.jsonTreeDecode(null);
        fail('Should have thrown');
      } on GraphNodeError catch (e) {
        expect(e.name, 'JSON deserialization error');
        expect(e.reason, 'Expected JSON string.');
      }
      try {
        kind.jsonTreeDecode('OTHER');
        fail('Should have thrown');
      } on GraphNodeError catch (e) {
        expect(e.name, 'JSON deserialization error');
        expect(e.reason, 'Not one of the 2 supported names.');
      }
      expect(
        kind.jsonTreeDecode('entry1'),
        'value1',
      );
      expect(
        kind.jsonTreeDecode('entry2'),
        'value2',
      );
    });

    test('validation', () {
      final kind = EnumKind(
        entries: [
          EnumKindEntry<DateTime>(
            id: 1,
            name: 'entry1',
            value: DateTime(2020),
          ),
          EnumKindEntry(
            id: 2,
            name: 'entry2',
            value: 'value2',
          ),
        ],
      );

      // Invalid values
      expect(kind.instanceIsValid(null), isFalse);
      expect(kind.instanceIsValid(DateTime(2019)), isFalse);
      expect(kind.instanceIsValid(''), isFalse);

      // Valid values
      expect(kind.instanceIsValid(DateTime(2020)), isTrue);
      expect(kind.instanceIsValid('value2'), isTrue);

      // Throwing calls
      expect(
        () => kind.instanceValidateOrThrow(null),
        throwsA(isA<ValidationError>()),
      );
      expect(
        () => kind.instanceValidateOrThrow(DateTime(2019)),
        throwsA(isA<ValidationError>()),
      );
      expect(
        () => kind.instanceValidateOrThrow(''),
        throwsA(isA<ValidationError>()),
      );

      // Non-throwing calls
      kind.instanceValidateOrThrow(DateTime(2020));
      kind.instanceValidateOrThrow('value2');
    });

    test('randomExample', () {
      final kind = EnumKind(
        entries: [
          EnumKindEntry<DateTime>(
            id: 1,
            name: 'entry1',
            value: DateTime(2020),
          ),
          EnumKindEntry(
            id: 2,
            name: 'entry2',
            value: 'value2',
          ),
        ],
      );
      final set = kind.randomExampleList(1000).toSet();
      expect(set, {DateTime(2020), 'value2'});
    });
  });
}
