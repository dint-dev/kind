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

import 'package:fixnum/fixnum.dart';
import 'package:kind/kind.dart';
import 'package:meta/meta.dart';
import 'package:protobuf/protobuf.dart' as protobuf;
import 'package:protobuf/protobuf.dart' show BuilderInfo;

import 'entity_kind_impl.dart';

/// [Kind] for any object.
///
/// It's recommended (but not strictly necessary) that you extend or implement
/// [Entity].
///
/// ## Examples
/// See [package documentation](https://pub.dev/packages/kind).
abstract class EntityKind<T extends Object> extends Kind<T> {
  /// [Kind] for [EntityKind].
  ///
  /// The purpose of annotation `@protected` is reducing accidental use.
  @protected
  static final EntityKind<EntityKind> kind = EntityKind<EntityKind>(
    name: 'EntityKind',
    define: (c) {
      final nameProp = c.requiredString(
        id: 1,
        name: 'name',
        getter: (t) => t.name,
      );
      final packageNameProp = c.optionalString(
        id: 2,
        name: 'packageName',
        getter: (t) => t.packageName,
      );
      final props = c.requiredList<Prop>(
        id: 3,
        name: 'props',
        // ignore: invalid_use_of_protected_member
        itemsKind: Prop.kind_,
        getter: (t) => t.props,
      );
      final primaryKeyProps = c.optionalList<String>(
        id: 4,
        name: 'primaryKeyProps',
        itemsKind: Prop.namePropKind,
        getter: (t) => t.primaryKeyProps,
      );
      final meaningsProp = c.requiredList<KindMeaning>(
        id: 5,
        name: 'meanings',
        itemsKind: KindMeaning.kind_,
        getter: (t) => t.meanings,
      );
      final description = c.optionalString(
        id: 6,
        name: 'description',
        getter: (t) => t.description,
      );
      c.constructorFromData = (data) {
        final name = data.get(nameProp);
        final packageName = data.get(packageNameProp);
        return EntityKind<Object>(
          name: name,
          packageName: packageName,
          meanings: data.get(meaningsProp),
          description: data.get(description),
          define: (c) {
            final propsList = data.get(props);
            for (var prop in propsList) {
              c.addProp(prop);
            }
            c.primaryKeyProps = data.get(primaryKeyProps);
            c.constructorFromData = (data) => data;
          },
        );
      };
    },
  );

  /// Constructs a new kind.
  ///
  /// ## Required parameters
  ///   * [name]
  ///     * Name of the kind.
  ///     * We recommend that the name is same as Dart class name.
  ///   * [build]
  ///     * A function that builds the kind. By having a separate function,
  ///       we are able to avoid dependency cycles.
  ///
  /// ## Optional parameters
  ///   * [packageName] - Package name for debugging purposes.
  ///   * [extendsClause] - Extended kind.
  ///   * [meanings] - Semantic meanings of this kind.
  ///   * [description] - Description of this kind.
  ///
  factory EntityKind({
    required String name,
    required void Function(EntityKindDefineContext<T> builder) define,
    String? packageName,
    List<KindMeaning> meanings,
    EntityKindExtendsClause extendsClause,
    String? description,
  }) = EntityKindImpl<T>;

  @protected
  EntityKind.constructor();

  /// Description of the kind.
  String? get description;

  /// Specifies a superclass.
  EntityKindExtendsClause? get extendsClause;

  @override
  int get hashCode {
    var h = name.hashCode;
    for (var prop in props) {
      h = (0xFFFFFFF & (h << 4)) ^ (h >> 28);
      h ^= prop.id.hashCode;
      h ^= prop.name.hashCode;
      h ^= prop.kind.name.hashCode;
    }
    return h;
  }

  /// Describes meanings in other vocabularies.
  ///
  /// ## Example
  /// In this example, we refer to [schema.org/Person](https://schema.org/Person):
  /// ```
  /// import 'package:kind/kind.dart';
  ///
  /// class Person extends Entity {
  ///   static final EntityKind<Person> kind = EntityKind<Person>(
  ///     // ...
  ///     meanings: [
  ///       KindMeaning.schemaOrg('Person'),
  ///     ],
  ///     // ...
  ///   );
  ///   // ...
  /// }
  /// ```
  List<KindMeaning> get meanings;

  /// Optional package name.
  String? get packageName;

  /// Optional primary key properties for relational database systems.
  List<String>? get primaryKeyProps;

  /// Properties.
  List<Prop<Object, Object?>> get props;

  @override
  int get protobufFieldType {
    return protobuf.PbFieldType.OM;
  }

