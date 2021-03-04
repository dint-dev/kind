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

/// [Kind] for enums (values that have a small number of valid values).
///
/// ## Example
/// ```
/// import 'package:kind/kind.dart';
///
/// enum VehicleType {
///   car,
///   motorcycle,
///   truck,
/// }
///
/// const vehicleTypeKind = EnumKind<VehicleType>([
///   EnumKindEntry<String>(
///     id: 1,
///     name: 'car',
///     value: VehicleType.car,
///   ),
///   EnumKindEntry<String>(
///     id: 2,
///     name: 'motorcycle',
///     value: VehicleType.motorcycle,
///   ),
///   EnumKindEntry<String>(
///     id: 3,
///     name: 'truck',
///     value: VehicleType.truck,
///   ),
/// ]);
/// ```
///
/// ## Generating random values
/// You can generate random values with the methods [randomExample()] and
/// [randomExampleList()]. All values have equal probability.
///
class EnumKind<T> extends PrimitiveKind<T> {
  /// [Kind] for [BoolKind].
  ///
  /// The purpose of annotation `@protected` is reducing accidental use.
  @protected
  static final EntityKind<EnumKind> kind = EntityKind<EnumKind>(
    name: 'EnumKind',
    build: (c) {
      final nameProp = c.optionalString(
        id: 1,
        name: 'name',
        getter: (t) {
          final value = t.name;
          if (value == 'Enum') {
            return null;
          }
          return value;
        },
      );
      final entriesProp = c.requiredList<EnumKindEntry>(
        id: 2,
        name: 'entries',
        itemsKind: EnumKindEntry.kind,
        getter: (t) => t.entries,
      );
      c.constructorFromData = (data) {
        return EnumKind(
          name: data.get(nameProp) ?? 'Enum',
          entries: data.get(entriesProp),
        );
      };
    },
  );

  final List<EnumKindEntry<T>> entries;

  @override
  final String name;

  EnumKind({this.name = 'Enum', required this.entries}) {
    final entryIds = <int>{};
    final entryNames = <String>{};
    for (var entry in entries) {
      final name = entry.name;
      final id = entry.id;
      if (!entryNames.add(name)) {
        throw StateError('Two (or more) enum entries have name "$name".');
      }
      if (!entryIds.add(id)) {
        throw StateError('Two (or more) enum entries have id "$id".');
      }
    }
  }

  @override
  int get hashCode => (EnumKind).hashCode ^ const ListEquality().hash(entries);

  @override
  int get protobufFieldType {
    return protobuf.PbFieldType.OS3;
  }

  @override
  EntityKind<EnumKind> getKind() => kind;

  @override
  // ignore: invalid_override_of_non_virtual_member
  bool instanceIsValid(Object? value) {
    return value is T && entries.any((element) => element.value == value);
  }

  @override
  void instanceValidateConstraints(ValidateContext context, T value) {
    super.instanceValidateConstraints(context, value);
    for (var entry in entries) {
      if (entry.value == value) {
        return;
      }
    }
    context.invalid(
      value: value,
      message: 'Not one of the valid values.',
    );
  }

  @override
  T jsonTreeDecode(Object? jsonValue, {JsonDecodingContext? context}) {
    if (jsonValue is String) {
      final namer = context?.namer;
      for (var entry in entries) {
        var name = entry.name;
        if (namer != null) {
          name = namer.fromEnumKindEntryName(this, entry, name);
        }
        if (jsonValue == name) {
          return entry.value;
        }
      }
      context ??= JsonDecodingContext();
      throw context.newGraphNodeError(
        value: jsonValue,
        reason: 'Not one of the ${entries.length} supported names.',
      );
    } else {
      context ??= JsonDecodingContext();
      throw context.newGraphNodeError(
        value: jsonValue,
        reason: 'Expected JSON string.',
      );
    }
  }

  @override
  String jsonTreeEncode(T instance, {JsonEncodingContext? context}) {
    for (var entry in entries) {
      if (entry.value == instance) {
        var name = entry.name;
        final namer = context?.namer;
        if (namer != null) {
          return namer.fromEnumKindEntryName(this, entry, name);
        }
        return name;
      }
    }
    context ??= JsonEncodingContext();
    throw context.newGraphNodeError(
      value: instance,
      reason: 'Not one of the ${entries.length} supported values.',
    );
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
  T protobufTreeDecode(Object? protobufValue,
      {ProtobufDecodingContext? context}) {
    if (protobufValue is int) {
      for (var entry in entries) {
        if (protobufValue == entry.id) {
          return entry.value;
        }
      }
      throw ArgumentError.value(
        protobufValue,
        'protobufValue',
        'Not one of the supported enum IDs',
      );
    } else {
      context ??= ProtobufDecodingContext();
      throw context.newUnsupportedTypeError(protobufValue);
    }
  }

  @override
  int protobufTreeEncode(T instance, {ProtobufEncodingContext? context}) {
    for (var entry in entries) {
      if (entry.value == instance) {
        return entry.id;
      }
    }
    throw ArgumentError.value(
      instance,
      'instance',
      'Not one of the supported enum values',
    );
  }

  @override
  T randomExample({RandomExampleContext? context}) {
    context ??= RandomExampleContext();
    return entries[context.random.nextInt(entries.length)].value;
  }
}

/// A possible value specified by [EnumKind].
class EnumKindEntry<T> extends Entity {
  /// [Kind] for [BoolKind].
  ///
  /// The purpose of annotation `@protected` is reducing accidental use.
  @protected
  static final EntityKind<EnumKindEntry> kind = EntityKind<EnumKindEntry>(
    name: 'EnumEntry',
    build: (c) {
      final idProp = c.requiredUint32(
        id: 1,
        name: 'id',
        getter: (t) => t.id,
      );
      final nameProp = c.requiredString(
        id: 2,
        name: 'name',
        getter: (t) => t.name,
      );
      final valueProp = c.required<Object?>(
        id: 3,
        name: 'value',
        kind: const ObjectKind(),
        getter: (t) => t.value,
      );
      c.constructorFromData = (data) => EnumKindEntry(
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

  EnumKindEntry({
    required this.id,
    required this.name,
    required this.value,
  });

  @override
  int get hashCode => id;

  @override
  bool operator ==(other) =>
      other is EnumKindEntry &&
      id == other.id &&
      value == other.value &&
      name == other.name;

  @override
  EntityKind<EnumKindEntry> getKind() => kind;
}
