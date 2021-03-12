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
import 'package:meta/meta.dart';
import 'package:protobuf/protobuf.dart' as protobuf;

/// [Kind] for [GeoPoint].
///
///
/// ## Serialization
/// ### JSON
/// ```json
/// {
///   "lat": 1.2,
///   "lng": 3.4
/// }
/// ```
///
/// ### Protocol Buffers / GRPC
/// Protocol Buffers is unsupported at the moment.
///
/// ## Generating random values
/// You can generate random values with the methods [randomExample()] and
/// [randomExampleList()].
///
/// Currently the methods return points near the following cities:
///   * San Francisco
///   * London
///   * Sydney
///
/// This is an implementation detail that could be changed in future.
@sealed
class GeoPointKind extends PrimitiveKind<GeoPoint> {
  /// [Kind] for [GeoPointKind].
  ///
  /// The purpose of annotation `@protected` is reducing accidental use.
  @protected
  static final EntityKind<GeoPointKind> kind = EntityKind<GeoPointKind>(
    name: 'GeoPointKind',
    define: (c) {
      c.constructor = () => const GeoPointKind();
    },
  );

  static final List<GeoPoint> _examples = [
    GeoPoint(37.7749, -122.4194), // San Francisco
    GeoPoint(51.5074, -0.1278), // London
    GeoPoint(-33.8688, 151.2093), // Sydney
  ];

  @literal
  const GeoPointKind();

  @override
  int get bitsPerListElement => 2 * 32;

  @override
  List<GeoPoint> get declaredExamples {
    return _examples;
  }

  @override
  int get hashCode => (GeoPointKind).hashCode;

  @override
  String get name => 'GeoPoint';

  @override
  int get protobufFieldType {
    return protobuf.PbFieldType.M;
  }

  @override
  bool operator ==(other) {
    return other is GeoPointKind;
  }

  @override
  EntityKind<GeoPointKind> getKind() => kind;

  @override
  GeoPoint jsonTreeDecode(Object? json, {JsonDecodingContext? context}) {
    if (json is Map) {
      final latitude = json['lat'] as double;
      final longitude = json['lng'] as double;
      return GeoPoint(latitude, longitude);
    } else {
      context ??= JsonDecodingContext();
      throw context.newGraphNodeError(
        value: json,
        reason: 'Expected JSON object.',
      );
    }
  }

  @override
  Object? jsonTreeEncode(GeoPoint value, {JsonEncodingContext? context}) {
    return {'lat': value.latitude, 'lng': value.longitude};
  }

  @override
  GeoPoint newInstance() {
    return GeoPoint.zero;
  }

  @override
  GeoPoint protobufTreeDecode(Object? value,
      {ProtobufDecodingContext? context}) {
    throw UnimplementedError();
  }

  @override
  Object protobufTreeEncode(GeoPoint value,
      {ProtobufEncodingContext? context}) {
    throw UnimplementedError();
  }

  @override
  GeoPoint randomExample({RandomExampleContext? context}) {
    context ??= RandomExampleContext();
    final random = context.random;
    final base = _examples[random.nextInt(_examples.length)];
    return GeoPoint(
      base.latitude + random.nextDouble() - 0.5,
      base.longitude + random.nextDouble() - 0.5,
    );
  }

  @override
  String toString() {
    return 'GeoPointKind()';
  }
}
