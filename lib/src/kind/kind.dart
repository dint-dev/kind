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

import 'package:kind/kind.dart';
import 'package:meta/meta.dart';
import 'package:protobuf/protobuf.dart';

/// A class for creating, inspecting, and manipulating instances of specific
/// type `T`.
///
/// ## Subclasses
///   * Booleans
///     * [BoolKind]
///   * Integers
///     * [Uint32Kind]
///     * [Uint64Kind]
///     * [Int8Kind]
///     * [Int16Kind]
///     * [Int32Kind]
///     * [Int64Kind]
///     * [Int64FixNumKind]
///   * Floating-point values
///     * [Float32Kind]
///     * [Float64Kind]
///   * Exact decimal values
///     * [DecimalKind]
///   * Date/time
///     * [DateKind]
///     * [DateTimeKind]
///     * [DateTimeWithTimeZoneKind]
///   * Sequences
///     * [StringKind]
///     * [BytesKind]
///   * Collections
///     * [ListKind]
///     * [MapKind]
///     * [SetKind]
///   * Some others
///     * [Currency.kind]
///     * [CurrencyAmountKind]
///     * [EnumKind]
///     * [GeoPointKind]
///     * [FutureKind]
///     * [JsonKind]
///     * [Kind.kind]
///     * [NullableKind]
///     * [OneOfKind]
///     * [StreamKind]
///     * [UuidKind]
///     * [UnitOfMeasure.kind]
///     * [VoidKind]
///   * Custom entities
///     * [EntityKind]
///
abstract class Kind<T> extends Entity {
  static final List<Kind<Kind>> _kinds = <Kind<Kind>>[
    // ignore: invalid_use_of_protected_member
    VoidKind.kind,
    // ignore: invalid_use_of_protected_member
    NullableKind.kind,
    // ignore: invalid_use_of_protected_member
    BoolKind.kind,
    // ignore: invalid_use_of_protected_member
    Int8Kind.kind,
    // ignore: invalid_use_of_protected_member
    Int16Kind.kind,
    // ignore: invalid_use_of_protected_member
    Int32Kind.kind,
    // ignore: invalid_use_of_protected_member
    Int64Kind.kind,
    // ignore: invalid_use_of_protected_member
    Uint8Kind.kind,
    // ignore: invalid_use_of_protected_member
    Uint16Kind.kind,
    // ignore: invalid_use_of_protected_member
    Uint32Kind.kind,
    // ignore: invalid_use_of_protected_member
    Uint64Kind.kind,
    // ignore: invalid_use_of_protected_member
    Int64FixNumKind.kind,
    // ignore: invalid_use_of_protected_member
    Float32Kind.kind,
    // ignore: invalid_use_of_protected_member
    Float64Kind.kind,
    // ignore: invalid_use_of_protected_member
    DecimalKind.kind,
    // ignore: invalid_use_of_protected_member
    DateKind.kind,
    // ignore: invalid_use_of_protected_member
    DateTimeKind.kind,
    // ignore: invalid_use_of_protected_member
    DateTimeWithTimeZoneKind.kind,
    // ignore: invalid_use_of_protected_member
    UuidKind.kind,
    // ignore: invalid_use_of_protected_member
    StringKind.kind,
    // ignore: invalid_use_of_protected_member
    BytesKind.kind,
    // ignore: invalid_use_of_protected_member
    DurationKind.kind,
    // ignore: invalid_use_of_protected_member
    GeoPointKind.kind,
    // ignore: invalid_use_of_protected_member
    ListKind.kind,
    // ignore: invalid_use_of_protected_member
    SetKind.kind,
    // ignore: invalid_use_of_protected_member
    MapKind.kind,
    // ignore: invalid_use_of_protected_member
    EnumKind.kind,
    // ignore: invalid_use_of_protected_member
    OneOfKind.kind,
    // ignore: invalid_use_of_protected_member
    ObjectKind.kind,
    // ignore: invalid_use_of_protected_member
    CurrencyAmountKind.kind,
    // ignore: invalid_use_of_protected_member
    FutureKind.kind,
    // ignore: invalid_use_of_protected_member
    StreamKind.kind,
    // ignore: invalid_use_of_protected_member
    EntityKind.kind,
  ];

  static final Kind<Kind> kind = OneOfKind<Kind>.fromKinds(_kinds);

