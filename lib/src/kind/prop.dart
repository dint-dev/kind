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
import 'package:kind/src/kind/reactive_system.dart';
import 'package:meta/meta.dart';

/// Property declared by [EntityKind].
///
/// ## Examples
/// See documentation for [EntityKind].
class Prop<T extends Object, V> {
  static const StringKind namePropKind = StringKind(
    minLengthInUtf8: 1,
    maxLengthInUtf8: 63,
  );

  /// [Kind] for [Prop].
  ///
  /// The purpose of annotation `@protected` is reducing accidental use.
  @protected
  static final Kind<Prop> kind_ = EntityKind<Prop>(
    name: 'Prop',
    build: (c) {
      final idProp = c.requiredUint64(
        id: 1,
        name: 'id',
        getter: (t) => t.id,
      );
      final nameProp = c.required<String>(
        id: 2,
        name: 'name',
        kind: namePropKind,
        getter: (t) => t.name,
      );
      final kindProp = c.required(
        id: 3,
        name: 'kind',
        kind: Kind.kind,
        getter: (t) => t.kind,
      );
      final defaultValueProp = c.optional<Object>(
        id: 4,
        name: 'defaultValue',
        kind: ObjectKind(),
        getter: (t) => t.defaultValue,
      );
      final meaningsProp = c.requiredList<PropMeaning>(
        id: 5,
        name: 'meanings',
        itemsKind: PropMeaning.kind_,
        getter: (t) => t.meanings,
      );
      final relationProp = c.optional<EntityRelation>(
        id: 6,
        name: 'relation',
        kind: EntityRelation.kind,
        getter: (t) => t.relation,
      );
      final descriptionProp = c.optionalString(
        id: 7,
        name: 'description',
        getter: (t) => t.description,
      );
      c.constructorFromData = (data) {
        final id = data.get(idProp);
        final name = data.get(nameProp);
        final kind = data.get(kindProp);
        final defaultValue = data.get(Prop<Prop, Object?>(
          id: defaultValueProp.id,
          name: defaultValueProp.name,
          kind: kind.toNullable(),
          getter: (t) => throw UnimplementedError(),
        ));
        final meanings = data.get(meaningsProp);
        final relation = data.get(relationProp);
        final description = data.get(descriptionProp);
        late Prop selfProp;
        selfProp = Prop(
          id: id,
          name: name,
          kind: kind,
          defaultValue: defaultValue,
          meanings: meanings,
          relation: relation,
          description: description,
          getter: (t) {
            if (t is Entity) {
              final prop = t
                  .getKind()
                  .props
                  .firstWhere((element) => element.name == name);
              if (!identical(prop, selfProp)) {
                return prop.get(t);
              }
            }
            throw UnsupportedError('Deserialized prop');
          },
        );
        return selfProp;
      };
    },
  );

  /// Numeric ID of the property. Must be 1 or greater.
  ///
  /// Used in Protocol Buffers / GRPC serialization.
  final int id;

  /// Name of the property.
  ///
  /// Used in JSON serialization and database mapping.
  ///
  /// The value can be any string, but we recommend that this is the same as
  /// Dart field name.
  final String name;

  /// [Kind] of the property.
  final Kind<V> kind;

  final V? defaultValue;

  /// A function that returns [FieldLike].
  ///
  /// ## Examples
  /// See documentation for [EntityKind].
  final FieldLike<V> Function(T target)? _field;

  /// Optional manual getter.
  ///
  /// ## Examples
  /// See documentation for [EntityKind].
  final V Function(T target)? _getter;

  /// Optional manual setter.
  ///
  /// ## Examples
  /// See documentation for [EntityKind].
  final void Function(T target, V value)? _setter;

  /// Describes meanings in other vocabularies.
  ///
  /// ## Example
  /// In this example, we refer to
  /// [schema.org/birthDate](https://schema.org/birthDate):
  /// ```
  /// import 'package:kind/kind.dart';
  ///
  /// class Person extends Entity {
  ///   static final EntityKind<Person> kind = EntityKind<Person>(
  ///     name: 'Person',
  ///     builder: (c) {
  ///       // ...
  ///       c.addProp(Prop<Person,Date?>(
  ///         id: 2,
  ///         name: 'birthDate',
  ///         kind: const DateKind(),
  ///         meanings: [
  ///           PropMeaning.schemaOrg('Person', 'birthDate'),
  ///         ],
  ///       ));
  ///       // ...
  ///     },
  ///   );
  ///   // ...
  /// }
  /// ```
  final List<PropMeaning> meanings;

  /// Relation to the other row (in a relational database). Null if [kind] is
  /// something else than [EntityKind].
  final EntityRelation? relation;

  /// Description of the property.
  final String? description;

