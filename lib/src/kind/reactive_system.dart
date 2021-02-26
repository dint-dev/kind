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

import 'dart:async';

import 'package:kind/kind.dart';

/// A reactive state management system that listens reads/writes.
///
/// The main use case is creating reactive functions with [newReactiveStream].
///
/// ## Reactive collection classes
///   * [ReactiveIterable]
///   * [ReactiveList]
///   * [ReactiveMap]
///   * [ReactiveSet]
///
/// ## Ways to make your class reactive
///   * Method 1 (recommended): Use [FieldLike] objects.
///   * Method 2: Use [ReactiveMixin].
///
/// ## Example of manual read/write notifications
/// In some cases, you may want to deal with [ReactiveSystem] directly. In such
/// case, you write something like:
/// ```
/// import 'package:kind/kind.dart';
///
/// class ExampleState {
///   String _answer = '1st answer';
///
///   String get answer {
///     ReactiveSystem.instance.beforeRead(this);
///     return _answer;
///   }
///
///   set answer(String value) {
///     ReactiveSystem.instance.beforeWrite(this);
///     _answer = value;
///   }
/// }
///
/// void main() {
///   final exampleState = ExampleState();
///
///   final function = () {
///     return exampleState.answer;
///   };
///
///   // Make a reactive stream of function results.
///   final stream = newReactiveStream(function);
///   stream.listen((result) {
///     print(result);
///   });
///
///   // Wait a bit.
///   // The reactive function prints "1st answer" during the delay.
///   await Future.delay(const Duration(milliseconds:500));
///
///   // Mutate property that's used by the function.
///   someObject.answer = '2nd answer';
///
///   // Wait a bit.
///   // The reactive function prints "2nd answer" during the delay.
///   await Future.delay(const Duration(milliseconds:500));
///
///   someObject.answer = '3rd answer';
///
///   // Wait a bit.
///   // The reactive function prints "3rd answer" during the delay
///   await Future.delay(const Duration(milliseconds:500));
/// }
/// ```
abstract class ReactiveSystem {
  /// The used instance of [ReactiveSystem].
  static ReactiveSystem instance = ReactiveSystem();

  factory ReactiveSystem({bool noOptimizations}) = _ReactiveSystem;

  /// Synchronous broadcast [Stream] of reads (before they happen).
  ///
  /// ReactiveSystem is able to recognize some notifications as redundant and
  /// such events are not added to the stream.
  ///
  /// For example, consecutive [beforeRead] invocations that have identical
  /// arguments cause only event in the stream.
  Stream<Object> get onRead;

  /// Synchronous broadcast [Stream] of writes (before they happen).
  ///
  /// ReactiveSystem is able to recognize some notifications as redundant and
  /// such events are not added to the stream.
  ///
  /// For example, consecutive [beforeWrite] invocations that have identical
  /// arguments cause only event in the stream.
  Stream<Object> get onWrite;

  /// Number of reads handled. Exposed for testing purposes.
  int get readCount;

  /// An integer used by [ReactiveMixin] for optimizing [beforeRead] calls.
  ///
  /// ## Semantics
  ///   * Code 0: every notification is needed.
  ///   * Code 1: no notification is needed.
  ///   * Code N >= 2: only one notification for each (N, object) tuple is
  ///     needed. By caching code of the last sent notification, reactive
  ///     objects are often able to skip notification.
  ///
  /// ## Example
  /// In the following example, we try to avoid unnecessary [beforeRead] and
  /// [beforeWrite] calls.
  ///
  /// ```
  /// import 'package:kind/kind.dart';
  ///
  /// class Person {
  ///   int _lastReadOptimizationCode = 0;
  ///   int _lastWriteOptimizationCode = 0;
  ///
  ///   String _name = '';
  ///
  ///   String get name {
  ///     _beforeRead;
  ///     return _name;
  ///   }
  ///   set name(String value) {
  ///     _beforeWrite();
  ///     _name = value;
  ///   }
  ///
  ///   void _beforeRead  {
  ///     final reactiveSystem = ReactiveSystem.instance;
  ///     final code = reactiveSystem.readOptimizationCode;
  ///     if (optimizationCode!=0) {
  ///       if (code==1 || code == _lastReadOptimizationCode) {
  ///         // Notification is not needed.
  ///         return;
  ///       }
  ///       _lastReadOptimizationCode = code;
  ///     }
  ///     reactiveSystem.beforeRead;
  ///   }
  ///
  ///   void _beforeWrite()  {
  ///     final reactiveSystem = ReactiveSystem.instance;
  ///     final code = reactiveSystem.writeOptimizationCode;
  ///     if (optimizationCode!=0) {
  ///       if (code==1 || code == _lastWriteOptimizationCode) {
  ///         // Notification is not needed.
  ///         return;
  ///       }
  ///       _lastWriteOptimizationCode = code;
  ///     }
  ///     reactiveSystem.beforeWrite();
  ///   }
  /// }
  /// ```
  int get readOptimizationCode;