  const Kind();

  /// Number of bits per value or -1 if the number of bits undefined.
  ///
  /// ## Example
  /// ```
  /// BoolKind().bitsPerElement; // --> 1
  /// Int32Kind().bitsPerElement; // --> 32
  /// Int64Kind().bitsPerElement; // --> 64
  /// Int64FixNumKind().bitsPerElement; // --> -1
  /// StringKind().bitsPerElement; // --> -1
  /// ```
  int get bitsPerListElement => -1;

  /// Returns declared examples of this value.
  ///
  /// ## Example
  /// ```
  /// final emailKind = StringKind(
  ///   examples: ['example@gmail.com'],
  /// );
  ///
  /// // ...
  ///
  /// final examples = emailKind.examples(); // --> ['example@gmail.com']
  /// ```
  List<T> get declaredExamples => <T>[];

  bool get isSerializable => true;

  /// Name of this kind for debugging purposes.
  ///
  /// ## Example
  /// ```
  /// final kind = Int32Kind();
  /// kind.name; // --> Int32
  /// ```
  String get name;

  /// Returns _package:protobuf_ [GeneratedMessage] field type.
  @protected
  int get protobufFieldType;

  /// Casts the value to `T` or throws an error.
  ///
  /// ## Examples
  /// ```
  /// StringKind().instanceCast('abc'); // --> 'abc'
  /// StringKind().instanceCast(0); // --> throws ArgumentError
  /// ```
  T instanceCast(Object? value) {
    if (value is T) {
      return value;
    } else {
      throw ArgumentError.value(value);
    }
  }

  /// Tells whether the argument is an instance of the wanted Dart type.
  ///
  /// ## Examples
  /// ```
  /// final kind = StringKind(minLengthInUtf8: 1);
  /// kind.instanceIsCorrectType(3.14); // --> false
  /// kind.instanceIsCorrectType('a'); // --> true
  /// kind.instanceIsCorrectType(''); // --> true, even though it does not match the constraints.
  /// ```
  @nonVirtual
  bool instanceIsCorrectType(Object? value) => value is T;

  /// Tells whether the argument is a value returned by [newInstance].
  ///
  /// ## Examples
  /// ```
  /// ListKind().instanceIsDefaultValue([]); // --> true
  /// ListKind().instanceIsDefaultValue(null); // --> false
  /// ListKind().instanceIsDefaultValue(['an item']); // --> false
  ///
  /// NullableKind(ListKind()).instanceIsDefaultValue(null); // --> true
  /// NullableKind(ListKind()).instanceIsDefaultValue([]); // --> false
  /// ```
  bool instanceIsDefaultValue(Object? value);

  /// A shorthand for checking validity with [instanceValidate].
  ///
  /// ## Example
  /// ```
  /// final kind = StringKind(minLengthInUtf8: 1, maxLengthInUtf8: 2);
  /// print(kind.instanceIsValid('')); // --> false
  /// print(kind.instanceIsValid('a')); // --> true
  /// print(kind.instanceIsValid('ab')); // --> true
  /// print(kind.instanceIsValid('abc')); // --> false
  /// ```
  @nonVirtual
  bool instanceIsValid(Object? value) {
    if (value is! T) {
      return false;
    }
    // Null is valid
    // (in that case, T is nullable)
    if (value == null) {
      return true;
    }
    try {
      instanceValidateOrThrow(value);
      return true;
    } on ValidationError {
      return false;
    }
  }

  /// Checks that the type is correct and then validates constraints with
  /// [instanceValidateConstraints].
  ///
  /// ## Example
  /// ```
  /// import 'package:kind/kind.dart';
  ///
  /// void main() {
  ///   final kind = const StringKind();
  ///
  ///   final context = ValidateContext();
  ///   context.instanceValidate('abc', kind: kind);
  ///   // The above calls kind.instanceValidate(...)
  /// }
  /// ```
  @nonVirtual
  void instanceValidate(ValidateContext context, Object? value) {
    if (value is! T) {
      context.invalid(
        value: value,
        message: 'Invalid type',
      );
      return;
    }
    instanceValidateConstraints(context, value);
  }

