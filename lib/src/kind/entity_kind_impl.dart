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
  final EntityKindExtendsClause? extendsClause;

  @override
  final List<EntityKind> withKinds;

  late List<String>? _primaryKeyDefinition;

  void Function(EntityKindDefineContext<T> builder)? _defineFunction;

  T Function()? _constructor;

  T Function(EntityData entityData)? _constructorFromEntityData;

  List<T>? _examples;

  protobuf.BuilderInfo? _protobufBuilderInfo;

  List<Prop<Object, Object?>>? _props;

  bool _isBuilding = false;

  @override
  final String? description;

  EntityKindImpl({
    required this.name,
    this.packageName,
    this.meanings = const [],
    this.extendsClause,
    this.withKinds = const [],
    this.description,
    required void Function(EntityKindDefineContext<T> builder) define,
  })   : _defineFunction = define,
        super.constructor();

  @override
  List<T> get declaredExamples {
    // Construct internal state of this EntityKind.
    _constructInternalStateOnce();

    return _examples!;
  }

  @override
  List<String>? get primaryKeyProps {
    // Construct internal state of this EntityKind.
    _constructInternalStateOnce();

    return _primaryKeyDefinition;
  }

  @override
  List<Prop<Object, Object?>> get props {
    // Construct internal state of this EntityKind.
    _constructInternalStateOnce();

    return _props!;
  }

  @override
  T jsonTreeDecode(Object? json, {JsonDecodingContext? context}) {
    // Construct internal state of this EntityKind.
    _constructInternalStateOnce();

    // Construct decoding context (if not given).
    context ??= JsonDecodingContext();

    // Check argument
    if (json is! Map) {
      throw context.newGraphNodeError(
        value: json,
        reason: 'Expected JSON object.',
      );
    }

    // Get property namer.
    final namer = context.namer;

    // Is this mutable or immutable?
    final constructorFromEntityData = _constructorFromEntityData;

    if (constructorFromEntityData == null) {
      // --------------
      // Mutable entity
      // --------------
      final result = newInstance();

      // For each property...
      for (var prop in props) {
        // Resolve JSON name of the property.
        var jsonKey = prop.name;
        if (namer != null) {
          jsonKey = namer.fromEntityKindPropName(this, prop, jsonKey);
        }

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
      // ----------------
      // Immutable entity
      // ----------------
      final entityData = EntityData();

      for (var prop in props) {
        // Resolve JSON name of the property.
        var jsonKey = prop.name;
        if (namer != null) {
          jsonKey = namer.fromEntityKindPropName(this, prop, jsonKey);
        }

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
  }

  @override
  Map<String, Object?> jsonTreeEncode(T value, {JsonEncodingContext? context}) {
    // Construct internal state of this EntityKind.
    _constructInternalStateOnce();

    // Construct encoding context (if not given)
    context ??= JsonEncodingContext();

    // Get property namer
    final namer = context.namer;

    // Construct empty JSON object
    final result = <String, Object?>{};

    // Enter this object
    context.enter(value);
    try {
      for (var prop in props) {
        // Get value of the property.
        // The method throws descriptive error message if it fails.
        final dartValue = prop.get(value);

        // Is the value equal to the default value?
        if (prop.kind.instanceIsDefaultValue(dartValue)) {
          continue;
        }

        // Encode property value as JSON.
        final jsonValue = context.encode(dartValue, kind: prop.kind);

        // Resolve JSON name of the property.
        var jsonKey = prop.name;
        if (namer != null) {
          jsonKey = namer.fromEntityKindPropName(this, prop, jsonKey);
        }

        // Mutate the returned JSON object.
        result[jsonKey] = jsonValue;
      }
      return result;
    } finally {
      // Leave this object
      context.leave();
    }
  }

  @override
  T newInstance() {
    // Construct internal state of this EntityKind.
    _constructInternalStateOnce();

    final constructor = _constructor;
    if (constructor != null) {
      // Construct instance.
      //
      // We don't need to initialize with default property values because
      // the constructor takes care of it.
      try {
        return constructor();
      } catch (error, stackTrace) {
        throw TraceableError(
          message: 'Constructing a default instance of `$name` failed.',
          error: error,
          stackTrace: stackTrace,
        );
      }
    }
    final constructorFromEntityData = _constructorFromEntityData;
    if (constructorFromEntityData != null) {
      // We don't need to initialize with default property values because
      // entityData.get(prop, value) will take care of it.
      final entityData = EntityData();
      try {
        return constructorFromEntityData(entityData);
      } catch (error, stackTrace) {
        throw TraceableError(
          message: 'Constructing an instance of `$name` failed.',
          error: error,
          stackTrace: stackTrace,
        );
      }
    }
    throw StateError('Kind `$name` does not have any constructor.');
  }

  @override
  T newInstanceFromData(EntityData data) {
    // Construct internal state of this EntityKind.
    _constructInternalStateOnce();

    final constructorFromData = _constructorFromEntityData;
    late T result;
    if (constructorFromData != null) {
      result = constructorFromData(data);
    } else {
      result = _constructor!();
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
  protobuf.BuilderInfo protobufBuilderInfo() {
    // Construct internal state of this EntityKind.
    _constructInternalStateOnce();

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
    // Construct internal state of this EntityKind.
    _constructInternalStateOnce();

    context ??= ProtobufDecodingContext();
    if (protobufObject is! protobuf.GeneratedMessage) {
      throw ArgumentError.value(
        protobufObject,
        'protobufObject',
        'Expected GeneratedMessage',
      );
    }
    final generatedMessage = protobufObject;
    final constructorFromEntityData = _constructorFromEntityData;
    if (constructorFromEntityData == null) {
      // --------------
      // Mutable entity
      // --------------
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
      // ----------------
      // Immutable entity
      // ----------------
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
    // Construct internal state of this EntityKind.
    _constructInternalStateOnce();

    context ??= ProtobufEncodingContext();
    final info = protobufBuilderInfo();
    final generatedMessage = _GeneratedMessageImpl(info);
    for (var prop in props) {
      // Get property value.
      final propValue = prop.get(instance);

      // Ignore default value.
      if (prop.kind.instanceIsDefaultValue(propValue)) {
        continue;
      }

      // Encode property value.
      final pbType = info.byIndex[prop.id - 1].type;
      var pbValue = context.encode(
        propValue,
        kind: prop.kind,
        pbType: pbType,
      );

      // Set PB field.
      generatedMessage.setField(prop.id, pbValue);
    }
    return generatedMessage;
  }

  @override
  T randomExample({RandomExampleContext? context}) {
    // Construct internal state of this EntityKind.
    _constructInternalStateOnce();

    // Construct context (if not given).
    context ??= RandomExampleContext();

    // Increment variables that protect us from too long operations
    // (infinite recursion, etc.).
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
        return newInstanceFromData(entityData);
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

  void _constructInternalStateOnce() {
    try {
      final defineFunction = _defineFunction;
      if (defineFunction == null) {
        return;
      }
      if (_isBuilding) {
        throw StateError(
          'Building kind "$name" led to infinite recursion',
        );
      }
      _isBuilding = true;
      try {
        final defineContext = EntityKindDefineContext<T>();

        // Extends?
        final extendsClause = this.extendsClause;
        if (extendsClause != null) {
          for (var prop in extendsClause.kind.props) {
            defineContext.addProp(prop);
          }
        }

        // Call `define` functions.
        defineFunction(defineContext);

        // Set internal state of EntityKind
        _props =
            List<Prop<Object, Object?>>.unmodifiable(defineContext.propList);
        _constructor = defineContext.constructor;
        _constructorFromEntityData = defineContext.constructorFromData;
        _examples = defineContext.examples;
        _protobufBuilderInfo = defineContext.protobufBuilderInfo;
        _primaryKeyDefinition = defineContext.primaryKeyProps;
        _defineFunction = null;
      } finally {
        _isBuilding = false;
      }

      // Check whether the developer made an infinite initialization error.
      final cycle = _findInitializationCycle([], [], this);
      if (cycle != null) {
        throw StateError(
          'Detected an instance initialization cycle ("$cycle") that would lead to stack overflow if `kind.newInstance()` was called.'
          ' You can fix this by using `NullableKind` so the initial value will be null.',
        );
      }
    } catch (error, stackTrace) {
      throw TraceableError(
        message: 'Building definition for `$name` failed.',
        error: error,
        stackTrace: stackTrace,
      );
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
    _constructInternalStateOnce();
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
      } catch (error, stackTrace) {
        throw TraceableError(
          message:
              'Constructing Protocol Buffers BuildInfo failed because of property `${prop.name}`.',
          error: error,
          stackTrace: stackTrace,
        );
      }
    }
    return info;
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
