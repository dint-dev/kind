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

/// A wrapper class for [Iterable] that makes reads and writes observable
/// (see [ReactiveSystem]).
abstract class ReactiveIterable<T> implements Iterable<T> {
  /// Makes any iterable reactive.
  ///
  /// ## Example
  /// ```
  /// import 'package:kind/kind';
  ///
  /// void main() {
  ///   final list = <String>['a', 'b', 'c'];
  ///   final reactiveIterable = ReactiveIterable<String>.wrap(
  ///     list,
  ///     wrappedState: list,
  ///   );
  /// }
  /// ```
  factory ReactiveIterable.wrap(
    Iterable<T> iterable, {
    required Object wrappedState,
  }) {
    if (iterable is _ReactiveIterable<T> &&
        identical(iterable.wrappedState, wrappedState)) {
      return iterable;
    }
    return _ReactiveIterable<T>(iterable, wrappedState: wrappedState);
  }
}

mixin ReactiveIterableWrapperMixin<E> implements ReactiveIterable<E> {
  int _lastReadOptimizationCode = 1;

  @override
  E get first {
    _beforeRead();
    return wrapped.first;
  }

  @override
  bool get isEmpty {
    _beforeRead();
    return wrapped.isEmpty;
  }

  @override
  bool get isNotEmpty {
    _beforeRead();
    return wrapped.isNotEmpty;
  }

  @override
  Iterator<E> get iterator {
    return _ReactiveIterator(wrappedState, wrapped.iterator);
  }

  @override
  E get last {
    _beforeRead();
    return wrapped.last;
  }

  @override
  int get length {
    _beforeRead();
    return wrapped.length;
  }

  @override
  E get single {
    _beforeRead();
    return wrapped.single;
  }

  /// Wrapped collection.
  Iterable<E> get wrapped;

  /// The state of [wrapped] that is passed to [ReactiveSystem.instance].
  @protected
  Object get wrappedState;

  @override
  bool any(bool Function(E element) test) {
    _beforeRead();
    return wrapped.every(test);
  }

  @override
  bool contains(Object? element) {
    _beforeRead();
    return wrapped.contains(element);
  }

  @override
  E elementAt(int index) {
    _beforeRead();
    return wrapped.elementAt(index);
  }

  @override
  bool every(bool Function(E element) test) {
    _beforeRead();
    return wrapped.every(test);
  }

  @override
  Iterable<T> expand<T>(Iterable<T> Function(E element) f) {
    final iterable = wrapped.expand(f);
    return ReactiveIterable<T>.wrap(iterable, wrappedState: wrappedState);
  }

  @override
  E firstWhere(bool Function(E element) test, {E Function()? orElse}) {
    _beforeRead();
    return wrapped.firstWhere(test, orElse: orElse);
  }

  @override
  T fold<T>(T initialValue, T Function(T previousValue, E element) combine) {
    _beforeRead();
    return wrapped.fold(initialValue, combine);
  }

  @override
  Iterable<E> followedBy(Iterable<E> other) {
    final iterable = wrapped.followedBy(other);
    return ReactiveIterable.wrap(iterable, wrappedState: wrappedState);
  }

  @override
  void forEach(void Function(E element) f) {
    _beforeRead();
    return wrapped.forEach(f);
  }

  @override
  String join([String separator = '']) {
    _beforeRead();
    return wrapped.join(separator);
  }

  @override
  E lastWhere(bool Function(E element) test, {E Function()? orElse}) {
    _beforeRead();
    return wrapped.lastWhere(test, orElse: orElse);
  }

  @override
  Iterable<T> map<T>(T Function(E e) f) {
    final iterable = wrapped.map(f);
    return ReactiveIterable<T>.wrap(iterable, wrappedState: wrappedState);
  }

  @override
  E reduce(E Function(E value, E element) combine) {
    _beforeRead();
    return wrapped.reduce(combine);
  }

  @override
  E singleWhere(bool Function(E element) test, {E Function()? orElse}) {
    _beforeRead();
    return wrapped.singleWhere(test, orElse: orElse);
  }

  @override
  Iterable<E> skip(int count) {
    final iterable = wrapped.skip(count);
    return ReactiveIterable<E>.wrap(iterable, wrappedState: wrappedState);
  }

  @override
  Iterable<E> skipWhile(bool Function(E value) test) {
    final iterable = wrapped.skipWhile(test);
    return ReactiveIterable.wrap(iterable, wrappedState: wrappedState);
  }

  @override
  Iterable<E> take(int count) {
    final iterable = wrapped.take(count);
    return ReactiveIterable<E>.wrap(iterable, wrappedState: wrappedState);
  }

  @override
  Iterable<E> takeWhile(bool Function(E value) test) {
    final iterable = wrapped.takeWhile(test);
    return ReactiveIterable.wrap(iterable, wrappedState: wrappedState);
  }

  @override
  List<E> toList({bool growable = true}) {
    _beforeRead();
    final list = wrapped.toList(growable: growable);
    return ReactiveList<E>.wrap(list);
  }

  @override
  Set<E> toSet() {
    _beforeRead();
    final set = wrapped.toSet();
    return ReactiveSet<E>.wrap(set);
  }

  @override
  Iterable<E> where(bool Function(E element) test) {
    final iterable = wrapped.where(test);
    return ReactiveIterable<E>.wrap(iterable, wrappedState: wrappedState);
  }

  @override
  Iterable<T> whereType<T>() {
    final iterable = wrapped.whereType<T>();
    return ReactiveIterable<T>.wrap(iterable, wrappedState: wrappedState);
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
    if (code == 0 || code != _lastReadOptimizationCode) {
      _lastReadOptimizationCode = code;
      reactiveSystem.beforeRead(wrappedState);
    }
  }
}

class _ReactiveIterable<T> with ReactiveIterableWrapperMixin<T> {
  @override
  final Iterable<T> wrapped;

  @override
  final Object wrappedState;

  _ReactiveIterable(this.wrapped, {required this.wrappedState});

  @override
  Iterable<R> cast<R>() {
    return ReactiveIterable<R>.wrap(
      wrapped.cast<R>(),
      wrappedState: wrappedState,
    );
  }
}

class _ReactiveIterator<E> extends Iterator<E> {
  /// The List<T> / Set<T> / etc. that contains the state.
  /// The iterator is just a temporary object.
  final Object _state;

  /// An optimization code from ReactiveSystem.
  int _lastReadOptimizationCode = 1;

  /// The wrapped iterator.
  final Iterator<E> _wrapped;

  _ReactiveIterator(this._state, this._wrapped);

  @override
  E get current {
    // Does ReactiveSystem want notifications?
    //
    // Code 0:      "Yes."
    // Code 1:      "No. Notifications are unnecessary."
    // Code N >= 2: "One notification per code is enough."
    //
    final reactiveSystem = ReactiveSystem.instance;
    final code = reactiveSystem.readOptimizationCode;
    if (code == 0 || code != _lastReadOptimizationCode) {
      _lastReadOptimizationCode = code;
      reactiveSystem.beforeRead(_state);
    }
    return _wrapped.current;
  }

  @override
  bool moveNext() {
    // Does ReactiveSystem want notifications?
    //
    // Code 0:      "Yes."
    // Code 1:      "No. Notifications are unnecessary."
    // Code N >= 2: "One notification per code is enough."
    //
    final reactiveSystem = ReactiveSystem.instance;
    final code = reactiveSystem.readOptimizationCode;
    if (code == 0 || code != _lastReadOptimizationCode) {
      _lastReadOptimizationCode = code;
      reactiveSystem.beforeRead(_state);
    }
    return _wrapped.moveNext();
  }
}
