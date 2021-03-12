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
  group('Currency', () {
    test('JSON serialization', () {
      final currency = Currency.usd;
      final currencyJson = 'USD';
      expect(
        Currency.kind.jsonTreeEncode(currency),
        currencyJson,
      );
      expect(
        Currency.kind.jsonTreeDecode(currencyJson),
        currency,
      );
    });

    test('byCode', () {
      expect(Currency.byCode['EUR'], Currency.eur);
      expect(Currency.byCode['SEK'], Currency.sek);
      expect(Currency.byCode['SE'], isNull);
      expect(Currency.byCode, hasLength(Currency.values.length));
    });

    test('byRegionCode', () {
      expect(Currency.byRegionCode['DE'], Currency.eur);
      expect(Currency.byRegionCode['SE'], Currency.sek);
      expect(Currency.byRegionCode['SEK'], isNull);
    });
  });
}
