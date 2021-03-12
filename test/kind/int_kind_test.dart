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

import 'dart:typed_data';

import 'package:kind/kind.dart';
import 'package:test/test.dart';

void main() {
  group('IntKindBase', () {
    group('randomExample', () {
      const n = 1000;

      test('no constraints', () {
        const kind = Int32Kind();
        final set = <int>{};
        for (var i = 0; i < n; i++) {
          set.add(kind.randomExample());
        }
        expect(set.toList()..sort(), hasLength(greaterThan(5)));
      });
      test('min:100', () {
        const kind = Int32Kind(min: 100);
        final set = <int>{};
        for (var i = 0; i < n; i++) {
          set.add(kind.randomExample());
        }
        expect(set.toList()..sort(), hasLength(greaterThan(5)));
      });
      test('max:100', () {
        const kind = Int32Kind(max: 100);
        final set = <int>{};
        for (var i = 0; i < n; i++) {
          set.add(kind.randomExample());
        }
        expect(set.toList()..sort(), hasLength(greaterThan(5)));
      });
      test('min:-3, max:3', () {
        const kind = Int32Kind(min: -3, max: 3);
        final set = <int>{};
        for (var i = 0; i < n; i++) {
          set.add(kind.randomExample());
        }
        expect(set.toList()..sort(), hasLength(7));
      });
    });
  });

  group('Int8Kind', () {
    test('name', () {
      expect(const Int8Kind().name,
          '${PrimitiveKind.namePrefixForNonClasses}Int8');
    });

    test('Int8Kind.kind', () {
      // ignore: invalid_use_of_protected_member
      final kind = Int8Kind.kind;
      expect(kind.name, 'Int8Kind');
      expect(
        kind.jsonTreeEncode(const Int8Kind()),
        {},
      );
      expect(
        kind.jsonTreeEncode(const Int8Kind(min: 2)),
        {'min': 2.0},
      );
      expect(
        kind.jsonTreeEncode(const Int8Kind(max: 2)),
        {'max': 2.0},
      );
    });

    test('minPossible', () {
      expect(Int8Kind.minPossible, -0x7F - 1);
    });

    test('maxPossible', () {
      expect(Int8Kind.maxPossible, 0x7F);
    });

    test('newList(reactive:false)', () {
      final list = const Int8Kind().newList(2, reactive: false);
      expect(list, isA<Int8List>());
      expect(list, hasLength(2));
    });

    group('validation:', () {
      test('no constraints', () {
        const kind = Int8Kind();
        expect(kind.instanceIsValid(Int8Kind.minPossible - 1), isFalse);
        expect(kind.instanceIsValid(Int8Kind.minPossible), isTrue);
        expect(kind.instanceIsValid(Int8Kind.minPossible + 1), isTrue);
        expect(kind.instanceIsValid(-2), isTrue);
        expect(kind.instanceIsValid(-1), isTrue);
        expect(kind.instanceIsValid(0), isTrue);
        expect(kind.instanceIsValid(1), isTrue);
        expect(kind.instanceIsValid(Int8Kind.maxPossible - 1), isTrue);
        expect(kind.instanceIsValid(Int8Kind.maxPossible), isTrue);
        expect(kind.instanceIsValid(Int8Kind.maxPossible + 1), isFalse);
      });

      test('min: 3', () {
        const kind = Int8Kind(min: 3);
        expect(kind.instanceIsValid(2), isFalse);
        expect(kind.instanceIsValid(3), isTrue);
        expect(kind.instanceIsValid(4), isTrue);
      });

      test('max: 3', () {
        const kind = Int8Kind(max: 3);
        expect(kind.instanceIsValid(2), isTrue);
        expect(kind.instanceIsValid(3), isTrue);
        expect(kind.instanceIsValid(4), isFalse);
      });
    });
  });

  group('Int16Kind', () {
    test('name', () {
      expect(const Int16Kind().name,
          '${PrimitiveKind.namePrefixForNonClasses}Int16');
    });

    test('Int16Kind.kind', () {
      // ignore: invalid_use_of_protected_member
      final kind = Int16Kind.kind;
      expect(kind.name, 'Int16Kind');
      expect(
        kind.jsonTreeEncode(const Int16Kind()),
        {},
      );
      expect(
        kind.jsonTreeEncode(const Int16Kind(min: 2)),
        {'min': 2.0},
      );
      expect(
        kind.jsonTreeEncode(const Int16Kind(max: 2)),
        {'max': 2.0},
      );
    });

    test('minPossible', () {
      expect(Int16Kind.minPossible, -0x7FFF - 1);
    });

    test('maxPossible', () {
      expect(Int16Kind.maxPossible, 0x7FFF);
    });

    test('newList(reactive:false)', () {
      final list = const Int16Kind().newList(2, reactive: false);
      expect(list, isA<Int16List>());
      expect(list, hasLength(2));
    });

    group('validation:', () {
      test('no constraints', () {
        const kind = Int16Kind();
        expect(kind.instanceIsValid(Int16Kind.minPossible - 1), isFalse);
        expect(kind.instanceIsValid(Int16Kind.minPossible), isTrue);
        expect(kind.instanceIsValid(Int16Kind.minPossible + 1), isTrue);
        expect(kind.instanceIsValid(-2), isTrue);
        expect(kind.instanceIsValid(-1), isTrue);
        expect(kind.instanceIsValid(0), isTrue);
        expect(kind.instanceIsValid(1), isTrue);
        expect(kind.instanceIsValid(Int16Kind.maxPossible - 1), isTrue);
        expect(kind.instanceIsValid(Int16Kind.maxPossible), isTrue);
        expect(kind.instanceIsValid(Int16Kind.maxPossible + 1), isFalse);
      });

      test('min: 3', () {
        const kind = Int16Kind(min: 3);
        expect(kind.instanceIsValid(2), isFalse);
        expect(kind.instanceIsValid(3), isTrue);
        expect(kind.instanceIsValid(4), isTrue);
      });

      test('max: 3', () {
        const kind = Int16Kind(max: 3);
        expect(kind.instanceIsValid(2), isTrue);
        expect(kind.instanceIsValid(3), isTrue);
        expect(kind.instanceIsValid(4), isFalse);
      });
    });
  });

  group('Int32Kind', () {
    test('name', () {
      expect(const Int32Kind().name,
          '${PrimitiveKind.namePrefixForNonClasses}Int32');
    });

    test('Int32Kind.kind', () {
      // ignore: invalid_use_of_protected_member
      final kind = Int32Kind.kind;
      expect(kind.name, 'Int32Kind');
      expect(
        kind.jsonTreeEncode(const Int32Kind()),
        {},
      );
      expect(
        kind.jsonTreeEncode(const Int32Kind(min: 2)),
        {'min': 2.0},
      );
      expect(
        kind.jsonTreeEncode(const Int32Kind(max: 2)),
        {'max': 2.0},
      );
    });

    test('== / hashCode', () {
      // Helper for eliminating suggestions to use constants.
      final two = 2;

      final value = Int32Kind(
        min: two,
        max: 3,
      );
      final clone = Int32Kind(
        min: two,
        max: 3,
      );
      final other0 = Int64Kind(
        min: two,
        max: 3,
      );
      final other1 = Int32Kind(
        min: two + 9999,
        max: 3,
      );
      final other2 = Int32Kind(
        min: two,
        max: 3 + 9999,
      );

      expect(value, clone);
      expect(value, isNot(other0));
      expect(value, isNot(other1));
      expect(value, isNot(other2));

      expect(value.hashCode, clone.hashCode);
      expect(value.hashCode, isNot(other0.hashCode));
      expect(value.hashCode, isNot(other1.hashCode));
      expect(value.hashCode, isNot(other2.hashCode));
    });

    test('newInstance', () {
      expect(const Int32Kind().newInstance(), 0);
    });

    test('newList()', () {
      final list = const Int32Kind().newList(2);
      expect(list, isA<ReactiveList<int>>());
      expect(list, hasLength(2));
      if (list is ReactiveList<int>) {
        expect(list.wrapped, isA<Int32List>());
      }
      expect(() => list.add(42), throwsUnsupportedError);
    });

    test('newList(growable:true)', () {
      final list = const Int32Kind().newList(2, growable: true);
      expect(list, hasLength(2));
      list.add(42);
      expect(list, hasLength(3));
    });

    test('newList(reactive:false)', () {
      final list = const Int32Kind().newList(2, reactive: false);
      expect(list, isA<Int32List>());
      expect(list, hasLength(2));
      expect(() => list.add(42), throwsUnsupportedError);
    });

    test('minPossible', () {
      expect(Int32Kind.minPossible, -0x7FFFFFFF - 1);
    });

    test('maxPossible', () {
      expect(Int32Kind.maxPossible, 0x7FFFFFFF);
    });

    group('validation:', () {
      test('no constraints', () {
        const kind = Int32Kind();
        expect(kind.instanceIsValid(Int32Kind.minPossible - 1), isFalse);
        expect(kind.instanceIsValid(Int32Kind.minPossible), isTrue);
        expect(kind.instanceIsValid(Int32Kind.minPossible + 1), isTrue);
        expect(kind.instanceIsValid(-2), isTrue);
        expect(kind.instanceIsValid(-1), isTrue);
        expect(kind.instanceIsValid(0), isTrue);
        expect(kind.instanceIsValid(1), isTrue);
        expect(kind.instanceIsValid(Int32Kind.maxPossible - 1), isTrue);
        expect(kind.instanceIsValid(Int32Kind.maxPossible), isTrue);
        expect(kind.instanceIsValid(Int32Kind.maxPossible + 1), isFalse);
      });

      test('min: 3', () {
        const kind = Int32Kind(min: 3);
        expect(kind.instanceIsValid(2), isFalse);
        expect(kind.instanceIsValid(3), isTrue);
        expect(kind.instanceIsValid(4), isTrue);
      });

      test('max: 3', () {
        const kind = Int32Kind(max: 3);
        expect(kind.instanceIsValid(2), isTrue);
        expect(kind.instanceIsValid(3), isTrue);
        expect(kind.instanceIsValid(4), isFalse);
      });
    });
  });

  group('Int64Kind', () {
    test('name', () {
      expect(const Int64Kind().name,
          '${PrimitiveKind.namePrefixForNonClasses}Int64');
    });

    test('Int64Kind.kind', () {
      // ignore: invalid_use_of_protected_member
      final kind = Int64Kind.kind;
      expect(kind.name, 'Int64Kind');
      expect(
        kind.jsonTreeEncode(const Int64Kind()),
        {},
      );
      expect(
        kind.jsonTreeEncode(const Int64Kind(min: 2)),
        {'min': 2.0},
      );
      expect(
        kind.jsonTreeEncode(const Int64Kind(max: 2)),
        {'max': 2.0},
      );
    });

    test('== / hashCode', () {
      // Helper for eliminating suggestions to use constants.
      final two = 2;

      final value = Int64Kind(
        min: two,
        max: 3,
      );
      final clone = Int64Kind(
        min: two,
        max: 3,
      );
      final other0 = Int32Kind(
        min: two,
        max: 3,
      );
      final other1 = Int64Kind(
        min: two + 9999,
        max: 3,
      );
      final other2 = Int64Kind(
        min: two,
        max: 3 + 9999,
      );

      expect(value, clone);
      expect(value, isNot(other0));
      expect(value, isNot(other1));
      expect(value, isNot(other2));

      expect(value.hashCode, clone.hashCode);
      expect(value.hashCode, isNot(other0.hashCode));
      expect(value.hashCode, isNot(other1.hashCode));
      expect(value.hashCode, isNot(other2.hashCode));
    });

    test('newInstance()', () {
      expect(const Int64Kind().newInstance(), 0);
    });

    test('newList() in non-browser', () {
      final list = const Int64Kind().newList(2);
      expect(list, isA<ReactiveList<int>>());
      expect(list, hasLength(2));
      if (list is ReactiveList<int>) {
        expect(list.wrapped, isA<Int64List>());
      }
      expect(() => list.add(42), throwsUnsupportedError);
    }, testOn: '!browser');

    test('newList() in browser', () {
      final list = const Int64Kind().newList(2);
      expect(list, isA<ReactiveList<int>>());
      expect(list, hasLength(2));
      expect(() => list.add(42), throwsUnsupportedError);
    }, testOn: 'browser');

    test('newList(growable:true)', () {
      final list = const Int64Kind().newList(2, growable: true);
      expect(list, hasLength(2));
      list.add(42);
      expect(list, hasLength(3));
    });

    test('newList(reactive:false) in non-browser', () {
      final list = const Int64Kind().newList(2, reactive: false);
      expect(list, isA<Int64List>());
      expect(list, hasLength(2));
      expect(() => list.add(42), throwsUnsupportedError);
    }, testOn: '!browser');

    test('newList(reactive:false) in browser', () {
      final list = const Int64Kind().newList(2, reactive: false);
      expect(list, hasLength(2));
      expect(() => list.add(42), throwsUnsupportedError);
    }, testOn: 'browser');

    test('minSafeInJs', () {
      expect(Int64Kind.minSafeInJs, -0xFFFFFFFFFFFFF);
    });

    test('maxSafeInJs', () {
      expect(Int64Kind.maxSafeInJs, 0xFFFFFFFFFFFFF);
    });

    group('validation:', () {
      test('no constraints', () {
        const kind = Int64Kind();
        expect(
          kind.instanceIsValid(0),
          isTrue,
        );
        expect(
          kind.instanceIsValid(-0x80000000 * bit32 | (bit32 - 1)),
          isTrue,
        );
        expect(
          kind.instanceIsValid(0x7FFFFFFF * bit32 | (bit32 - 1)),
          isTrue,
        );
      });
      test('safeInJs: true', () {
        const kind = Int64Kind(safeInJs: true);
        expect(
          kind.instanceIsValid(0),
          isTrue,
        );
        expect(
          kind.instanceIsValid(Int64Kind.minSafeInJs),
          isTrue,
        );
        expect(
          kind.instanceIsValid(Int64Kind.maxSafeInJs),
          isTrue,
        );
        expect(
          kind.instanceIsValid(Int64Kind.minSafeInJs - 1),
          isFalse,
        );
        expect(
          kind.instanceIsValid(Int64Kind.maxSafeInJs + 1),
          isFalse,
        );
      });
      test('min: 3', () {
        const kind = Int64Kind(min: 3);
        expect(
          kind.instanceIsValid(-3),
          isFalse,
        );
        expect(
          kind.instanceIsValid(2),
          isFalse,
        );
        expect(
          kind.instanceIsValid(3),
          isTrue,
        );
        expect(
          kind.instanceIsValid(4),
          isTrue,
        );
      });
      test('max: 3', () {
        const kind = Int64Kind(max: 3);
        expect(
          kind.instanceIsValid(-4),
          isTrue,
        );
        expect(
          kind.instanceIsValid(2),
          isTrue,
        );
        expect(
          kind.instanceIsValid(3),
          isTrue,
        );
        expect(
          kind.instanceIsValid(4),
          isFalse,
        );
      });
    });
  });

  group('Uint8Kind', () {
    test('name', () {
      expect(const Uint8Kind().name,
          '${PrimitiveKind.namePrefixForNonClasses}Uint8');
    });

    test('Uint8Kind.kind', () {
      // ignore: invalid_use_of_protected_member
      final kind = Uint8Kind.kind;
      expect(kind.name, 'Uint8Kind');
      expect(
        kind.jsonTreeEncode(const Uint8Kind()),
        {},
      );
      expect(
        kind.jsonTreeEncode(const Uint8Kind(min: 2)),
        {'min': 2.0},
      );
      expect(
        kind.jsonTreeEncode(const Uint8Kind(max: 2)),
        {'max': 2.0},
      );
    });

    test('newList(reactive:false)', () {
      final list = const Uint8Kind().newList(2, reactive: false);
      expect(list, isA<Uint8List>());
      expect(list, hasLength(2));
    });

    test('maxPossible', () {
      expect(Uint8Kind.maxPossible, 0xFF);
    });

    group('validation:', () {
      test('no constraints', () {
        const kind = Uint8Kind();
        expect(kind.instanceIsValid(-2), isFalse);
        expect(kind.instanceIsValid(-1), isFalse);
        expect(kind.instanceIsValid(0), isTrue);
        expect(kind.instanceIsValid(1), isTrue);
        expect(kind.instanceIsValid(2), isTrue);
        expect(kind.instanceIsValid(Uint8Kind.maxPossible), isTrue);
        expect(kind.instanceIsValid(Uint8Kind.maxPossible + 1), isFalse);
      });

      test('min: 3', () {
        const kind = Uint8Kind(min: 3);
        expect(kind.instanceIsValid(2), isFalse);
        expect(kind.instanceIsValid(3), isTrue);
        expect(kind.instanceIsValid(4), isTrue);
      });

      test('max: 3', () {
        const kind = Uint8Kind(max: 3);
        expect(kind.instanceIsValid(2), isTrue);
        expect(kind.instanceIsValid(3), isTrue);
        expect(kind.instanceIsValid(4), isFalse);
      });
    });
  });

  group('Uint16Kind', () {
    test('name', () {
      expect(const Uint16Kind().name,
          '${PrimitiveKind.namePrefixForNonClasses}Uint16');
    });

    test('Uint16Kind.kind', () {
      // ignore: invalid_use_of_protected_member
      final kind = Uint16Kind.kind;
      expect(kind.name, 'Uint16Kind');
      expect(
        kind.jsonTreeEncode(const Uint16Kind()),
        {},
      );
      expect(
        kind.jsonTreeEncode(const Uint16Kind(min: 2)),
        {'min': 2.0},
      );
      expect(
        kind.jsonTreeEncode(const Uint16Kind(max: 2)),
        {'max': 2.0},
      );
    });

    test('newList(reactive:false)', () {
      final list = const Uint16Kind().newList(2, reactive: false);
      expect(list, isA<Uint16List>());
      expect(list, hasLength(2));
    });

    test('maxPossible', () {
      expect(Uint16Kind.maxPossible, 0xFFFF);
    });

    group('validation:', () {
      test('no constraints', () {
        const kind = Uint16Kind();
        expect(kind.instanceIsValid(-2), isFalse);
        expect(kind.instanceIsValid(-1), isFalse);
        expect(kind.instanceIsValid(0), isTrue);
        expect(kind.instanceIsValid(1), isTrue);
        expect(kind.instanceIsValid(2), isTrue);
        expect(kind.instanceIsValid(Uint16Kind.maxPossible), isTrue);
        expect(kind.instanceIsValid(Uint16Kind.maxPossible + 1), isFalse);
      });

      test('min: 3', () {
        const kind = Uint16Kind(min: 3);
        expect(kind.instanceIsValid(2), isFalse);
        expect(kind.instanceIsValid(3), isTrue);
        expect(kind.instanceIsValid(4), isTrue);
      });

      test('max: 3', () {
        const kind = Uint16Kind(max: 3);
        expect(kind.instanceIsValid(2), isTrue);
        expect(kind.instanceIsValid(3), isTrue);
        expect(kind.instanceIsValid(4), isFalse);
      });
    });
  });

  group('Uint32Kind', () {
    test('name', () {
      expect(const Uint32Kind().name,
          '${PrimitiveKind.namePrefixForNonClasses}Uint32');
    });

    test('Uint32Kind.kind', () {
      // ignore: invalid_use_of_protected_member
      final kind = Uint32Kind.kind;
      expect(kind.name, 'Uint32Kind');
      expect(
        kind.jsonTreeEncode(const Uint32Kind()),
        {},
      );
      expect(
        kind.jsonTreeEncode(const Uint32Kind(min: 2)),
        {'min': 2.0},
      );
      expect(
        kind.jsonTreeEncode(const Uint32Kind(max: 2)),
        {'max': 2.0},
      );
    });

    test('== / hashCode', () {
      // Helper for eliminating suggestions to use constants.
      final two = 2;

      final value = Uint32Kind(
        min: two,
        max: 3,
      );
      final clone = Uint32Kind(
        min: two,
        max: 3,
      );
      final other0 = Uint64Kind(
        min: two,
        max: 3,
      );
      final other1 = Uint32Kind(
        min: two + 9999,
        max: 3,
      );
      final other2 = Uint32Kind(
        min: two,
        max: 3 + 9999,
      );

      expect(value, clone);
      expect(value, isNot(other0));
      expect(value, isNot(other1));
      expect(value, isNot(other2));

      expect(value.hashCode, clone.hashCode);
      expect(value.hashCode, isNot(other0.hashCode));
      expect(value.hashCode, isNot(other1.hashCode));
      expect(value.hashCode, isNot(other2.hashCode));
    });

    test('newInstance()', () {
      expect(const Uint32Kind().newInstance(), 0);
    });

    test('newList()', () {
      final list = const Uint32Kind().newList(2);
      expect(list, isA<ReactiveList<int>>());
      expect(list, hasLength(2));
      if (list is ReactiveList<int>) {
        expect(list.wrapped, isA<Uint32List>());
      }
      expect(() => list.add(42), throwsUnsupportedError);
    });

    test('newList(growable:true)', () {
      final list = const Uint32Kind().newList(2, growable: true);
      expect(list, hasLength(2));
      list.add(42);
      expect(list, hasLength(3));
    });

    test('newList(reactive:false)', () {
      final list = const Uint32Kind().newList(2, reactive: false);
      expect(list, isA<Uint32List>());
      expect(list, hasLength(2));
      expect(() => list.add(42), throwsUnsupportedError);
    });

    test('maxPossible', () {
      expect(Uint32Kind.maxPossible, 0xFFFFFFFF);
    });

    group('validation:', () {
      test('no constraints', () {
        const kind = Uint32Kind();
        expect(kind.instanceIsValid(-2), isFalse);
        expect(kind.instanceIsValid(-1), isFalse);
        expect(kind.instanceIsValid(0), isTrue);
        expect(kind.instanceIsValid(1), isTrue);
        expect(kind.instanceIsValid(2), isTrue);
        expect(kind.instanceIsValid(Uint32Kind.maxPossible), isTrue);
        expect(kind.instanceIsValid(Uint32Kind.maxPossible + 1), isFalse);
      });

      test('min: 3', () {
        const kind = Uint32Kind(min: 3);
        expect(kind.instanceIsValid(2), isFalse);
        expect(kind.instanceIsValid(3), isTrue);
        expect(kind.instanceIsValid(4), isTrue);
      });

      test('max: 3', () {
        const kind = Uint32Kind(max: 3);
        expect(kind.instanceIsValid(2), isTrue);
        expect(kind.instanceIsValid(3), isTrue);
        expect(kind.instanceIsValid(4), isFalse);
      });
    });
  });

  group('Uint64Kind', () {
    test('name', () {
      expect(const Uint64Kind().name,
          '${PrimitiveKind.namePrefixForNonClasses}Uint64');
    });

    test('Uint64Kind.kind', () {
      // ignore: invalid_use_of_protected_member
      final kind = Uint64Kind.kind;
      expect(kind.name, 'Uint64Kind');
      expect(
        kind.jsonTreeEncode(const Uint64Kind()),
        {},
      );
      expect(
        kind.jsonTreeEncode(const Uint64Kind(min: 2)),
        {'min': 2.0},
      );
      expect(
        kind.jsonTreeEncode(const Uint64Kind(max: 2)),
        {'max': 2.0},
      );
    });

    test('== / hashCode', () {
      // Helper for eliminating suggestions to use constants.
      final two = 2;

      final value = Uint64Kind(
        min: two,
        max: 3,
      );
      final clone = Uint64Kind(
        min: two,
        max: 3,
      );
      final other0 = Uint32Kind(
        min: two,
        max: 3,
      );
      final other1 = Uint64Kind(
        min: two + 9999,
        max: 3,
      );
      final other2 = Uint64Kind(
        min: two,
        max: 3 + 9999,
      );

      expect(value, clone);
      expect(value, isNot(other0));
      expect(value, isNot(other1));
      expect(value, isNot(other2));

      expect(value.hashCode, clone.hashCode);
      expect(value.hashCode, isNot(other0.hashCode));
      expect(value.hashCode, isNot(other1.hashCode));
      expect(value.hashCode, isNot(other2.hashCode));
    });

    test('newInstance()', () {
      expect(const Uint64Kind().newInstance(), 0);
    });

    test('newList() in non-browser', () {
      final list = const Uint64Kind().newList(2);
      expect(list, isA<ReactiveList<int>>());
      expect(list, hasLength(2));
      if (list is ReactiveList<int>) {
        expect(list.wrapped, isA<Uint64List>());
      }
      expect(() => list.add(42), throwsUnsupportedError);
    }, testOn: '!browser');

    test('newList() in browser', () {
      final list = const Uint64Kind().newList(2);
      expect(list, isA<ReactiveList<int>>());
      expect(list, hasLength(2));
      expect(() => list.add(42), throwsUnsupportedError);
    }, testOn: 'browser');

    test('newList(growable:true)', () {
      final list = const Uint64Kind().newList(2, growable: true);
      expect(list, hasLength(2));
      list.add(42);
      expect(list, hasLength(3));
    });

    test('newList(reactive:false) in non-browser', () {
      final list = const Uint64Kind().newList(2, reactive: false);
      expect(list, isA<Uint64List>());
      expect(list, hasLength(2));
      expect(() => list.add(42), throwsUnsupportedError);
    }, testOn: '!browser');

    test('newList(reactive:false) in browser', () {
      final list = const Uint64Kind().newList(2, reactive: false);
      expect(list, hasLength(2));
      expect(() => list.add(42), throwsUnsupportedError);
    }, testOn: 'browser');

    group('validation:', () {
      test('no constraints', () {
        const kind = Uint64Kind();
        expect(
          kind.instanceIsValid(-1),
          isTrue,
        );
        expect(
          kind.instanceIsValid(0),
          isTrue,
        );
        expect(
          kind.instanceIsValid(0xFFFFFFFF * bit32 | (bit32 - 1)),
          isTrue,
        );
      });

      test('safeInJs: true', () {
        const kind = Uint64Kind(safeInJs: true);
        expect(
          kind.instanceIsValid(-1),
          isFalse,
        );
        expect(
          kind.instanceIsValid(0),
          isTrue,
        );
        expect(
          kind.instanceIsValid(Uint64Kind.maxSafeInJs),
          isTrue,
        );
        expect(
          kind.instanceIsValid(Uint64Kind.maxSafeInJs + 1),
          isFalse,
        );
      });
      test('min: 3', () {
        const kind = Uint64Kind(min: 3);
        expect(
          kind.instanceIsValid(-3),
          isFalse,
        );
        expect(
          kind.instanceIsValid(2),
          isFalse,
        );
        expect(
          kind.instanceIsValid(3),
          isTrue,
        );
        expect(
          kind.instanceIsValid(4),
          isTrue,
        );
      });
      test('max: 3', () {
        const kind = Uint64Kind(max: 3);
        expect(
          kind.instanceIsValid(-4),
          isFalse,
        );
        expect(
          kind.instanceIsValid(2),
          isTrue,
        );
        expect(
          kind.instanceIsValid(3),
          isTrue,
        );
        expect(
          kind.instanceIsValid(4),
          isFalse,
        );
      });
    });
  });
}

final bit32 = 0x100000000;
