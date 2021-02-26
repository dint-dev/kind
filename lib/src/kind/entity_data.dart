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

/// Raw data of [Entity].
abstract class EntityData {
  factory EntityData() = _EntityData;

  /// Whether object is unmodifiable.
  bool get isFrozen;

  /// Checks whether the property is defined.
  bool contains(Prop prop);

  /// Ensures that [isFrozen] is `true`.
  ///
  /// After calling this method, invocations of [set] or [remove]
  /// must throw [FrozenError].
  void freeze();

  /// Get the property.
  R get<R>(Prop<dynamic, R> prop);

  /// Removes the property.
  ///
  /// Throws [FrozenError] if [isFrozen] is true.
  void remove(Prop prop);

  /// Sets the property.
  ///
  /// Throws [FrozenError] if [isFrozen] is true.
  void set<T>(Prop<dynamic, T> prop, T value);
}

/// Thrown when there is an attempt to mutate a frozen object.
///
/// ## See also
///   * [EntityData.freeze]
///   * [ReactiveList.freeze]
///   * [ReactiveSet.freeze]
class FrozenError extends Error {}

class _EntityData implements EntityData {
  final Map<int, Object?> _map = {};
  bool _isFrozen = false;

  @override
  bool get isFrozen => _isFrozen;

  @override
  bool contains(Prop prop) {
    return _map.containsKey(prop.id);
  }

  @override
  void freeze() {
    _isFrozen = true;
  }

  @override
  T get<T>(Prop<dynamic, T> prop) {
    final value = _map[prop.id];
    if (value == null && !_map.containsKey(prop.id)) {
      return prop.defaultValue ?? prop.kind.newInstance();
    }
    if (!prop.kind.instanceIsCorrectType(value)) {
      throw StateError(
        'Prop "${prop.name}" (id: ${prop.id}) should have "${prop.kind.name}", but it has another type: ${value.runtimeType}',
      );
    }
    return value as T;
  }

  @override
  void remove(Prop<Object, dynamic> prop) {
    _map.remove(prop);
  }

  @override
  void set<T>(Prop<dynamic, T> prop, T value) {
    if (_isFrozen) {
      throw FrozenError();
    }
    if (value == null) {
      _map.remove(prop.id);
    } else {
      _map[prop.id] = value;
    }
  }
}
