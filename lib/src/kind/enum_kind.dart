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

import 'package:collection/collection.dart';
import 'package:kind/kind.dart';
import 'package:meta/meta.dart';
import 'package:protobuf/protobuf.dart' as protobuf;

/// A possible value specified by [EnumKind].
class EnumEntry<T> extends Entity {
  /// [Kind] for [BoolKind].
  ///
  /// The purpose of annotation `@protected` is reducing accidental use.
  @protected
  static final EntityKind<EnumEntry> kind = EntityKind<EnumEntry>(
    name: 'EnumEntry',
    build: (c) {
      final idProp = c.requiredUint64(
        id: 1,
        name: 'id',
      );
      final nameProp = c.requiredString(
        id: 2,
        name: 'name',
      );
      final valueProp = c.required<Object>(
        id: 3,
        name: 'value',
        kind: const ObjectKind(),
      );
      c.constructorFromData = (data) => EnumEntry(
            id: data.get(idProp),
            name: data.get(nameProp),
            value: data.get(valueProp),
          );
    },
  );

  /// ID of the entry. Must be 0 or greater.
  final int id;

  /// Name (for debugging purposes).
  final String name;

  /// Value of the entry.
  final T value;

  EnumEntry({
    required this.id,
    required this.name,
    required this.value,
  });

  @override
  int get hashCode => id;

  @override
  bool operator ==(other) =>
      other is EnumEntry &&
      id == other.id &&
      value == other.value &&
      name == other.name;

  @override
  EntityKind<EnumEntry> getKind() => kind;
}

/// [Kind] for enums (values that have a small number of valid values).
///
/// ## Example
/// ```
/// import 'package:kind/kind.dart';
///
/// const vehicleTypeKind = EnumKind<String>([
///   EnumEntry<String>(
///     id: 1,
///     value: 'car',
///   ),
///   EnumEntry<String>(
///     id: 2,
///     value: 'motorcycle',
///   ),
///   EnumEntry<String>(
///     id: 3,
///     value: 'truck',
///   ),
/// ]);
/// ```
///
/// ## Generating random values
/// You can generate random values with the methods [randomExample()] and
/// [randomExampleList()].
///
class EnumKind<T> extends PrimitiveKind<T> {
  /// [Kind] for [BoolKind].
  ///
  /// The purpose of annotation `@protected` is reducing accidental use.
  @protected
  static final EntityKind<EnumKind> kind = EntityKind<EnumKind>(
    name: 'EnumKind',
    build: (c) {
      final entriesProp = c.requiredList<EnumEntry>(
        id: 1,
        name: 'entries',
        itemsKind: EnumEntry.kind,
      );
      c.constructorFromData = (data) => EnumKind(
            entries: data.get(entriesProp),
          );
    },
  );

  final List<EnumEntry<T>> entries;

  EnumKind({required this.entries}) {
    final entryIds = <int>{};
    final entryNames = <String>{};
    for (var entry in entries) {
      final name = entry.name;
      final id = entry.id;
      if (!entryNames.add(name)) {
        throw StateError('Two (or more) have conflicting name "$name".');
      }
      if (!entryIds.add(id)) {
        throw StateError('Two (or more) have conflicting id "$id".');
      }
    }
  }

  @override
  int get hashCode => (EnumKind).hashCode ^ const ListEquality().hash(entries);

  @override
  String get name => 'Enum';

  @override
  int get protobufFieldType {
    return protobuf.PbFieldType.OS3;
  }

  @override
  EntityKind<EnumKind> getKind() => kind;

  @override
  bool instanceIsValid(Object? value) {
    return value is T && entries.any((element) => element.value == value);
  }

  @override
  T jsonTreeDecode(Object? json, {JsonDecodingContext? context}) {
    if (json is num) {
      final jsonAsInt = json.toInt();
      for (var entry in entries) {
        if (jsonAsInt == entry.id) {
          return entry.value;
        }
      }
      throw ArgumentError.value(json);
    } else {
      context ??= JsonDecodingContext();
      throw context.newGraphNodeError(
        value: json,
        reason: 'Expected JSON number',
      );
    }
  }

  @override
  Object? jsonTreeEncode(T value, {JsonEncodingContext? context}) {
    for (var entry in entries) {
      if (entry.value == value) {
        return entry.id;
      }
    }
    throw ArgumentError.value(value);
  }

  @override
  T newInstance() {
    return entries.first.value;
  }

  List<protobuf.ProtobufEnum> protobufEnums() {
    return entries
        .map((e) => protobuf.ProtobufEnum(e.id, e.name))
        .toList(growable: false);
  }

  @override
  T protobufTreeDecode(Object? value, {ProtobufDecodingContext? context}) {
    if (value is int) {
      for (var entry in entries) {
        if (value == entry.id) {
          return entry.value;
        }
      }
      throw ArgumentError.value(value);
    } else {
      context ??= ProtobufDecodingContext();
      throw context.newUnsupportedTypeError(value);
    }
  }

  @override
  Object? protobufTreeEncode(T instance, {ProtobufEncodingContext? context}) {
    for (var entry in entries) {
      if (entry.value == instance) {
        return entry.id;
      }
    }
    throw ArgumentError.value(instance);
  }

  @override
  T randomExample({RandomExampleContext? context}) {
    context ??= RandomExampleContext();
    return entries[context.random.nextInt(entries.length)].value;
  }
}
