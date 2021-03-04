[![Pub Package](https://img.shields.io/pub/v/kind.svg)](https://pub.dartlang.org/packages/kind)
[![Github Actions CI](https://github.com/dint-dev/kind/workflows/Dart%20CI/badge.svg)](https://github.com/dint-dev/kind/actions?query=workflow%3A%22Dart+CI%22)

# Overview

An unified data layer framework that enables serialization, persistence, and state management for
any Dart class. This an early version and the APIs are not frozen. The package requires a null-safe
Flutter SDK 2.0.0 or later.

## Links
  * [Official API reference](https://pub.dev/documentation/kind/latest/)
  * [Issue tracker](https://github.com/dint-dev/kind/issues)
  * [Github project](https://github.com/dint-dev/kind)

## Features
  * __Encode/decode JSON.__
    * The package can handle most JSON serialization requirements.
  * __Encode/decode Protocol Buffers.__
    * The package can handle most Protocol Buffers (and GRPC) serialization requirements.
  * __Use databases (upcoming).__
    * Our sibling package [database](https://pub.dev/packages/database) will use this framework in
      future.
  * __Observe views / mutations in graphs__
    * The package has [ReactiveSystem](https://pub.dev/documentation/kind/latest/kind/EntityKind/ReactiveSystem.html)
      for observing views and mutations of reactive states in the isolate.
    * When you are deserializing JSON or Protocol Buffers, you get reactive objects by default.

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
  * Recommended _StringKind_ instances:
    * [stringKindForEmailAddress](https://pub.dev/documentation/kind/latest/kind.strings/stringKindForEmailAddress.html) (email address)
    * [stringKindForMarkdown](https://pub.dev/documentation/kind/latest/kind.strings/stringKindForMarkdown.html) (Markdown formatted content)
    * [stringKindForPhoneNumber](https://pub.dev/documentation/kind/latest/kind.strings/stringKindForPhoneNumber.html) (phone number)
    * [stringKindForUrl](https://pub.dev/documentation/kind/latest/kind.strings/stringKindForUrl.html) (URL)

### Other APIs
  * [Date](https://pub.dev/documentation/kind/latest/kind/GeoPoint-class.html) (unlike _DateTime_, has only date)
  * [DateTimeWithTimeZone](https://pub.dev/documentation/kind/latest/kind/GeoPoint-class.html) (unlike _DateTime_, allows arbitrary time zone)
  * [GeoPoint](https://pub.dev/documentation/kind/latest/kind/GeoPoint-class.html) (geographical latitude/longitude coordinates)
  * [ReactiveIterable](https://pub.dev/documentation/kind/latest/kind/ReactiveIterable-class.html)
  * [ReactiveList](https://pub.dev/documentation/kind/latest/kind/ReactiveList-class.html)
  * [ReactiveMap](https://pub.dev/documentation/kind/latest/kind/ReactiveMap-class.html)
  * [ReactiveSet](https://pub.dev/documentation/kind/latest/kind/ReactiveSet-class.html)
  * [Uuid](https://pub.dev/documentation/kind/latest/kind/GeoPoint-class.html) (128-bit object identifier)

## Some alternatives
  * For serialization
    * [built_value](https://pub.dev/packages/json_serializable)
    * [json_serializable](https://pub.dev/packages/json_serializable)
    * [protobuf](https://pub.dev/packages/protobuf)
  * For state management
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
  sdk: '>=2.12.0 <3.0.0'

dependencies:
  kind: ^0.3.2
```

## 2.Write data models
In the following example, we use [Field](https://pub.dev/documentation/kind/latest/kind/Field-class.html)
and [ListField](https://pub.dev/documentation/kind/latest/kind/ListField-class.html).
Wrapping values inside _Field<T>_ simplifies state observation. If you want to use normal Dart
getters / setters, see "Alternative approaches" section below.

```dart
import 'package:kind/kind.dart';

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
      b.requiredList<Person>(
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
  late final ListField<Person> friends = ListField<Person>(this);

  @override
  EntityKind getKind() => kind;
}

void main() {
    final alice = Person();
    alice.name.value = 'Alice';

    final bob = Person();
    bob.name.value = 'Bob';

    alice.friends.add(bob);
    bob.friends.add(alice);

    // Your objects have:
    //   * `==` (that supports cyclic graphs)
    //   * `hashCode`
    //   * `toString()``
    //   * And more!
}
```


# JSON serialization
Use [jsonTreeEncode(...)](https://pub.dev/documentation/kind/latest/kind/EntityKind/jsonTreeEncode.html)
and [jsonTreeDecode(...)](https://pub.dev/documentation/kind/latest/kind/EntityKind/jsonTreeDecode.html):

```dart
final alice = Person();
final bob = Person();
alice.name.value = 'Alice';
bob.name.value = 'Bob';
alice.friends.add(bob);

// Person --> JSON tree
final aliceJson = person.getKind().jsonTreeEncode(alice);
// JSON tree:
//   {
//     "fullName": "Alice",
//     "friends": [
//       {
//         "fullName": "Bob",
//       }
//     ]
//   }

// JSON tree --> Person
final decodedAlice = Person.kind.jsonTreeDecode(aliceJson);
```

## Mapping identifiers
If you want to use underscore naming convention, simply pass
[UnderscoreNamer](https://pub.dev/documentation/kind/latest/kind/UnderscoreNamer-class.html)
in the context object:
```dart
final namer = UnderscoreNamer();

// Person --> JSON tree
final aliceJson = person.getKind().jsonTreeEncode(
  alice,
  context: JsonEncodingContext(namer: namer),
);

// JSON tree --> Person
final decodedAlice = Person.kind.jsonTreeDecode(
  aliceJson,
  context: JsonDecodingContext(namer: namer),
);
```

You can also declare special rules:
```dart
final namer = UnderscoreNamer(
  rules: {
    'fullName': 'real_name',
  },
);
```

# Protocol Buffers serialization
For encoding/decoding Protocol Buffers bytes,
use [protobufBytesEncode(...)](https://pub.dev/documentation/kind/latest/kind/EntityKind/protobufBytesEncode.html)
and [protobufBytesDecode(...)](https://pub.dev/documentation/kind/latest/kind/EntityKind/protobufBytesDecode.html):

```dart
// Person --> bytes
final bytes = Person.kind.protobufBytesEncode(person);

// bytes --> Person
final person = Person.kind.protobufBytesDecode(bytes);
```

For encoding/decoding [GeneratedMessage](https://pub.dev/documentation/protobuf/latest/protobuf/GeneratedMessage-class.html)
(used by [package:protobuf](https://pub.dev/packages/protobuf) and [package:grpc](https://pub.dev/packages/grpc)),
use [protobufTreeEncode(...)](https://pub.dev/documentation/kind/latest/kind/EntityKind/protobufTreeEncode.html)
and [protobufTreeDecode(...)](https://pub.dev/documentation/kind/latest/kind/EntityKind/protobufTreeDecode.html):
```dart
// Person --> GeneratedMessage
final generatedMessage = Person.kind.protobufTreeEncode(person);

// GeneratedMessage --> Person
final person = Person.kind.protobufTreeDecode(generatedMessage);
```

You can also generate _GeneratedMessage_ classes with GRPC tooling and merge messages using
[mergeFromMessage](https://pub.dev/documentation/protobuf/latest/protobuf/GeneratedMessage/mergeFromMessage.html).


# Alternative approaches to specifying data classes
### Why / why not?
The alternative approaches:
  * Do not force you to deviate from the way you normally write classes.
  * Perform better when you have millions of objects.
  * Do not support reactive programming with `ReactiveSystem` unless you write a lot error-prone
    boilerplate code.
    * At some point, we may release a code generator that generates boilerplate for you, but there
      will inevitably going to be some complexity unless Dart language designers decide to support
      something like decorator annotations.

## Mutable and non-reactive
You just define `getter` and `setter` in [Prop](https://pub.dev/documentation/kind/latest/kind/Prop-class.html)
for ordinary Dart fields:
```dart
import 'package:kind/kind.dart';

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

## Mutable and reactive
You can use [ReactiveMixin](https://pub.dev/documentation/kind/latest/kind/ReactiveMixin-class.html)
for implementing getters and setters that send notifications to
[ReactiveSystem](https://pub.dev/documentation/kind/latest/kind/ReactiveSystem-class.html):
```dart
// ...

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

// `personKind` is identical to the previous example.
// ...
```


## Immutable and non-reactive
```dart
import 'package:kind/kind.dart';

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

## Immutable and reactive
You can use [ReactiveMixin](https://pub.dev/documentation/kind/latest/kind/ReactiveMixin-class.html)
for implementing getters and setters that send notifications to
[ReactiveSystem](https://pub.dev/documentation/kind/latest/kind/ReactiveSystem-class.html):
```dart
// ...

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

// `personKind` is identical to the previous example.
// ...
```