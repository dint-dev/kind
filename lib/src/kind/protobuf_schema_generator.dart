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

/// Generates a Protocol Buffers schema file from a set of [EntityKind] values.
///
/// ## Example
/// ```
/// import 'dart:io';
/// import 'package:kind/kind.dart';
/// import 'package:kind/protobuf_encoding_and_decoding.dart';
///
/// void main() {
///   final generator = ProtocolBuffersSchemaGenerator(
///     kinds: <Kind>{
///       MyKind,
///     },
///   );
///   final source = generate();
///
///   final file = File('example.proto');
///   file.createSync();
///   file.writeAsStringSync(source);
/// }
/// ```
class ProtocolBuffersSchemaGenerator {
  final Set<EntityKind> kinds;

  ProtocolBuffersSchemaGenerator({required this.kinds});

  String generate() {
    final sortedKinds = kinds.toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    final sb = StringBuffer();
    for (var kind in sortedKinds) {
      sb.writeln('message ${kind.name} {');
      for (var prop in kind.props) {
        sb.write('  ');
        sb.write(typeName(prop.kind));
        sb.write(' ');
        sb.write(prop.name);
        sb.write(' = ');
        sb.write(prop.id);
        sb.writeln(';');
      }
      sb.writeln('}');
      sb.writeln();
    }
    return sb.toString();
  }

  String typeName(Kind kind) {
    if (kind is BoolKind) {
      return 'bool';
    }
    if (kind is Uint8Kind) {
      return 'uint8';
    }
    if (kind is Uint16Kind) {
      return 'uint16';
    }
    if (kind is Uint32Kind) {
      return 'uint32';
    }
    if (kind is Uint64Kind) {
      return 'uint64';
    }
    if (kind is Int8Kind) {
      return 'sint8';
    }
    if (kind is Int16Kind) {
      return 'sint16';
    }
    if (kind is Int32Kind) {
      return 'sint32';
    }
    if (kind is Int64Kind) {
      return 'sint64';
    }
    if (kind is Int64FixNumKind) {
      if (kind.unsigned) {
        if (kind.fixed) {
          return 'fixed64';
        } else {
          return 'uint64';
        }
      } else {
        if (kind.fixed) {
          return 'sfixed64';
        } else {
          return 'sint64';
        }
      }
    }
    if (kind is Float32Kind) {
      return 'float32';
    }
    if (kind is Float64Kind) {
      return 'float64';
    }
    if (kind is DateKind) {
      return 'string';
    }
    if (kind is DateTimeKind) {
      return 'DateTimeWithTimeZone';
    }
    if (kind is DateTimeWithTimeZoneKind) {
      return 'DateTimeWithTimeZone';
    }
    if (kind is GeoPointKind) {
      return 'GeoPoint';
    }
    if (kind is StringKind) {
      return 'string';
    }
    if (kind is BytesKind) {
      return 'bytes';
    }
    if (kind is ListKind) {
      return 'repeated ${typeName(kind.itemsKind)}';
    }
    if (kind is SetKind) {
      return 'repeated ${typeName(kind.itemsKind)}';
    }
    if (kind is EntityKind) {
      return kind.name;
    }
    throw ArgumentError.value(kind);
  }
}
