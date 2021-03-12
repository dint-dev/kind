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

/// Mixin for [FutureKind] and [StreamKind].
mixin NonSerializableKindMixin<T extends Object> implements Kind<T> {
  @override
  bool get isSerializable => false;

  @override
  int get protobufFieldType {
    final name = getKind().name;
    throw UnsupportedError('$name does not support `protobufFieldType`.');
  }

  @override
  bool instanceIsDefaultValue(Object? value) {
    return false;
  }

  @override
  T jsonTreeDecode(Object? value, {JsonDecodingContext? context}) {
    final name = getKind().name;
    throw UnsupportedError('$name does not support `jsonTreeDecode(...)`.');
  }

  @override
  Object? jsonTreeEncode(T instance, {JsonEncodingContext? context}) {
    final name = getKind().name;
    throw UnsupportedError('$name does not support `jsonTreeEncode(...)`.');
  }

  @override
  T newInstance() {
    final name = getKind().name;
    throw UnsupportedError('$name does not support `newInstance()`.');
  }

  @override
  T protobufTreeDecode(Object? value, {ProtobufDecodingContext? context}) {
    final name = getKind().name;
    throw UnsupportedError('$name does not support `protobufTreeDecode()`.');
  }

  @override
  Object protobufTreeEncode(T instance, {ProtobufEncodingContext? context}) {
    final name = getKind().name;
    throw UnsupportedError('$name does not support `protobufTreeEncode()`.');
  }
}

/// [Kind] for [Stream] (`Stream<T>`).
///
/// Unlike most other kinds, instances of this kind are not serializable.
class StreamKind<T> extends Kind<Stream<T>>
    with NonSerializableKindMixin<Stream<T>> {
  @protected
  static final EntityKind<StreamKind> kind = EntityKind<StreamKind>(
    name: 'StreamKind',
    define: (c) {
      final eventKind = c.required<Kind>(
        id: 1,
        name: 'eventKind',
        kind: Kind.kind,
        getter: (t) => t.eventKind,
      );
      c.constructorFromData = (data) {
        return StreamKind(data.get(eventKind));
      };
    },
  );

  /// Kind of the event objects.
  final Kind<T> eventKind;

  StreamKind(this.eventKind);

  @override
  String get name => 'StreamKind';

  @override
  EntityKind<StreamKind> getKind() => kind;
}
