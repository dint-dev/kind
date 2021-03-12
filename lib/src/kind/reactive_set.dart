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

/// A wrapper class for [Set] that makes reads and writes observable
/// (see [ReactiveSystem]).
///
/// ## Example
/// Example of using [ReactiveSet.wrap]:
/// ```
/// import 'package:kind/kind';
///
/// void main() {
///   final set = <String>{'a', 'b', 'c'};
///   final reactiveSet = ReactiveSet<String>.wrap(set);
/// }
/// ```
abstract class ReactiveSet<E> implements Set<E>, ReactiveIterable<E> {
  /// Like [ReactiveSet()], but creates a reactive set.
  factory ReactiveSet() {
    return _ReactiveSet<E>(<E>{});
  }

  /// Like [Set.from], but creates a reactive set.
  factory ReactiveSet.from(Iterable elements) =>
      _ReactiveSet<E>(Set<E>.from(elements));

  /// Like [Set.identity], but creates a reactive set.
  factory ReactiveSet.identity() => _ReactiveSet<E>(Set<E>.identity());

  /// Like [Set.of], but creates a reactive set.
  factory ReactiveSet.of(Iterable<E> elements) =>
      _ReactiveSet<E>(Set<E>.of(elements));

  /// Makes any set reactive by wrapping it.
  ///
  /// If the argument is already a subclass of [ReactiveSet], returns the
  /// argument.
  ///
  /// ## Example
  /// ```
  /// import 'package:kind/kind';
  ///
  /// void main() {
  ///   final nonReactiveSet = <String>{'a', 'b', 'c'};
  ///   final reactiveSet = ReactiveSet<String>.wrap(nonReactiveSet);
  ///
  ///   // ReactiveSystem can observe the read event.
  ///   reactiveSet.first;
  ///
  ///   // ReactiveSystem can observe the write event.
  ///   reactiveSet.add('added value');
  /// }
  /// ```
  factory ReactiveSet.wrap(Set<E> set) {
    if (set is ReactiveSet<E>) {
      return set;
    }
    return _ReactiveSet(set);
  }

  /// Wrapped (non-reactive) set.
  ///
  /// Enables operations to be optimized when maximal performance is needed.
  Set<E> get wrapped;

  /// Makes the set immutable.
  ///
  /// After calling this method, any attempt to mutate the set will cause
  /// [FrozenError] to be thrown.
  void freeze();
}

class _ReactiveSet<T> extends SetBase<T>
    with ReactiveIterableWrapperMixin<T>
    implements ReactiveSet<T> {
  /// A token for freezing the list.
  static final Object _frozenToken = Object();

  @override
  final Set<T> wrapped;

  @override
  final Object wrappedState;

  Object? _lastReadOptimizationCode;
  Object? _lastWriteOptimizationCode;

  _ReactiveSet(this.wrapped, {Object? wrappedState})
      : wrappedState = wrappedState ?? wrapped;

  @override
  Iterator<T> get iterator {
    return _ReactiveSetIterator(this, wrapped.iterator);
  }

  @override
  bool add(T value) {
    _beforeWrite();
    _beforeRead();
    return wrapped.add(value);
  }

  @override
  void addAll(Iterable<T> elements) {
    _beforeWrite();
    wrapped.addAll(elements);
  }

  @override
  Set<R> cast<R>() {
    return ReactiveSet<R>.wrap(wrapped.cast<R>());
  }

  @override
  void clear() {
    _beforeWrite();
    wrapped.clear();
  }

  @override
  void freeze() {
    _lastWriteOptimizationCode = _frozenToken;
  }

  @override
  T? lookup(Object? element) {
    _beforeRead();
    return wrapped.lookup(element);
  }

  @override
  bool remove(Object? value) {
    _beforeWrite();
    _beforeRead();
    return wrapped.remove(value);
  }

  @override
  void removeAll(Iterable<Object?> elements) {
    _beforeWrite();
    return wrapped.removeAll(elements);
  }

  void _beforeRead() {
    final reactiveSystem = ReactiveSystem.instance;

    // Does ReactiveSystem want notifications?
    //
    // Code 0:      "Yes."
    // Code 1:      "No. Notifications are unnecessary."
    // Code N >= 2: "One notification per code is enough."
    //
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
    final lastWriteOptimizationCode = _lastWriteOptimizationCode;
    if (lastWriteOptimizationCode == _frozenToken) {
      throw FrozenError();
    }

    // Does ReactiveSystem want notifications?
    //
    // Code 0:      "Yes."
    // Code 1:      "No. Notifications are unnecessary."
    // Code N >= 2: "One notification per code is enough."
    //
    final reactiveSystem = ReactiveSystem.instance;
    final code = reactiveSystem.writeOptimizationCode;
    if (code != 0) {
      if (code == 1 || code == lastWriteOptimizationCode) {
        return;
      }
      _lastWriteOptimizationCode = code;
    }
    reactiveSystem.beforeWrite(this);
  }
}

class _ReactiveSetIterator<E> extends Iterator<E> {
  final _ReactiveSet<E> _set;
  final Iterator<E> _wrapped;

  _ReactiveSetIterator(this._set, this._wrapped);

  @override
  E get current {
    _set._beforeRead();
    return _wrapped.current;
  }

  @override
  bool moveNext() {
    _set._beforeRead();
    return _wrapped.moveNext();
  }
}
