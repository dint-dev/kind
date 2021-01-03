# Overview

This package provides a serialization solution and data frames for large data sets.

__This is an initial experimental version. Not recommended for use.__

# Example
In _pubspec.yaml_:
```yaml
dependencies:
  kind: ^0.1.0-nullsafety.0
```

In your `main`:
```dart
import 'package:kind/kind.dart';

void main() {
  final json = <String,Object?>{
    'name': 'Joe',
    'age': 42,
  };

  // Decode JSON
  final person = Person.kind.decode(Data.fromJson(json));

  // Encode JSON
  final json= Person.kind.encodeJsonObject(person);
}

class Person implements HasKind {
  static final Kind kind = PersonKind<Person>();
  
  final String name;
  final int? age;
  
  Person({required this.name, required this.age});
  
  @override
  Kind getKind() => kind;
}

/// Object mapping for `Person`.
class PersonKind<T extends Person> extends Kind<T> {
  late StringProp<T> name = StringProp<T>(
    this,
    'name',
    getter: (t) => t.name,
  );

  late NullableProp<T, int> age = NullableProp<T,int>(
    IntProp(this, 'age'),
    getter: (t) => t.age,
  );

  @override
  Person decode(Data data) {
    return Person(
      name: name.decode(data);
      age: age.decode(data),
    );
  }
}
```