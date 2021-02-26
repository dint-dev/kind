[![Pub Package](https://img.shields.io/pub/v/kind.svg)](https://pub.dartlang.org/packages/kind)
[![Github Actions CI](https://github.com/dint-dev/kind/workflows/Dart%20CI/badge.svg)](https://github.com/dint-dev/kind/actions?query=workflow%3A%22Dart+CI%22)

# Overview

This is __Kind framework__ for serialization / persistence / reactive state management.

__This is an initial experimental version. The APIs are not frozen.__

## What it gives you?
  * __Convert graphs to/from JSON trees.__
    * Use [kind.jsonTreeEncode](https://pub.dev/documentation/kind/latest/kind/EntityKind/jsonTreeEncode.html)
      / [kind.jsonTreeDecode)](https://pub.dev/documentation/kind/latest/kind/EntityKind/jsonTreeDecode.html).
  * __Convert graphs to/from Protocol Buffers (and GRPC) trees.__
    * Use [kind.protobufTreeEncode](https://pub.dev/documentation/kind/latest/kind/EntityKind/protobufTreeEncode.html)
      / [kind.protobufTreeDecode](https://pub.dev/documentation/kind/latest/kind/EntityKind/protobufTreeDecode.html).
  * __Use databases (upcoming).__
    * Our sibling package [database](https://pub.dev/packages/database) will use this framework in
      future.
  * __Reactive programming__
    * The package has [ReactiveSystem](https://pub.dev/documentation/kind/latest/kind/EntityKind/ReactiveSystem.html)
      for observing views and mutations of reactive states in the isolate. JSON / Protobuf
      deserialization methods construct reactive objects by default.
  * __Various small helpers for data layer programming.__
    * Use [kind.instanceValidate](https://pub.dev/documentation/kind/latest/kind/Kind/instanceValidate.html) to
      validate instances. For instance, if you have `StringKind(minLengthInRunes:3, maxLines:1)`,
      you get a debugging-friendly error message when you validate instance "a".
    * Use [kind.randomExample](https://pub.dev/documentation/kind/latest/kind/Kind/randomExample.html)
      to generate random instances of the kind.
    * Frameworks may use [kind.newList](https://pub.dev/documentation/kind/latest/kind/Kind/randomExample.html)
      to construct a memory-efficient lists without knowing the type. For instance,
      [Float32Kind](https://pub.dev/documentation/kind/latest/kind/Kind/randomExample.html), will
      give you a _dart:typed_data_ [Float32List](https://api.flutter.dev/flutter/dart-typed_data/Float32List-class.html)
      rather than normal `List<double>` when you ask for a non-growable list.
    * Frameworks may use [entityKind.meaning](https://pub.dev/documentation/kind/latest/kind/EntityKind/meaning.html)
      to understand kinds and properties in terms of other vocabularies (such as [schema.org](https://schema.org)
      schemas).

## Overview of APIs
### Built-in kinds
  * Booleans
    * [BoolKind](https://pub.dev/documentation/kind/latest/kind/BoolKind-class.html)
  * Integers
    * [Int8Kind](https://pub.dev/documentation/kind/latest/kind/Int8Kind-class.html)
    * [Int16Kind](https://pub.dev/documentation/kind/latest/kind/Int16Kind-class.html)
    * [Int32Kind](https://pub.dev/documentation/kind/latest/kind/Int32Kind-class.html)
    * [Int64Kind](https://pub.dev/documentation/kind/latest/kind/Int64Kind-class.html)
    * [Int64FixNumKind](https://pub.dev/documentation/kind/latest/kind/Int64FixNumKind-class.html)
    * [Uint8Kind](https://pub.dev/documentation/kind/latest/kind/Uint8Kind-class.html)
    * [Uint16Kind](https://pub.dev/documentation/kind/latest/kind/Uint16Kind-class.html)
    * [Uint32Kind](https://pub.dev/documentation/kind/latest/kind/Uint32Kind-class.html)
    * [Uint64Kind](https://pub.dev/documentation/kind/latest/kind/Uint64Kind-class.html)
  * Floating-point numbers
    * [Float32Kind](https://pub.dev/documentation/kind/latest/kind/Float32Kind-class.html)
    * [Float64Kind](https://pub.dev/documentation/kind/latest/kind/Float64Kind-class.html)
  * Date and time
    * [DateKind](https://pub.dev/documentation/kind/latest/kind/DateKind-class.html)
    * [DateTimeKind](https://pub.dev/documentation/kind/latest/kind/DateTimeKind-class.html)
    * [DateTimeWithTimeZoneKind](https://pub.dev/documentation/kind/latest/kind/DateTimeWithTimeZoneKind-class.html)
  * Strings and bytes
    * [StringKind](https://pub.dev/documentation/kind/latest/kind/StringKind-class.html)
    * [BytesKind](https://pub.dev/documentation/kind/latest/kind/BytesKind-class.html)
  * Lists and sets
    * [ListKind](https://pub.dev/documentation/kind/latest/kind/ListKind-class.html)
    * [SetKind](https://pub.dev/documentation/kind/latest/kind/SetKind-class.html)
  * Others
    * [EnumKind](https://pub.dev/documentation/kind/latest/kind/EnumKind-class.html)
    * [GeoPointKind](https://pub.dev/documentation/kind/latest/kind/GeoPointKind-class.html)
    * [JsonKind](https://pub.dev/documentation/kind/latest/kind/JsonKind-class.html)
    * [NullableKind](https://pub.dev/documentation/kind/latest/kind/NullableKind-class.html)
    * [ObjectKind](https://pub.dev/documentation/kind/latest/kind/ObjectKind-class.html)
    * [OneOfKind](https://pub.dev/documentation/kind/latest/kind/OneOfKind-class.html)
    * [UuidKind](https://pub.dev/documentation/kind/latest/kind/UuidKind-class.html)
  * Your custom models
    * [CompositePrimitiveKind](https://pub.dev/documentation/kind/latest/kind/CompositePrimitiveKind-class.html)
    * [EntityKind](https://pub.dev/documentation/kind/latest/kind/EntityKind-class.html)

### Built-in string formats
  * [stringKindForEmailAddress](https://pub.dev/documentation/kind/latest/kind.strings/stringKindForEmailAddress.html) (email address)
  * [stringKindForMarkdown](https://pub.dev/documentation/kind/latest/kind.strings/stringKindForMarkdown.html) (Markdown formatted content)
  * [stringKindForPhoneNumber](https://pub.dev/documentation/kind/latest/kind.strings/stringKindForPhoneNumber.html) (phone number)
  * [stringKindForUrl](https://pub.dev/documentation/kind/latest/kind.strings/stringKindForUrl.html) (URL)

### Data primitives
  * [Date](https://pub.dev/documentation/kind/latest/kind/GeoPoint-class.html) (like _DateTime_, but does not define time)
  * [DateTimeWithTimeZone](https://pub.dev/documentation/kind/latest/kind/GeoPoint-class.html) (like _DateTime_, but allows any time zone)
  * [GeoPoint](https://pub.dev/documentation/kind/latest/kind/GeoPoint-class.html) (geographical latitude/longitude coordinates)
  * [Uuid](https://pub.dev/documentation/kind/latest/kind/GeoPoint-class.html) (128-bit object identifier)

### Reactive collection classes
  * [ReactiveIterable](https://pub.dev/documentation/kind/latest/kind/ReactiveIterable-class.html)
  * [ReactiveList](https://pub.dev/documentation/kind/latest/kind/ReactiveList-class.html)
  * [ReactiveMap](https://pub.dev/documentation/kind/latest/kind/ReactiveMap-class.html)
  * [ReactiveSet](https://pub.dev/documentation/kind/latest/kind/ReactiveSet-class.html)

## Some alternatives
### For serialization
  * [built_value](https://pub.dev/packages/json_serializable)
    * Generates code for immutable values and JSON serialization.
  * [json_serializable](https://pub.dev/packages/json_serializable)
    * Generates code for JSON serialization.
  * [protobuf](https://pub.dev/packages/protobuf)
    * Generates code for Protocol Buffers serialization.

## For state management
  * [get](https://pub.dev/packages/get)
  * [get_it](https://pub.dev/packages/get_it)
  * [fish_redux](https://pub.dev/packages/fish_redux)
  * [flutter_redux](https://pub.dev/packages/flutter_redux)
  * [mobx](https://pub.dev/packages/mobx)
  * [riverpod](https://pub.dev/packages/riverpod)

# Getting started
## 1.Adding dependency
In _pubspec.yaml_, you should have something like:
```yaml
environment:
  sdk: '>=2.12.0-0 <3.0.0'

dependencies:
  kind: ^0.2.0
```

## 2.Write data models
In this example, we use [Field](https://pub.dev/documentation/kind/latest/kind/Field-class.html)
helper to avoid writing reactive getters / setters:
```dart
class Person extends Entity {
  static final EntityKind<Person> kind = EntityKind<Person>(
    name: 'Person',
    build: (b) {
      b.optionalString(
        id: 1,
        name: 'fullName',
        minLength: 1,
        field: (e) => e.fullName,
      );
      b.requiredSet<Person>(
        id: 2,
        name: 'friends',
        itemsKind: Person.kind,
        field: (e) => e.friends,
      );
      b.constructor = () => Person();
    },
  );

  /// Full name.
  late final Field<String?> fullName = Field<String?>(this);

  /// Friends.
  late final SetField<Person> friends = SetField<Person>(this);

  @override
  EntityKind getKind() => kind;
}
```


# Serialization
## JSON

```dart
// Encode
final json = person.getKind().jsonTreeEncode(person);

// Decode
final person = Person.kind.jsonTreeDecode(json);
```


## Protocol Buffers

```dart
// Encode
final generatedMessage = person.getKind().protobufTreeEncode(person);

// Decode
final person = Person.kind.protobufTreeDecode(generatedMessage);
```


# Alternative approaches to specifying data classes
### Why / why not?
The alternative approaches:
  * Do not force you to deviate from the way you normally write classes.
  * Perform better when you have millions of objects.
  * Do not support reactive programming with `ReactiveSystem` unless you write a lot error-prone
    boilerplate code.
    * In future, we may release a code generator that generates boilerplate for you, but there will
      inevitably going to be some complexity unless Dart language designers decide to support
      something like decorator annotations.

## For mutable classes
### ...without reactive programming support
You just define `getter` and `setter` in [Prop](https://pub.dev/documentation/kind/latest/kind/Prop-class.html)
for ordinary Dart fields:
```dart
class Person {
  /// Full name.
  String? fullName = '';

  /// Friends.
  final Set<Person> friends = {};
}

/// EntityKind for [Person].
final EntityKind<Person> personKind = EntityKind<Person>(
  name: 'Person',
  build: (builder) {
    builder.optionalString(
      id: 1,
      name: 'fullName',
      getter: (t) => t.fullName,
      setter: (t,v) => t.fullName = v,
    );
    builder.requiredSet<Person>(
      id: 2,
      name: 'friends',
      itemsKind: personKind,
      getter: (t) => t.friends,
    );
    builder.constructor = () => Person();
  },
);
```

### ...with reactive programming support
You can use [ReactiveMixin](https://pub.dev/documentation/kind/latest/kind/ReactiveMixin-class.html)
for implementing reactive getters and setters:
```dart
class Person extends Entity with ReactiveMixin {
  String? _fullName;
  final Set<Person> _friends = ReactiveSet<Person>();

  /// Full name of the person.
  String? get fullName => beforeGet(_fullName);
  set fullName(String? value) => _fullName = beforeSet(_fullName, value);

  /// Friends of the person.
  Set<Person> get friends => beforeGet(_friends);

  @override
  EntityKind<Person> getKind() => personKind;
}

// The `personKind` is identical to the previous example.
// ...
```


## For immutable classes
### ...without reactive programming support
```dart
// Extending Entity is optional, but recommended.
class Person {
  /// Full name of the person.
  final String? name;

  /// Friends of the person.
  final Set<Person> friends;

  Person({
    this.fullName,
    this.friends = const {},
  });
}

/// EntityKind for [Person].
final EntityKind<Person> personKind = EntityKind<Person>(
  name: 'Person',
  build: (builder) {
    final fullName = builder.optionalString(
      id: 1,
      name: 'fullName',
      getter: (t) => t.fullName,
    );
    final friends = builder.requiredSet<Person>(
      id: 2,
      name: 'friends',
      itemsKind: personKind,
      getter: (t) => t.friends,
    );
    builder.constructorFromData = (data) {
      return Person(
        name: data.get(fullName),
        friends: data.get(friends),
      );
    };
  },
);
```

### ...with reactive programming support
You can use [ReactiveMixin](https://pub.dev/documentation/kind/latest/kind/ReactiveMixin-class.html)
for implementing reactive getters:
```dart
// Extending Entity is optional, but recommended.
class Person extends Entity with ReactiveMixin {
  final String? _fullName;
  final Set<Person> _friends;

  /// Full name of the person.
  String? get fullName => beforeGet(_fullName);

  /// Friends of the person.
  Set<Person> get friends => beforeGet(_friends);

  Person({
    required String? name,
    Set<Person> friends = const {},
  }) :
    _fullName = name,
    _friends = ReactiveSet<Person>.wrap(friends);

  @override
  EntityKind<Person> getKind() => personKind;
}

// The `personKind` is identical to the previous example.
// ...
```