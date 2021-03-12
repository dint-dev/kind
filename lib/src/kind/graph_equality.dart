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

import 'package:collection/collection.dart';
import 'package:fixnum/fixnum.dart';
import 'package:kind/kind.dart';

/// Evaluates equality and hash code for possibly cyclic graphs.
class GraphEquality implements Equality<Object?> {
  const GraphEquality();

  @override
  bool equals(
    Object? left,
    Object? right, {
    List<Object>? stack,
    bool throwOnDifference = false,
  }) {
    if (identical(left, right)) {
      return true;
    }

    // Because the instances were not identical,
    // we can rule out some cases.
    if (left == null ||
        right == null ||
        left is bool ||
        right is bool ||
        left is num ||
        right is num ||
        left is String ||
        right is String) {
      if (throwOnDifference) {
        throw _error(
          'Objects are different:',
          left,
          right,
        );
      }
      return false;
    }

    // Entity?
    if (left is Entity) {
      if (right is! Entity) {
        if (throwOnDifference) {
          throw _error(
            'Objects are different:',
            left,
            right,
          );
        }
        return false;
      }
      final kind = left.getKind();
      if (!identical(kind, right.getKind())) {
        if (throwOnDifference) {
          throw _error(
            'Objects are different:',
            left,
            right,
          );
        }
        return false;
      }
      return equalsEntity(
        left,
        right,
        kind: kind,
        stack: stack,
        throwOnDifference: throwOnDifference,
      );
    }

    // List<T>?
    if (left is List) {
      if (right is! List) {
        if (throwOnDifference) {
          throw _error(
            'Objects are different:',
            left,
            right,
          );
        }
        return false;
      }
      return equalsList(
        left,
        right,
        stack: stack,
        throwOnDifference: throwOnDifference,
      );
    }

    // Set<T>?
    if (left is Set) {
      if (right is! Set) {
        if (throwOnDifference) {
          throw _error(
            'Objects are different:',
            left,
            right,
          );
        }
        return false;
      }
      return equalsSet(
        left,
        right,
        stack: stack,
        throwOnDifference: throwOnDifference,
      );
    }

    // Map<K,V>?
    if (left is Map) {
      if (right is! Map) {
        if (throwOnDifference) {
          throw _error(
            'Objects are different:',
            left,
            right,
          );
        }
        return false;
      }
      return equalsMap(
        left,
        right,
        stack: stack,
        throwOnDifference: throwOnDifference,
      );
    }

    return left == right;
  }

  bool equalsEntity(
    Object left,
    Object right, {
    required EntityKind kind,
    required List<Object>? stack,
    bool throwOnDifference = false,
  }) {
    if (!kind.instanceIsCorrectType(left)) {
      if (throwOnDifference) {
        throw StateError('Object has wrong type: $left');
      }
      return false;
    }
    if (!kind.instanceIsCorrectType(right)) {
      if (throwOnDifference) {
        throw StateError('Object has wrong type: $right');
      }
      return false;
    }
    var hasUsedStack = false;
    try {
      for (var prop in kind.props) {
        // These produce good error messages by default,
        // so we don't need to catch possible errors.
        final leftValue = prop.get(left);
        final rightValue = prop.get(right);

        // Try to avoid using GraphEquality, which has overhead.
        if (leftValue == null ||
            leftValue is bool ||
            leftValue is num ||
            leftValue is String) {
          if (leftValue != rightValue) {
            if (throwOnDifference) {
              throw _error(
                'Kind `${kind.name}` property `${prop.name}` has difference:',
                leftValue,
                rightValue,
              );
            }
            return false;
          }
        } else {
          stack ??= [];
          if (!hasUsedStack) {
            for (var element in stack) {
              if (identical(element, left)) {
                return true;
              }
            }
            stack.add(left);
            hasUsedStack = true;
          }

          try {
            if (!equals(
              leftValue,
              rightValue,
              stack: stack,
              throwOnDifference: throwOnDifference,
            )) {
              return false;
            }
          } catch (error, stackTrace) {
            throw throw TraceableError(
              message:
                  'Equality on kind `${kind.name}` property `${prop.name}` failed.',
              error: error,
              stackTrace: stackTrace,
            );
          }
        }
      }
      return true;
    } finally {
      if (stack != null && hasUsedStack) {
        stack.removeLast();
      }
    }
  }

