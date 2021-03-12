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
  group('CamelCaseNamer', () {
    test('upperCaseProps: true', () {
      final namer = CamelCaseNamer(
        upperCaseProps: true,
      );

      // Example kind
      final kind = EntityKind(
        name: 'Person',
        define: (c) {
          c.optionalDate(
            id: 1,
            name: 'birthDate',
            getter: (t) => throw UnimplementedError(),
          );
        },
      );

      // birthDate --> BirthDate
      expect(
        namer.fromEntityKindPropName(kind, kind.props.single, 'birthDate'),
        'BirthDate',
      );

      // Does not affect other methods
      expect(namer.fromName(''), '');
      expect(namer.fromName('birthDate'), 'birthDate');
    });

    test('rules', () {
      final namer = CamelCaseNamer(
        rules: {
          'x': 'y',
        },
      );
      expect(namer.fromName('normal'), 'normal');
      expect(namer.fromName('x'), 'y');
    });
  });

  group('UnderscoreNamer', () {
    final namer = UnderscoreNamer();

    test('""', () {
      expect(namer.fromName(''), '');
    });

    test('"a"', () {
      expect(namer.fromName('a'), 'a');
    });

    test('"aBc"', () {
      expect(namer.fromName('aBc'), 'a_bc');
    });

    test('"aBC"', () {
      expect(namer.fromName('aBC'), 'a_b_c');
    });

    test('"a_b_c"', () {
      expect(namer.fromName('a_b_c'), 'a_b_c');
    });

    test('rules', () {
      final namer = UnderscoreNamer(
        rules: {
          'x': 'y',
        },
      );
      expect(namer.fromName('a_'), 'a_');
      expect(namer.fromName('x'), 'y');
    });
  });
}
