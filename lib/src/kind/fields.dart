import 'dart:collection';

import 'package:kind/kind.dart';
import 'package:meta/meta.dart';

/// A [FieldLike] for non-collection objects.
///
/// ## Why?
/// See explanation at the documentation for [FieldLike].
///
/// ## Example
/// The following example demonstrates use of [Field], [ListField], and [SetField].
///
/// The relatively few lines of code gives you:
///   * JSON serialization.
///   * Protocol Buffers / GRPC serialization.
///   * Database mapping.
///   * Observability of both reads and writes (see [ReactiveSystem]).
///
/// ```
/// import 'package:kind/kind.dart';
///
/// class Person extends Entity {
///    static final EntityKind<Person> kind = EntityKind<Person>(
///      name: 'Person',
///      define: (c) {
///        // You could also use shorthand: `requiredString(...)`
///        c.addProp(Prop<Person, String>(
///          id: 1,
///          name: 'name',
///          field: (e) => e.name,
///          kind: StringKind(
///            maxLengthInUtf8: 80,
///          ),
///        ));
///        // You could also use shorthand: `optionalDate(...)`
///        c.addProp(Prop<Person, Date?>(
///          id: 2,
///          name: 'dateOfBirth',
///          field: (e) => e.dateOfBirth,
///          kind: DateKind().toNullable(),
///        ));
///        // You could also use shorthand: `requiredList(...)`
///        c.addProp(Prop<Person, List<String>>(
///          id: 3,
///          name: 'favoriteFoods',
///          field: (e) => e.favoriteFoods,
///          kind: ListKind(
///            itemsKind: StringKind(
///              maxLengthInUtf8: 80,
///            ),
///          ),
///        ));
///        // You could also use shorthand: `requiredSet(...)`
///        c.addProp(Prop<Person, Set<Person>>(
///          id: 4,
///          name: 'friends',
///          field: (e) => e.friends,
///          kind: SetKind<Person>(
///            itemsKind: Person.kind,
///          ),
///        ));
///      },
///   );
///
///   /// Full name.
///   late final Field<String> name = Field<String>(this);
///
///   /// Date of birth, if known.
///   late final Field<Date?> dateOfBirth = Field<Date?>(this);
///
///   /// Favorite foods (ordered by preference).
///   late final ListField<Food> favoriteFoods = ListField<Food>(this);
///
///   /// Friends (unordered).
///   late final SetField<Person> friends = SetField<Person>(this);
///
///   @override
///   EntityKind<Person> getKind() => kind;
/// }
/// ```
class Field<T> extends FieldLike<T> {
  T? _value;

  Field(Entity parent, [this._value]) : super(parent);

  T get value {
    final result = _value;
    if (result != null) {
      return result;
    }
    if (result is T) {
      return result;
    }
    final prop = getParentProp();
    final kind = prop.kind;
    final newInstance = kind.newInstance();
    _value = newInstance;
    return newInstance;
  }

  set value(T newValue) {
    _value = newValue;
  }
}

/// Superclass for [Field], [SetField], and [ListField].
///
/// ## Comparison to code generation
///   * __Easier to use.__ `Field<T>` may be simpler for developers than setting
///       up code generation correctly. See the example below.
///   * __Worse performance__.
///     * Use of `Field<T>` raises memory consumption. It slows down allocations,
///       memory accesses, and garbage collection. But avoid premature
///       optimization! The performance impact is unlikely to be noticeable
///       in typical business applications.
///
/// ## Example
/// The following example demonstrates use of [Field], [ListField], and [SetField].
///
/// The relatively few lines of code gives you:
///   * JSON serialization.
///   * Protocol Buffers / GRPC serialization.
///   * Database mapping.
///   * Observability of both reads and writes (see [ReactiveSystem]).
///
/// ```
/// import 'package:kind/kind.dart';
///
/// class Person extends Entity {
///    static final EntityKind<Person> kind = EntityKind<Person>(
///      name: 'Person',
///      define: (c) {
///        // You could also use shorthand: `requiredString(...)`
///        c.addProp(Prop<Person, String>(
///          id: 1,
///          name: 'name',
///          field: (e) => e.name,
///          kind: StringKind(
///            maxLengthInUtf8: 80,
///          ),
///        ));
///        // You could also use shorthand: `optionalDate(...)`
///        c.addProp(Prop<Person, Date?>(
///          id: 2,
///          name: 'dateOfBirth',
///          field: (e) => e.dateOfBirth,
///          kind: DateKind().toNullable(),
///        ));
///        // You could also use shorthand: `requiredList(...)`
///        c.addProp(Prop<Person, List<String>>(
///          id: 3,
///          name: 'favoriteFoods',
///          field: (e) => e.favoriteFoods,
///          kind: ListKind(
///            itemsKind: StringKind(
///              maxLengthInUtf8: 80,
///            ),
///          ),
///        ));
///        // You could also use shorthand: `requiredSet(...)`
///        c.addProp(Prop<Person, Set<Person>>(
///          id: 4,
///          name: 'friends',
///          field: (e) => e.friends,
///          kind: SetKind<Person>(
///            itemsKind: Person.kind,
///          ),
///        ));
///      },
///   );
///
///   /// Full name.
///   late final Field<String> name = Field<String>(this);
///
///   /// Date of birth, if known.
///   late final Field<Date?> dateOfBirth = Field<Date?>(this);
///
///   /// Favorite foods (ordered by preference).
///   late final ListField<Food> favoriteFoods = ListField<Food>(this);
///
///   /// Friends (unordered).
///   late final SetField<Person> friends = SetField<Person>(this);
///
///   @override
///   EntityKind<Person> getKind() => kind;
/// }
/// ```
abstract class FieldLike<T> {
  @protected
  final Entity $parent;

