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

class ObjectKind<T extends Object> extends PrimitiveKind<T> {
  static final EntityKind<ObjectKind> kind = EntityKind<ObjectKind>(
    name: 'ObjectKind',
    build: (c) {
      c.constructor = () => const ObjectKind();
    },
  );

  const ObjectKind();

  @override
  String get name => 'Object';

  @override
  int get protobufFieldType => throw UnimplementedError();

  @override
  EntityKind<ObjectKind> getKind() {
    return kind;
  }

  @override
  T jsonTreeDecode(Object? value, {JsonDecodingContext? context}) {
    if (context != null) {
      final kindLibrary = context.kindLibrary;
      if (kindLibrary != null) {
        for (var kind in kindLibrary.items) {
          if (kind is Kind<T>) {
            return kind.jsonTreeDecode(value, context: context);
          }
        }
      }
    }
    // TODO: implement jsonToDart
    throw UnimplementedError();
  }

  @override
  Object? jsonTreeEncode(T instance, {JsonEncodingContext? context}) {
    if (instance is Entity) {
      return instance.getKind().jsonTreeEncode(instance);
    }
    if (context != null) {
      final kindLibrary = context.kindLibrary;
      if (kindLibrary != null) {
        for (var kind in kindLibrary.items) {
          if (kind is Kind<T>) {
            return kind.jsonTreeEncode(instance, context: context);
          }
        }
      }
    }
    throw UnimplementedError();
  }

  @override
  T newInstance() {
    throw UnsupportedError('ObjectInstanceKind.newInstance() is unsupported.');
  }

  @override
  T protobufTreeDecode(Object? value, {ProtobufDecodingContext? context}) {
    if (context != null) {
      final kindLibrary = context.kindLibrary;
      if (kindLibrary != null) {
        for (var kind in kindLibrary.items) {
          if (kind is Kind<T>) {
            return kind.protobufTreeDecode(value, context: context);
          }
        }
      }
    }
    // TODO: implement protobufValueToDart
    throw UnimplementedError();
  }

  @override
  Object? protobufTreeEncode(T instance, {ProtobufEncodingContext? context}) {
    if (instance is Entity) {
      return instance.getKind().protobufTreeEncode(instance);
    }
    if (context != null) {
      final kindLibrary = context.kindLibrary;
      if (kindLibrary != null) {
        for (var kind in kindLibrary.items) {
          if (kind is Kind<T>) {
            return kind.protobufTreeEncode(instance, context: context);
          }
        }
      }
    }
    throw UnimplementedError();
  }
}
