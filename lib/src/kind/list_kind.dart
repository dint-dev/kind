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
import 'package:protobuf/protobuf.dart' as protobuf;

/// [Kind] for [List].
///
/// ## Constraints
///   * Number of items ([minLength], [maxLength])
///
/// ## Example
/// See [EntityKind] for an example.
///
@sealed
class ListKind<T> extends Kind<List<T>> {
  /// [Kind] for [ListKind].
  ///
  /// The purpose of annotation `@protected` is reducing accidental use.
  @protected
  static final EntityKind<ListKind> kind = EntityKind<ListKind>(
    name: 'ListKind',
    build: (c) {
      final itemsKind = c.required(
        id: 1,
        name: 'itemsKind',
        kind: Kind.kind,
        getter: (t) => t.itemsKind,
      );
      final minLength = c.requiredUint64(
        id: 2,
        name: 'minLength',
        getter: (t) => t.minLength,
      );
      final maxLength = c.optionalUint64(
        id: 3,
        name: 'maxLength',
        getter: (t) => t.maxLength,
      );
      c.constructorFromData = (data) {
        return ListKind(
          data.get(itemsKind),
          minLength: data.get(minLength),
          maxLength: data.get(maxLength),
        );
      };
    },
  );

  /// Kind for items.
  final Kind<T> itemsKind;

  /// Minimum number of items.
  final int minLength;

  /// Maximum number of items.
  final int? maxLength;

  final bool reactive;

  @literal
  const ListKind(
    this.itemsKind, {
    this.minLength = 0,
    this.maxLength,
    this.reactive = true,
  })  : assert(minLength >= 0),
        assert(maxLength == null || maxLength >= minLength);

  @override
  int get hashCode {
    // IMPORTANT: Avoid cycles that cause stack overflow.
    return itemsKind.name.hashCode ^ minLength.hashCode ^ maxLength.hashCode;
  }

  @override
  String get name => 'List';

  @override
  int get protobufFieldType {
    final pbFieldType = itemsKind.protobufFieldType;
    switch (pbFieldType) {
      case protobuf.PbFieldType.OM:
        return protobuf.PbFieldType.PM;
      case protobuf.PbFieldType.OY:
        return protobuf.PbFieldType.PY;
      case protobuf.PbFieldType.O3:
        return protobuf.PbFieldType.P3;
      case protobuf.PbFieldType.O6:
        return protobuf.PbFieldType.P6;
      case protobuf.PbFieldType.OS3:
        return protobuf.PbFieldType.PS3;
      case protobuf.PbFieldType.OS6:
        return protobuf.PbFieldType.PS6;
      case protobuf.PbFieldType.OF:
        return protobuf.PbFieldType.PF;
      case protobuf.PbFieldType.OD:
        return protobuf.PbFieldType.PD;
      case protobuf.PbFieldType.OU3:
        return protobuf.PbFieldType.PU3;
      case protobuf.PbFieldType.OU6:
        return protobuf.PbFieldType.PU6;
      default:
        throw ArgumentError.value('Unsupported item type: $itemsKind');
    }
  }

  @override
  EntityKind<ListKind> getKind() => kind;

  @override
  bool instanceIsDefaultValue(Object? value) {
    return value is List<T> && value.isEmpty;
  }

  @override
  void instanceValidateConstraints(ValidateContext context, List<T> value) {
    context.validateLength(
      value: value,
      length: value.length,
      minLength: minLength,
      maxLength: maxLength,
    );
    for (var i = 0; i < value.length; i++) {
      context.validateIndex(i, value[i], kind: itemsKind);
    }
    super.instanceValidateConstraints(context, value);
  }

  @override
  List<T> jsonTreeDecode(Object? json, {JsonDecodingContext? context}) {
    context ??= JsonDecodingContext();
    context.enter(json);
    try {
      if (json is List) {
        final result = itemsKind.newList(
          json.length,
          growable: true,
          reactive: context.reactive,
        );
        for (var i = 0; i < result.length; i++) {
          final item = json[i];
          context.enterIndex(i, item);
          result[i] = context.decode(item, kind: itemsKind);
          context.leave();
        }
        return result;
      } else {
        throw context.newGraphNodeError(
          value: json,
          reason: 'Expected JSON array',
        );
      }
    } finally {
      context.leave();
    }
  }

  @override
  Object? jsonTreeEncode(List<T> value, {JsonEncodingContext? context}) {
    context ??= JsonEncodingContext();
    context.enter(value);
    try {
      final result = <Object?>[];
      for (var i = 0; i < value.length; i++) {
        final item = value[i];
        context.enterIndex(i, item);
        result.add(context.encode(item, kind: itemsKind));
        context.leave();
      }
      return result;
    } finally {
      context.leave();
    }
  }

  @override
  List<T> newInstance() {
    return itemsKind.newList(
      0,
      growable: true,
      reactive: reactive,
    );
  }

  @override
  List<T> protobufTreeDecode(Object? value,
      {ProtobufDecodingContext? context}) {
    context ??= ProtobufDecodingContext();
    context.enter(value);
    try {
      if (value is List) {
        final result = itemsKind.newList(
          value.length,
          growable: true,
          reactive: context.reactive,
        );
        for (var i = 0; i < result.length; i++) {
          result[i] = context.decode(i, kind: itemsKind);
        }
        return result;
      }
      throw context.newUnsupportedTypeError(value);
    } finally {
      context.leave();
    }
  }

  @override
  Object? protobufTreeEncode(List<T> value,
      {ProtobufEncodingContext? context}) {
    context ??= ProtobufEncodingContext();
    context.enter(value);
    try {
      if (value is List) {
        final result = <Object?>[];
        for (var item in value) {
          result.add(context.encode(item, kind: itemsKind));
        }
        return result;
      }
      throw context.newUnsupportedTypeError(value);
    } finally {
      context.leave();
    }
  }

  @override
  List<T> randomExample({RandomExampleContext? context}) {
    context ??= RandomExampleContext();
    final random = context.random;
    final minLength = this.minLength;
    var maxLength = this.maxLength ?? (minLength + 2);
    if (context.minimizeNewInstances) {
      maxLength = minLength;
    }
    context.nonPrimitivesCount++;
    context.depth++;
    final length = minLength + random.nextInt(maxLength + 1 - minLength);
    final result = <T>[];
    for (var i = 0; i < length; i++) {
      result.add(itemsKind.randomExample(context: context));
    }
    context.depth--;
    return result;
  }

  @override
  String toString() {
    final sb = StringBuffer();
    sb.writeln('ListKind(');
    sb.write('  itemsKind: ');
    sb.write(itemsKind);
    sb.writeln(',');
    final minLength = this.minLength;
    if (minLength != 0) {
      sb.write('  minLength: ');
      sb.write(minLength);
      sb.writeln(',');
    }
    final maxLength = this.maxLength;
    if (maxLength != null) {
      sb.write('  maxLength: ');
      sb.write(maxLength);
      sb.writeln(',');
    }
    sb.write(')');
    return sb.toString();
  }
}
