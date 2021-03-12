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

/// A collection of ([Prop], value) tuples.
abstract class EntityData {
  /// Constructs a mutable instance of [EntityData].
  factory EntityData() = _EntityData;

  /// Tells whether object is unmodifiable.
  bool get isFrozen;

  /// Tells whether the data contains the property.
  bool contains(Prop prop);

  /// Makes the data immutable (if it isn't already).
  ///
  /// After calling this method:
  ///   * Invocations of state-mutating methods ([set] or [remove]) must throw
  ///     [FrozenError].
  ///   * [isFrozen] must return `true`.
  void freeze();

  /// Gets value of the property.
  R get<R>(Prop<dynamic, R> prop);

  /// Removes the property.
  ///
  /// Throws [FrozenError] if [isFrozen] is true.
  void remove(Prop prop);

  /// Sets value of the property.
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

/// Default implementation of [EntityData].
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
      final defaultValue = prop.defaultValue;
      if (defaultValue != null) {
        return defaultValue;
      }
      try {
        return prop.kind.newInstance();
      } catch (error, stackTrace) {
        throw TraceableError(
          message: 'Creating default value for property "${prop.name}" failed.',
          error: error,
          stackTrace: stackTrace,
        );
      }
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
