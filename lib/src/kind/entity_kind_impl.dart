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

import 'package:fixnum/fixnum.dart' show Int64;
import 'package:kind/kind.dart';
import 'package:protobuf/protobuf.dart' as protobuf;

/// NOT EXPORTED.
class EntityKindImpl<T extends Object> extends EntityKind<T> {
  @override
  final String name;

  @override
  final String? packageName;

  @override
  final List<KindMeaning> meanings;

  @override
  final EntityKind? extendsKind;

  @override
  final List<EntityKind> withKinds;

  late KeyProps? _primaryKeyDefinition;

  void Function(EntityKindBuilder<T> builder)? _buildFunction;

  T Function()? _constructor;

  T Function(EntityData entityData)? _constructorFromEntityData;

  List<T>? _examples;

  protobuf.BuilderInfo? _protobufBuilderInfo;

  List<Prop<T, Object?>>? _props;

  bool _isBuilding = false;

  EntityKindImpl({
    required this.name,
    this.packageName,
    this.meanings = const [],
    this.extendsKind,
    this.withKinds = const [],
    required void Function(EntityKindBuilder<T> builder) build,
  })   : _buildFunction = build,
        super.constructor();

  @override
  List<T> get declaredExamples {
    _buildOnce();
    return _examples!;
  }

  @override
  KeyProps? get primaryKeyProps {
    _buildOnce();
    return _primaryKeyDefinition;
  }

  @override
  List<Prop<T, Object?>> get props {
    _buildOnce();
    return _props!;
  }

  @override
  int get protobufFieldType {
    return protobuf.PbFieldType.OM;
  }

  @override
  bool instanceEquals(T left, Object right, {GraphEquality? context}) {
    try {
      if (right is! T) {
        return false;
      }
      for (var prop in props) {
        final leftValue = prop.get(left);
        final rightValue = prop.get(right);
        if (leftValue == null ||
            leftValue is bool ||
            leftValue is num ||
            leftValue is String ||
            leftValue is Date ||
            leftValue is DateTime ||
            leftValue is DateTimeWithTimeZone) {
          if (leftValue != rightValue) {
            return false;
          }
        } else {
          context ??= GraphEquality();
          if (!context.equals(leftValue, rightValue)) {
            return false;
          }
        }
      }
      return true;
    } catch (e) {
      throw throw StateError('EntityKind.instanceEquals(...) failed: $e');
    }
  }

  @override
  int instanceHash(T instance) {
    var h = 0;
    for (var prop in props) {
      final kind = prop.kind;
      if (kind is BoolKind ||
          kind is NumericKind ||
          kind is DateTimeKind ||
          kind is DateTimeWithTimeZoneKind ||
          kind is StringKind ||
          kind is BytesKind) {
        h ^= prop.get(instance).hashCode;
      }
    }
    return h;
  }

