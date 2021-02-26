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

/// An error in a graph.
class GraphNodeError extends Error {
  /// Node that caused the error.
  final Object? node;

  /// Path from root node to the error-causing node ([node]).
  final List? pathEdges;

  /// Name of the error.
  final String name;

  /// A more detailed message describing why the error occurred.
  final String? reason;

  GraphNodeError({
    required this.name,
    this.node,
    this.pathEdges,
    this.reason,
  });

  String? pathToString() {
    final pathEdges = this.pathEdges;
    if (pathEdges == null) {
      return null;
    }
    final sb = StringBuffer();
    for (var item in pathEdges) {
      sb.write('/');
      if (item is String) {
        sb.write(item.replaceAll('~', '~0').replaceAll('/', '~1'));
      } else if (item is int) {
        sb.write(item);
      } else {
        sb.write('~');
      }
    }
    return sb.toString();
  }

  @override
  String toString() {
    final sb = StringBuffer();
    sb.write(name);
    final path = pathToString();
    if (path != null) {
      sb.write(' occurred at `');
      sb.write(path);
      sb.write('`');
    }
    sb.write(': ');
    final reason = this.reason;
    if (reason != null) {
      sb.write(reason);
    }
    final node = this.node;
    if (node != null) {
      sb.write('\nValue is:\n  ');
      sb.write(node.toString().replaceAll('\n', '\n  '));
    }
    return sb.toString();
  }
}
