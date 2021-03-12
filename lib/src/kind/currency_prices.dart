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

import 'package:collection/collection.dart';
import 'package:kind/kind.dart';

/// Currency exchange rates at specific point of time.
///
/// This class was declared so that developers who use [CurrencyAmount]
/// have a common way of getting currency conversion rates
/// ([CurrencyPrices.instance]).
class CurrencyPrices {
  static final EntityKind<CurrencyPrices> kind = EntityKind(
    name: 'CurrencyPrices',
    define: (c) {
      final pricesAt = c.requiredDateTime(
        id: 1,
        name: 'pricesAt',
        getter: (t) => t.pricesAt,
      );
      final currency = c.required(
        id: 2,
        name: 'currency',
        kind: Currency.kind,
      );
      final inversePrices = c.requiredMap(
        id: 3,
        name: 'inversePrices',
        keyKind: const StringKind(
          minLengthInUtf8: 3,
          maxLengthInUtf8: 3,
        ),
        valueKind: const Float64Kind(
          min: 0.0,
          exclusiveMin: true,
        ),
      );
      c.constructorFromData = (data) {
        return CurrencyPrices(
          pricesAt: data.get(pricesAt),
          currency: data.get(currency),
          inversePrices: data.get(inversePrices),
        );
      };
    },
  );

  /// Approximate currency prices from some point of history.
  static CurrencyPrices instance = CurrencyPrices(
    pricesAt: DateTime(2020, 03, 10),
    currency: Currency.eur,
    inversePrices: _initialMap,
  );

  // Values from European Central Bank:
  // https://www.ecb.europa.eu/stats/policy_and_exchange_rates/euro_reference_exchange_rates/html/index.en.html
  // (European Central Bank website says the statistics is free for use)
  //
  // If you have a larger dataset that can be used completely freely,
  // please replace the values.
  static final _initialMap = Map<String, double>.fromIterables(
    _initialKeys,
    _initialValues,
  );
  static final _initialKeys =
      'USD JPY BGN CZK DKK GBP HUF PLN RON SEK CHF ISK NOK HRK RUB TRY AUD BRL CAD CNY HKD IDR ILS INR KRW MXN MYR NZD PHP SGD THB ZAR'
          .split(' ');
  static final _initialValues =
      '1.1892 129.12 1.9558 26.226 7.4366 0.85655 367.48 4.5752 4.8865 10.1305 1.1069 152.10 10.0813 7.5865 87.9744 9.0269 1.5430 6.8807 1.5041 7.7433 9.2307 17130.43 3.9532 86.8100 1357.05 25.2221 4.9072 1.6590 57.780 1.6019 36.592 18.1740'
          .split(' ')
          .map(double.parse);

  /// Approximate time of the currency market information.
  final DateTime pricesAt;

  /// Pricing currency.
  final Currency currency;

  /// Prices of [currency] (measured in currency X).
  final Map<String, double> inversePrices;

  /// Prices of currency X (measured in [currency]).
  late final Map<String, double> prices = inversePrices
      .map((key, value) => MapEntry<String, double>(key, 1 / value));

  CurrencyPrices({
    required this.pricesAt,
    required this.currency,
    required this.inversePrices,
  });

  @override
  int get hashCode =>
      pricesAt.hashCode ^
      currency.hashCode ^
      const MapEquality<String, double>().hash(inversePrices);

  @override
  bool operator ==(other) =>
      other is CurrencyPrices &&
      pricesAt == other.pricesAt &&
      currency == other.currency &&
      const MapEquality<String, double>()
          .equals(inversePrices, other.inversePrices);

  CurrencyAmount? convert(
    CurrencyAmount currencyAmount, {
    required Currency toCurrency,
  }) {
    if (currencyAmount.currency.code == currency.code) {
      return currencyAmount;
    }
    final a = inversePrices[currencyAmount.currency.hashCode];
    if (a == null) {
      return null;
    }
    final b = inversePrices[currency.code];
    if (b == null) {
      return null;
    }
  }
}
