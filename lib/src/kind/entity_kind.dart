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
import 'package:kind/src/kind/relations.dart';
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
/// ### 1.Recommended approach (with fields)
/// In this example, we use [FieldLike] helpers to avoid writing reactive
/// getters / setters:
/// ```
/// import 'package:kind/kind.dart';
///
/// class Person extends Entity {
///   static final EntityKind<Person> kind = EntityKind<Person>(
///     name: 'Person',
///     build: (b) {
///       // Full name
///       b.optionalString(
///         id: 1,
///         name: 'fullName',
///         minLength: 1,
///         field: (e) => e.fullName,
///       );
///
///       // Friends
///       b.requiredList<Person>(
///         id: 2,
///         name: 'friends',
///         itemsKind: Person.kind,
///         field: (e) => e.friends,
///       );
///
///       /// Constructor
///       b.constructor = () => Person();
///     },
///   );
///
///   /// Full name.
///   late final Field<String?> fullName = Field<String?>(this);
///
///   /// Friends of the person.
///   late final SetField<Person> friends = SetField<Person>(this);
///
///   @override
///   EntityKind getKind() => kind;
/// }
/// ```
///
/// ### 2.Without fields, mutable, non-reactive
/// ```
/// import 'package:kind/kind.dart';
///
/// class Person extends Entity {
///   static final EntityKind<Person> kind = EntityKind<Person>(
///     name: 'Person',
///     build: (builder) {
///       // Full name.
///       builder.requiredString(
///         id: 1,
///         name: 'fullName',
///         getter: (e) => e.fullName,
///         setter: (e,v) => e.fullName = v,
///       );
///
///       // Friends
///       builder.requiredSet<Person>(
///         id: 2,
///         name: 'friends',
///         getter: (e) => e.friends,
///       );
///
///       // Constructor
///       b.constructor = () => Person();
///     },
///   );
///
///   // Full name of the person.
///   String name = '';
///
///   // Optional birth date.
///   final Set<Person> friends = {};
///
///   @override
///   getKind() => kind;
/// }
/// ```
///
/// ### 3.Without fields, mutable, reactive
/// In this example, we use [ReactiveMixin] for implementing reactive getters
/// and setters:
/// ```
/// import 'package:kind/kind.dart';
///
/// class Person extends Entity with ReactiveMixin {
///   /// `kind` is identical to the previous example.
///   /// ...
///
///   String _name = '';
///   final Set<Person> _friends = ReactiveList<Person>();
///
///   //// Full name.
///   String get name => beforeGet(_name); // <-- Dispatches 'read' event
///   set name(String name) => _name = beforeSet(_name, name); // <-- Dispatches 'write' event
///
///   //// Friends of the person.
///   Set<Person> get friends => beforeGet(_friends); // <-- Dispatches 'read' event
///
///   @override
///   EntityKind<Person> getKind() => organizationKind;
/// }
/// ```
///
/// ### 4.Without fields, immutable, non-reactive
///```
/// import 'package:kind/kind.dart';
///
/// /// Person.
/// class Person extends Entity {
///   static final EntityKind<Person> kind = EntityKind<Person>(
///     name: 'Person',
///     build: (builder) {
///      // Full name
///      final fullName = builder.requiredString(
///        id: 1,
///        name: 'fullName',
///        getter: (e) => e.fullName,
///      );
///
///      // Friends
///      final friends = builder.requiredSet<Person>(
///        id: 2,
///        name: 'friends',
///        itemsKind: organizationKind,
///        getter: (e) => e.friends,
///      );
///
///      // Set `constructorFromData` (instead of `constructor`)
///      builder.constructorFromData = (data) {
///        return Person(
///          name: data.get(fullName),
///          friends: data.get(friends),
///        );
///      };
///    },
///   );
///
///   //// Full name.
///   final String name;
///
///   //// Friends of the person.
///   final Set<Person> friends;
///
///   Person({
///     required this.name,
///     this.friends = const <Person>{},
///   });
/// }
/// ```
///
/// ### 5.Without fields, immutable, reactive
/// In this example, we use [ReactiveMixin] for implementing reactive getters:
/// ```
/// import 'package:kind/kind.dart';
///
/// class Person extends Entity with ReactiveMixin {
///   /// `kind` is identical to the previous example.
///   /// ...
///
///   final String _name;
///   final Set<Person> _friends;
///
///   /// Full name.
///   String get name => beforeGet(_name); // <-- Dispatches 'read' event
///
///   /// Friends of the person.
///   Set<Person> get friends => beforeGet(_friends); // <-- Dispatches 'read' event
///
///   Person({
///     required String name,
///     Set<Person> friends = const {},
///   }) :
///     _name = name,
///     _friends = ReactiveSet<Person>.wrap(friends); // <--  Make the list observable
///
///   @override
///   EntityKind<Person> getKind() => organizationKind;
/// }
/// ```
///
abstract class EntityKind<T extends Object> extends Kind<T> {
  /// [Kind] for [EntityKind].
  ///
  /// The purpose of annotation `@protected` is reducing accidental use.
  @protected
  static final EntityKind<EntityKind> kind = EntityKind<EntityKind>(
    name: 'EntityKind',
    build: (c) {
      final name = c.requiredString(
        id: 1,
        name: 'name',
        getter: (t) => t.name,
      );
      final packageName = c.optionalString(
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
      c.constructorFromData = (data) {
        return EntityKind(
          name: data.get(name),
          packageName: data.get(packageName),
          build: (c) {
            final propsList = data.get(props);
            for (var prop in propsList) {
              c.addProp(prop);
            }
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
  ///   * [packageName]
  ///   * [meanings]
  ///   * [extendsKind]
  ///   * [withKinds]
  ///
  factory EntityKind({
    required String name,
    required void Function(EntityKindBuilder<T> builder) build,
    String? packageName,
    List<KindMeaning> meanings,
    EntityKind? extendsKind,
    List<EntityKind> withKinds,
  }) = EntityKindImpl<T>;

  @protected
  EntityKind.constructor();

  /// Kinds that this kind extends using `extends` clause.
  EntityKind? get extendsKind;

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

  /// Primary key properties.
  KeyProps? get primaryKeyProps;

  /// Properties.
  List<Prop<T, dynamic>> get props;

  /// Kinds that this kind extends using `with` clause.
  List<EntityKind> get withKinds;

  @override
  EntityKind<EntityKind> getKind() => kind;

  bool instanceEquals(T left, Object right, {GraphEquality? context});

  /// A helper for computing a hash code for entities.
  ///
  /// ## Example
  /// ```
  /// class Example extends Entity {
  ///   // ...
  ///
  ///   @override
  ///   int get hashCode => getKind().instanceHash(this);
  ///
  ///   // ...
  /// }
  /// ```
  int instanceHash(T a) {
    var h = 0;
    for (var prop in props) {
      final value = prop.get(a);
      if (value == null ||
          value is bool ||
          value is num ||
          value is String ||
          value is DateTime ||
          value is DateTimeWithTimeZone ||
          value is Date ||
          value is GeoPoint) {
        h = 11 * h ^ value.hashCode;
      } else if (value is Iterable) {
        h = 3 * h ^ value.length;
      }
    }
    return h;
  }

  /// A helper for computing a debug-friendly string representation for
  /// entities.
  ///
  /// ## Example
  /// ```
  /// class Example extends Entity {
  ///   // ...
  ///
  ///   @override
  ///   String toString() => getKind().instanceToString(this);
  ///
  ///   // ...
  /// }
  /// ```
  String instanceToString(T instance) {
    final sb = StringBuffer();
    sb.write(name);
    sb.write('(');
    var printedAllProps = true;
    for (var prop in props) {
      try {
        final value = prop.get(instance);
        if (value == null ||
            value is bool ||
            value is num ||
            value is Int64 ||
            value is String ||
            value is DateTime ||
            value is DateTimeWithTimeZone ||
            value is Date ||
            value is GeoPoint) {
          sb.write('\n  ');
          sb.write(prop.name);
          sb.write(': ');
          if (value == null ||
              value is bool ||
              value is num ||
              value is Int64) {
            sb.write(value);
          } else if (value is String) {
            sb.write("'");
            sb.write(value.replaceAll("'", r"\'").replaceAll('\n', "\\n'\n'"));
            sb.write("'");
          } else if (value is DateTime) {
            sb.write("DateTime.parse('");
            sb.write(value.toIso8601String());
            sb.write("')");
          } else if (value is DateTimeWithTimeZone) {
            sb.write("DateTime.parse('");
            sb.write(value.toIso8601String());
            sb.write("')");
          } else if (value is Date) {
            sb.write("DateTime.parse('");
            sb.write(value.year.toString().padLeft(2, '0'));
            sb.write("')");
            sb.write(value.month.toString().padLeft(2, '0'));
            sb.write("')");
            sb.write(value.day.toString().padLeft(2, '0'));
            sb.write("')");
          } else {
            sb.write(value);
          }
        } else {
          printedAllProps = false;
        }
      } catch (e) {
        throw StateError(
            'Kind "${name}" instanceToString(...) threw error on property "${prop.name}": $e');
      }
    }
    if (!printedAllProps) {
      sb.writeln('\n...');
    }
    sb.write('\n)');
    return sb.toString();
  }

  /// Constructs a new instance from the entity data.
  T newFromData(EntityData data);

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
}