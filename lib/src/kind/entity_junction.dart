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

/// Junction table specification in a relational database.
///
/// See [EntityRelation]
class EntityJunction extends Entity {
  static final EntityKind<EntityJunction> kind = EntityKind<EntityJunction>(
    name: 'EntityJunction',
    define: (c) {
      final tableName = c.requiredString(
        id: 1,
        name: 'tableName',
        minLengthInUtf8: 1,
        getter: (t) => t.tableName,
      );
      final localKey = c.requiredList<String>(
        id: 2,
        name: 'localPropNames',
        itemsKind: const StringKind(minLengthInUtf8: 1, maxLengthInUtf8: 63),
        getter: (t) => t.localPropNames,
      );
      final foreignKey = c.requiredList<String>(
        id: 3,
        name: 'foreignPropNames',
        itemsKind: const StringKind(minLengthInUtf8: 1, maxLengthInUtf8: 63),
        getter: (t) => t.foreignPropNames,
      );
      c.constructorFromData = (data) {
        return EntityJunction(
          tableName: data.get(tableName),
          localPropNames: data.get(localKey),
          foreignPropNames: data.get(foreignKey),
        );
      };
    },
  );

  final String tableName;
  final List<String> localPropNames;
  final List<String> foreignPropNames;

  EntityJunction({
    required this.tableName,
    required this.localPropNames,
    required this.foreignPropNames,
  });

  @override
  EntityKind<EntityJunction> getKind() => kind;
}
