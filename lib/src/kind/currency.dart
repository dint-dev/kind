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

/// Information about a currency.
///
/// # Predefined currencies
/// The following static fields provide access to all the predefined
/// currencies:
///   * [byCode]
///   * [byRegionCode]
///   * [values]
///
/// # Examples
/// ## Formatting strings
/// ```
/// import 'package:kind/kind.dart';
///
/// final priceString = Currency.usd.format('100.0');
/// ```
///
/// ## In numeric kinds
/// [NumericKind] subclasses support specifying [UnitOfMeasurement]:
/// ```
/// import 'package:kind/kind.dart';
///
/// final priceKind = DecimalKind(
///   unitOfMeasurement: Currency.usd,
/// );
/// ```
class Currency extends UnitOfMeasurement {
  static final Kind<Currency> kind =
      CompositePrimitiveKind<Currency, String>.simple(
    name: 'Currency',
    primitiveKind: const StringKind(),
    fromPrimitive: (code) {
      final existing = Currency.byCode[code];
      if (existing != null) {
        return existing;
      }
      return Currency.specify(
        englishName: code,
        code: code,
        regionCode: null,
        fractionDigitsInPricing: 2,
      );
    },
    toPrimitive: (currency) => currency.code,
  );

  /// Unmodifiable map from three-letter codes to currencies.
  static final Map<String, Currency> byCode =
      Map<String, Currency>.unmodifiable(Map<String, Currency>.fromEntries(
    values.map(
      (e) => MapEntry<String, Currency>(e.code, e),
    ),
  ));

  /// Unmodifiable list of currencies sorted by code.
  static final List<Currency> values = List<Currency>.unmodifiable(<Currency>{
    aed,
    ars,
    aud,
    bgn,
    brl,
    cad,
    clp,
    czk,
    cop,
    dkk,
    egp,
    eur,
    gbp,
    hkd,
    hrk,
    huf,
    idr,
    ils,
    inr,
    isk,
    irr,
    jpy,
    kes,
    krw,
    ngn,
    nok,
    nzd,
    myr,
    mxn,
    qar,
    pen,
    pkr,
    php,
    pln,
    sar,
    sek,
    sgd,
    rmb,
    ron,
    rub,
    thb,
    try_,
    twd,
    uah,
    usd,
    vnd,
    zar,
  }.toList()
    ..sort((a, b) => a.code.compareTo(b.code)));

  /// Unmodifiable map from country/region codes to currencies.
  static final Map<String, Currency> byRegionCode = () {
    final map = <String, Currency>{};
    for (var currency in values) {
      final regionCode = currency.regionCode;
      if (regionCode != null) {
        if (map.containsKey(regionCode)) {
          throw Error();
        }
        map[regionCode] = currency;
      }
      final otherRegionCodes = currency.otherCountryCodes;
      for (var regionCode in otherRegionCodes) {
        if (map.containsKey(regionCode)) {
          throw Error();
        }
        map[regionCode] = currency;
      }
    }
    return Map<String, Currency>.unmodifiable(map);
  }();

  /// United Arab Emirates dirham.
  static const Currency aed = Currency.specify(
    englishName: 'United Arab Emirates dirham',
    code: 'AED',
    regionCode: 'AE',
    fractionDigitsInPricing: 2,
    symbol: 'د.إ',
  );

  /// Argentine peso.
  static const Currency ars = Currency.specify(
    englishName: 'Argentine peso',
    code: 'ARS',
    regionCode: 'AR',
    fractionDigitsInPricing: 2,
    symbol: r'$',
  );

  /// Australian dollar.
  static const Currency aud = Currency.specify(
    englishName: 'Australian dollar',
    code: 'AUD',
    regionCode: 'AU',
    fractionDigitsInPricing: 2,
    symbol: r'$',
  );

  /// Bangladeshi taka.
  static const Currency bdt = Currency.specify(
    englishName: 'Bangladeshi taka',
    code: 'BDT',
    regionCode: 'BD',
    fractionDigitsInPricing: 0,
    symbol: '৳',
  );

  /// Bulgarian lev.
  static const Currency bgn = Currency.specify(
    englishName: 'Bulgarian lev',
    code: 'BGN',
    regionCode: 'BG',
    fractionDigitsInPricing: 2,
    symbol: 'лв',
  );