  /// Number of refreshes handled. Exposed for testing purposes.
  int get refreshCount;

  /// Number of writes handled. Exposed for testing purposes.
  int get writeCount;

  /// An integer used by [ReactiveMixin] for optimizing [beforeWrite] calls.
  ///
  /// ## Semantics
  ///   * Code 0: every notification is needed.
  ///   * Code 1: no notification is needed.
  ///   * Code N >= 2: only one notification for each (N, object) tuple is
  ///     needed. By caching code of the last sent notification, reactive
  ///     objects are often able to skip notification.
  ///
  /// ## Example
  /// In the following example, we try to avoid unnecessary [beforeRead] and
  /// [beforeWrite] calls.
  ///
  /// ```
  /// import 'package:kind/kind.dart';
  ///
  /// class Person {
  ///   int _lastReadOptimizationCode = 0;
  ///   int _lastWriteOptimizationCode = 0;
  ///
  ///   String _name = '';
  ///
  ///   String get name {
  ///     _beforeRead;
  ///     return _name;
  ///   }
  ///   set name(String value) {
  ///     _beforeWrite();
  ///     _name = value;
  ///   }
  ///
  ///   void _beforeRead  {
  ///     final reactiveSystem = ReactiveSystem.instance;
  ///     final code = reactiveSystem.readOptimizationCode;
  ///     if (optimizationCode!=0) {
  ///       if (code==1 || code == _lastReadOptimizationCode) {
  ///         // Notification is not needed.
  ///         return;
  ///       }
  ///       _lastReadOptimizationCode = code;
  ///     }
  ///     reactiveSystem.beforeRead;
  ///   }
  ///
  ///   void _beforeWrite()  {
  ///     final reactiveSystem = ReactiveSystem.instance;
  ///     final code = reactiveSystem.writeOptimizationCode;
  ///     if (optimizationCode!=0) {
  ///       if (code==1 || code == _lastWriteOptimizationCode) {
  ///         // Notification is not needed.
  ///         return;
  ///       }
  ///       _lastWriteOptimizationCode = code;
  ///     }
  ///     reactiveSystem.beforeWrite();
  ///   }
  /// }
  /// ```
  int get writeOptimizationCode;

  /// Notifies the system that state of an object is going to be viewed.
  ///
  /// The notification enables [ReactiveSystem] to track objects that were
  /// seen by some repeatable computation. If the system later receives
  /// [beforeWrite] call notifying that one of the objects was mutated, the
  /// system can dispatch the computation be done again.
  ///
  /// ## Example
  /// You can find an example in [ReactiveSystem] documentation.
  void beforeRead(Object value);

  /// Notifies the system that a state of an object is going to be mutated.
  ///
  /// The notification enables [ReactiveSystem] to tell anyone who depends on
  /// the object to re-read its value.
  ///
  /// ## Example
  /// You can find an example in [ReactiveSystem] documentation.
  void beforeWrite(Object value);

  /// Produces a reactive stream that contains evaluations of the argument.
  ///
  /// First, the function is evaluated and the result is added to the stream.
  ///
  /// Each time a new value is added to stream, its dependencies are tracked by
  /// [ReactiveSystem]. When a mutation happens in any of the dependencies seen
  /// during the previous evaluation, a new value is evaluated and added to the
  /// stream.
  ///
  /// Parameter [waitAfterError] specifies duration to wait after the function
  /// threw an error. The default value is unspecified.
  ///
  /// Parameter [waitMin] specifies minimum duration between two events. The
  /// default is 0 seconds.
  ///
  /// ## Example
  /// ```
  /// import 'package:kind/kind.dart';
  ///
  /// Future<void> main() async {
  ///   final greetings = ReactiveList<String>.wrap(["hello]);
  ///
  ///   // In this example, our reactive function just returns the first item of
  ///   // the (reactive) list.
  ///   final stream = ReactiveSystem.instance.newReactiveStream(() {
  ///     return greetings.first;
  ///   });
  ///
  ///   // Listen to the stream.
  ///   stream.listen((greeting) {
  ///     print(greeting);
  ///   });
  ///
  ///   // A small asynchronous gap.
  ///   await Future.delay(const Duration(0));
  ///   // Prints:
  ///   //   Hello!
  ///
  ///   // Mutation.
  ///   list[0] = 'Hi!'!;
  ///
  ///   // A small asynchronous gap.
  ///   await Future.delay(const Duration(0));
  ///   // Prints:
  ///   //   Hi!
  /// }
  /// ```
  Stream<T> newReactiveStream<T>(
    FutureOr<T> Function() function, {
    Duration? waitAfterError,
    Duration? waitMin,
    bool sync = false,
  });
}

