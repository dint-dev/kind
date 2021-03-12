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
import 'package:kind/src/kind/currency.dart';
import 'package:meta/meta.dart';

/// Superclass for units that DO have fixed conversion formulas.
///
/// For example, [Currency] instances DO NOT have fixed conversion rates.
abstract class ConvertibleUnitOfMeasure<
    T extends ConvertibleUnitOfMeasure<dynamic>> extends UnitOfMeasurement {
  /// Short name such as "m" or "m²".
  final String shortName;

  /// Conversion rate to the standard unit (SI or other).
  final double inStandardUnit;

  @literal
  const ConvertibleUnitOfMeasure.specify({
    required String identifier,
    required this.shortName,
    required this.inStandardUnit,
  }) : super.specify(
          identifier: identifier,
        );

  /// Converts a [Decimal] value to another unit.
  Decimal convertDecimal(Decimal value, {required T to}) {
    final result = convertDouble(value.toDouble(), to: to);
    return Decimal.fromDouble(
      result,
      fractionDigits: value.fractionDigits,
    );
  }

  /// Converts a floating-point to another unit.
  double convertDouble(double value, {required T to}) {
    return (value * inStandardUnit) / to.inStandardUnit;
  }
}

/// Unit of area ([squareMeters], [squareFeet], etc.).
///
/// The predefined values are:
///   * SI units
///     * [squareMeters]
///     * [squareKilometers]
///   * Others
///     * [squareFeet]
///     * [squareMiles]
@sealed
class UnitOfArea extends ConvertibleUnitOfMeasure<UnitOfArea> {
  /// All predefined values.
  static final List<UnitOfArea> values = const [
    squareMeters,
    squareKilometers,
    squareFeet,
    squareMiles,
  ];

  /// Square meters (m²).
  static const UnitOfArea squareMeters = UnitOfArea._specify(
    identifier: 'squareMeters',
    shortName: 'm²',
    inStandardUnit: 1,
  );

  /// Square kilometers (km²).
  static const UnitOfArea squareKilometers = UnitOfArea._specify(
    identifier: 'squareKilometers',
    shortName: 'km²',
    inStandardUnit: 1000000.0,
  );

  /// Square feet (sqft).
  static const UnitOfArea squareFeet = UnitOfArea._specify(
    identifier: 'squareFeet',
    shortName: 'sqft',
    inStandardUnit: 0.09290304,
  );

  /// Square miles (sqmi).
  static const UnitOfArea squareMiles = UnitOfArea._specify(
    identifier: 'squareMiles',
    shortName: 'sqmi',
    inStandardUnit: 2589988.110336,
  );

  const UnitOfArea._specify({
    required String identifier,
    required String shortName,
    required double inStandardUnit,
  }) : super.specify(
          identifier: identifier,
          shortName: shortName,
          inStandardUnit: inStandardUnit,
        );
}

/// Unit of length ([meter], [feet], etc.).
///
/// The predefined values are:
///   * SI units
///     * [millimeters]
///     * [centimeters]
///     * [meters]
///     * [kilometers]
///   * Others
///     * [inches]
///     * [feet]
///     * [miles]
///     * [nauticalMiles]
@sealed
class UnitOfLength extends ConvertibleUnitOfMeasure<UnitOfLength> {
  /// All predefined values.
  static final List<UnitOfLength> values = const [
    millimeters,
    centimeters,
    meters,
    kilometers,
    inches,
    feet,
    miles,
    nauticalMiles,
  ];

  /// Millimeters (mm).
  static const UnitOfLength millimeters = UnitOfLength._specify(
    identifier: 'millimeters',
    shortName: 'mm',
    inStandardUnit: 0.001,
  );

  /// Centimeters (cm).
  static const UnitOfLength centimeters = UnitOfLength._specify(
    identifier: 'centimeters',
    shortName: 'cm',
    inStandardUnit: 0.01,
  );

  /// Meters (m).
  static const UnitOfLength meters = UnitOfLength._specify(
    identifier: 'meters',
    shortName: 'm',
    inStandardUnit: 1.0,
  );