  /// Brazilian real.
  static const Currency brl = Currency.specify(
    englishName: 'Brazilian real',
    code: 'BRL',
    regionCode: 'BR',
    fractionDigitsInPricing: 2,
    symbol: r'R$',
  );

  /// Canadian dollar.
  static const Currency cad = Currency.specify(
    englishName: 'Canadian dollar',
    code: 'CAD',
    regionCode: 'CA',
    fractionDigitsInPricing: 2,
    symbol: r'$',
  );

  /// Swiss franc.
  static const Currency chf = Currency.specify(
    englishName: 'Swiss franc',
    code: 'CHF',
    regionCode: 'CH',
    fractionDigitsInPricing: 2,
    symbol: 'fr',
  );

  /// Chilean peso.
  static const Currency clp = Currency.specify(
    englishName: 'Chilean peso',
    code: 'CLP',
    regionCode: 'CL',
    fractionDigitsInPricing: 2,
    symbol: r'$',
  );

  /// Colombian peso.
  static const Currency cop = Currency.specify(
    englishName: 'Colombian peso',
    code: 'COP',
    regionCode: 'CO',
    fractionDigitsInPricing: 2,
    symbol: r'$',
  );

  /// Czech koruna.
  static const Currency czk = Currency.specify(
    englishName: 'Czech koruna',
    code: 'CZK',
    regionCode: 'CZ',
    fractionDigitsInPricing: 2,
    symbol: 'Kč',
  );

  /// British pound.
  static const Currency gbp = Currency.specify(
    englishName: 'British pound',
    code: 'GBP',
    regionCode: 'UK',
    fractionDigitsInPricing: 2,
    symbol: '£',
  );

  /// Danish krone.
  static const Currency dkk = Currency.specify(
    englishName: 'Danish krone',
    code: 'DKK',
    regionCode: 'DK',
    fractionDigitsInPricing: 2,
    symbol: 'kr',
  );

  /// Egyptian pound.
  static const Currency egp = Currency.specify(
    englishName: 'Egyptian pound',
    code: 'EGP',
    regionCode: 'EG',
    fractionDigitsInPricing: 2,
    symbol: 'E£',
  );

  /// Euro.
  static const Currency eur = Currency.specify(
    englishName: 'Euro',
    code: 'EUR',
    regionCode: null,
    otherCountryCodes: {
      // Eurozone
      'AT',
      'BE',
      'CY',
      'EE',
      'ES',
      'FI',
      'FR',
      'DE',
      'GR',
      'IE',
      'IT',
      'LV',
      'LT',
      'LU',
      'MT',
      'NL',
      'PT',
      'SK',
      'SI',

      // Microstates
      'AD',
      'MC',
      'SM',
      'VA',
    },
    fractionDigitsInPricing: 2,
    symbol: '€',
  );

  /// Hong Kong dollar.
  static const Currency hkd = Currency.specify(
    englishName: 'Hong Kong dollar',
    code: 'HKD',
    regionCode: 'HK',
    fractionDigitsInPricing: 2,
    symbol: r'$',
  );

  /// Croatian kuna.
  static const Currency hrk = Currency.specify(
    englishName: 'Croatian kuna',
    code: 'HRK',
    regionCode: 'HR',
    fractionDigitsInPricing: 0,
    symbol: 'Ft',
  );

  /// Hungarian forint.
  static const Currency huf = Currency.specify(
    englishName: 'Hungarian forint',
    code: 'HUF',
    regionCode: 'HU',
    fractionDigitsInPricing: 2,
    symbol: 'kn',
  );

  /// Israeli new shekel.
  static const Currency ils = Currency.specify(
    englishName: 'Israeli new shekel',
    code: 'ILS',
    regionCode: 'IL',
    fractionDigitsInPricing: 2,
    symbol: '₪',
  );

  /// Indian rupee.
  static const Currency inr = Currency.specify(
    englishName: 'Indian rupeeh',
    code: 'INR',
    regionCode: 'IN',
    fractionDigitsInPricing: 0, // In practice
    symbol: '₹',
  );

  /// Iranian rial.
  static const Currency irr = Currency.specify(
    englishName: 'Iranian rial',
    code: 'IRR',
    regionCode: 'IR',
    fractionDigitsInPricing: 0, // In practice
    symbol: '﷼',
  );

  /// Indonesian rupiah
  static const Currency idr = Currency.specify(
    englishName: 'Indonesian rupiah',
    code: 'IDR',
    regionCode: 'ID',
    fractionDigitsInPricing: 2,
    symbol: 'Rp',
  );