  /// Additional data about this reference.
  ///
  /// Example purposes:
  ///   * Database persistence information kept by a database framework.
  late Map<Object, Object> $additionalData;

  FieldLike(this.$parent);

  Prop<dynamic, T> getParentProp() {
    final parent = $parent;
    final prop = parent.getKind().props.singleWhere((prop) {
      return prop.isFieldIdenticalTo(parent, this);
    }, orElse: () {
      throw StateError(
        'Could not find property in the EntityKind.\n'
        '\n'
        'Make sure your class looks like the following:/\n'
        '    class YourClass extends Entity {/\n'
        '      static final EntityKind<YourClass> kind = EntityKind<YourClass>(\n'
        '        define: (c) {\n'
        '          // ...\n'
        '          c.addProp(Prop<YourClass, YourFieldType>(\n'
        '           id: 42,\n'
        '           name: \'yourField\',\n'
        '           field: (e) => e.yourField, // <---- IMPORTANT\n'
        '           kind: YourFieldKind(),\n'
        '          ));\n'
        '        },\n'
        '      );\n'
        '      // ...\n'
        '      late final Field<YourFieldType> yourField = Field<YourFieldType>(this);\n'
        '      // ...\n'
        '      @override\n'
        '      EntityKind<YourClass> getKind() => kind;\n'
        '    }\n',
      );
    });
    return prop as Prop<dynamic, T>;
  }
}

/// A [FieldLike] for `List<T>`.
///
/// ## Why?
/// See explanation at the documentation for [FieldLike].
///
/// ## Example
/// The following example demonstrates use of [Field], [ListField], and [SetField].
///
/// The relatively few lines of code gives you:
///   * JSON serialization.
///   * Protocol Buffers / GRPC serialization.
///   * Database mapping.
///   * Observability of both reads and writes (see [ReactiveSystem]).
///
/// ```
/// import 'package:kind/kind.dart';
///
/// class Person extends Entity {
///    static final EntityKind<Person> kind = EntityKind<Person>(
///      name: 'Person',
///      define: (c) {
///        // You could also use shorthand: `requiredString(...)`
///        c.addProp(Prop<Person, String>(
///          id: 1,
///          name: 'name',
///          field: (e) => e.name,
///          kind: StringKind(
///            maxLengthInUtf8: 80,
///          ),
///        ));
///        // You could also use shorthand: `optionalDate(...)`
///        c.addProp(Prop<Person, Date?>(
///          id: 2,
///          name: 'dateOfBirth',
///          field: (e) => e.dateOfBirth,
///          kind: DateKind().toNullable(),
///        ));
///        // You could also use shorthand: `requiredList<String>(...)`
///        c.addProp(Prop<Person, List<String>>(
///          id: 3,
///          name: 'favoriteFoods',
///          field: (e) => e.favoriteFoods,
///          kind: ListKind(
///            itemsKind: StringKind(
///              maxLengthInUtf8: 80,
///            ),
///          ),
///        ));
///        // You could also use shorthand: `requiredSet<Person>(...)`
///        c.addProp(Prop<Person, Set<Person>>(
///          id: 4,
///          name: 'friends',
///          field: (e) => e.friends,
///          kind: SetKind<Person>(
///            itemsKind: Person.kind,
///          ),
///        ));
///      },
///   );
///
///   /// Full name.
///   late final Field<String> name = Field<String>(this);
///
///   /// Date of birth, if known.
///   late final Field<Date?> dateOfBirth = Field<Date?>(this);
///
///   /// Favorite foods (ordered by preference).
///   late final ListField<Food> favoriteFoods = ListField<Food>(this);
///
///   /// Friends (unordered).
///   late final SetField<Person> friends = SetField<Person>(this);
///
///   @override
///   EntityKind<Person> getKind() => kind;
/// }
/// ```
class ListField<T> extends WrappingField<List<T>> with ListMixin<T> {
  ListField(Entity parent) : super(parent, ReactiveList<T>.empty());