class _ReactiveFunction<T> {
  _ReactiveFunction? _nextReadListener;
  _ReactiveFunction? _nextWriteListener;
  final _ReactiveSystem reactiveSystem;
  final Future<T> Function() function;
  final Duration? waitAfterError;
  final Duration? waitMin;
  final Zone _zone = Zone.current.fork();
  final _dependencies = Set<Object>.identity();
  final StreamController<T> _streamController;
  var _isClosed = true;

  _ReactiveFunction(
      {required this.reactiveSystem,
      required this.function,
      required this.waitAfterError,
      required this.waitMin,
      required bool sync})
      : _streamController = StreamController<T>.broadcast(sync: sync) {
    _streamController.onListen = () {
      _isClosed = false;
      _refresh();
    };
    _streamController.onCancel = () {
      _isClosed = true;
      reactiveSystem._removeReadListener(this);
      reactiveSystem._removeWriteListener(this);
    };
  }

  void _refresh() {
    assert(_nextReadListener == null);
    assert(_nextWriteListener == null);

    reactiveSystem.refreshCount++;

    // Clear dependencies
    _dependencies.clear();

    // Begin listening reads
    reactiveSystem._beforeReadListener(this);

    _zone.run(function).then((value) {
      // Stop listening reads
      reactiveSystem._removeReadListener(this);

      // Is the subscription cancelled?
      if (_isClosed) {
        return;
      }

      // Add event
      _streamController.add(value);

      final waitMin = this.waitMin;
      if (waitMin == null) {
        // Listen for mutations
        reactiveSystem._addWriteListener(this);
      } else {
        Timer(waitMin, () {
          // Is the subscription cancelled?
          if (_isClosed) {
            return;
          }

          // Listen for mutations
          reactiveSystem._addWriteListener(this);
        });
      }
    }, onError: (error, stackTrace) {
      // Stop listening reads
      reactiveSystem._removeReadListener(this);

      // Is the subscription cancelled?
      if (_isClosed) {
        return;
      }

      // Add error
      _streamController.addError(error, stackTrace);

      // Retry in 5 seconds by default
      final waitAfterError = this.waitAfterError ?? const Duration(seconds: 5);
      Timer(waitAfterError, () {
        if (_isClosed) {
          return;
        }
        _refresh();
      });
    });
  }
}

// TODO: Prevent cyclic mutations by keeping causal chain
class _ReactiveSystem implements ReactiveSystem {
  static const int _bit48 = 0x1000000000000;

  _ReactiveFunction? _firstReadListener;
  _ReactiveFunction? _firstWriteListener;

  @override
  int readOptimizationCode = 1;

  @override
  int writeOptimizationCode = 1;

  Object? _ignoredRead;

  Object? _ignoredWrite;

  @override
  int readCount = 0;

  StreamController<Object>? _readStreamController;

  StreamController<Object>? _writeStreamController;
  @override
  int writeCount = 0;

  @override
  int refreshCount = 0;

  _ReactiveSystem({bool noOptimizations = false}) {
    if (noOptimizations) {
      readOptimizationCode = 0;
      writeOptimizationCode = 0;
    }
  }

  @override
  Stream<Object> get onRead {
    final streamController =
        _readStreamController ??= StreamController<Object>.broadcast(
      sync: true,
      onCancel: () {
        _readStreamController = null;
      },
    );
    return streamController.stream;
  }

  @override
  Stream<Object> get onWrite {
    final streamController =
        _writeStreamController ??= StreamController<Object>.broadcast(
      sync: true,
      onCancel: () {
        _writeStreamController = null;
      },
    );
    return streamController.stream;
  }

  @override
  void beforeRead(Object object) {
    // A small optimization that makes N consecutive accesses take only O(N).
    if (identical(_ignoredRead, object) && readOptimizationCode != 0) {
      return;
    }
    _ignoredRead = object;
    readCount++;

    final currentZone = Zone.current;
    var f = _firstReadListener;
    while (f != null) {
      final zone = f._zone;
      Zone? z = currentZone;
      while (z != null) {
        if (identical(z, zone)) {
          f._dependencies.add(object);
          break;
        }
        z = z.parent;
      }
      f = f._nextReadListener;
    }
    final streamController = _readStreamController;
    if (streamController != null) {
      streamController.add(object);
    }
  }

