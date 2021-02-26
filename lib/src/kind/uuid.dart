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
import 'dart:typed_data';

/// UUID is an universally unique 128-bit identifier.
///
/// UUID has [canonicalString], which is 36 characters long string that contains
/// 32 lower-case hexadecimal digits grouped with 4 dashes ("-"). For instance,
/// "f81d4fae-7dec-11d0-a765-00a0c91e6bf6" is a canonical representation of
/// UUID.
///
/// ## Serialization
///   * In JSON, UUID is a string in the canonical form.
///   * In Protocol Buffers, UUID is 16 bytes.
///
class Uuid extends Comparable<Uuid> {
  /// UUID "00000000-0000-0000-0000-000000000000".
  static final Uuid zero = Uuid('00000000-0000-0000-0000-000000000000');

  static final _regExp =
      RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$');

  /// Canonical string such as "f81d4fae-7dec-11d0-a765-00a0c91e6bf6".
  final String canonicalString;

  UnmodifiableUint8ListView? _bytes;

  /// Constructs UUID from string.
  ///
  /// ## Example
  /// ```
  /// import 'package:kind/kind.dart';
  ///
  /// final uuid = Uuid('f81d4fae-7dec-11d0-a765-00a0c91e6bf6');
  /// ```
  Uuid(String s) : canonicalString = s {
    if (s.length != 36 || !_regExp.hasMatch(s)) {
      throw ArgumentError.value(s, 's', 'Not a valid UUID');
    }
  }

  /// Constructs UUID from bytes.
  ///
  /// ## Example
  /// ```
  /// import 'package:kind/kind.dart';
  ///
  /// final uuid = Uuid.fromBytes([0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]);
  /// ```
  factory Uuid.fromBytes(List<int> bytes) {
    if (bytes.length != 16) {
      throw ArgumentError.value(bytes);
    }
    final uint8List = bytes is UnmodifiableUint8ListView
        ? bytes
        : UnmodifiableUint8ListView(Uint8List.fromList(bytes));
    final sb = StringBuffer();
    for (var i = 0; i < bytes.length; i++) {
      if (i == 4 || i == 6 || i == 8 || i == 10) {
        sb.write('-');
      }
      sb.write(uint8List[i].toRadixString(16).padLeft(2, '0'));
    }
    return Uuid(sb.toString()).._bytes = uint8List;
  }

  @override
  int get hashCode => canonicalString.hashCode;

  @override
  bool operator ==(Object other) =>
      other is Uuid && canonicalString == other.canonicalString;

  @override
  int compareTo(Uuid other) {
    return canonicalString.compareTo(other.canonicalString);
  }

  /// Returns 16 bytes of the UUID.
  UnmodifiableUint8ListView toBytes() {
    final existingBytes = _bytes;
    if (existingBytes != null) {
      return existingBytes;
    }
    final bytes = Uint8List(16);
    var bytesIndex = 0;
    final canonicalString = this.canonicalString;
    for (var i = 0; i < canonicalString.length; i += 2) {
      if (i == 8 || i == 13 || i == 18 || i == 23) {
        i--;
        continue;
      }
      bytes[bytesIndex] = int.parse(
        canonicalString.substring(i, i + 2),
        radix: 16,
      );
      bytesIndex++;
    }
    final unmodifiableBytes = UnmodifiableUint8ListView(bytes);
    _bytes = unmodifiableBytes;
    return unmodifiableBytes;
  }

  @override
  String toString() => "Uuid('$canonicalString')";

  /// Returns uniformly random UUID.
  ///
  /// ## Example
  /// ```
  /// import 'package:kind/kind.dart';
  ///
  /// final uuid = Uuid.random();
  /// ```
  static Uuid random({Random? random}) {
    random ??= Random.secure();
    final bytes = Uint8List(16);
    for (var i = 0; i < bytes.length; i++) {
      bytes[i] = random.nextInt(0x100);
    }
    return Uuid.fromBytes(UnmodifiableUint8ListView(bytes));
  }
}
