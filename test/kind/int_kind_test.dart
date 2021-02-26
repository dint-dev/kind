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
import 'dart:typed_data';

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

  group('Int32Kind', () {
    test('name', () {
      expect(const Int32Kind().name, 'Int32');
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

    test('defaultValue', () {
      expect(const Int32Kind().newInstance(), 0);
    });

    test('validation #1', () {
      const kind = Int32Kind();
      expect(kind.instanceIsValid(-2), isTrue);
      expect(kind.instanceIsValid(0), isTrue);
      expect(kind.instanceIsValid(2), isTrue);
    });

    test('validation #2', () {
      const kind = Int32Kind(min: 2);
      expect(kind.instanceIsValid(1), isFalse);
      expect(kind.instanceIsValid(2), isTrue);
      expect(kind.instanceIsValid(3), isTrue);
    });

    test('validation #2', () {
      const kind = Int32Kind(max: 2);
      expect(kind.instanceIsValid(1), isTrue);
      expect(kind.instanceIsValid(2), isTrue);
      expect(kind.instanceIsValid(3), isFalse);
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
  });

  group('Int64Kind', () {
    test('name', () {
      expect(const Int64Kind().name, 'Int64');
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
  });

  group('Uint32Kind', () {
    test('name', () {
      expect(const Uint32Kind().name, 'Uint32');
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
  });

  group('Uint64Kind', () {
    test('name', () {
      expect(const Uint64Kind().name, 'Uint64');
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
  });
}
