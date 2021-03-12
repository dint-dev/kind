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
import 'package:meta/meta.dart';

/// [Kind] for [CurrencyAmount].
class CurrencyAmountKind extends Kind<CurrencyAmount> {
  /// [Kind] for [CurrencyAmountKind].
  @protected
  static final EntityKind<CurrencyAmountKind> kind =
      EntityKind<CurrencyAmountKind>(
    name: 'CurrencyAmountKind',
    define: (c) {
      final nonNegative = c.requiredBool(
        id: 1,
        name: 'nonNegative',
        getter: (t) => t.nonNegative,
      );
      c.constructorFromData = (data) {
        return CurrencyAmountKind(
          nonNegative: data.get(nonNegative),
        );
      };
    },
  );
  final bool nonNegative;

  const CurrencyAmountKind({
    this.nonNegative = false,
  });

  @override
  int get hashCode => (CurrencyAmountKind).hashCode ^ nonNegative.hashCode;

  @override
  String get name => 'CurrencyAmount';

  @override
  int get protobufFieldType => throw UnimplementedError();

  @override
  bool operator ==(Object other) =>
      other is CurrencyAmountKind && nonNegative == other.nonNegative;

  @override
  EntityKind<Object> getKind() => kind;

  @override
  bool instanceIsDefaultValue(Object? value) {
    return value is CurrencyAmount &&
        value.amount.toDouble() == 0.0 &&
        value.currency == Currency.usd;
  }

  @override
  CurrencyAmount jsonTreeDecode(Object? value, {JsonDecodingContext? context}) {
    final s = const StringKind().jsonTreeDecode(value, context: context);
    return CurrencyAmount.parseCodeFormat(s);
  }

  @override
  Object? jsonTreeEncode(CurrencyAmount instance,
      {JsonEncodingContext? context}) {
    return instance.toCodeFormat();
  }

  @override
  CurrencyAmount newInstance() {
    return CurrencyAmount.fromDecimal(
      Decimal.fromDouble(0, fractionDigits: 2),
      currency: Currency.usd,
    );
  }

  @override
  CurrencyAmount protobufTreeDecode(Object? value,
      {ProtobufDecodingContext? context}) {
    final s = const StringKind().protobufTreeDecode(value, context: context);
    return CurrencyAmount.parseCodeFormat(s);
  }

  @override
  String protobufTreeEncode(CurrencyAmount instance,
      {ProtobufEncodingContext? context}) {
    return instance.toCodeFormat();
  }
}
