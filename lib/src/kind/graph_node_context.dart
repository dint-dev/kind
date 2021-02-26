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

/// Superclass for graph walkers like [JsonEncodingContext].
abstract class GraphNodeContext {
  /// Path from root node to the current node.
  final List<Object?> pathEdges = [];
  final List<Object?> pathNodes = [];

  /// Primary label for errors constructed by [newGraphNodeError].
  @protected
  String get errorPrimaryLabel;

  void enter(Object? value) {
    pathEdges.add(null);
    pathNodes.add(value);
  }

  /// Enters a field.
  void enterField(String name, Object? value) {
    pathEdges.add(name);
    pathNodes.add(value);
  }

  /// Enters an index.
  void enterIndex(int index, Object? value) {
    pathEdges.add(index);
    pathNodes.add(value);
  }

  /// Enters a map entry.
  void enterMapEntry(String key, Object? value) {
    pathEdges.add(key);
    pathNodes.add(value);
  }

  /// Leaves the the top node.
  void leave() {
    pathEdges.removeLast();
    pathNodes.removeLast();
  }

  /// Constructs a new instance of [GraphNodeError] that describes the
  /// location in the graph.
  GraphNodeError newGraphNodeError({
    required Object? value,
    required String reason,
  }) {
    return GraphNodeError(
      name: errorPrimaryLabel,
      node: value,
      pathEdges: pathEdges,
      reason: reason,
    );
  }

  /// Returns true if [pathNodes] has an identical value.
  bool pathContainsValue(Object? value) {
    if (value == null) {
      return false;
    }
    for (var item in pathNodes) {
      if (identical(item, value)) {
        return true;
      }
    }
    return false;
  }
}
