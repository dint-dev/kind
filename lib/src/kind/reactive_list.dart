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

/// A wrapper class for [List] that makes reads and writes observable
/// (see [ReactiveSystem]).
///
/// ## Example
/// Example of using [ReactiveList.wrap]:
/// ```
/// import 'package:kind/kind';
///
/// void main() {
///   final nonReactiveList = <String>['a', 'b', 'c'];
///   final reactiveList = ReactiveList<String>.wrap(nonReactiveList);
///
///   // ReactiveSystem can observe the read event.
///   reactiveList.first;
///
///   // ReactiveSystem can observe the write event.
///   reactiveList.add('added value');
/// }
/// ```
abstract class ReactiveList<E> implements List<E>, ReactiveIterable<E> {
  /// Like [List.empty], but creates a reactive list.
  factory ReactiveList.empty({bool growable = true}) {
    return ReactiveList.wrap(List<E>.empty(growable: growable));
  }

  /// Like [List.filled(length, fill)], but creates a reactive list.
  factory ReactiveList.filled(
    int length,
    E fill, {
    bool growable = false,
  }) {
    return _ReactiveList<E>(List<E>.filled(length, fill, growable: growable));
  }

  /// Like [List.from(elements)], but creates a reactive list.
  factory ReactiveList.from(
    Iterable elements, {
    bool growable = true,
  }) {
    return _ReactiveList<E>(List<E>.from(elements, growable: growable));
  }

  /// Like [List.generate], but creates a reactive list.
  factory ReactiveList.generate(
    int length,
    E Function(int index) generator, {
    bool growable = true,
  }) {
    return _ReactiveList<E>(List<E>.generate(
      length,
      generator,
      growable: growable,
    ));
  }

  /// Like [List.of], but creates a reactive list.
  factory ReactiveList.of(
    Iterable<E> iterable, {
    bool growable = true,
  }) {
    return _ReactiveList<E>(List<E>.of(iterable, growable: growable));
  }

  /// Makes any list reactive by wrapping it.
  ///
  /// If the argument is already a subclass of [ReactiveList], returns the
  /// argument.
  ///
  /// ## Example
  /// Example of using [ReactiveList.wrap]:
  /// ```
  /// import 'package:kind/kind';
  ///
  /// void main() {
  ///   final list = <String>['a', 'b', 'c'];
  ///   final reactiveList = ReactiveList<String>.wrap(list);
  /// }
  /// ```
  factory ReactiveList.wrap(List<E> list) {
    if (list is ReactiveList<E>) {
      return list;
    }
    return _ReactiveList<E>(list);
  }

  /// Wrapped (non-reactive) list.
  ///
  /// Enables operations to be optimized when maximal performance is needed.
  List<E> get wrapped;

  /// Makes the list immutable.
  ///
  /// After calling this method, any attempt to mutate the list will cause
  /// [FrozenError] to be thrown.
  void freeze();
}

class _ReactiveList<T> extends ListBase<T>
    with ReactiveIterableWrapperMixin<T>
    implements ReactiveList<T> {
  /// A token for freezing the list.
  static final int _frozenWriteToken = -1;

  @override
  final List<T> wrapped;

  @override
  final Object wrappedState;

  int? _lastReadOptimizationCode;
  int? _lastWriteOptimizationCode;

  _ReactiveList(this.wrapped, {Object? wrappedState})
      : wrappedState = wrappedState ?? wrapped;

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
  Iterator<T> get iterator {
    return _ReactiveListIterator(this, wrapped.iterator);
  }

  @override
  set length(int newLength) {
    _beforeWrite();
    wrapped.length = newLength;
  }

  @override
  T operator [](int index) {
    _beforeRead();
    return wrapped[index];
  }

  @override
  void operator []=(int index, T value) {
    _beforeWrite();
    wrapped[index] = value;
  }

  @override
  void add(T element) {
    _beforeWrite();
    wrapped.add(element);
  }

  @override
  void addAll(Iterable<T> elements) {
    _beforeWrite();
    wrapped.addAll(elements);
  }

  @override
  List<R> cast<R>() {
    return ReactiveList.wrap(wrapped.cast<R>());
  }

  @override
  void freeze() {
    _lastWriteOptimizationCode = _frozenWriteToken;
  }

  @override
  int indexOf(Object? element, [int start = 0]) {
    _beforeRead();
    if (element is T) {
      return wrapped.indexOf(element, start);
    }
    return -1;
  }

  @override
  bool remove(Object? element) {
    _beforeRead();
    _beforeWrite();
    return wrapped.remove(element);
  }

  @override
  T removeLast() {
    _beforeRead();
    _beforeWrite();
    return wrapped.removeLast();
  }

  @override
  void sort([int Function(T a, T b)? compare]) {
    _beforeRead();
    _beforeWrite();
    return wrapped.sort(compare);
  }

  @override
  List<T> sublist(int start, [int? end]) {
    _beforeRead();
    return _ReactiveList(wrapped.sublist(start, end));
  }

  @override
  List<T> toList({bool growable = true}) {
    _beforeRead();
    return _ReactiveList(wrapped.toList(growable: growable));
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

    // No.
    reactiveSystem.beforeRead(this);
  }

  void _beforeWrite() {
    final lastWriteOptimizationCode = _lastWriteOptimizationCode;
    if (lastWriteOptimizationCode == _frozenWriteToken) {
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

    // No.
    reactiveSystem.beforeWrite(this);
  }
}

class _ReactiveListIterator<E> extends Iterator<E> {
  final _ReactiveList<E> _list;
  final Iterator<E> _wrapped;

  _ReactiveListIterator(this._list, this._wrapped);

  @override
  E get current {
    _list._beforeRead();
    return _wrapped.current;
  }

  @override
  bool moveNext() {
    _list._beforeRead();
    return _wrapped.moveNext();
  }
}
