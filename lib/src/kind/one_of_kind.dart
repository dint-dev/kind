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

/// [Kind] for polymorphic values.
///
/// ## Example
/// ```
/// const contactKind = OneOfKind<Contact>(
///   discriminatorName: 'type',
///   entries: [
///     OneOfKindEntry<Contact>(
///       id: 1,
///       name: 'Person',
///       kind: PersonContact.kind,
///     ),
///     OneOfKindEntry<Contact>(
///       id: 2,
///       name: 'Company',
///       kind: CompanyContact.kind,
///     ),
///   ],
/// );
/// ```
///
/// ## JSON serialization
/// ### With discriminator
/// In this approach, you define a non-null [discriminatorName].
/// For instance, let's use discriminator "type". Then the output will look like
/// the following:
/// ```json
/// {
///   "type": "Person",
///   "name": "John Doe"
/// }
/// ```
///
/// ### Without discriminator
/// If [discriminatorName] is null, the output will look like:
/// ```json
/// {
///   "Person": {
///     "name": "John Doe"
///   }
/// }
/// ```
@sealed
class OneOfKind<T> extends Kind<T> {
  /// [Kind] for [OneOfKind].
  ///
  /// The purpose of annotation `@protected` is reducing accidental use.
  @protected
  static final EntityKind<OneOfKind> kind = EntityKind<OneOfKind>(
    name: 'OneOfKind',
    build: (c) {
      final entries = c.requiredList<OneOfKindEntry>(
        id: 1,
        name: 'entries',
        itemsKind: OneOfKindEntry.kind_,
        getter: (t) => t.entries,
      );
      final discriminatorName = c.optionalString(
        id: 2,
        name: 'discriminatorName',
        getter: (t) => t.discriminatorName,
      );
      final primitiveValueName = c.optionalString(
        id: 3,
        name: 'primitiveValueName',
        getter: (t) => t.primitiveValueName,
      );
      c.constructorFromData = (data) {
        return OneOfKind(
          entries: data.get(entries),
          discriminatorName: data.get(discriminatorName),
          primitiveValueName: data.get(primitiveValueName),
        );
      };
    },
  );

  /// Possible kinds.
  final List<OneOfKindEntry<T>> entries;

  /// Discriminator name.
  final String? discriminatorName;

  /// Property for primitive values.
  ///
  /// Ignored if [discriminatorName] is null.
  final String? primitiveValueName;

