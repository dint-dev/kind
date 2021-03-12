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

import 'dart:math';

import 'package:kind/kind.dart';
import 'package:meta/meta.dart';

/// A geographic point on Earth.
///
/// Latitude and longitude should be between -180.0 (inclusive) and 180.0
/// (inclusive).
///
/// ## Example
/// ```
/// import 'package:kind/kind.dart';
///
/// final sanFrancisco = GeoPoint(37.7749, -122.4194);
/// final london = GeoPoint(51.5074, -0.1278);
/// final distance = sanFrancisco.distanceTo(london);
/// final distanceInMiles = sanFrancisco.distanceTo(london, unitOfLength: UnitOfLength.miles);
/// ```
@sealed
class GeoPoint implements Comparable<GeoPoint> {
  /// GeoPoint(0.0, 0.0).
  static final GeoPoint zero = GeoPoint(0.0, 0.0);

  /// Latitude. Should be in the range -180.0 <= value <= 180.0.
  final double latitude;

  /// Longitude. Should be in the range -180.0 <= value <= 180.0.
  final double longitude;

  /// Constructs a geographical point with latitude and longitude.
  ///
  /// ## Example
  /// ```dart
  /// final sanFrancisco = GeoPoint(37.7749, -122.4194);
  /// ```
  GeoPoint(this.latitude, this.longitude) {
    if (!(latitude.isFinite && latitude >= -180.0 && latitude <= 180.0)) {
      throw ArgumentError.value(latitude, 'latitude');
    }
    if (!(longitude.isFinite && longitude >= -180.0 && longitude <= 180.0)) {
      throw ArgumentError.value(longitude, 'longitude');
    }
  }

  @override
  int get hashCode => latitude.hashCode << 2 ^ longitude.hashCode;

  @override
  bool operator ==(other) =>
      other is GeoPoint &&
      latitude == other.latitude &&
      longitude == other.longitude;

  @override
  int compareTo(GeoPoint other) {
    var r = latitude.compareTo(other.latitude);
    if (r != 0) {
      return r;
    }
    return longitude.compareTo(other.longitude);
  }

  /// Calculates distance to another geographical point.
  ///
  /// ## Example
  /// ```dart
  /// final sanFrancisco = GeoPoint(37.7749, -122.4194);
  /// final london = GeoPoint(51.5074, -0.1278);
  ///
  /// // Meters
  /// final distance = london.distanceTo(sanFrancisco);
  ///
  /// // Miles
  /// final distanceInMiles = london.distanceTo(
  ///   sanFrancisco,
  ///   unitOfLength: UnitOfLength.miles,
  /// );
  /// ```
  double distanceTo(GeoPoint other,
      {UnitOfLength unitOfLength = UnitOfLength.meters}) {
    final lat0 = _toRadians(latitude);
    final lon0 = _toRadians(longitude);
    final lat1 = _toRadians(other.latitude);
    final lon1 = _toRadians(other.longitude);
    final dlon = lon1 - lon0;
    final dlat = lat1 - lat0;
    final a = pow(sin(dlat / 2), 2.0) +
        cos(lat0) * cos(lat1) * pow(sin(dlon / 2), 2.0);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    const _radius = 6378137.0;
    return UnitOfLength.meters.convertDouble(c * _radius, to: unitOfLength);
  }

  @override
  String toString() => 'GeoPoint($latitude, $longitude)';

  static double _toRadians(double value) => (value / 180) * pi;
}
