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
import 'package:kind/kind.dart';

/// A context that helps construct [GraphNodeError] instances.
class GraphEquality implements Equality<Object?> {
  @override
  bool equals(Object? left, Object? right, {List<Object>? stack}) {
    if (identical(left, right)) {
      return true;
    }
    if (left == null ||
        right == null ||
        left is bool ||
        right is bool ||
        left is num ||
        right is num ||
        left is String ||
        right is String) {
      return false;
    }
    if (left is Entity) {
      if (right is! Entity) {
        return false;
      }
      final kind = left.getKind();
      if (!identical(kind, right.getKind())) {
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
        for (var prop in kind.props) {
          final leftValue = prop.get(left);
          final rightValue = prop.get(right);
          if (!equals(leftValue, rightValue, stack: stack)) {
            return false;
          }
        }
        return true;
      } finally {
        stack.removeLast();
      }
    }
    if (left is List) {
      if (right is! List) {
        return false;
      }
      if (left is List<int> && right is List<int>) {
        return const ListEquality<int>().equals(left, right);
      }
      if (left.length != right.length) {
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
        for (var i = 0; i < left.length; i++) {
          if (!equals(left[i], right[i], stack: stack)) {
            return false;
          }
        }
        return true;
      } finally {
        stack.removeLast();
      }
    }
    if (left is Set) {
      if (right is! List) {
        return false;
      }
      if (left.length != right.length) {
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
            return false;
          } else {
            // No, we can use contains().
            if (!right.contains(leftItem)) {
              return false;
            }
          }
        }
        return true;
      } finally {
        stack.removeLast();
      }
    }
    if (left is Map) {
      if (right is! Map) {
        return false;
      }
      if (left.length != right.length) {
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
            if (leftValue == null) {
              if (right.containsKey(key)) {
                continue;
              }
            }
            return false;
          }
          if (!equals(leftValue, rightValue, stack: stack)) {
            return false;
          }
        }
        return true;
      } finally {
        stack.removeLast();
      }
    }
    return left == right;
  }

  @override
  int hash(Object? object) {
    return object.hashCode;
  }

  @override
  bool isValidKey(Object? o) {
    return true;
  }
}
