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

import 'package:kind/kind.dart';
import 'package:test/test.dart';

void main() {
  group('CompositePrimitiveKind', () {
    final kind = _ExampleKind();

    test('jsonTreeDecode', () {
      final value = kind.jsonTreeDecode('abc');
      expect(value, _Example('abc'));
    });

    test('jsonTreeEncode', () {
      final value = kind.jsonTreeEncode(_Example('abc'));
      expect(value, 'abc');
    });

    test('newInstance()', () {
      expect(kind.newInstance(), _Example(''));
    });

    test('protobufFieldType', () {
      expect(kind.protobufFieldType, const StringKind().protobufFieldType);
    });

    test('protobufValueToInstance', () {
      final value = kind.protobufTreeDecode('abc');
      expect(value, _Example('abc'));
    });

    test('protobufValueFromInstance', () {
      final value = kind.protobufTreeEncode(_Example('abc'));
      expect(value, 'abc');
    });
  });
}

class _Example {
  final String value;

  _Example(this.value);

  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(other) => other is _Example && value == other.value;

  @override
  String toString() => '_Example("$value")';
}

class _ExampleKind extends CompositePrimitiveKind<_Example, String> {
  @override
  String get name => 'Example';

  @override
  PrimitiveKind<String> buildPrimitiveKind() {
    return const StringKind();
  }

  @override
  EntityKind<Object> getKind() {
    throw UnimplementedError();
  }

  @override
  _Example instanceFromPrimitive(String builtKindInstance) {
    return _Example(builtKindInstance);
  }

  @override
  String instanceToPrimitive(_Example instance) {
    return instance.value;
  }
}
