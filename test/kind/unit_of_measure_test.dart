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
  group('UnitOfArea', () {
    test('converting', () {
      final converted = UnitOfArea.squareMiles.convertDouble(
        2.0,
        to: UnitOfArea.squareFeet,
      );
      expect((converted / 1000).round(), 55757);
    });

    test('squareMeters', () {
      const unit = UnitOfArea.squareMeters;
      expect(unit.identifier, 'squareMeters');
      expect(unit.inStandardUnit, 1.0);
    });

    test('squareFeet', () {
      const unit = UnitOfArea.squareFeet;
      expect(unit.identifier, 'squareFeet');
      expect(unit.inStandardUnit, 0.09290304);
    });
  });

  group('UnitOfTemperature', () {
    test('celsius', () {
      const unit = UnitOfTemperature.celsius;
      expect(unit.identifier, 'celsius');
      expect(unit.inStandardUnit, 1.0);
      expect(unit.zeroInStandardUnit, 273.15);
    });

    test('kelvin', () {
      const unit = UnitOfTemperature.kelvin;
      expect(unit.identifier, 'kelvin');
      expect(unit.inStandardUnit, 1.0);
      expect(unit.zeroInStandardUnit, 0.0);
    });

    test('fahrenheit', () {
      const unit = UnitOfTemperature.fahrenheit;
      expect(unit.identifier, 'fahrenheit');
      expect(unit.inStandardUnit, 5 / 9);
      expect(unit.zeroInStandardUnit, 255.372);
    });

    group('convertDouble(...):', () {
      test('-5 celsius --> kelvin', () {
        expect(
          UnitOfTemperature.celsius.convertDouble(
            -5.0,
            to: UnitOfTemperature.kelvin,
          ),
          268.15,
        );
      });

      test('-5 celsius --> celsius', () {
        expect(
          UnitOfTemperature.celsius.convertDouble(
            -5.0,
            to: UnitOfTemperature.celsius,
          ),
          -5.0,
        );
      });

      test('0 kelvin --> fahrenheit', () {
        expect(
          UnitOfTemperature.kelvin
              .convertDouble(
                0.0,
                to: UnitOfTemperature.fahrenheit,
              )
              .round(),
          -460,
        );
      });

      test('0 fahrenheit --> kelvin', () {
        expect(
          UnitOfTemperature.fahrenheit.convertDouble(
            0.0,
            to: UnitOfTemperature.kelvin,
          ),
          255.372,
        );
      });

      test('-5 celsius --> fahrenheit', () {
        expect(
          UnitOfTemperature.celsius
              .convertDouble(
                -5.0,
                to: UnitOfTemperature.fahrenheit,
              )
              .round(),
          23,
        );
      });
    });
    group('convertDecimal(...):', () {
      test('-5 celsius --> fahrenheit', () {
        expect(
          UnitOfTemperature.celsius.convertDecimal(
            Decimal.fromDouble(-5.0, fractionDigits: 2),
            to: UnitOfTemperature.fahrenheit,
          ),
          Decimal.fromDouble(23, fractionDigits: 2),
        );
      });
    });
  });

  group('UnitOfLength', () {
    test('millimeters', () {
      const unit = UnitOfLength.millimeters;
      expect(unit.identifier, 'millimeters');
      expect(unit.inStandardUnit, 0.001);
      expect(unit.convertDouble(50.0, to: UnitOfLength.meters), 0.05);
    });

    test('centimeters', () {
      const unit = UnitOfLength.centimeters;
      expect(unit.identifier, 'centimeters');
      expect(unit.inStandardUnit, 0.01);
      expect(unit.convertDouble(50.0, to: UnitOfLength.meters), 0.5);
    });

    test('meters', () {
      const unit = UnitOfLength.meters;
      expect(unit.identifier, 'meters');
      expect(unit.inStandardUnit, 1.0);
      expect(unit.convertDouble(5.0, to: UnitOfLength.meters), 5.0);
    });

    test('kilometers', () {
      const unit = UnitOfLength.kilometers;
      expect(unit.identifier, 'kilometers');
      expect(unit.inStandardUnit, 1000.0);
      expect(unit.convertDouble(0.1, to: UnitOfLength.meters), 100.0);
    });

    test('inches', () {
      const unit = UnitOfLength.inches;
      expect(unit.identifier, 'inches');
      expect(unit.inStandardUnit, 0.0254);
    });

    test('feet', () {
      const unit = UnitOfLength.feet;
      expect(unit.identifier, 'feet');
      expect(unit.inStandardUnit, 0.3048);
    });

    test('miles', () {
      const unit = UnitOfLength.miles;
      expect(unit.identifier, 'miles');
      expect(unit.inStandardUnit, 1609.344);
    });
  });

  group('UnitOfVolume', () {
    test('converting', () {
      final converted = UnitOfVolume.cubicMeters.convertDouble(
        2.0,
        to: UnitOfVolume.liters,
      );
      expect(converted, 2000.0);
    });

    test('cubicMeters', () {
      const unit = UnitOfVolume.cubicMeters;
      expect(unit.identifier, 'cubicMeters');
      expect(unit.inStandardUnit, 1.0);
    });

    test('liters', () {
      const unit = UnitOfVolume.liters;
      expect(unit.identifier, 'liters');
      expect(unit.inStandardUnit, 0.001);
    });
  });

  group('UnitOfWeight', () {
    test('converting', () {
      final converted = UnitOfWeight.grams.convertDouble(
        10.0,
        to: UnitOfWeight.ounces,
      );
      expect((converted - 0.35274).abs(), lessThan(0.00001));
    });

    test('grams', () {
      const unit = UnitOfWeight.grams;
      expect(unit.identifier, 'grams');
      expect(unit.inStandardUnit, 0.001);
    });

    test('kilograms', () {
      const unit = UnitOfWeight.kilograms;
      expect(unit.identifier, 'kilograms');
      expect(unit.inStandardUnit, 1.0);
    });

    test('ounces', () {
      const unit = UnitOfWeight.ounces;
      expect(unit.identifier, 'ounces');
      expect(unit.inStandardUnit, 0.0283495);
    });

    test('pounds', () {
      const unit = UnitOfWeight.pounds;
      expect(unit.identifier, 'pounds');
      expect(unit.inStandardUnit, 0.453592);
    });
  });
}