  /// Kilometers (km).
  static const UnitOfLength kilometers = UnitOfLength._specify(
    identifier: 'kilometers',
    shortName: 'km',
    inStandardUnit: 1000,
  );

  /// Inches (in).
  static const UnitOfLength inches = UnitOfLength._specify(
    identifier: 'inches',
    shortName: 'in',
    inStandardUnit: 0.0254,
  );

  /// Feet (ft).
  static const UnitOfLength feet = UnitOfLength._specify(
    identifier: 'feet',
    shortName: 'ft',
    inStandardUnit: 0.3048,
  );

  /// Miles (mi).
  static const UnitOfLength miles = UnitOfLength._specify(
    identifier: 'miles',
    shortName: 'mi',
    inStandardUnit: 1609.344,
  );

  /// Nautical miles (nmi).
  static const UnitOfLength nauticalMiles = UnitOfLength._specify(
    identifier: 'nauticalMiles',
    shortName: 'nmi',
    inStandardUnit: 1852,
  );

  const UnitOfLength._specify({
    required String identifier,
    required String shortName,
    required double inStandardUnit,
  }) : super.specify(
          identifier: identifier,
          shortName: shortName,
          inStandardUnit: inStandardUnit,
        );
}

/// Unit of measurement (kilogram, meter, feet, etc.).
///
/// # Subclasses
///   * [Currency]
///   * [ConvertibleUnitOfMeasure]
///     * [UnitOfArea]
///     * [UnitOfLength]
///     * [UnitOfTemperature]
///     * [UnitOfVolume]
///     * [UnitOfWeight]
///
/// # Defining your own unit
/// ```
/// import 'package:kind/kind.dart';
///
/// const UnitOfMeasurement exampleUnit = UnitOfMeasurement(
///   name: 'example',
/// );
/// ```
///
/// # Usage in numeric kinds
/// Subclasses of [NumericKind] support defining unit of measurement:
/// ```
/// import 'package:kind/kind.dart';
///
/// const Float64Kind travelDistanceKind = Float64Kind(
///   unitOfMeasurement: UnitOfLength.meters,
///   min: 0.0,
/// );
/// ```
class UnitOfMeasurement implements Comparable<UnitOfMeasurement> {
  static final Kind<UnitOfMeasurement> kind =
      CompositePrimitiveKind<UnitOfMeasurement, String>.simple(
    name: 'UnitOfMeasurement',
    primitiveKind: const StringKind(maxLengthInUtf8: 32),
    fromPrimitive: (name) {
      for (var value in values) {
        if (value.identifier == name) {
          return value;
        }
      }
      return UnitOfMeasurement.specify(identifier: name);
    },
    toPrimitive: (unit) => unit.identifier,
  );

  /// All default units.
  static final List<UnitOfMeasurement> values =
      List<UnitOfMeasurement>.unmodifiable([
    ...UnitOfArea.values,
    ...UnitOfLength.values,
    ...UnitOfTemperature.values,
    ...UnitOfVolume.values,
    ...UnitOfWeight.values,
  ]);

  /// Identifier of the constant.
  final String identifier;

  const UnitOfMeasurement.specify({required this.identifier});

  @override
  int get hashCode => identifier.hashCode;

  @override
  bool operator ==(other) =>
      other is UnitOfMeasurement && identifier == other.identifier;

  @override
  int compareTo(UnitOfMeasurement other) {
    return identifier.compareTo(other.identifier);
  }

  @override
  String toString() => 'UnitOfMeasure(identifier: "$identifier", ...)';
}

/// Unit of temperature.
///
/// The predefined values are:
///   * SI units
///     * [celsius]
///     * [kelvin]
///   * Others
///     * [fahrenheit]
/// All predefined values.
@sealed
class UnitOfTemperature extends ConvertibleUnitOfMeasure<UnitOfTemperature> {
  /// All declared values.
  static final List<UnitOfTemperature> values = const [
    celsius,
    kelvin,
    fahrenheit,
  ];

  /// Celsius (ºC).
  static const UnitOfTemperature celsius = UnitOfTemperature._specify(
    identifier: 'celsius',
    shortName: 'ºC',
    zeroInStandardUnit: 273.15,
    rateToStandardUnit: 1.0,
  );

