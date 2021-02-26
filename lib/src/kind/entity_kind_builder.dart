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
import 'package:protobuf/protobuf.dart' show BuilderInfo;

/// Builds instances of [EntityKind].
class EntityKindBuilder<T extends Object> with PropDeclarationHelperMixin<T> {
  /// List of properties.
  final List<Prop<Object, Object?>> propList = [];

  /// Column IDs subclasses should not use.
  final Set<int> reservedColumnIds = <int>{};

  /// Constructor.
  ///
  /// Either [constructor] or [constructorFromData] must be non-null.
  T Function()? constructor;

  /// Constructor from data.
  ///
  /// Either [constructor] or [constructorFromData] must be non-null.
  T Function(EntityData data)? constructorFromData;

  /// Protocol Buffers [BuilderInfo].
  BuilderInfo? protobufBuilderInfo;

  /// A function that generates a random example.
  T Function(RandomExampleContext? context)? generateRandomExample;

  /// Declared, static examples.
  final List<T> declaredExamples = [];

  /// Primary key properties.
  KeyProps? primaryKeyProps;

  @override
  void addProp(Prop<Object, Object?> prop) {
    for (var existingProp in propList) {
      if (existingProp.id == prop.id) {
        throw StateError(
            'A prop already has id ${prop.id}:\n  ${existingProp.toString().replaceAll('\n', '\n  ')}');
      }
      if (existingProp.name == prop.name) {
        throw StateError(
            'A prop already has name \'${prop.name}\':\n  ${existingProp.toString().replaceAll('\n', '\n  ')}');
      }
    }
    propList.add(prop);
  }
}