  /// Validates that the argument matches constraints (minimum length, etc.).
  ///
  /// ## Example
  /// ```
  /// import 'package:kind/kind.dart';
  ///
  /// void main() {
  ///   final kind = const StringKind();
  ///
  ///   final context = ValidateContext();
  ///   context.instanceValidate('abc', kind: kind);
  ///   // The above calls kind.instanceValidateConstraints(...)
  /// }
  /// ```
  void instanceValidateConstraints(ValidateContext context, T value) {
    // Do nothing
  }

  /// A shorthand for calling [instanceValidate] with the context
  /// [ValidateContext.throwing()].
  ///
  /// ## Example
  /// ```
  /// import 'package:kind/kind.dart';
  ///
  /// void main() {
  ///   final kind = const StringKind(maxLengthInUtf8: 2);
  ///
  ///   kind.validateOrThrow('ab'); // Nothing happens
  ///   kind.validateOrThrow('abc'); // Throws an error
  /// }
  /// ```
  @nonVirtual
  void instanceValidateOrThrow(Object? value) {
    instanceValidate(ValidateContext.throwing(), value);
  }

  /// Converts the argument (a JSON tree) into an instance of `T`.
  ///
  ///
  /// ## Valid nodes in JSON trees
  /// The method takes a tree, where nodes are instances of:
  ///   * `null`
  ///   * `bool`
  ///   * `double`
  ///   * `String`
  ///   * `List`, where items are valid nodes.
  ///   * `Map<String,Object?>`, where keys are strings and values are valid
  ///     nodes.
  ///
  ///
  /// # Errors
  ///
  /// Thrown errors are subclasses of [GraphNodeError], which describes which
  /// node in the input graph caused the error.
  ///
  ///
  /// ## Examples
  /// ```
  /// import 'package:kind/kind.dart';
  ///
  /// void main() {
  ///   final json = '2020-12-31';
  ///   final kind = DateKind();
  ///   kind.jsonTreeDecode(json); // --> Date(2020, 12, 31)
  /// }
  /// ```
  ///
  ///
  /// # Implementing this method
  ///
  /// Implementations must use [context] to:
  ///   * Serialize other values.
  ///   * Construct errors.
  ///
  /// If [context] is null, implementations must construct one with
  /// [JsonDecodingContext()].
  ///
  T jsonTreeDecode(Object? value, {JsonDecodingContext? context});

  /// Converts the argument into a JSON tree.
  ///
  /// ## Valid nodes in JSON trees
  ///
  /// The method returns a tree, where nodes are instances of:
  ///   * `null`
  ///   * `bool`
  ///   * `double`
  ///   * `String`
  ///   * `List`, where items are valid nodes.
  ///   * `Map<String,Object?>`, where keys are strings and values are valid
  ///     nodes.
  ///
  ///
  /// # Errors
  ///
  /// Thrown errors are subclasses of [GraphNodeError], which describes which
  /// node in the input graph caused the error.
  ///
  ///
  /// ## Examples
  ///
  /// ```
  /// import 'package:kind/kind.dart';
  ///
  /// void main() {
  ///   final date = Date(2020, 12, 31);
  ///   final kind = DateKind();
  ///   kind.jsonTreeEncode(date); // --> '2020-12-31'
  /// }
  /// ```
  ///
  ///
  /// # Implementing this method
  ///
  /// Implementations must use [context] to:
  ///   * Serialize other values.
  ///   * Construct errors.
  ///
  /// If [context] is null, implementations must construct one with
  /// [JsonDecodingContext()].
  ///
  Object? jsonTreeEncode(
    T instance, {
    JsonEncodingContext? context,
  });

  /// Returns new default value.
  ///
  /// ## Examples
  /// ```
  /// import 'package:kind/kind.dart';
  ///
  /// void main() {
  ///   BoolKind().newInstance(); // --> false
  ///   Int64Kind().newInstance(); // --> 0
  ///   StringKind().newInstance(); // --> ''
  ///   NullableKind(StringKind()).newInstance();// --> null
  ///   ListKind(StringKind()).newInstance(); // --> []
  /// }
  /// ```
  T newInstance();

