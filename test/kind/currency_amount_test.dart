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
  group('CurrencyAmount', () {
    test('JSON serialization', () {
      final currencyAmount = CurrencyAmount('3.14', Currency.usd);
      final currencyAmountJson = 'USD 3.14';
      expect(
        const CurrencyAmountKind().jsonTreeEncode(currencyAmount),
        currencyAmountJson,
      );
      expect(
        const CurrencyAmountKind().jsonTreeDecode(currencyAmountJson),
        currencyAmount,
      );
    });

    test('== / hashCode', () {
      final object = CurrencyAmount.usd('2.50');
      final clone0 = CurrencyAmount.fromDecimal(
        Decimal.fromDouble(2.5, fractionDigits: 1),
        currency: Currency.specify(
          englishName: '',
          code: 'USD',
          regionCode: null,
          fractionDigitsInPricing: 2,
        ),
      );
      final other0 = CurrencyAmount.usd('3.00');
      final other1 = CurrencyAmount.fromDecimal(
        Decimal.fromDouble(2.5, fractionDigits: 1),
        currency: Currency.byCode['EUR']!,
      );

      expect(object, clone0);
      expect(object, isNot(other0));
      expect(object, isNot(other1));

      expect(object.hashCode, clone0.hashCode);
      expect(object.hashCode, isNot(other0.hashCode));
      expect(object.hashCode, isNot(other1.hashCode));
    });
  });
}
