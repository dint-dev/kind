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
  * Decimal numbers
    * [DecimalKind](https://pub.dev/documentation/kind/latest/kind/DecimalKind-class.html)
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
  * One of multiple values or kinds
    * [EnumKind](https://pub.dev/documentation/kind/latest/kind/EnumKind-class.html)
    * [ObjectKind](https://pub.dev/documentation/kind/latest/kind/ObjectKind-class.html)
    * [OneOfKind](https://pub.dev/documentation/kind/latest/kind/OneOfKind-class.html)
  * Money
    * [Currency.kind](https://pub.dev/documentation/kind/latest/kind/Currency/kind.html)
    * [CurrencyAmountKind](https://pub.dev/documentation/kind/latest/kind/CurrencyAmountKind-class.html)
  * Geospatial
    * [GeoPointKind](https://pub.dev/documentation/kind/latest/kind/GeoPointKind-class.html)
  * Unique identifiers
    * [UuidKind](https://pub.dev/documentation/kind/latest/kind/UuidKind-class.html)
  * Arbitrary JSON trees
    * [JsonKind](https://pub.dev/documentation/kind/latest/kind/JsonKind-class.html)
  * Others
    * [FutureKind](https://pub.dev/documentation/kind/latest/kind/FutureKind-class.html)
    * [NullableKind](https://pub.dev/documentation/kind/latest/kind/NullableKind-class.html)
    * [StreamKind](https://pub.dev/documentation/kind/latest/kind/StreamKind-class.html)
  * Your custom models
    * [CompositePrimitiveKind](https://pub.dev/documentation/kind/latest/kind/CompositePrimitiveKind-class.html)
    * [EntityKind](https://pub.dev/documentation/kind/latest/kind/EntityKind-class.html)
  * Recommended _StringKind_ instances:
    * [stringKindForEmailAddress](https://pub.dev/documentation/kind/latest/kind.strings/stringKindForEmailAddress-constant.html) (email address)
    * [stringKindForMarkdown](https://pub.dev/documentation/kind/latest/kind.strings/stringKindForMarkdown-constant.html) (Markdown formatted content)
    * [stringKindForPhoneNumber](https://pub.dev/documentation/kind/latest/kind.strings/stringKindForPhoneNumber-constant.html) (phone number)
    * [stringKindForUrl](https://pub.dev/documentation/kind/latest/kind.strings/stringKindForUrl-constant.html) (URL)

### Other APIs
  * [Currency](https://pub.dev/documentation/kind/latest/kind/Currency-class.html) (currency)
  * [CurrencyAmount](https://pub.dev/documentation/kind/latest/kind/CurrencyAmount-class.html) (currency amount)
  * [Date](https://pub.dev/documentation/kind/latest/kind/GeoPoint-class.html) (unlike _DateTime_, has only date)
  * [DateTimeWithTimeZone](https://pub.dev/documentation/kind/latest/kind/GeoPoint-class.html) (unlike _DateTime_, allows arbitrary time zone)
  * [Decimal](https://pub.dev/documentation/kind/latest/kind/Decimal-class.html) (decimal number)
  * [GeoPoint](https://pub.dev/documentation/kind/latest/kind/GeoPoint-class.html) (geographical latitude/longitude coordinates)
  * [ReactiveIterable](https://pub.dev/documentation/kind/latest/kind/ReactiveIterable-class.html) (reactive Iterable<T>)
  * [ReactiveList](https://pub.dev/documentation/kind/latest/kind/ReactiveList-class.html) (reactive List<T>)
  * [ReactiveMap](https://pub.dev/documentation/kind/latest/kind/ReactiveMap-class.html) (reactive Map<T>)
  * [ReactiveSet](https://pub.dev/documentation/kind/latest/kind/ReactiveSet-class.html) (reactive Set<T>)
  * [UnitOfArea](https://pub.dev/documentation/kind/latest/kind/UnitOfArea-class.html) (unit of area)
  * [UnitOfLength](https://pub.dev/documentation/kind/latest/kind/UnitOfLength-class.html) (unit of length)
  * [UnitOfMeasure](https://pub.dev/documentation/kind/latest/kind/UnitOfMeasure-class.html) (unit of measure)
  * [UnitOfVolume](https://pub.dev/documentation/kind/latest/kind/UnitOfVolume-class.html) (unit of volume)
  * [UnitOfWeight](https://pub.dev/documentation/kind/latest/kind/UnitOfWeight-class.html) (unit of weight)
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
  kind: ^0.5.0
```

## 2.Write data models

When you extend [Entity](https://pub.dev/documentation/kind/latest/kind/Entity-class.html)
and declare [EntityKind](https://pub.dev/documentation/kind/latest/kind/EntityKind-class.html)
for your entity, you get:
  * `==` (that handles cycles correctly)
  * `hashCode`
  * `toString()`
  * JSON serialization
  * Protocol Buffers serialization
  * And more!

There are many ways to declare _EntityKind_. Your choice depends on:
  * Is your class immutable or mutable?
  * Do you need state observation?

## Immutable class?
```dart
import 'package:kind/kind.dart';

class Pet extends Object with EntityMixin {
  static final EntityKind<Pet> kind = EntityKind<Pet>(
    name: 'Pet',
    define: (c) {
      // In this function, we define:
      //   * Properties
      //   * Constructor
      //   * Additional metadata (examples, etc.)

      // Property #1
      //
      // Here "optionalString()" means "define a nullable string property".
      // It returns an instance of Prop<Pet, String?>.
      final nameProp = c.optionalString(
        // ID is some unique integer that's 1 or greater.
        //
        // It's used by (optional) Protocol Buffers serialization.
        //
        id: 1,

        // Name of the field.
        //
        // It's used by, for example, JSON serialization.
        //
        name: 'name',

        // Here we say that the string must have at least 1 character.
        minLengthInUtf8: 1,

        // Getter that returns value of the field.
        getter: (t) => t.name,
      );

      // Property #2
      final bestFriendProp = c.optional<Pet>(
        id: 2,
        name: 'bestFriend',
        kind: Pet.kind,
        getter: (t) => t.bestFriend,
      );

      // Property #3
      final friendsProp = c.requiredList<Pet>(
        id: 3,
        name: 'friends',
        itemsKind: Pet.kind,
        getter: (t) => t.friends,
      );

      // Example (optional)
      c.examples = [
        Pet(name: 'Charlie'),
      ];

      // Define constructor
      c.constructorFromData = (data) {
        return Pet(
          name: data.get(nameProp),
          bestFriend: data.get(bestFriendProp),
          friends: data.get(friendsProp),
        );
      };
    },
  );

  /// Full name.
  final String? name;

  /// Best friend.
  final Pet? bestFriend;

  /// List of friends.
  final List<Pet> friends;

  Pet({
    this.name,
    this.bestFriend,
    this.friends = const [],
  });

  @override
  EntityKind<Pet> getKind() => kind;
}
```

Property definition methods such as `optionalString` (in
[EntityKindDefineContext](https://pub.dev/documentation/kind/latest/kind/EntityKindDefineContext-class.html))
are just convenient methods for adding [Prop<T,V>](https://pub.dev/documentation/kind/latest/kind/Prop-class.html)
instances. They save a few lines compared to something like:
```dart
c.addProp(Prop<Pet, String?>(
  id: 1,
  name: 'name',
  kind: const StringKind(
    minLengthInUtf8: 1,
  ),
  getter: (t) => t.name,
));
```

## Mutable class?
```dart
import 'package:kind/kind.dart';

class Pet extends Object with EntityMixin {
  static final EntityKind<Pet> kind = EntityKind<Pet>(
    name: 'Pet',
    define: (c) {
      // Property #1
      c.optionalString(
        id: 1,
        name: 'name',
        minLengthInUtf8: 1,
        getter: (t) => t.name,
        setter: (e,v) => e.name = v, // <-- Not defined in the earlier approach.
      );

      // Property #2
      c.optional<Pet>(
        id: 2,
        name: 'bestFriend',
        kind: Pet.kind,
        getter: (t) => t.bestFriend,
        setter: (e,v) => e.bestFriend = v, // <-- Not defined in the earlier approach.
      );

      // Property #3
      c.requiredList<Pet>(
        id: 3,
        name: 'friends',
        itemsKind: Pet.kind,
        getter: (t) => t.friends,
        setter: (e,v) => e.friends = v, // <-- Not defined in the earlier approach.
      );

      // Define constructor
      c.constructor = () => Pet(); // <-- Different from the earlier approach.
    },
  );

  /// Full name.
  String? name;

  /// Best friend.
  Pet? bestFriend;

  /// List of friends.
  List<Pet> friends = [];

  @override
  EntityKind getKind() => kind;
}
```


# JSON serialization
Use [JsonEncodingContext](https://pub.dev/documentation/kind/latest/kind/JsonEncodingContext-class.html)
and [JsonDecodingContext](https://pub.dev/documentation/kind/latest/kind/JsonDecodingContext-class.html):

```dart
import 'package:kind/kind.dart';

void main() {}
  final cat = Pet();
  bob.name.value = 'Bob';
  
  final dog = Pet();
  alice.name.value = 'Alice';
  alice.bestFriend = cat;

  // Pet --> JSON tree
  final encodingContext = JsonEncodingContext();
  final dogJson = encodingContext.encode(dog, kind: Pet.kind);
  // JSON tree:
  //   {
  //     "name": "Alice",
  //     "bestFriend": {
  //       "name": "Bob",
  //     }
  //   }
  
  // JSON tree --> Pet
  final decodingContext = JsonEncodingContext();
  final decodedDog = decodingContext.decode(dogJson, kind: Pet.kind);
}
```

If you want to map identifiers to different naming convention or have special
identifier rules, use [Namer](https://pub.dev/documentation/kind/latest/kind/Namer-class.html).

If you want to change entirely how some classes are serialized, override
methods in  [JsonEncodingContext](https://pub.dev/documentation/kind/latest/kind/JsonEncodingContext-class.html)
and [JsonDecodingContext](https://pub.dev/documentation/kind/latest/kind/JsonDecodingContext-class.html).

# Protocol Buffers serialization
For encoding/decoding Protocol Buffers bytes,
use [protobufBytesEncode(...)](https://pub.dev/documentation/kind/latest/kind/EntityKind/protobufBytesEncode.html)
and [protobufBytesDecode(...)](https://pub.dev/documentation/kind/latest/kind/EntityKind/protobufBytesDecode.html):

```dart
// Pet --> bytes
final bytes = Pet.kind.protobufBytesEncode(pet);

// bytes --> Pet
final pet = Pet.kind.protobufBytesDecode(bytes);
```

For encoding/decoding [GeneratedMessage](https://pub.dev/documentation/protobuf/latest/protobuf/GeneratedMessage-class.html)
(used by [package:protobuf](https://pub.dev/packages/protobuf) and [package:grpc](https://pub.dev/packages/grpc)),
use [protobufTreeEncode(...)](https://pub.dev/documentation/kind/latest/kind/EntityKind/protobufTreeEncode.html)
and [protobufTreeDecode(...)](https://pub.dev/documentation/kind/latest/kind/EntityKind/protobufTreeDecode.html):
```dart
// Pet --> GeneratedMessage
final generatedMessage = Pet.kind.protobufTreeEncode(pet);

// GeneratedMessage --> Pet
final pet = Pet.kind.protobufTreeDecode(generatedMessage);
```

You can also generate _GeneratedMessage_ classes with GRPC tooling and merge messages (using
[mergeFromMessage](https://pub.dev/documentation/protobuf/latest/protobuf/GeneratedMessage/mergeFromMessage.html)
and other methods available).

If you want to map identifiers to different naming convention or have special
identifier rules, use [Namer](https://pub.dev/documentation/kind/latest/kind/Namer-class.html).

If you want to change entirely how some classes are serialized, override
methods in  [ProtobufEncodingContext](https://pub.dev/documentation/kind/latest/kind/ProtobufEncodingContext-class.html)
and [ProtobufDecodingContext](https://pub.dev/documentation/kind/latest/kind/ProtobufDecodingContext-class.html).


# Defining reactive classes
## Approach #1: Field<T> instances
In the following example, we use [Field](https://pub.dev/documentation/kind/latest/kind/Field-class.html)
and [ListField](https://pub.dev/documentation/kind/latest/kind/ListField-class.html).
They handle sending of notifications to [ReactiveSystem](https://pub.dev/documentation/kind/latest/kind/ReactiveSystem-class.html).

```dart
import 'package:kind/kind.dart';

class Pet extends Object with EntityMixin {
  static final EntityKind<Pet> kind = EntityKind<Pet>(
    name: 'Pet',
    define: (c) {
      // Property #1
      c.optionalString(
        id: 1,
        name: 'name',
        minLengthInUtf8: 1,
        field: (e) => e.name,
      );

      // Property #2
      c.optional<Pet>(
        id: 2,
        name: 'bestFriend',
        kind: Pet.kind,
        field: (e) => e.bestFriend,
      );

      // Property #3
      c.requiredList<Pet>(
        id: 3,
        name: 'friends',
        itemsKind: Pet.kind,
        field: (e) => e.friends,
      );

      // Define constructor
      c.constructor = () => Pet();
    },
  );

  /// Full name.
  late final Field<String?> name = Field<String?>(this);

  /// Best friend.
  late final Field<Pet?> friends = Field<Pet?>(this);

  /// List of friends.
  late final ListField<Pet> friends = ListField<Pet>(this);

  @override
  EntityKind getKind() => kind;
}
```

## Approach #2: ReactiveMixin
You can use [ReactiveMixin](https://pub.dev/documentation/kind/latest/kind/ReactiveMixin-class.html)
for implementing getters and setters that send notifications to
[ReactiveSystem](https://pub.dev/documentation/kind/latest/kind/ReactiveSystem-class.html).

This is a bit more error-prone approach than the approach above.

```dart
import 'package:kind/kind.dart';

class Pet extends Entity with ReactiveMixin {
  static final EntityKind<Pet> kind = EntityKind<Pet>(
    name: 'Pet',
    define: (c) {
      // Property #1
      c.optionalString(
        id: 1,
        name: 'name',
        minLengthInUtf8: 1,
        getter: (t) => t.name,
        setter: (e,v) => e.name = v, // <-- Not defined in the earlier approach.
      );

      // Property #2
      c.optional<Pet>(
        id: 2,
        name: 'bestFriend',
        kind: Pet.kind,
        getter: (t) => t.bestFriend,
        setter: (e,v) => e.bestFriend = v, // <-- Not defined in the earlier approach.
      );

      // Property #3
      c.requiredList<Pet>(
        id: 3,
        name: 'friends',
        itemsKind: Pet.kind,
        getter: (t) => t.friends,
        setter: (e,v) => e.friends = v, // <-- Not defined in the earlier approach.
      );

      // Define constructor
      c.constructor = () => Pet(); // <-- Different from the earlier approach.
    },
  );

  String? _name;
  Pet? _bestFriend;
  List<Pet> _friends = ReactiveList<Pet>.empty();

  /// Full name.
  String? get name => beforeGet(_name);
  set name(String? value) => _name = beforeSet(_name, value);

  /// Best friend.
  Pet? get bestFriend => beforeGet(_bestFriend);
  set bestFriend(Pet? value) => _bestFriend = beforeSet(_bestFriend, value);

  /// List of friends.
  List<Pet> get friends => beforeGet(_friends);
  set friends(List<Pet> value) => _friends = beforeSet(_friends, value);

  @override
  EntityKind<Pet> getKind() => petKind;
}
```