  /// Constructs a new property declaration.
  ///
  /// Required parameters are:
  ///   * [id]
  ///     * Numeric ID. Must be 1 or greater.
  ///     * Used by Protocol Buffers / GRPC serialization
  ///   * [name]
  ///     * Name of the property.
  ///     * Used in JSON serialization and database mapping.
  ///   * [kind]
  ///     * Kind of the property.
  ///   * One of the following:
  ///     * [field]
  ///     * [getter] and [setter]
  ///
  /// Optional parameters are:
  ///   * [meanings]
  ///   * [relation]
  Prop({
    required this.id,
    required this.name,
    required this.kind,
    this.defaultValue,
    FieldLike<V> Function(T target)? field,
    V Function(T target)? getter,
    void Function(T target, V value)? setter,
    this.meanings = const [],
    this.relation,
    this.description,
  })  : _field = field,
        _getter = getter,
        _setter = setter {
    if (field == null && getter == null) {
      throw ArgumentError(
        'Property "$name" (id: $id) defines neither `getter` or `field`.',
      );
    }
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ kind.hashCode;

  bool get isMutable => _setter != null || _field is Field;

  @override
  bool operator ==(other) =>
      other is Prop &&
      id == other.id &&
      name == other.name &&
      kind == other.kind &&
      defaultValue == other.defaultValue &&
      const ListEquality<PropMeaning>().equals(meanings, other.meanings) &&
      relation == other.relation &&
      description == other.description;

  /// Returns value of the prop.
  V get(T target) {
    ReactiveSystem.instance.beforeRead(target);

    // Did developer define a manual getter?
    final getter = _getter;
    if (getter != null) {
      try {
        // Yes. Use it.
        return getter(target);
      } catch (e) {
        throw StateError(
          'Calling getter of kind "${_kindName(target)}" property "$name" (id: $id) failed: $e',
        );
      }
    }

    // Get function that returns field
    final field = _field;
    if (field != null) {
      late FieldLike fieldInstance;
      try {
        // Get field
        fieldInstance = field(target);
      } catch (e) {
        throw StateError(
          'Calling field getter of kind "${_kindName(target)}" property "$name" (id: $id) failed: $e',
        );
      }

      // Normal field?
      if (fieldInstance is Field) {
        final value = fieldInstance.value;
        if (value is V) {
          return value;
        } else {
          throw StateError(
            'Kind "${_kindName(target)}" property "$name" (id: $id) has an instance of unexpected type.',
          );
        }
      }

      // Wrapping field?
      if (fieldInstance is WrappingField) {
        final value = fieldInstance.$wrapped;
        if (value is V) {
          return value;
        } else {
          throw StateError(
            'Kind "${_kindName(target)}" property "$name" (id: $id) has an instance of unexpected type.',
          );
        }
      }

      // This should be impossible
      throw StateError(
        'Kind "${_kindName(target)}" property "$name" (id: $id) has unsupported FieldLike: $fieldInstance',
      );
    }
    throw StateError(
      'Kind "${_kindName(target)}" property "$name" (id: $id) has no `field` or `getter`.',
    );
  }

  /// Used by [FieldLike] to find the correct [Prop].
  bool isFieldIdenticalTo(T target, FieldLike fieldLike) {
    final field = _field;
    return field != null && identical(field(target), fieldLike);
  }

  /// Sets value of the prop.
  void set(T target, V value) {
    // Did developer define a manual setter?
    final setter = _setter;
    if (setter != null) {
      // Yes. Use the setter.
      ReactiveSystem.instance.beforeWrite(target);
      setter(target, value);
      return;
    }

    // Get function that returns field
    final field = _field;
    if (field != null) {
      // Get field
      final fieldInstance = field(target);

      // Normal field?
      if (fieldInstance is Field<V>) {
        fieldInstance.value = value;
        return;
      }

      // Wrapping field?
      if (fieldInstance is WrappingField<V>) {
        fieldInstance.$wrapped = value;
      }

      // This should be impossible
      throw StateError(
        'Kind "${_kindName(target)}" property "$name" (id: $id) has unsupported FieldLike: $fieldInstance',
      );
    }
    throw StateError(
      'Kind "${_kindName(target)}" property "$name" (id: $id) has no `field` or `setter`.',
    );
  }

  @override
  String toString() {
    final sb = StringBuffer();
    sb.write('Prop(\n');
    sb.write('  id: ');
    sb.write(id);
    sb.write(',\n');
    sb.write('  name: "');
    sb.write(name);
    sb.write('",\n');
    sb.write('  kind: ');
    sb.write(kind.toString().replaceAll('\n', '\n  '));
    sb.write(',\n');
    if (defaultValue != null) {
      sb.write('  defaultValue: ');
      sb.write(defaultValue);
      sb.write(',\n');
    }
    if (_field != null) {
      sb.write('  field: ...,\n');
    }
    if (_getter != null) {
      sb.write('  getter: ...,\n');
    }
    if (_setter != null) {
      sb.write('  setter: ...,\n');
    }
    sb.write(')');
    return sb.toString();
  }

  static String _kindName(Object target) {
    return target is Entity ? target.getKind().name : '${target.runtimeType}';
  }
}
