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
  group('GeoPoint:', () {
    final sanFrancisco = GeoPoint(37.7749, -122.4194);
    final london = GeoPoint(51.5074, -0.1278);
    final sydney = GeoPoint(-33.8688, 151.2093);

    test('"==" / hashCode', () {
      final value = GeoPoint(1.2, 3.4);
      final clone = GeoPoint(1.2, 3.4);
      final other0 = GeoPoint(1.2, 3); // Other latitude
      final other1 = GeoPoint(1, 3.4); // Other longitude
      expect(value, clone);
      expect(value, isNot(other0));
      expect(value, isNot(other1));
      expect(value.hashCode, clone.hashCode);
      expect(value.hashCode, isNot(other0.hashCode));
      expect(value.hashCode, isNot(other1.hashCode));
    });

    test('distanceTo(..): London - London --> 0 km', () {
      expect(london.distanceTo(london), 0);
    });

    test('distanceTo(..): London - San Francisco --> 8,626 km', () {
      // London - San Francisco
      expect(london.distanceTo(sanFrancisco) ~/ 1000, 8626);

      // San Francisco - London
      expect(sanFrancisco.distanceTo(london) ~/ 1000, 8626);

      // With unit parameter
      final explicitlyInKm = sanFrancisco.distanceTo(
        london,
        unitOfLength: UnitOfLength.kilometers,
      );
      expect(explicitlyInKm.round(), 8626);
    });

    test('distanceTo(..): San Francisco - Sydney --> 11,961 km', () {
      // San Francisco - Sydney
      expect(sanFrancisco.distanceTo(sydney) ~/ 1000, 11961);

      // Sydney - San Francisco
      expect(sydney.distanceTo(sanFrancisco) ~/ 1000, 11961);
    });
  });
}
