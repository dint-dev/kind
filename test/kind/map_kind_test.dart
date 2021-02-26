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
  group('MapKind', () {
    test('== / hashCode', () {
      // Helper for eliminating suggestions to use constants.
      final two = 2;

      final value = MapKind(
        StringKind(minLengthInUtf8: two),
        StringKind(minLengthInUtf8: two),
      );
      final clone = MapKind(
        StringKind(minLengthInUtf8: two),
        StringKind(minLengthInUtf8: two),
      );
      final other0 = MapKind(
        StringKind(minLengthInUtf8: two, maxLengthInUtf8: 9999),
        StringKind(minLengthInUtf8: two),
      );
      final other1 = MapKind(
        StringKind(minLengthInUtf8: two),
        StringKind(minLengthInUtf8: two, maxLengthInUtf8: 9999),
      );

      expect(value, clone);
      expect(value, isNot(other0));
      expect(value, isNot(other1));

      expect(value.hashCode, clone.hashCode);
      expect(value.hashCode, isNot(other0.hashCode));
      expect(value.hashCode, isNot(other1.hashCode));
    });

    test('jsonTreeDecode', () {
      const kind = MapKind(
        DateKind(),
        GeoPointKind(),
      );
      final jsonTree = {
        '2020-01-01': {'lat': 1.5, 'lng': 2.5},
      };
      final expectedDartTree = {
        Date(2020, 1, 1): GeoPoint(1.5, 2.5),
      };
      final actualDartTree = kind.jsonTreeDecode(jsonTree);
      expect(actualDartTree, expectedDartTree);
    });

    test('jsonTreeEncode', () {
      const kind = MapKind(
        DateKind(),
        GeoPointKind(),
      );
      final dartTree = {
        Date(2020, 1, 1): GeoPoint(1.5, 2.5),
      };
      final expectedJsonTree = {
        '2020-01-01': {'lat': 1.5, 'lng': 2.5},
      };
      final actualJsonTree = kind.jsonTreeEncode(dartTree);
      expect(actualJsonTree, expectedJsonTree);
    });
  });
}