  /// Kelvin (K).
  static const UnitOfTemperature kelvin = UnitOfTemperature._specify(
    identifier: 'kelvin',
    shortName: 'K',
    zeroInStandardUnit: 0.0,
    rateToStandardUnit: 1.0,
  );

  /// Fahrenheit (ºF).
  static const UnitOfTemperature fahrenheit = UnitOfTemperature._specify(
    identifier: 'fahrenheit',
    shortName: 'ºF',
    zeroInStandardUnit: 255.372,
    rateToStandardUnit: 5 / 9,
  );

  final double zeroInStandardUnit;

  const UnitOfTemperature._specify({
    required String identifier,
    required String shortName,
    required this.zeroInStandardUnit,
    required double rateToStandardUnit,
  }) : super.specify(
          identifier: identifier,
          shortName: shortName,
          inStandardUnit: rateToStandardUnit,
        );

  @override
  Decimal convertDecimal(
    Decimal value, {
    required UnitOfTemperature to,
  }) {
    final result = convertDouble(value.toDouble(), to: to);
    return Decimal.fromDouble(
      result,
      fractionDigits: value.fractionDigits,
    );
  }

  @override
  double convertDouble(double value, {required UnitOfTemperature to}) {
    final inKelvin = value * inStandardUnit + zeroInStandardUnit;
    return (inKelvin - to.zeroInStandardUnit) / to.inStandardUnit;
  }
}

/// Unit of volume ([cubicMeters], [liters], etc.).
///
/// The predefined values are:
///   * SI units
///     * [cubicMeters]
///     * [liters] (cubic desimeters)
@sealed
class UnitOfVolume extends ConvertibleUnitOfMeasure<UnitOfVolume> {
  /// All predefined values.
  static final List<UnitOfVolume> values = const [
    cubicMeters,
    liters,
  ];

  /// Cubic meters (m³).
  static const UnitOfVolume cubicMeters = UnitOfVolume._specify(
    identifier: 'cubicMeters',
    shortName: 'm³',
    inStandardUnit: 1,
  );

  /// Liters (L).
  static const UnitOfVolume liters = UnitOfVolume._specify(
    identifier: 'liters',
    shortName: 'L',
    inStandardUnit: 0.001,
  );

  const UnitOfVolume._specify({
    required String identifier,
    required String shortName,
    required double inStandardUnit,
  }) : super.specify(
          identifier: identifier,
          shortName: shortName,
          inStandardUnit: inStandardUnit,
        );
}

/// Unit of weight ([kilograms], [pounds], etc.).
///
/// The predefined values are:
///   * SI units
///     * [grams]
///     * [kilograms]
///   * Others
///     * [ounces]
///     * [pounds]
@sealed
class UnitOfWeight extends ConvertibleUnitOfMeasure<UnitOfWeight> {
  /// All predefined values.
  static final List<UnitOfWeight> values = const [
    grams,
    kilograms,
    ounces,
    pounds,
  ];

  /// Grams (g).
  static const UnitOfWeight grams = UnitOfWeight._specify(
    identifier: 'grams',
    shortName: 'g',
    inStandardUnit: 0.001,
  );

  /// Kilograms (kg).
  static const UnitOfWeight kilograms = UnitOfWeight._specify(
    identifier: 'kilograms',
    shortName: 'kg',
    inStandardUnit: 1.0,
  );

  /// Ounces (oz).
  static const UnitOfWeight ounces = UnitOfWeight._specify(
    identifier: 'ounces',
    shortName: 'oz',
    inStandardUnit: 0.0283495,
  );

  /// Pounds (lbs).
  static const UnitOfWeight pounds = UnitOfWeight._specify(
    identifier: 'pounds',
    shortName: 'lbs',
    inStandardUnit: 0.453592,
  );

  const UnitOfWeight._specify({
    required String identifier,
    required String shortName,
    required double inStandardUnit,
  }) : super.specify(
          identifier: identifier,
          shortName: shortName,
          inStandardUnit: inStandardUnit,
        );
}
