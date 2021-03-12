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
import 'package:kind/src/kind/object_kind.dart';
import 'package:test/test.dart';

void main() {
  group('ObjectKind', () {
    test('name', () {
      expect(ObjectKind().name, 'Object');
    });

    test('ObjectKind.kind', () {
      // ignore: invalid_use_of_protected_member
      final kind = ObjectKind.kind;
      expect(kind.name, 'ObjectKind');
      expect(kind.jsonTreeEncode(ObjectKind()), {});
      expect(kind.jsonTreeDecode({}), ObjectKind());
    });

    test('jsonTreeEncode: KindLibrary not present', () {
      final kind = ObjectKind<_Example>();
      final object = _Example();
      try {
        kind.jsonTreeEncode(object);
        fail('Expected error');
      } on GraphNodeError catch (e) {
        expect(e.node, same(object));
      }
    });

    test('jsonTreeEncode: KindLibrary present', () {
      final context = JsonEncodingContext(kindLibrary: _kindLibrary);
      final kind = ObjectKind<_Example>();
      final object = _Example();
      final json = kind.jsonTreeEncode(object, context: context);
      expect(json, {});
    });

    test('jsonTreeDecode: KindLibrary not present', () {
      final kind = ObjectKind<_Example>();
      final json = {};
      try {
        kind.jsonTreeDecode(json);
        fail('Expected error');
      } on GraphNodeError catch (e) {
        expect(e.node, same(json));
      }
    });

    test('jsonTreeDecode: KindLibrary present', () {
      final context = JsonDecodingContext(kindLibrary: _kindLibrary);
      final kind = ObjectKind<_Example>();
      final json = {};
      final result = kind.jsonTreeDecode(json, context: context);
      expect(result, isA<_Example>());
    });
  });
}

final _kindLibrary = KindLibrary([_Example.kind]);

class _Example {
  static final EntityKind kind = EntityKind<_Example>(
    name: 'example',
    define: (c) {
      c.constructor = () => _Example();
    },
  );
}