  @override
  void beforeWrite(Object object) {
    // A small optimization that makes N consecutive accesses take only O(N).
    if (identical(_ignoredWrite, object) && writeOptimizationCode != 0) {
      return;
    }
    _ignoredWrite = object;
    writeCount++;

    _ReactiveFunction? previousReactiveFunction;

    // Iterate linked list of write listeners
    var writeListener = _firstWriteListener;
    while (writeListener != null) {
      // Is it listening to the object?
      if (writeListener._dependencies.contains(object)) {
        // Clear cache
        _ignoredWrite = null;

        // Remove listener from the linked list
        if (previousReactiveFunction == null) {
          // The listener was the first listener.
          _firstWriteListener = writeListener._nextWriteListener;
        } else {
          // The listener was not the first listener.
          previousReactiveFunction._nextWriteListener =
              writeListener._nextWriteListener;
        }

        // Schedule refresh.
        final finalWriteListener = writeListener;
        Future(() {
          finalWriteListener._refresh();
        });
      }

      // Move to the next listener.
      previousReactiveFunction = writeListener;
      writeListener = writeListener._nextWriteListener;
    }

    // Is someone listening to all changes?
    final streamController = _writeStreamController;
    if (streamController != null) {
      // Yes, broadcast notification.
      streamController.add(object);
    }
  }

  @override
  Stream<T> newReactiveStream<T>(
    FutureOr<T> Function() function, {
    Duration? waitAfterError,
    Duration? waitMin,
    bool sync = false,
  }) {
    // Wrap the function.
    // This will ensure that the error is caught nicely.
    final wrappedFunction = () => Future<T>(function);

    // Construct `_ReactiveFunction`
    final f = _ReactiveFunction(
      reactiveSystem: this,
      function: wrappedFunction,
      waitAfterError: waitAfterError,
      waitMin: waitMin,
      sync: sync,
    );

    // Return stream
    return f._streamController.stream;
  }

  void _addWriteListener(_ReactiveFunction f) {
    // Increment optimization code.
    var optimizationCode = writeOptimizationCode;
    if (optimizationCode >= 1) {
      // The unique code space is 48 bits (because of Javascript).
      // Have we used every code?
      if (optimizationCode == _bit48 - 1) {
        optimizationCode = 0;
      } else {
        optimizationCode++;
      }
      writeOptimizationCode = optimizationCode;
    }
    _ignoredWrite = null;
    f._nextWriteListener = _firstReadListener;
    _firstWriteListener = f;
  }

  void _beforeReadListener(_ReactiveFunction f) {
    // Increment optimization code.
    var optimizationCode = readOptimizationCode;
    if (optimizationCode >= 1) {
      // The unique code space is 48 bits (because of Javascript).
      // Have we used every code?
      if (optimizationCode == _bit48 - 1) {
        optimizationCode = 0;
      } else {
        optimizationCode++;
      }
      readOptimizationCode = optimizationCode;
    }

    _ignoredRead = null;
    f._nextReadListener = _firstReadListener;
    _firstReadListener = f;
  }

  void _removeReadListener(_ReactiveFunction removed) {
    // Increment optimization code.
    var optimizationCode = readOptimizationCode;
    if (optimizationCode >= 1) {
      // The unique code space is 48 bits (because of Javascript).
      // Have we used every code?
      if (optimizationCode == _bit48 - 1) {
        optimizationCode = 0;
      } else {
        optimizationCode++;
      }
      readOptimizationCode = optimizationCode;
    }
    _ignoredRead = null;
    _ReactiveFunction? previousF;
    var f = _firstReadListener;
    while (f != null) {
      if (identical(f, removed)) {
        if (previousF == null) {
          _firstReadListener = removed._nextReadListener;
        } else {
          previousF._nextReadListener = removed._nextReadListener;
        }
        return;
      }
      f = f._nextReadListener;
    }
  }

  void _removeWriteListener(_ReactiveFunction removed) {
    // Increment optimization code.
    var optimizationCode = writeOptimizationCode;
    if (optimizationCode >= 1) {
      // The unique code space is 48 bits (because of Javascript).
      // Have we used every code?
      if (optimizationCode == _bit48 - 1) {
        optimizationCode = 0;
      } else {
        optimizationCode++;
      }
      writeOptimizationCode = optimizationCode;
    }
    _ignoredWrite = null;
    _ReactiveFunction? previousF;
    var f = _firstWriteListener;
    while (f != null) {
      if (identical(f, removed)) {
        if (previousF == null) {
          _firstWriteListener = removed._nextWriteListener;
        } else {
          previousF._nextWriteListener = removed._nextWriteListener;
        }
        return;
      }
      f = f._nextWriteListener;
    }
  }
}
