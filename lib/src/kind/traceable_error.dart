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

/// An error that adds contextual information to a caught error.
///
/// # Example
/// ```
/// import 'package:kind/kind.dart';
///
/// void main() {
///   try {
///     methodThatThrows();
///   } catch (error, stackTrace) {
///     throw TraceableError(
///       message: 'Caught an error from methodThatThrows()',
///       error: error,
///       stackTrace: stackTrace,
///     );
///   }
/// }
///
/// void methodThatThrows() {
///   throw StateError('Initial error');
/// }
/// ```
class TraceableError {
  final String message;
  final Object error;
  final StackTrace stackTrace;

  factory TraceableError({
    required String message,
    required Object error,
    required StackTrace stackTrace,
  }) {
    if (error is TraceableError) {
      return TraceableError._(
        message: message,
        error: error,
        stackTrace: error.stackTrace,
      );
    }
    return TraceableError._(
      message: message,
      error: error,
      stackTrace: stackTrace,
    );
  }

  TraceableError._({
    required this.message,
    required this.error,
    required this.stackTrace,
  });

  @override
  String toString() {
    final sb = StringBuffer();
    sb.write('Error trace:\n');
    Object? error = this.error;
    for (var i = 0; i < 100; i++) {
      if (error is TraceableError) {
        sb.write('  * ');
        sb.write(error.message.replaceAll('\n', '\n    '));
        sb.write('\n');
        error = error.error;
      } else {
        sb.write('  * ');
        sb.write(error.toString().replaceAll('\n', '\n    '));
        sb.write('\n');
        break;
      }
    }
    sb.write('\nStack trace:\n  ');
    sb.write(stackTrace.toString().replaceAll('\n', '\n  '));
    sb.write('\n');
    return sb.toString();
  }
}
