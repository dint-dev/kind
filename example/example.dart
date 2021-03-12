import 'dart:convert';

import 'package:kind/kind.dart';

void main() {
  final decodedJson = {
    'name': 'John Doe',
    'friends': [
      {'name': 'Alice'},
      {'name': 'Bob'},
    ],
  };

  // Decode JSON
  final person = Person.kind.jsonTreeDecode(
    decodedJson,
  );
  print('Name:');
  print(person.identifier);

  // Encode JSON
  final encodedJson = person.toJson();

  print('JSON:');
  print(json.encode(encodedJson));
}

class Person extends Entity {
  static final kind = EntityKind<Person>(
    name: 'Person',
    packageName: 'example',
    define: (c) {
      c.requiredString(
        id: 1,
        name: 'name',
        maxLengthInUtf8: 64,
        examples: ['John Doe'],
        field: (t) => t.name,
      );
      c.optionalDate(
        id: 2,
        name: 'dateOfBirth',
        field: (t) => t.dateOfBirth,
      );
      c.requiredList<Person>(
        id: 2,
        name: 'friends',
        itemsKind: Person.kind,
        field: (t) => t.friends,
      );
      c.constructor = () => Person();
    },
  );

  /// Name of person.
  late final Field<String> name = Field<String>(this);

  /// Name of person (nullable).
  late final Field<Date?> dateOfBirth = Field<Date?>(this);

  /// Employees of the person.
  late final ListField<Person> friends = ListField<Person>(this);

  @override
  EntityKind getKind() => kind;
}
