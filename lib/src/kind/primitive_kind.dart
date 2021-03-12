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

/// Superclass for [IntKindBase], [Int64FixNumKind], [FloatKindBase], and
/// [DecimalKind].
abstract class NumericKind<T> extends PrimitiveKind<T> {
  /// Unit of measurement (for visualization purposes).
  final UnitOfMeasurement? unitOfMeasurement;

  /// Maximum valid value.
  ///
  /// If this is a non-integer kind, the set of valid values MAY exclude
  /// the maximum value.
  final T? max;

  /// Minimum valid value.
  ///
  /// If this is a non-integer kind, the set of valid values MAY exclude
  /// the minimum value.
  final T? min;

  const NumericKind({
    required this.unitOfMeasurement,
    required this.min,
    required this.max,
  });
}

/// Superclass for kinds of primitives values such as [int] and [String].
abstract class PrimitiveKind<T> extends Kind<T> {
  static const String namePrefixForNonClasses = '@';

  const PrimitiveKind();

  @override
  bool instanceIsDefaultValue(Object? value) {
    return value is T && value == newInstance();
  }

  @override
  T newInstance();

  @override
  List<T> newList(int length, {bool growable = false, bool reactive = true}) {
    // Construct a new list.
    final defaultInstance = newInstance();
    final list = List<T>.filled(
      length,
      defaultInstance,
      growable: growable,
    );

    // Wrap with ReactiveList?
    if (reactive) {
      return ReactiveList<T>.wrap(list);
    }

    return list;
  }
}
