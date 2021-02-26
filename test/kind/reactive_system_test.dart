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
import 'package:test/test.dart';

void main() {
  group('ReactiveSystem', () {
    group('streamReactiveFunction', () {
      const smallDelay = Duration(milliseconds: 10);

      setUpAll(() async {
        // We saw the first test failing without some waiting.
        await Future.delayed(const Duration(milliseconds: 200));
      });

      setUp(() {
        final oldSystem = ReactiveSystem.instance;
        addTearDown(() {
          ReactiveSystem.instance = oldSystem;
        });
        ReactiveSystem.instance = ReactiveSystem();
      });

      test('initial state', () async {
        expect(ReactiveSystem.instance.readCount, 0);
        expect(ReactiveSystem.instance.readOptimizationCode, 1);
        expect(ReactiveSystem.instance.writeCount, 0);
        expect(ReactiveSystem.instance.writeOptimizationCode, 1);
      });

      test('beforeRead() remembers last notification and ignores duplicates',
          () async {
        final system = ReactiveSystem.instance;
        final a = Object();
        final b = Object();
        expect(system.readCount, 0);

        // view `a`
        system.beforeRead(a);
        expect(system.readCount, 1);

        // view `a` again
        system.beforeRead(a);
        expect(system.readCount, 1);
        system.beforeRead(a);
        expect(system.readCount, 1);

        // view `b`
        system.beforeRead(b);
        expect(system.readCount, 2);

        // view `b` again
        system.beforeRead(b);
        expect(system.readCount, 2);

        // view `a`
        system.beforeRead(a);
        expect(system.readCount, 3);

        // view `b`
        system.beforeRead(b);
        expect(system.readCount, 4);
      });

      test('beforeWrite() remembers last notification and ignores duplicates',
          () async {
        final system = ReactiveSystem.instance;
        final a = Object();
        final b = Object();
        expect(system.writeCount, 0);

        // mutate `a`
        system.beforeWrite(a);
        expect(system.writeCount, 1);

        // mutate `a` again
        system.beforeWrite(a);
        expect(system.writeCount, 1);
        system.beforeWrite(a);
        expect(system.writeCount, 1);

        // mutate`b`
        system.beforeWrite(b);
        expect(system.writeCount, 2);

        // mutate `b` again
        system.beforeWrite(b);
        expect(system.writeCount, 2);

        // mutate `a`
        system.beforeWrite(a);
        expect(system.writeCount, 3);

        // mutate `b`
        system.beforeWrite(b);
        expect(system.writeCount, 4);
      });

      test('beforeRead() and beforeWrite() have separate memories', () async {
        final system = ReactiveSystem.instance;
        final object = Object();
        expect(system.readCount, 0);
        expect(system.writeCount, 0);

        system.beforeRead(object);
        expect(system.readCount, 1);
        expect(system.writeCount, 0);

        system.beforeWrite(object);
        expect(system.readCount, 1);
        expect(system.writeCount, 1);

        system.beforeRead(object);
        expect(system.readCount, 1);
        expect(system.writeCount, 1);
      });

      test('ReactiveSystem(noOptimization: true) disables optimizations',
          () async {
        final system = ReactiveSystem(noOptimizations: true);
        expect(system.readCount, 0);
        expect(system.readOptimizationCode, 0);
        expect(system.writeCount, 0);
        expect(system.writeOptimizationCode, 0);

        final object = Object();

        // Reads
        expect(system.readCount, 0);
        system.beforeRead(object);
        expect(system.readCount, 1);
        system.beforeRead(object);
        expect(system.readCount, 2);

        // Writes
        expect(system.writeCount, 0);
        system.beforeWrite(object);
        expect(system.writeCount, 1);
        system.beforeWrite(object);
        expect(system.writeCount, 2);
      });

      group('newReactiveStream(...):', () {
        test('simple usage', () async {
          final stateOwner0 = Object();
          final stateOwner1 = Object();
          var state0 = 'a';
          var state1 = 'b';
          final function = () {
            ReactiveSystem.instance.beforeRead(stateOwner0);
            ReactiveSystem.instance.beforeRead(stateOwner1);
            return '$state0$state1';
          };
          final stream = ReactiveSystem.instance.newReactiveStream(function);

          // ReactiveSystem state (no changes yet)
          expect(ReactiveSystem.instance.readCount, 0);
          expect(ReactiveSystem.instance.readOptimizationCode, 1);
          expect(ReactiveSystem.instance.writeCount, 0);
          expect(ReactiveSystem.instance.writeOptimizationCode, 1);

          // Subscribe
          final results = [];
          var isDone = false;
          final subscription = stream.listen((event) {
            results.add(event);
          }, onError: (error) {
            fail(error);
          }, onDone: () {
            isDone = true;
          });
          addTearDown(() => subscription.cancel());

          // No value before an async gap
          expect(results, isEmpty);
          expect(ReactiveSystem.instance.readCount, 0);
          expect(ReactiveSystem.instance.readOptimizationCode, 2);
          expect(ReactiveSystem.instance.writeCount, 0);
          expect(ReactiveSystem.instance.writeOptimizationCode, 1);

          // Initial value
          await Future.delayed(smallDelay);
          expect(isDone, isFalse);
          expect(results, ['ab']);
          expect(ReactiveSystem.instance.readCount, 2);
          expect(ReactiveSystem.instance.readOptimizationCode, 3);
          expect(ReactiveSystem.instance.writeCount, 0);
          expect(ReactiveSystem.instance.writeOptimizationCode, 2);

          // Change `state0`
          state0 = 'A';
          ReactiveSystem.instance.beforeWrite(stateOwner0);
          expect(ReactiveSystem.instance.readCount, 2);
          expect(ReactiveSystem.instance.readOptimizationCode, 3);
          expect(ReactiveSystem.instance.writeCount, 1);
          expect(ReactiveSystem.instance.writeOptimizationCode, 2);

          // Check that the impact
          await Future.delayed(smallDelay);
          expect(isDone, isFalse);
          expect(results, ['ab', 'Ab']);
          expect(ReactiveSystem.instance.readCount, 4);
          expect(ReactiveSystem.instance.readOptimizationCode, 5);
          expect(ReactiveSystem.instance.writeCount, 1);
          expect(ReactiveSystem.instance.writeOptimizationCode, 3);
        });

        test(
            'multiple mutations without an asynchronous gap cause only one refresh',
            () async {
          final reactiveSystemAtStart = ReactiveSystem.instance;
          final stateOwner0 = Object();
          final stateOwner1 = Object();
          var state0 = 'a';
          var state1 = 'b';
          final function = () {
            ReactiveSystem.instance.beforeRead(stateOwner0);
            ReactiveSystem.instance.beforeRead(stateOwner1);
            return '$state0$state1';
          };
          final stream = ReactiveSystem.instance.newReactiveStream(function);

          // Subscribe
          final results = [];
          var isDone = false;
          final subscription = stream.listen((event) {
            results.add(event);
          }, onError: (error) {
            fail(error);
          }, onDone: () {
            isDone = true;
          });
          addTearDown(() => subscription.cancel());

          // No value before an async gap
          expect(results, isEmpty);

          // Initial value
          await Future.delayed(smallDelay);
          expect(isDone, isFalse);
          expect(results, ['ab']);

          // Multiple writes
          state0 = 'other';
          ReactiveSystem.instance.beforeWrite(stateOwner0);
          state0 = 'x';
          ReactiveSystem.instance.beforeWrite(stateOwner0);
          ReactiveSystem.instance.beforeWrite(stateOwner1);
          state1 = 'y';
          ReactiveSystem.instance.beforeWrite(stateOwner1);
          ReactiveSystem.instance.beforeWrite(stateOwner0);
          ReactiveSystem.instance.beforeWrite(stateOwner1);

          // Only 1 event
          await Future.delayed(smallDelay);
          expect(ReactiveSystem.instance, same(reactiveSystemAtStart));
          expect(isDone, isFalse);
          expect(results, ['ab', 'xy']);
        });

        test('1 000 refreshes', () async {
          final stateOwner = Object();
          final function = () {
            ReactiveSystem.instance.beforeRead(stateOwner);
            return null;
          };
          final stream = ReactiveSystem.instance.newReactiveStream(function);
          var n = 0;
          stream.listen((event) {
            n++;
          });
          final expectedN = 1000;
          for (var i = 0; i < expectedN; i++) {
            ReactiveSystem.instance.beforeWrite(stateOwner);
            await Future(() => null);
            await Future(() => null);
            await Future(() => null);
            await Future(() => null);
          }
          expect(n, expectedN);
        });

        test('function throws, by default no retry in 2 seconds', () async {
          final function = () {
            return Future.error(Error());
          };
          final stream = ReactiveSystem.instance.newReactiveStream(function);

          // Subscribe
          final results = [];
          var errors = [];
          var isDone = false;
          final subscription = stream.listen((event) {
            results.add(event);
          }, onError: (error) {
            errors.add(error);
          }, onDone: () {
            isDone = true;
          });
          addTearDown(() => subscription.cancel());

          await Future.delayed(smallDelay);

          expect(results, []);
          expect(errors, hasLength(1));
          expect(isDone, isFalse);

          await Future.delayed(const Duration(seconds: 2));

          expect(results, []);
          expect(errors, hasLength(1));
          expect(isDone, isFalse);
        });

        test('function throws, request retry every 80 milliseconds', () async {
          final function = () {
            return Future.error(Error());
          };
          final stream = ReactiveSystem.instance.newReactiveStream(
            function,
            waitAfterError: const Duration(milliseconds: 80),
          );

          // Subscribe
          final results = [];
          var errors = [];
          var isDone = false;
          final subscription = stream.listen((event) {
            results.add(event);
          }, onError: (error) {
            errors.add(error);
          }, onDone: () {
            isDone = true;
          });
          addTearDown(() => subscription.cancel());

          await Future.delayed(smallDelay);

          expect(results, []);
          expect(errors, hasLength(1));
          expect(isDone, isFalse);

          await Future.delayed(const Duration(milliseconds: 100));

          expect(results, []);
          expect(errors, hasLength(anyOf(1, 2)));
          expect(isDone, isFalse);

          await Future.delayed(const Duration(milliseconds: 100));

          expect(results, []);
          expect(errors, hasLength(anyOf(2, 3)));
          expect(isDone, isFalse);
        });

        test('function throws synchronously', () async {
          // The function that will throw every time
          final function = () {
            throw Error();
          };

          // The stream
          final stream = ReactiveSystem.instance.newReactiveStream(
            function,
            waitAfterError: const Duration(milliseconds: 80),
          );

          // Subscribe
          final results = [];
          var errors = [];
          var isDone = false;
          final subscription = stream.listen((event) {
            results.add(event);
          }, onError: (error) {
            errors.add(error);
          }, onDone: () {
            isDone = true;
          });
          addTearDown(() => subscription.cancel());

          await Future.delayed(smallDelay);

          expect(results, []);
          expect(errors, hasLength(1));
          expect(isDone, isFalse);

          await Future.delayed(const Duration(milliseconds: 100));

          expect(results, []);
          expect(errors, hasLength(2));
          expect(isDone, isFalse);

          await Future.delayed(const Duration(milliseconds: 100));

          expect(results, []);
          expect(errors, hasLength(3));
          expect(isDone, isFalse);
        });

        test('streamSubscription.cancel()', () async {
          final stateOwner0 = Object();
          final stateOwner1 = Object();
          var state0 = 'a';
          var state1 = 'b';
          final function = () {
            ReactiveSystem.instance.beforeRead(stateOwner0);
            ReactiveSystem.instance.beforeRead(stateOwner1);
            return '$state0$state1';
          };
          final stream = ReactiveSystem.instance.newReactiveStream(function);

          // Subscribe
          final results = [];
          var isDone = false;
          final subscription = stream.listen((event) {
            results.add(event);
          }, onError: (error) {
            fail(error);
          }, onDone: () {
            isDone = true;
          });
          addTearDown(() => subscription.cancel());

          // No value before an async gap
          expect(results, isEmpty);

          // Initial value
          await Future.delayed(smallDelay);
          expect(results, ['ab']);

          // Cancel subscription
          expect(isDone, isFalse);
          await subscription.cancel();
          await Future.delayed(smallDelay);

          // Change dependencies
          state0 = 'other';
          state1 = 'other';
          ReactiveSystem.instance.beforeWrite(stateOwner0);
          ReactiveSystem.instance.beforeWrite(stateOwner1);
          await Future.delayed(smallDelay);
          expect(results, ['ab']);
        });
      });
    });
  });
}