  /// Kinds that this kind extends using `with` clause.
  List<EntityKind> get withKinds;

  @override
  EntityKind<EntityKind> getKind() => kind;

  /// A helper for checking equality for entities.
  @nonVirtual
  bool instanceEquals(T left, Object right, {GraphEquality? context}) {
    if (right is! T) {
      return false;
    }
    for (var prop in props) {
      // These produce good error messages by default,
      // so we don't need to catch possible errors.
      final leftValue = prop.get(left);
      final rightValue = prop.get(right);

      // Try to avoid using GraphEquality, which has overhead.
      if (leftValue == null ||
          leftValue is bool ||
          leftValue is num ||
          leftValue is String ||
          leftValue is Int64 ||
          leftValue is Decimal ||
          leftValue is Date ||
          leftValue is DateTime ||
          leftValue is DateTimeWithTimeZone ||
          leftValue is Duration ||
          leftValue is CurrencyAmount ||
          leftValue is GeoPoint ||
          leftValue is Uuid) {
        if (leftValue != rightValue) {
          return false;
        }
      } else {
        try {
          context ??= GraphEquality();
          if (!context.equals(leftValue, rightValue)) {
            return false;
          }
        } catch (error, stackTrace) {
          throw throw TraceableError(
            message: 'Equality on kind `$name` property `${prop.name}` failed.',
            error: error,
            stackTrace: stackTrace,
          );
        }
      }
    }
    return true;
  }

  @override
  bool instanceIsDefaultValue(Object? value) {
    if (value is! T) {
      return false;
    }
    for (var prop in props) {
      final propValue = prop.get(value);
      if (!prop.kind.instanceIsDefaultValue(propValue)) {
        return false;
      }
    }
    return true;
  }

  @override
  void instanceValidateConstraints(ValidateContext context, T target) {
    super.instanceValidateConstraints(context, target);
    for (var prop in props) {
      final propValue = prop.get(target);
      context.validateProp(prop.name, propValue, kind: prop.kind);
    }
  }

  /// Constructs a new instance from the [EntityData].
  T newInstanceFromData(EntityData data);

  /// Returns _'package:protobuf'_ [BuilderInfo].
  @protected
  protobuf.BuilderInfo protobufBuilderInfo();

  /// Converts Protocol Buffers message bytes to `T`.
  ///
  /// You can optionally define [ProtobufDecodingContext].
  T protobufBytesDecode(
    List<int> bytes, {
    ProtobufDecodingContext? context,
  });

  /// Converts `T` to Protocol Buffers message bytes.
  ///
  /// You can optionally define [ProtobufEncodingContext].
  List<int> protobufBytesEncode(
    T instance, {
    ProtobufEncodingContext? context,
  }) {
    return protobufTreeEncode(instance, context: context).writeToBuffer();
  }

  /// Converts `T` to Protocol Buffers message.
  ///
  /// You can optionally define [ProtobufEncodingContext].
  @override
  protobuf.GeneratedMessage protobufTreeEncode(
    T instance, {
    ProtobufEncodingContext? context,
  });

  @override
  String toString({bool detailed = false}) {
    if (detailed) {
      final builder = EntityDebugStringBuilder();
      builder.writeDartEntity(this, kind: kind);
      return builder.toString();
    }
    return '$name.kind';
  }
}

class EntityKindExtendsClause<T extends Object> extends Entity {
  static final EntityKind<EntityKindExtendsClause> kind_ =
      EntityKind<EntityKindExtendsClause>(
    name: 'EntityKindInheritanceClause',
    define: (c) {
      final kind = c.required<EntityKind>(
        id: 1,
        name: 'kind',
        kind: EntityKind.kind,
      );
      final localKey = c.optionalList<String>(
        id: 2,
        name: 'localPropNames',
        itemsKind: Prop.namePropKind,
      );
      final foreignKey = c.optionalList<String>(
        id: 3,
        name: 'foreignPropNames',
        itemsKind: Prop.namePropKind,
      );
      c.constructorFromData = (data) {
        return EntityKindExtendsClause(
          kind: data.get(kind),
          localPropNames: data.get(localKey),
          foreignPropNames: data.get(foreignKey),
        );
      };
    },
  );

  /// Extended kind.
  final EntityKind<T> kind;

  /// Properties in the local (relational database) table.
  final List<String>? localPropNames;

  /// Properties in the foreign (relational database) table.
  final List<String>? foreignPropNames;

  EntityKindExtendsClause({
    required this.kind,
    this.localPropNames,
    this.foreignPropNames,
  });

  @override
  EntityKind<Object> getKind() => kind;
}