  /// Returns a new list of this kind, which is guaranteed some properties.
  ///
  /// The method allocates the most performant list possible. For instance,
  /// [Float32Kind](https://pub.dev/documentation/kind/latest/kind/Kind/randomExample.html),
  /// will give you a _dart:typed_data_ [Float32List](https://api.flutter.dev/flutter/dart-typed_data/Float32List-class.html)
  /// rather than normal `List<double>`.
  ///
  /// ## Example
  /// ```
  /// import 'package:kind/kind.dart';
  ///
  /// void main() {
  ///   final kind = StringKind();
  ///   final list = kind.newList(
  ///     3,
  ///     growable: false,
  ///     reactive: false,
  ///   );
  /// }
  /// ```
  List<T> newList(int length, {bool growable = false, bool reactive = true}) {
    late List<T> list;
    if (length < 0) {
      throw ArgumentError.value(length, 'length');
    } else if (length == 0) {
      list = List<T>.empty(
        growable: growable,
      );
      // Non-growable empty list can't be mutated,
      // so it does not need to be reactive.
      if (!growable) {
        return list;
      }
    } else {
      // Construct default instance.
      late T defaultInstance;
      try {
        defaultInstance = newInstance();
      } catch (error, stackTrace) {
        throw TraceableError(
          message:
              'Constructing `List<$name>` (length $length) failed because filler instance could not be constructed.',
          error: error,
          stackTrace: stackTrace,
        );
      }
      list = List<T>.filled(
        length,
        defaultInstance,
        growable: growable,
      );

      // The defaultInstance could be mutable, so we need to construct a new
      // instance for every index.
      //
      // We can retain the item at index 0.
      //
      // In PrimitiveKind we override this method to avoid this.
      for (var i = 1; i < length; i++) {
        list[i] = newInstance();
      }
    }

    // Wrap with ReactiveList?
    if (reactive) {
      return ReactiveList<T>.wrap(list);
    }

    return list;
  }

  /// A method similar to the list constructor [List.from].
  ///
  /// By default, the new list is growable. You can create a non-growable list
  /// by setting `growable: false`.
  ///
  /// By default, the new list is wrapped with [ReactiveList]. You can disable
  /// this behavior by setting `reactive: false`.
  ///
  /// The method allocates the most performant list possible. For instance,
  /// [Float32Kind](https://pub.dev/documentation/kind/latest/kind/Kind/randomExample.html),
  /// will give you a _dart:typed_data_ [Float32List](https://api.flutter.dev/flutter/dart-typed_data/Float32List-class.html)
  /// rather than normal `List<double>` (if `growable` and `reactive` are false).
  ///
  /// ## Example
  /// ```
  /// import 'package:kind/kind.dart';
  ///
  /// void main() {
  ///   final kind = StringKind();
  ///   final list = kind.newListFrom(
  ///     ['a', 'b', 'c'],
  ///     growable: true,
  ///     reactive: false,
  ///   );
  /// }
  /// ```
  List<T> newListFrom(Iterable<T> iterable,
      {bool growable = true, bool reactive = true}) {
    late List<T> oldList;
    if (iterable is List<T>) {
      if (iterable is ReactiveList<T>) {
        oldList = iterable.wrapped;
      } else {
        oldList = iterable;
      }
    } else {
      oldList = iterable.toList();
    }
    final length = oldList.length;
    final list = newList(length, growable: growable, reactive: false);
    for (var i = 0; i < length; i++) {
      list[i] = oldList[i];
    }
    if (reactive && (length != 0 || growable)) {
      return ReactiveList<T>.wrap(list);
    }
    return list;
  }

  /// A method similar to the list constructor [List.generate].
  ///
  /// The method allocates the most performant list possible. For instance,
  /// [Float32Kind](https://pub.dev/documentation/kind/latest/kind/Kind/randomExample.html),
  /// will give you a _dart:typed_data_ [Float32List](https://api.flutter.dev/flutter/dart-typed_data/Float32List-class.html)
  /// rather than normal `List<double>` (if `growable` and `reactive` are false).
  ///
  /// ## Example
  /// ```
  /// import 'package:kind/kind.dart';
  ///
  /// void main() {
  ///   final kind = StringKind();
  ///   final list = kind.newListFromGenerator(
  ///     100,
  ///     (i)=>'initial value',
  ///     growable: false,
  ///     reactive: false,
  ///   );
  /// }
  /// ```
  List<T> newListGenerate(
    int length,
    T Function(int i) function, {
    bool growable = false,
    bool reactive = true,
  }) {
    final list = List<T>.generate(
      length,
      function,
      growable: growable,
    );
    if (reactive && (length != 0 || growable)) {
      return ReactiveList<T>.wrap(list);
    }
    return list;
  }

