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

/// Exact amount of specific currency.
///
/// # Example
/// ```
/// import 'package:kind/kind.dart';
///
/// void main() {
///   // 3.14 Danish krones.
///   final amount = CurrencyAmount('3.14', Currency.dkk);
///
///   // Prints "3.14 kr"
///   print(amount.toLocalFormat());
///
///   // Prints "DKK 3.14"
///   print(amount.toCodeFormat());
/// }
/// ```
class CurrencyAmount implements Comparable<CurrencyAmount> {
  /// Exact amount.
  final Decimal amount;

  /// Currency.
  final Currency currency;

  factory CurrencyAmount(String s, Currency currency) {
    final decimal = Decimal(s);
    return CurrencyAmount.fromDecimal(decimal, currency: currency);
  }

  /// A shorthand for constructing amounts of [Currency.eur].
  factory CurrencyAmount.eur(String s) {
    return CurrencyAmount(s, Currency.eur);
  }

  CurrencyAmount.fromDecimal(Decimal amount, {required this.currency})
      : amount = amount.usingFractionDigits(currency.fractionDigitsInPricing);

  /// A shorthand for constructing amounts of [Currency.usd].
  factory CurrencyAmount.usd(String s) {
    return CurrencyAmount(s, Currency.usd);
  }

  @override
  int get hashCode => amount.hashCode ^ currency.code.hashCode;

  /// Adds an amount of the same currency.
  ///
  /// Throws [ArgumentError] if the currencies are different.
  CurrencyAmount operator +(CurrencyAmount other) {
    if (currency.code != other.currency.code) {
      throw ArgumentError.value(other);
    }
    return CurrencyAmount.fromDecimal(amount + other.amount,
        currency: currency);
  }

  /// Negates the amount.
  CurrencyAmount operator -() {
    return CurrencyAmount.fromDecimal(-amount, currency: currency);
  }

  /// Subtracts an amount of the same currency.
  ///
  /// Throws [ArgumentError] if the currencies are different.
  CurrencyAmount operator -(CurrencyAmount other) {
    if (currency.code != other.currency.code) {
      throw ArgumentError.value(other);
    }
    return CurrencyAmount.fromDecimal(amount - other.amount,
        currency: currency);
  }

  @override
  bool operator ==(other) =>
      other is CurrencyAmount &&
      amount == other.amount &&
      currency.code == other.currency.code;

  @override
  int compareTo(CurrencyAmount other) {
    final r = currency.code.compareTo(other.currency.code);
    if (r != 0) {
      return r;
    }
    return amount.compareTo(other.amount);
  }

  /// Multiples this amount with a number.
  CurrencyAmount scale(num f) {
    return CurrencyAmount.fromDecimal(amount.scale(f), currency: currency);
  }

  /// Constructs a string with format "USD 3.14".
  String toCodeFormat() {
    return '${currency.code} $amount';
  }

  @override
  String toString() {
    return toCodeFormat();
  }

  /// Parses strings with format "USD 3.14".
  static CurrencyAmount parseCodeFormat(String s) {
    s = s.trim();
    final i = s.indexOf(' ');
    if (i < 0) {
      throw FormatException(
          'Expected a string with format "USD 3.14", got "$s".');
    }
    final currencyCode = s.substring(0, i);
    var currency = Currency.byCode[currencyCode];
    currency ??= Currency.specify(
      englishName: currencyCode,
      code: currencyCode,
      regionCode: null,
      fractionDigitsInPricing: 2,
    );
    final amount = Decimal(s.substring(i + 1).trim());
    return CurrencyAmount.fromDecimal(amount, currency: currency);
  }

  static CurrencyAmount? tryParse(String s, {required Currency currency}) {
    final decimal = Decimal.tryParse(s);
    if (decimal == null) {
      return null;
    }
    return CurrencyAmount.fromDecimal(decimal, currency: currency);
  }
}