  @override
  String instanceToString(T instance) {
    _buildOnce();
    final sb = StringBuffer();
    sb.write(name);
    sb.write('()\n');
    for (var prop in props) {
      sb.write('..');
      sb.write(prop.name);
      sb.write(' = ');
      final value = prop.get(instance);
      if (value == null || value is bool || value is num) {
        sb.write(value);
      } else if (value is DateTime) {
        sb.write('DateTime.parse(\'');
        sb.write(value.toIso8601String());
        sb.write('\')\n');
      } else if (value is DateTimeWithTimeZone) {
        sb.write('DateTimeWithTimeZone.parse(\'');
        sb.write(value.toIso8601String());
        sb.write('\')\n');
      } else if (value is String) {
        if (value.length < 80) {
          sb.write('\'');
          sb.write(value.replaceAll(r'\', r'\\').replaceAll('\n', r'\n'));
          sb.write('\'');
        } else {
          sb.write('<< string with ');
          sb.write(value.runes.length);
          sb.write(' Unicode runes >>');
        }
      } else {
        sb.write('<< ');
        sb.write(value.runtimeType);
        sb.write(' >>');
      }
      sb.write('\n');
    }
    return sb.toString();
  }

  @override
  T jsonTreeDecode(Object? json, {JsonDecodingContext? context}) {
    _buildOnce();
    context ??= JsonDecodingContext();
    if (json is Map) {
      final constructorFromEntityData = _constructorFromEntityData;
      if (constructorFromEntityData == null) {
        final result = newInstance();

        // For each property...
        for (var prop in props) {
          final jsonKey = prop.name;

          // Property does not exist (in the JSON object)?
          if (!json.containsKey(jsonKey)) {
            // We don't need to set default value.
            // (because `newInstance()` already took care of it.)
            continue;
          }

          // Property exists
          final jsonValue = json[jsonKey];
          final dartValue = context.decode(jsonValue, kind: prop.kind);
          prop.set(result, dartValue);
        }

        return result;
      } else {
        final entityData = EntityData();

        for (var prop in props) {
          final jsonKey = prop.name;

          // Property does not exist (in the JSON object)?
          if (!json.containsKey(jsonKey)) {
            // Set default value?
            final defaultValue = prop.defaultValue;
            if (defaultValue != null) {
              entityData.set(prop, defaultValue);
            }
            continue;
          }

          // Property exists
          final jsonValue = json[jsonKey];
          final dartValue = context.decode(jsonValue, kind: prop.kind);
          entityData.set(prop, dartValue);
        }

        return constructorFromEntityData(entityData);
      }
    } else {
      throw context.newGraphNodeError(
        value: json,
        reason: 'Expected JSON object.',
      );
    }
  }

  @override
  Map<String, Object?> jsonTreeEncode(T value, {JsonEncodingContext? context}) {
    _buildOnce();
    context ??= JsonEncodingContext();
    context.enter(value);
    try {
      final result = <String, Object?>{};
      for (var prop in props) {
        final dartValue = prop.get(value);
        final jsonValue = context.encode(dartValue, kind: prop.kind);
        result[prop.name] = jsonValue;
      }
      return result;
    } finally {
      context.leave();
    }
  }

  @override
  T newFromData(EntityData data) {
    _buildOnce();
    final constructorFromData = _constructorFromEntityData;
    late T result;
    if (constructorFromData != null) {
      result = constructorFromData(data);
    } else {
      result = newInstance();
    }
    for (var prop in props) {
      if (prop.isMutable) {
        final propValue = data.get(prop);
        prop.set(result, propValue);
      }
    }
    return result;
  }

  @override
  T newInstance() {
    _buildOnce();
    final constructor = _constructor;
    if (constructor != null) {
      // Construct instance.
      //
      // We don't need to initialize with default property values because
      // the constructor takes care of it.
      return constructor();
    }
    final constructorFromEntityData = _constructorFromEntityData;
    if (constructorFromEntityData != null) {
      // We don't need to initialize with default property values because
      // entityData.get(prop, value) will take care of it.
      final entityData = EntityData();
      return constructorFromEntityData(entityData);
    }
    throw StateError('Kind `$name` does not have constructor');
  }

  @override
  protobuf.BuilderInfo protobufBuilderInfo() {
    _buildOnce();
    return _protobufBuilderInfo ??= _newProtobufBuilderInfo();
  }

  @override
  T protobufBytesDecode(List<int> bytes, {ProtobufDecodingContext? context}) {
    final generatedMessage = _GeneratedMessageImpl(protobufBuilderInfo());
    generatedMessage.mergeFromBuffer(bytes);
    return protobufTreeDecode(generatedMessage, context: context);
  }

  @override
  protobuf.GeneratedMessage protobufNewInstance() =>
      _GeneratedMessageImpl(protobufBuilderInfo());

  @override
  T protobufTreeDecode(Object? protobufObject,
      {ProtobufDecodingContext? context}) {
    _buildOnce();
    context ??= ProtobufDecodingContext();
    if (protobufObject is! protobuf.GeneratedMessage) {
      throw ArgumentError.value(
          protobufObject, 'protobufObject', 'Expected GeneratedMessage');
    }
    final generatedMessage = protobufObject;
    final constructorFromEntityData = _constructorFromEntityData;
    if (constructorFromEntityData == null) {
      // Construct an instance.
      final result = newInstance();

      // For each property...
      for (var prop in props) {
        // Property does not exist?
        if (!generatedMessage.hasField(prop.id)) {
          // We don't need to set default value.
          // (because `newInstance()` already took care of it.)
          continue;
        }

        // Property exists
        final propKind = prop.kind;
        final propValueAsProtobufValue = generatedMessage.getField(
          prop.id,
        );
        final propValue = context.decode(
          propValueAsProtobufValue,
          kind: propKind,
        );
        prop.set(result, propValue);
      }
      return result;
    } else {
      final entityData = EntityData();

      // For each property...
      for (var prop in props) {
        // Property does not exist?
        if (!generatedMessage.hasField(prop.id)) {
          // Set default value?
          final defaultValue = prop.defaultValue;
          if (defaultValue != null) {
            entityData.set(prop, defaultValue);
          }
          continue;
        }

        // Property exists
        final propKind = prop.kind;
        final propValueAsProtobufValue = generatedMessage.getField(
          prop.id,
        );
        final propValue = context.decode(
          propValueAsProtobufValue,
          kind: propKind,
        );
        entityData.set(prop, propValue);
      }

      return constructorFromEntityData(entityData);
    }
  }

  @override
  protobuf.GeneratedMessage protobufTreeEncode(T instance,
      {ProtobufEncodingContext? context}) {
    _buildOnce();
    context ??= ProtobufEncodingContext();
    final info = protobufBuilderInfo();
    final generatedMessage = _GeneratedMessageImpl(info);
    for (var prop in props) {
      final propValue = prop.get(instance);
      if (prop.kind.instanceIsDefaultValue(propValue)) {
        continue;
      }
      var propValueAsProtobufValue = context.encode(
        propValue,
        kind: prop.kind,
      );
      if (propValueAsProtobufValue != null) {
        final type = info.byIndex[prop.id - 1].type;
        final value = _valueToProtobufValue(
          propValueAsProtobufValue,
          pbType: type,
        );
        generatedMessage.setField(prop.id, value);
      }
    }
    return generatedMessage;
  }

  @override
  T randomExample({RandomExampleContext? context}) {
    _buildOnce();
    context ??= RandomExampleContext();
    context.nonPrimitivesCount++;
    context.depth++;
    try {
      // Is it possible that the class is immutable?
      final constructorFromEntityData = _constructorFromEntityData;
      if (constructorFromEntityData != null) {
        // Yes, the class may be immutable.
        //
        // Construct EntityData.
        final entityData = EntityData();

        // Mutate each property in EntityData.
        for (var prop in props) {
          final propValue = prop.kind.randomExample(context: context);
          entityData.set(prop, propValue);
        }

        // Construct instance using the EntityData.
        return newFromData(entityData);
      }

      // No, the class is definitely not immutable.
      //
      // Construct a new default instance.
      final result = newInstance();

      // Mutate each property.
      for (var prop in props) {
        if (prop.isMutable) {
          final propValue = prop.kind.randomExample(context: context);
          prop.set(result, propValue);
        }
      }

      // Return the instance
      return result;
    } finally {
      context.depth--;
    }
  }

  @override
  String toString({bool props = false}) {
    return '$name.kind';
  }

  void _buildOnce() {
    final buildFunction = _buildFunction;
    if (buildFunction == null) {
      return;
    }
    if (_isBuilding) {
      throw StateError('Infinite recursion');
    }
    _isBuilding = true;
    try {
      final builder = EntityKindBuilder<T>();
      try {
        buildFunction(builder);
      } catch (e) {
        throw StateError('Building kind "$name" failed: $e');
      }
      for (var prop in builder.propList) {
        // ignore: invalid_use_of_protected_member
        prop.declaredByKind = this;
      }
      _props = List<Prop<T, Object?>>.unmodifiable(builder.propList);
      _constructor = builder.constructor;
      _constructorFromEntityData = builder.constructorFromData;
      _examples = builder.declaredExamples;
      _protobufBuilderInfo = builder.protobufBuilderInfo;
      _primaryKeyDefinition = builder.primaryKeyProps;
      _buildFunction = null;
    } finally {
      _isBuilding = false;
    }
    try {
      // Check whether the developer made an infinite initialization error.
      final cycle = _findInitializationCycle([], [], this);
      if (cycle != null) {
        throw StateError(
          'Kind "$name" has an instance initialization cycle ("$cycle") that would lead to stack overflow if `kind.newInstance()` was called.'
          ' You can fix this by using `NullableKind` so the initial value will be null.',
        );
      }
    } catch (e) {
      _buildFunction = buildFunction;
      rethrow;
    }
  }

  String? _findInitializationCycle(
    List stack,
    List<String> propCycle,
    Kind kind,
  ) {
    // Only the following kinds can cause initialization cycle:
    //   * Non-nullable EntityKind
    //   * OneOfKind where the default value can cause initialization cycle.
    //
    // For example, ListKind enables reference cycle, but not initialization
    // cycle (the initial value is an empty list).
    if (kind is EntityKind) {
      for (var item in stack) {
        if (identical(item, kind)) {
          return '/${propCycle.join('/')}';
        }
      }
      stack.add(kind);
      for (var prop in kind.props) {
        propCycle.add(prop.name);
        final result = _findInitializationCycle(stack, propCycle, prop.kind);
        if (result != null) {
          return result;
        }
        propCycle.removeLast();
      }
      stack.removeLast();
      return null;
    } else if (kind is OneOfKind) {
      return _findInitializationCycle(
          stack, propCycle, kind.entries.first.kind);
    } else {
      return null;
    }
  }

  protobuf.BuilderInfo _newProtobufBuilderInfo(
      {ProtobufBuilderInfoContext? context}) {
    _buildOnce();
    context ??= ProtobufBuilderInfoContext();
    final packageName = this.packageName;
    final info = protobuf.BuilderInfo(
      name,
      createEmptyInstance: () {
        return _GeneratedMessageImpl<T>(
          protobufBuilderInfo(),
        );
      },
      package: packageName == null
          ? const protobuf.PackageName('')
          : protobuf.PackageName(packageName),
    );

    for (var prop in props) {
      final id = prop.id;
      final name = prop.name;
      var repeated = false;
      final originalPropKind = prop.kind;
      Kind propKind = originalPropKind;
      if (propKind is ListKind) {
        propKind = propKind.itemsKind;
        repeated = true;
      } else if (propKind is SetKind) {
        propKind = propKind.itemsKind;
        repeated = true;
      }
      if (propKind is NullableKind) {
        if (repeated) {
          throw UnsupportedError(
              'Iterables of nullable values are unsupported in Protocol Buffers');
        }
        propKind = propKind.wrapped;
      }
      final pbType = propKind.protobufFieldType;
      protobuf.CreateBuilderFunc? createBuilderFunc;
      final finalKind = propKind;
      if (pbType == protobuf.PbFieldType.OM ||
          pbType == protobuf.PbFieldType.PM) {
        createBuilderFunc = () {
          return finalKind.protobufNewInstance() as protobuf.GeneratedMessage;
        };
      }
      protobuf.ValueOfFunc? valueOfFunc;
      List<protobuf.ProtobufEnum>? protobufEnums;
      if (propKind is EnumKind) {
        protobufEnums = propKind.protobufEnums();
      }
      try {
        if (repeated) {
          info.addRepeated(
            id,
            name,
            pbType,
            (x) {},
            createBuilderFunc,
            valueOfFunc,
            protobufEnums,
            protoName: name,
          );
        } else {
          info.add(
            id,
            name,
            pbType,
            createBuilderFunc != null ? null : finalKind.protobufNewInstance(),
            createBuilderFunc,
            valueOfFunc,
            protobufEnums,
            protoName: name,
          );
        }
      } catch (e) {
        throw StateError(
            'Constructing Protocol Buffers BuildInfo failed because of: $prop\nError: $e');
      }
    }
    return info;
  }

  static Object _valueToProtobufValue(Object value, {required int pbType}) {
    switch (pbType) {
      // case protobuf.PbFieldType.OB:
      //   if (value is bool) {
      //     return value ? 1 : 0;
      //   }
      //   break;
      //
      // case protobuf.PbFieldType.PB:
      //   if (value is List) {
      //     return value.map((e) => e ? 1 : 0).toList();
      //   }
      //   break;

      case protobuf.PbFieldType.O6:
        continue int64Case;

      int64Case:
      case protobuf.PbFieldType.OS6:
        if (value is num) {
          return Int64(value.toInt());
        }
        break;

      case protobuf.PbFieldType.P6:
        continue int64ListCase;

      int64ListCase:
      case protobuf.PbFieldType.PS6:
        if (value is List) {
          return value.map((e) => Int64(e)).toList();
        }
        break;
    }
    return value;
  }
}

/// Minimal implementation of [protobuf.GeneratedMessage].
class _GeneratedMessageImpl<T extends Object>
    extends protobuf.GeneratedMessage {
  @override
  // ignore: invalid_use_of_protected_member
  final protobuf.BuilderInfo info_;

  _GeneratedMessageImpl(this.info_);

  @override
  _GeneratedMessageImpl<T> clone() {
    final clone = createEmptyInstance();
    clone.mergeFromMessage(this);
    return clone;
  }

  @override
  _GeneratedMessageImpl<T> createEmptyInstance() {
    return _GeneratedMessageImpl(info_);
  }
}