  bool equalsList(
    List left,
    List right, {
    required List<Object>? stack,
    bool throwOnDifference = false,
  }) {
    if (left.length != right.length) {
      if (throwOnDifference) {
        throw _error(
          'Lists have different lengths:',
          left.length,
          right.length,
        );
      }
      return false;
    }
    if (left is List<int> && right is List<int>) {
      return const ListEquality<int>().equals(left, right);
    }
    stack ??= [];
    for (var objectInStack in stack) {
      if (identical(objectInStack, left)) {
        return true;
      }
    }
    stack.add(left);
    try {
      for (var i = 0; i < left.length; i++) {
        if (!equals(
          left[i],
          right[i],
          stack: stack,
          throwOnDifference: throwOnDifference,
        )) {
          return false;
        }
      }
      return true;
    } finally {
      stack.removeLast();
    }
  }

  bool equalsMap(
    Map left,
    Map right, {
    required List<Object>? stack,
    bool throwOnDifference = false,
  }) {
    if (left.length != right.length) {
      if (throwOnDifference) {
        throw _error(
          'Maps have different lengths:',
          left.length,
          right.length,
        );
      }
      return false;
    }
    stack ??= [];
    for (var element in stack) {
      if (identical(element, left)) {
        return true;
      }
    }
    stack.add(left);
    try {
      for (var key in left.keys) {
        final leftValue = left[key];
        final rightValue = right[key];
        if (rightValue == null) {
          if (leftValue != null) {
            throw _error(
              'Map entries have different values:',
              leftValue,
              rightValue,
            );
          }
          if (right.containsKey(key)) {
            continue;
          }
          if (throwOnDifference) {
            throw _errorWithOneArg(
              'Right-side is missing value:',
              leftValue,
            );
          }
          return false;
        }
        if (!equals(
          leftValue,
          rightValue,
          stack: stack,
          throwOnDifference: throwOnDifference,
        )) {
          return false;
        }
      }
      return true;
    } finally {
      stack.removeLast();
    }
  }

  bool equalsSet(
    Set left,
    Set right, {
    required List<Object>? stack,
    bool throwOnDifference = false,
  }) {
    if (left.length != right.length) {
      if (throwOnDifference) {
        throw _error(
          'Sets have different lengths:',
          left.length,
          right.length,
        );
      }
      return false;
    }
    stack ??= [];
    for (var element in stack) {
      if (identical(element, left)) {
        return true;
      }
    }
    stack.add(left);
    try {
      leftLoop:
      for (var leftItem in left) {
        // Do we need to use GraphContext for equality?
        if (leftItem is Entity || leftItem is Iterable || leftItem is Map) {
          // Yes.
          for (var rightItem in right) {
            if (equals(leftItem, rightItem)) {
              // Found equal item in the right set.
              continue leftLoop;
            }
          }
          // None of the items on the right set equals the left item.
          if (throwOnDifference) {
            throw _errorWithOneArg(
              'Right-side set is missing item:',
              leftItem,
            );
          }
          return false;
        } else {
          // No, we can use contains().
          if (!right.contains(leftItem)) {
            if (throwOnDifference) {
              throw _errorWithOneArg(
                'Right-side set is missing item:',
                leftItem,
              );
            }
            return false;
          }
        }
      }
      return true;
    } finally {
      stack.removeLast();
    }
  }

  @override
  int hash(Object? object) {
    if (object is Entity) {
      return hashEntity(object, kind: object.getKind());
    }
    return object.hashCode;
  }

  int hashEntity(Object object, {required EntityKind kind}) {
    var h = 0;
    for (var prop in kind.props) {
      final value = prop.get(object);
      if (value == null ||
          value is bool ||
          value is num ||
          value is Int64 ||
          value is Decimal ||
          value is String ||
          value is Date ||
          value is DateTime ||
          value is DateTimeWithTimeZone ||
          value is GeoPoint ||
          value is Uuid) {
        h = 11 * h ^ value.hashCode;
      } else if (value is Iterable) {
        h *= 11;
        if (value is List<String>) {
          h ^= const ListEquality().hash(value);
        } else if (value is Set<String>) {
          h ^= const SetEquality().hash(value);
        } else {
          h ^= value.length;
        }
      }
    }
    return h;
  }

  @override
  bool isValidKey(Object? o) {
    return true;
  }

  Object _error(String message, Object? left, Object? right) {
    final b = EntityDebugStringBuilder();
    b.write(message);
    b.write(' ');
    b.writeDartObject(left);
    b.write(' != ');
    b.writeDartObject(right);
    return StateError(b.toString());
  }

  Object _errorWithOneArg(String message, Object? arg) {
    final b = EntityDebugStringBuilder();
    b.write(message);
    b.write(' ');
    b.writeDartObject(arg);
    return StateError(b.toString());
  }
}
