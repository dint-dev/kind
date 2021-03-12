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

/// [Kind] for [Future] (`Future<T>`).
///
/// Unlike most other kinds, instances of this kind are not serializable.
class FutureKind<T> extends Kind<Future<T>>
    with NonSerializableKindMixin<Future<T>> {
  @protected
  static final EntityKind<FutureKind> kind = EntityKind<FutureKind>(
    name: 'FutureKind',
    define: (c) {
      final eventKind = c.required<Kind>(
        id: 1,
        name: 'valueKind',
        kind: Kind.kind,
        getter: (t) => t.resultKind,
      );
      c.constructorFromData = (data) {
        return FutureKind(data.get(eventKind));
      };
    },
  );

  /// Kind of the result object.
  final Kind<T> resultKind;

  FutureKind(this.resultKind);

  @override
  String get name => 'Future';

  @override
  EntityKind<FutureKind> getKind() => kind;
}
