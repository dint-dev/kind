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

import 'dart:collection';

import 'package:kind/kind.dart';

/// A wrapper class for [Map] that makes reads and writes observable
/// (see [ReactiveSystem]).
///
/// ## Example
/// Example of using [ReactiveMap.wrap]:
/// ```
/// import 'package:kind/kind';
///
/// void main() {
///   final nonReactiveMap = <String,String>{'key': 'value'};
///   final reactiveMap = ReactiveMap<String,String>.wrap(nonReactiveMap);
/// }
/// ```
abstract class ReactiveMap<K, V> implements Map<K, V> {
  /// Creates a reactive map.
  factory ReactiveMap() {
    return ReactiveMap.wrap(<K, V>{});
  }

  /// Makes any map reactive by wrapping it.
  ///
  /// If the argument is already a subclass of [ReactiveMap], returns the
  /// argument.
  ///
  /// ## Example
  /// ```
  /// import 'package:kind/kind';
  ///
  /// void main() {
  ///   final map = <String,String>{'key': 'value'};
  ///   final reactiveMap = ReactiveMap<String,String>.wrap(map);
  /// }
  /// ```
  factory ReactiveMap.wrap(Map<K, V> map) {
    if (map is ReactiveMap<K, V>) {
      return map;
    }
    return _ReactiveMap<K, V>(map);
  }
}

class _ReactiveMap<K, V> extends MapBase<K, V> implements ReactiveMap<K, V> {
  final Map<K, V> wrapped;
  int? _lastReadOptimizationCode;
  int? _lastWriteOptimizationCode;

  _ReactiveMap(this.wrapped);

  @override
  Iterable<K> get keys {
    return ReactiveIterable<K>.wrap(wrapped.keys, wrappedState: this);
  }

  @override
  V? operator [](Object? key) {
    _beforeRead();
    return wrapped[key];
  }

  @override
  void operator []=(K key, V value) {
    _beforeWrite();
    wrapped[key] = value;
  }

  @override
  void addAll(Map<K, V> other) {
    _beforeWrite();
    wrapped.addAll(other);
  }

  @override
  void clear() {
    _beforeWrite();
    wrapped.clear();
  }

  @override
  bool containsKey(Object? key) {
    _beforeRead();
    return wrapped.containsKey(key);
  }

  @override
  bool containsValue(Object? value) {
    _beforeRead();
    return wrapped.containsValue(value);
  }

  @override
  void forEach(void Function(K key, V value) action) {
    _beforeRead();
    return wrapped.forEach(action);
  }

  @override
  V? remove(Object? key) {
    _beforeRead();
    _beforeWrite();
    return wrapped.remove(key);
  }

  void _beforeRead() {
    // Does ReactiveSystem want notifications?
    //
    // Code 0:      "Yes."
    // Code 1:      "No. Notifications are unnecessary."
    // Code N >= 2: "One notification per code is enough."
    //
    final reactiveSystem = ReactiveSystem.instance;
    final code = reactiveSystem.readOptimizationCode;
    if (code != 0) {
      if (code == 1 || code == _lastReadOptimizationCode) {
        return;
      }
      _lastReadOptimizationCode = code;
    }

    reactiveSystem.beforeRead(this);
  }

  void _beforeWrite() {
    // Does ReactiveSystem want notifications?
    //
    // Code 0:      "Yes."
    // Code 1:      "No. Notifications are unnecessary."
    // Code N >= 2: "One notification per code is enough."
    //
    final reactiveSystem = ReactiveSystem.instance;
    final code = reactiveSystem.writeOptimizationCode;
    if (code != 0) {
      if (code == 1 || code == _lastWriteOptimizationCode) {
        return;
      }
      _lastWriteOptimizationCode = code;
    }

    reactiveSystem.beforeWrite(this);
  }
}