  /// Constructs _package:protobuf_ [GeneratedMessage] field value
  /// (e.g. [bool], [Int64], [GeneratedMessage]).
  @protected
  Object? protobufNewInstance() => newInstance();

  /// Converts the argument (a Protocol Buffers tree) into an instance of `T`.
  ///
  /// The input graph contains instances of the following types:
  ///   * `null`
  ///   * `bool`
  ///   * `int`
  ///   * `Int64` (_package:fixnum_)
  ///   * `double`
  ///   * `String`
  ///   * `Uint8List`
  ///   * `GeneratedMessage` (_package:protobuf_)
  ///     * Field values must be instances of allowed types.
  ///   * `List`
  ///     * Items must be instances of single non-list allowed type.
  ///
  /// The graph must be a tree (no cycles are allowed).
  ///
  /// The method must deserialize other values with `context`, which may be
  /// constructed by the method if it's `null`.
  ///
  /// ## Example
  /// ```
  /// StringKind().protobufTreeDecode('abc');
  /// // --> 'abc'
  ///
  /// // We assume `generatedMessage` is an instance of GeneratedMessage
  /// // (package:protobuf)
  /// SomeEntity.kind.protobufTreeDecode(generatedMessage);
  /// // --> instance of SomeEntity
  /// ```
  T protobufTreeDecode(Object? value, {ProtobufDecodingContext? context});

  /// Converts the argument into a Protocol Buffers tree.
  ///
  /// The output graph can contain instances of the following types:
  ///   * `null`
  ///   * `bool`
  ///   * `int`
  ///   * `Int64` (_package:fixnum_)
  ///   * `double`
  ///   * `String`
  ///   * `Uint8List`
  ///   * `GeneratedMessage` (_package:protobuf_)
  ///     * Field values must be instances of allowed types.
  ///   * `List`
  ///     * Items must be instances of single non-list allowed type.
  ///
  /// The output graph must be a tree (no cycles are allowed).
  ///
  /// The method must serialize other values with `context`, which may be
  /// constructed by the method if it's `null`.
  ///
  /// ## Example
  /// ```
  /// StringKind().protobufTreeEncode('abc');
  /// // --> 'abc'
  ///
  /// SomeEntity.kind.protobufTreeEncode(instanceOfSomeEntity);
  /// // --> GeneratedMessage (package:protobuf)
  /// ```
  Object protobufTreeEncode(
    T instance, {
    ProtobufEncodingContext? context,
  });

  /// Generates a random example.
  ///
  /// Subclasses may return examples from some specific distribution. For
  /// example, [Int64Kind] returns random numbers near 0.
  ///
  /// If you want to generate a list of examples, you can use
  /// [randomExampleList].
  ///
  /// ## Example
  /// ```
  /// import 'package:kind/kind.dart';
  ///
  /// final kind = StringKind();
  /// final loremIpsumExample = kind.randomExample();
  /// ```
  T randomExample({RandomExampleContext? context}) {
    final declaredExamples = this.declaredExamples;
    if (declaredExamples.isNotEmpty) {
      context ??= RandomExampleContext();
      return declaredExamples[context.random.nextInt(declaredExamples.length)];
    }
    return newInstance();
  }

  /// Generates a list of N random examples (with [randomExample]).
  ///
  /// ## Example
  /// ```
  /// import 'package:kind/kind.dart';
  ///
  /// final kind = StringKind();
  /// final loremIpsumExamples = kind.randomExampleList(10);
  /// ```
  @nonVirtual
  List<T> randomExampleList(int n, {RandomExampleContext? context}) {
    context ??= RandomExampleContext(nonPrimitivesCountMax: n * 100);
    final list = newList(n);
    for (var i = 0; i < n; i++) {
      list[i] = randomExample(context: context);
    }
    return list;
  }

  /// Returns a non-nullable version of this kind.
  ///
  /// There are two cases:
  ///   * If this kind is `NullableKind<T>`, returns the wrapped kind.
  ///   * Otherwise returns this kind.
  ///
  /// ## Examples
  /// ```
  /// import 'package:kind/kind.dart';
  ///
  /// StringKind().toNonNullable(); // --> StringKind()
  /// NullableKind(StringKind()).toNonNullable(); // --> StringKind()
  /// ```
  Kind<T> toNonNullable() => this;