  @override
  int get length {
    return $wrapped.length;
  }

  @override
  set length(int length) {
    $wrapped.length = length;
  }

  @override
  T operator [](int index) {
    return $wrapped[index];
  }

  @override
  void operator []=(int index, T element) {
    $wrapped[index] = element;
  }

  @override
  void add(T element) {
    $wrapped.add(element);
  }

  @override
  void addAll(Iterable<T> iterable) {
    $wrapped.addAll(iterable);
  }

  @override
  void clear() {
    $wrapped.clear();
  }
}

/// A [FieldLike] for `Set<T>`.
///
/// ## Why?
/// See explanation at the documentation for [FieldLike].
///
/// ## Example
/// The following example demonstrates use of [Field], [ListField], and [SetField].
///
/// The relatively few lines of code gives you:
///   * JSON serialization.
///   * Protocol Buffers / GRPC serialization.
///   * Database mapping.
///   * Observability of both reads and writes (see [ReactiveSystem]).
///
/// ```
/// import 'package:kind/kind.dart';
///
/// class Person extends Entity {
///    static final EntityKind<Person> kind = EntityKind<Person>(
///      name: 'Person',
///      define: (c) {
///        // You could also use shorthand: `requiredString(...)`
///        c.addProp(Prop<Person, String>(
///          id: 1,
///          name: 'name',
///          field: (e) => e.name,
///          kind: StringKind(
///            maxLengthInUtf8: 80,
///          ),
///        ));
///        // You could also use shorthand: `optionalDate(...)`
///        c.addProp(Prop<Person, Date?>(
///          id: 2,
///          name: 'dateOfBirth',
///          field: (e) => e.dateOfBirth,
///          kind: DateKind().toNullable(),
///        ));
///        // You could also use shorthand: `requiredList(...)`
///        c.addProp(Prop<Person, List<String>>(
///          id: 3,
///          name: 'favoriteFoods',
///          field: (e) => e.favoriteFoods,
///          kind: ListKind(
///            itemsKind: StringKind(
///              maxLengthInUtf8: 80,
///            ),
///          ),
///        ));
///        // You could also use shorthand: `requiredSet(...)`
///        c.addProp(Prop<Person, Set<Person>>(
///          id: 4,
///          name: 'friends',
///          field: (e) => e.friends,
///          kind: SetKind<Person>(
///            itemsKind: Person.kind,
///          ),
///        ));
///      },
///   );
///
///   /// Full name.
///   late final Field<String> name = Field<String>(this);
///
///   /// Date of birth, if known.
///   late final Field<Date?> dateOfBirth = Field<Date?>(this);
///
///   /// Favorite foods (ordered by preference).
///   late final ListField<Food> favoriteFoods = ListField<Food>(this);
///
///   /// Friends (unordered).
///   late final SetField<Person> friends = SetField<Person>(this);
///
///   @override
///   EntityKind<Person> getKind() => kind;
/// }
/// ```
class SetField<T> extends WrappingField<Set<T>> with SetMixin<T> {
  SetField(Entity parent) : super(parent, ReactiveSet<T>());

  @override
  Iterator<T> get iterator {
    return $wrapped.iterator;
  }

  @override
  int get length => $wrapped.length;

  @override
  bool add(T element) {
    return $wrapped.add(element);
  }

  @override
  void clear() {
    $wrapped.clear();
  }

  @override
  bool contains(Object? element) {
    return $wrapped.contains(element);
  }

  @override
  T? lookup(Object? element) {
    return $wrapped.lookup(element);
  }

  @override
  bool remove(Object? element) {
    return $wrapped.remove(element);
  }

  @override
  Set<T> toSet() {
    return $wrapped.toSet();
  }
}

/// Superclass for [ListField] and [SetField].
abstract class WrappingField<T> extends FieldLike<T> {
  T $wrapped;
  WrappingField(Entity parent, this.$wrapped) : super(parent);
}