  /// Icelandic króna.
  static const Currency isk = Currency.specify(
    englishName: 'Icelandic króna',
    code: 'ISK',
    regionCode: 'IS',
    fractionDigitsInPricing: 2,
    symbol: 'kr',
  );

  /// Japanese yen.
  static const Currency jpy = Currency.specify(
    englishName: 'Japanese yen',
    code: 'JPY',
    regionCode: 'JP',
    fractionDigitsInPricing: 0,
    symbol: '¥',
  );

  /// Kenyan shilling.
  static const Currency kes = Currency.specify(
    englishName: 'Kenyan shilling',
    code: 'KES',
    regionCode: 'KE',
    fractionDigitsInPricing: 0,
    symbol: 'Ksh',
  );

  /// Korean won.
  static const Currency krw = Currency.specify(
    englishName: 'Korean won',
    code: 'KRW',
    regionCode: 'KR',
    fractionDigitsInPricing: 0,
    symbol: '₩',
  );

  /// Malaysian ringgit.
  static const Currency myr = Currency.specify(
    englishName: 'Malaysian ringgit',
    code: 'MYR',
    regionCode: 'MY',
    fractionDigitsInPricing: 2,
    symbol: 'RM',
  );

  /// Mexican peso.
  static const Currency mxn = Currency.specify(
    englishName: 'Mexican peso',
    code: 'MXN',
    regionCode: 'MX',
    fractionDigitsInPricing: 2,
    symbol: r'$',
  );

  /// Nigerian naira.
  static const Currency ngn = Currency.specify(
    englishName: 'Nigerian naira',
    code: 'NGN',
    regionCode: 'NG',
    fractionDigitsInPricing: 2, // In practice
    symbol: '₦',
  );

  /// Norwegian krone.
  static const Currency nok = Currency.specify(
    englishName: 'Norwegian krone',
    code: 'NOK',
    regionCode: 'NO',
    fractionDigitsInPricing: 2,
    symbol: 'kr',
  );

  /// New Zealand dollar.
  static const Currency nzd = Currency.specify(
    englishName: 'New Zealand dollar',
    code: 'NDZ',
    regionCode: 'NZ',
    fractionDigitsInPricing: 2,
    symbol: r'$',
  );

  /// Peruvian sol.
  static const Currency pen = Currency.specify(
    englishName: 'Peruvian sol',
    code: 'PEN',
    regionCode: 'PE',
    fractionDigitsInPricing: 2,
    symbol: r'S/',
  );

  /// Qatari riyal.
  static const Currency qar = Currency.specify(
    englishName: 'Qatari riyal',
    code: 'QAR',
    regionCode: 'QA',
    fractionDigitsInPricing: 2,
    symbol: 'QR',
  );

  /// Philippine peso.
  static const Currency php = Currency.specify(
    englishName: 'Philippine peso',
    code: 'PHP',
    regionCode: 'PH',
    fractionDigitsInPricing: 2,
    symbol: '₱',
  );

  /// Pakistani rupee.
  static const Currency pkr = Currency.specify(
    englishName: 'Pakistani rupee',
    code: 'PKR',
    regionCode: 'PK',
    fractionDigitsInPricing: 2,
    symbol: '₨;',
  );

  /// Polish złoty.
  static const Currency pln = Currency.specify(
    englishName: 'Polish złoty',
    code: 'PLN',
    regionCode: 'PL',
    fractionDigitsInPricing: 2,
    symbol: 'zł',
  );

  /// Saudi riyal.
  static const Currency sar = Currency.specify(
    englishName: 'Saudi riyal',
    code: 'SAR',
    regionCode: 'SA',
    fractionDigitsInPricing: 2,
    symbol: '﷼',
  );

  /// Swedish krona.
  static const Currency sek = Currency.specify(
    englishName: 'Swedish krona',
    code: 'SEK',
    regionCode: 'SE',
    fractionDigitsInPricing: 2,
    symbol: 'kr',
  );

  /// Singapore dollar.
  static const Currency sgd = Currency.specify(
    englishName: 'Singapore dollar',
    code: 'SGD',
    regionCode: 'SG',
    fractionDigitsInPricing: 2,
    symbol: r'$',
  );

  /// Chinese renminbi.
  static const Currency rmb = Currency.specify(
    englishName: 'Chinese renminbi',
    code: 'RMB',
    regionCode: 'CN',
    fractionDigitsInPricing: 2,
    symbol: '¥',
  );

