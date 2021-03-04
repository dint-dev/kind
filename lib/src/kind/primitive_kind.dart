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

/// Superclass for [IntKindBase], [Int64FixNumKind], and [FloatKindBase].
abstract class NumericKind<T> extends PrimitiveKind<T> {
  const NumericKind();

  /// Maximum valid value (inclusive).
  T? get max;

  /// Minimum valid value (inclusive).
  T? get min;
}

/// Superclass for kinds of primitives values such as [int] and [String].
abstract class PrimitiveKind<T> extends Kind<T> {
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