  /// Returns a nullable version of this kind.
  ///
  /// There are two cases:
  ///   * If this kind is already nullable, returns this kind.
  ///   * Otherwise constructs `Nullable<T>(this)`.
  ///
  /// ## Examples
  /// ```
  /// import 'package:kind/kind.dart';
  ///
  /// void main() {
  ///   StringKind().toNullable(); // --> NullableKind(StringKind())
  ///   NullableKind(StringKind()).toNullable(); // --> NullableKind(StringKind())
  /// }
  /// ```
  NullableKind<T> toNullable() => NullableKind<T>(this);

  /// Returns [Kind] for instances of common Dart classes.
  ///
  /// ## Supported instance types
  ///   * [Null]
  ///     Returns `null`.
  ///   * [int] and [double]
  ///     * If the argument is [int], the function will return [Int64Kind] in
  ///       non-Javascript platforms and [Float64Kind] in non-Javascript
  ///       platforms.
  ///     * If the argument is [double], the function will return [Float64Kind].
  ///   * [Date]
  ///     * Returns [DateKind]
  ///   * [DateTime]
  ///     * Returns [DateTimeKind]
  ///   * [DateTimeWithTimeZone]
  ///     * Returns [DateTimeWithTimeZoneKind]
  ///   * [GeoPoint]
  ///     * Returns [GeoPointKind]
  ///   * [String]
  ///     * Returns [StringKind]
  ///   * [Uint8List]
  ///     * Returns [BytesKind]
  ///   * [Entity]
  ///     * Returns the result of calling `instance.getKind()`.
  ///
  /// ## Examples
  /// ```
  /// Kind.of(3); // --> Int64Kind()
  /// Kind.of(3, noInt: true); // --> DoubleKind()
  /// Kind.of(3.14); // --> DoubleKind()
  /// Kind.of('abc'); // --> StringKind()
  /// Kind.of(entityKind); // --> entityKind.getKind()
  /// ```
  static Kind? of(Object? value, {bool noInt = false}) {
    if (value == null) {
      return null;
    }
    if (value is bool) {
      return const BoolKind();
    }
    if (noInt) {
      if (value is num) {
        return const Float64Kind();
      }
    } else {
      // In browsers, any `num` will return Float64Kind.
      if (value is double) {
        return const Float64Kind();
      }
      if (value is int) {
        return const Int64Kind();
      }
    }
    if (value is DateTime) {
      return const DateTimeKind();
    }
    if (value is Date) {
      return const DateKind();
    }
    if (value is DateTimeWithTimeZone) {
      return const DateTimeWithTimeZoneKind();
    }
    if (value is GeoPoint) {
      return const GeoPointKind();
    }
    if (value is String) {
      return const StringKind();
    }
    if (value is Uint8List) {
      return const BytesKind();
    }
    if (value is Entity) {
      return value.getKind();
    }
    throw ArgumentError.value(value);
  }
}

/// Context for [Kind.randomExample].
///
/// The purpose of the context object is:
///   * Passing random number generator ([random]).
///   * Preventing generation of too large graphs.
///
/// ## Example
/// ```
/// import 'package:kind/kind.dart';
///
/// final kind = StringKind(
///   randomExampleGenerator: (context) {
///     final i = context.random.nextInt(3);
///     return ['a', 'b', 'c'][i];
///   },
/// )
/// ```
class RandomExampleContext {
  static final _random = Random.secure();

  /// Current number of generated non-primitive values.
  int nonPrimitivesCount = 0;

  /// Current depth in the generated tree.
  int depth = 0;

  /// Maximum number of generated non-primitive values.
  ///
  /// Used to prevent stack overflow.
  final int nonPrimitivesCountMax;

  /// Maximum depth in the generated tree.
  ///
  /// Used to prevent stack overflow.
  final int depthMax;

  /// Random number generator.
  final Random random;

  RandomExampleContext({
    Random? random,
    this.nonPrimitivesCountMax = 1000,
    this.depthMax = 3,
  }) : random = random ?? _random;

  /// True if random example generators should return nulls or empty
  /// collections whenever they can.
  bool get minimizeNewInstances =>
      nonPrimitivesCount >= nonPrimitivesCountMax || depth >= depthMax;

  /// Generates an example of the given kind.
  T generate<T>(Kind<T> kind) {
    return kind.randomExample(context: this);
  }
}
