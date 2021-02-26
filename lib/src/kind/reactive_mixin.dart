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

/// Mixin for making a reactive class from any mutable class.
///
/// Using this class is complicated. We recommend considering alternatives
/// described in [EntityKind] documentation.
///
/// ## Example
/// In the following example:
///   * Getters `name` and `friends` invoke [beforeFieldGet]
///   * Setter `name=` invokes [beforeFieldSet]
///   * Method `becomeDr()` invokes [beforeMethodThatsReadsAndWrites].
///
/// ```
/// import 'package:kind/kind.dart';
///
/// class Person with ReactiveMixin {
///   String _name = '';
///   final List<Person> _friends = ReactiveList<Person>(); // <-- Note that the list is reactive
///
///   /// Name of the person.
///   String get name => beforeFieldGet(_name);
///   set name(String value) => _name = beforeFieldSet(_name, value);
///
///   /// Friends of the person.
///   List<Person> get friends => beforeFieldGet(_friends);
///
///   /// Gives honorific 'Dr'.
///   void becomeDr() {
///     // This method will view and mutate state of the object.
///     beforeMethodThatReadsAndWrites();
///     _name = 'Dr $_name';
///   }
/// }
/// ```
mixin ReactiveMixin<T> {
  int? _lastReadOptimizationCode;
  int? _lastWriteOptimizationCode;

  /// A helper that should be called before Dart field is viewed.
  ///
  /// ## Example
  /// See documentation for [ReactiveMixin] class.
  @protected
  V beforeFieldGet<V>(V value) {
    beforeMethodThatReads();
    return value;
  }

  /// A helper that should be called before Dart field is mutated.
  ///
  /// ## Example
  /// See documentation for [ReactiveMixin] class.
  @protected
  V beforeFieldSet<V>(V oldValue, V newValue) {
    if (!identical(oldValue, newValue)) {
      beforeMethodThatWrites();
    }
    return newValue;
  }

  /// A helper that should be called before a method that COULD perform reads.
  ///
  /// ## Example
  /// See documentation for [ReactiveMixin] class.
  @protected
  void beforeMethodThatReads() {
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

  /// A helper that should be called before a method that COULD perform reads or
  /// writes.
  ///
  /// ## Example
  /// See documentation for [ReactiveMixin] class.
  @protected
  void beforeMethodThatsReadsAndWrites() {
    beforeMethodThatReads();
    beforeMethodThatWrites();
  }

  /// A helper that should be called before a method that COULD perform writes.
  ///
  /// ## Example
  /// See documentation for [ReactiveMixin] class.
  ///
  @protected
  void beforeMethodThatWrites() {
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
      _lastReadOptimizationCode = code;
    }
    reactiveSystem.beforeWrite(this);
  }
}