  OneOfKind({
    required this.entries,
    this.discriminatorName,
    this.primitiveValueName,
  }) {
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
  int get hashCode => (OneOfKind).hashCode ^ discriminatorName.hashCode;

  @override
  String get name => 'OneOf';

  @override
  int get protobufFieldType {
    throw UnimplementedError();
  }

  OneOfKindEntry<T>? getEntry(T value) {
    for (var entry in entries) {
      if (entry.kind.instanceIsCorrectType(value)) {
        return entry;
      }
    }
    return null;
  }

  @override
  EntityKind<OneOfKind> getKind() => kind;

  @override
  bool instanceIsDefaultValue(Object? value) {
    return entries.first.kind.instanceIsDefaultValue(value);
  }

  @override
  void instanceValidateConstraints(ValidateContext context, T value) {
    super.instanceValidateConstraints(context, value);
    for (var entry in entries) {
      if (entry.kind.instanceIsValid(value)) {
        return;
      }
    }
    for (var entry in entries) {
      entry.kind.instanceValidate(context, value);
    }
  }

  @override
  T jsonTreeDecode(Object? json, {JsonDecodingContext? context}) {
    if (json == null) {
      final result = null;
      if (result is T) {
        return result;
      }
    }
    context ??= JsonDecodingContext();
    if (entries.isEmpty) {
      throw context.newGraphNodeError(
        value: json,
        reason: 'OneOfKind does not have entries',
      );
    }
    if (json is! Map) {
      throw context.newGraphNodeError(
        value: json,
        reason: 'Expected JSON object.',
      );
    }
    final discriminatorName =
        this.discriminatorName ?? context.jsonSettings.defaultDiscriminatorName;
    if (!json.containsKey(discriminatorName)) {
      throw context.newGraphNodeError(
        value: json,
        reason:
            'JSON object does not have discriminator property "$discriminatorName".',
      );
    }
    final discriminatorValue = json[discriminatorName];
    if (discriminatorValue is! String) {
      context.pathEdges.add(discriminatorName);
      throw context.newGraphNodeError(
        value: json,
        reason:
            'Expected JSON object discriminator property "$discriminatorName" to be JSON string.',
      );
    }
    final namer = context.namer;
    for (var entry in entries) {
      var name = entry.name;
      if (namer != null) {
        name = namer.fromName(name);
      }
      if (name == discriminatorValue) {
        final kind = entry.kind;
        if (kind is PrimitiveKind) {
          final primitiveValueName = this.primitiveValueName ?? 'value';
          final valueJson = json[primitiveValueName];
          if (valueJson == null) {
            throw context.newGraphNodeError(
              value: json,
              reason: 'JSON object is missing property "$primitiveValueName".',
            );
          }
          return kind.jsonTreeDecode(valueJson);
        }
        return context.decode(json, kind: entry.kind);
      }
    }
    context.pathEdges.add(discriminatorName);
    throw context.newGraphNodeError(
      value: discriminatorValue,
      reason:
          'Expected JSON object discriminator property "$discriminatorName" value "$primitiveValueName" to be one of the following:\n'
          '  * "${entries.map((e) => e.name).join('"\n  * "')}"\n',
    );
  }

  @override
  Object? jsonTreeEncode(T value, {JsonEncodingContext? context}) {
    context ??= JsonEncodingContext();
    final entry = getEntry(value);
    if (entry == null) {
      throw context.newGraphNodeError(
        value: value,
        reason: 'Values of the given type are unsupported.',
      );
    }
    final json = context.encode(
      value,
      kind: entry.kind,
    );
    final discriminatorName =
        this.discriminatorName ?? context.jsonSettings.defaultDiscriminatorName;
    var discriminatorValue = entry.name;
    var namer = context.namer;
    if (namer != null) {
      discriminatorValue = namer.fromName(discriminatorValue);
    }
    if (json is Map && entry.kind is! PrimitiveKind) {
      json[discriminatorName] = discriminatorValue;
      return json;
    } else {
      final defaultValueName =
          primitiveValueName ?? context.jsonSettings.defaultValueName;
      return <String, Object?>{
        discriminatorName: discriminatorValue,
        defaultValueName: json,
      };
    }
  }

  @override
  T newInstance() {
    final Object? object = null;
    if (object is T) {
      return object;
    }
    return entries.first.kind.newInstance();
  }

  @override
  T protobufTreeDecode(Object? value, {ProtobufDecodingContext? context}) {
    throw UnimplementedError();
  }

  @override
  Object? protobufTreeEncode(T instance, {ProtobufEncodingContext? context}) {
    throw UnimplementedError();
  }

  @override
  T randomExample({RandomExampleContext? context}) {
    context ??= RandomExampleContext();
    final entry = entries[context.random.nextInt(entries.length)];
    return entry.kind.randomExample(context: context);
  }
}

/// Entry in [OneOfKind].
class OneOfKindEntry<T> {
  /// [Kind] for [OneOfKindEntry].
  ///
  /// The purpose of annotation `@protected` is reducing accidental use.
  @protected
  static final Kind<OneOfKindEntry> kind_ = EntityKind<OneOfKindEntry>(
    name: 'OneOfKindEntry',
    build: (c) {
      final idProp = c.requiredUint64(
        id: 1,
        name: 'id',
        getter: (t) => t.id,
      );
      final nameProp = c.requiredString(
        id: 2,
        name: 'name',
        getter: (t) => t.name,
      );
      final kindProp = c.required<Kind>(
        id: 3,
        name: 'kind',
        kind: Kind.kind,
        getter: (t) => t.kind,
      );
      c.constructorFromData = (data) => OneOfKindEntry(
            id: data.get(idProp),
            name: data.get(nameProp),
            kind: data.get(kindProp),
          );
    },
  );

  /// Numeric ID of this kind. Used in Protocol Buffers serialization.
  final int id;

  /// Name of this kind. Used in JSON serialization.
  final String name;

  /// Kind.
  final Kind<T> kind;

  OneOfKindEntry({
    required this.id,
    required this.name,
    required this.kind,
  });

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ kind.hashCode;

  @override
  bool operator ==(other) =>
      other is OneOfKindEntry &&
      id == other.id &&
      name == other.name &&
      kind == other.kind;
}