  /// Romanian leu.
  static const Currency ron = Currency.specify(
    englishName: 'Russian ruble',
    code: 'RON',
    regionCode: 'RO',
    fractionDigitsInPricing: 2,
    symbol: 'L',
  );

  /// Russian ruble.
  static const Currency rub = Currency.specify(
    englishName: 'Russian ruble',
    code: 'RUB',
    regionCode: 'RU',
    fractionDigitsInPricing: 2,
    symbol: '₽',
  );

  /// Thai baht.
  static const Currency thb = Currency.specify(
    englishName: 'Thai baht',
    code: 'THB',
    regionCode: 'TH',
    fractionDigitsInPricing: 2,
    symbol: '฿',
  );

  /// New Taiwan dollar.
  static const Currency twd = Currency.specify(
    englishName: 'New Taiwan dollar',
    code: 'TWD',
    regionCode: 'TW',
    fractionDigitsInPricing: 2,
    symbol: r'$',
  );

  /// Turkish lira.
  static const Currency try_ = Currency.specify(
    englishName: 'Turkish lira',
    code: 'TRY',
    regionCode: 'TR',
    fractionDigitsInPricing: 2,
    symbol: '₺',
  );

  /// Ukrainian hryvnia.
  static const Currency uah = Currency.specify(
    englishName: 'Ukrainian hryvnia',
    code: 'UAH',
    regionCode: 'UA',
    fractionDigitsInPricing: 2,
    symbol: '₴',
  );

  /// United States dollar.
  static const Currency usd = Currency.specify(
    englishName: 'United States dollar',
    code: 'USD',
    regionCode: 'US',
    otherCountryCodes: {
      'EC',
      'GU',
      'PR',
      'SV',
      'TL',
      'VI',
      'ZW',
      'AS',
    },
    fractionDigitsInPricing: 2,
    symbol: r'$',
  );

  /// Vietnamese đồng.
  static const Currency vnd = Currency.specify(
    englishName: 'Vietnamese đồng',
    code: 'VND',
    regionCode: 'VN',
    fractionDigitsInPricing: 2,
    symbol: '₫',
  );

  /// South African rand.
  static const Currency zar = Currency.specify(
    englishName: 'South African rand',
    code: 'ZAR',
    regionCode: 'ZA',
    fractionDigitsInPricing: 2,
    symbol: 'R',
  );

  final String code;
  final String? symbol;
  final String? regionCode;
  final Set<String> otherCountryCodes;
  final int fractionDigitsInPricing;

  const Currency.specify({
    required String englishName,
    required this.code,
    required this.regionCode,
    required this.fractionDigitsInPricing,
    this.symbol,
    this.otherCountryCodes = const {},
  }) : super.specify(identifier: code);

  @override
  int get hashCode => code.hashCode;

  @override
  bool operator ==(other) =>
      other is Currency &&
      code == other.code &&
      symbol == other.symbol &&
      regionCode == other.regionCode &&
      const SetEquality<String>()
          .equals(otherCountryCodes, other.otherCountryCodes) &&
      fractionDigitsInPricing == other.fractionDigitsInPricing;

  /// Formats [int] or [double] amount.
  ///
  /// # Example
  /// ```
  /// Currency.usd.format(1.99);
  /// ```
  String format(num amount) {
    return formatDecimal(Decimal.fromDouble(
      amount,
      fractionDigits: fractionDigitsInPricing,
    ));
  }

  /// Formats [Decimal] amount.
  ///
  /// # Example
  /// ```
  /// Currency.usd.formatDecimal(Decimal(1.99));
  /// ```
  String formatDecimal(Decimal decimal) {
    final s = decimal.usingFractionDigits(fractionDigitsInPricing).toString();
    final symbol = this.symbol;
    if (symbol != null) {
      if (symbol == r'$') {
        return '$regionCode\$ $s';
      }
      return '$symbol$s';
    }
    return '$code $s';
  }

  /// Formats [String] amount
  ///
  /// # Example
  /// ```
  /// Currency.usd.formatString('1.99');
  /// ```
  String formatString(String amount) {
    return formatDecimal(Decimal(amount));
  }

  /// Prints a debug string with format 'Currency.usd'.
  @override
  String toString() {
    var identifier = code.toLowerCase();
    if (identifier == 'try') {
      identifier = 'try_';
    }
    return 'Currency.$identifier';
  }
}
