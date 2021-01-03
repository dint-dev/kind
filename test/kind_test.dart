import 'package:kind/kind.dart';
import 'package:test/test.dart';

void main() {
  group('Kind', () {
    test('encodeJsonObject(...)', () {
      final json =
          Example.kind.encodeJsonObject(Example()..stringField = 'hello');
      expect(json['stringField'], 'hello');
    });

    test('decode(...)', () {
      final data = Data.fromJson({'stringField': 'hello'});
      final value = Example.kind.decode(data);
      expect(value.stringField, 'hello');
    });
  });

  test('MemoryFrame', () async {
    final frame = MemoryFrame<int>(
      items: [1,2,3],
    );
    final list = await frame.where((item) => item>=2).toList();
    expect(list, [2,3]);
  });
}

class Example extends HasKind {
  static final kind = ExampleKind();

  bool boolField = false;
  int intField = 0;
  double doubleField = 0.0;
  DateTime dateTimeField = DateTime.fromMicrosecondsSinceEpoch(0);
  String stringField = '';
  List<String> listField = [];
  String? nullableField;

  @override
  Kind getKind() => kind;
}

class ExampleKind<T extends Example> extends Kind<T> {
  late BoolProp<T> boolField = BoolProp<T>(
    this,
    'boolField',
    getter: (t) => t.boolField,
  );

  late IntProp<T> intField = IntProp<T>(
    this,
    'intField',
    getter: (t) => t.intField,
  );

  late DoubleProp<T> doubleField = DoubleProp<T>(
    this,
    'doubleField',
    getter: (t) => t.doubleField,
  );

  late DateTimeProp<T> dateTimeField = DateTimeProp<T>(
    this,
    'dateTimeField',
    getter: (t) => t.dateTimeField,
  );

  late StringProp<T> stringField = StringProp<T>(
    this,
    'stringField',
    getter: (t) => t.stringField,
  );

  late ListProp<T, String> listField = ListProp<T, String>(
    this,
    'listField',
    getter: (t) => t.listField,
  );

  late NullableProp<T, String?> nullableField = NullableProp<T, String?>(
    StringProp(this, 'nullableField'),
    getter: (t) => t.nullableField,
  );

  ExampleKind()
      : super(
          name: 'Example',
        );

  @override
  Example decode(Data data) {
    return Example()
      ..boolField = boolField.get(data)
      ..intField = intField.get(data)
      ..doubleField = doubleField.get(data)
      ..dateTimeField = dateTimeField.get(data)
      ..stringField = stringField.get(data)
      ..listField = listField.get(data)
      ..nullableField = nullableField.get(data);
  }
}
