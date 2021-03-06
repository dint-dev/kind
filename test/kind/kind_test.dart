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
  group('Kind', () {
    test('Kind.kind', () {
      final oneOfKind = Kind.kind as OneOfKind<Kind>;
      final kinds = oneOfKind.entries.map((e) => e.kind).toSet();
      // ignore: invalid_use_of_protected_member
      expect(kinds, contains(BoolKind.kind));
      // ignore: invalid_use_of_protected_member
      expect(kinds, contains(Int32Kind.kind));
      // ignore: invalid_use_of_protected_member
      expect(kinds, contains(Int64Kind.kind));
      // ignore: invalid_use_of_protected_member
      expect(kinds, contains(Int64FixNumKind.kind));
      // ignore: invalid_use_of_protected_member
      expect(kinds, contains(Uint32Kind.kind));
      // ignore: invalid_use_of_protected_member
      expect(kinds, contains(Uint64Kind.kind));
      // ignore: invalid_use_of_protected_member
      expect(kinds, contains(StringKind.kind));
      // ignore: invalid_use_of_protected_member
      expect(kinds, contains(BytesKind.kind));
      // ignore: invalid_use_of_protected_member
      expect(kinds, contains(SetKind.kind));
      // ignore: invalid_use_of_protected_member
      expect(kinds, contains(ListKind.kind));
      // ignore: invalid_use_of_protected_member
      expect(kinds, contains(EntityKind.kind));

      for (var kind in kinds) {
        if (!kind.isSerializable) {
          continue;
        }
        kind.newInstance();
        if (kind is StringKind) {
          expect(kind.instanceIsCorrectType(3.14), isFalse);
          expect(kind.instanceIsValid(3.14), isFalse);
          expect(kind.instanceIsCorrectType(3.14), isFalse);
        } else {
          expect(kind.instanceIsCorrectType('abc'), isFalse);
          expect(kind.instanceIsValid('abc'), isFalse);
          expect(kind.instanceIsDefaultValue('abc'), isFalse);
        }
      }
    });
  });
}
