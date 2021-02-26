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

/// [Kind] for [Set].
///
/// ## Constraints
///   * Number of items ([minLength], [maxLength])
///
/// ## Example.
/// See [EntityKind] for an example.
///
@sealed
class SetKind<T> extends Kind<Set<T>> {
  /// [Kind] for [SetKind].
  ///
  /// The purpose of annotation `@protected` is reducing accidental use.
  @protected
  static final EntityKind<SetKind> kind = EntityKind<SetKind>(
    name: 'SetKind',
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
        return SetKind(
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

  const SetKind(
    this.itemsKind, {
    this.minLength = 0,
    this.maxLength,
  })  : assert(minLength >= 0),
        assert(maxLength == null || maxLength >= minLength);

  @override
  int get hashCode {
    // IMPORTANT: Avoid cycles that cause stack overflow.
    return itemsKind.name.hashCode ^ minLength ^ maxLength.hashCode;
  }

  @override
  String get name => 'Set';

  @override
  int get protobufFieldType {
    return ListKind(itemsKind).protobufFieldType;
  }

  @override
  EntityKind<SetKind> getKind() => kind;

  @override
  bool instanceIsDefaultValue(Object? value) {
    return value is Set<T> && value.isEmpty;
  }

  @override
  void instanceValidateConstraints(ValidateContext context, Set<T> value) {
    context.validateLength(
      value: value,
      length: value.length,
      minLength: minLength,
      maxLength: maxLength,
    );
    var i = 0;
    for (var item in value) {
      context.validateIndex(i, item, kind: itemsKind);
      i++;
    }
    super.instanceValidateConstraints(context, value);
  }

  @override
  Set<T> jsonTreeDecode(Object? json, {JsonDecodingContext? context}) {
    context ??= JsonDecodingContext();
    context.enter(json);
    try {
      if (json is List) {
        final result = <T>{};
        var i = 0;
        for (var item in json) {
          context.enterIndex(i, item);
          result.add(context.decode(item, kind: itemsKind));
          context.leave();
          i++;
        }
        return result;
      } else {
        throw context.newGraphNodeError(
          value: json,
          reason: 'Expected JSON array.',
        );
      }
    } finally {
      context.leave();
    }
  }

  @override
  Object? jsonTreeEncode(Set<T> value, {JsonEncodingContext? context}) {
    context ??= JsonEncodingContext();
    context.enter(value);
    try {
      final json = [];
      var i = 0;
      for (var item in value) {
        context.enterIndex(i, item);
        context.encode(item, kind: itemsKind);
        context.leave();
        i++;
      }
      return json;
    } finally {
      context.leave();
    }
  }

  @override
  Set<T> newInstance() => ReactiveSet<T>();

  @override
  Set<T> protobufTreeDecode(Object? value, {ProtobufDecodingContext? context}) {
    if (value is List) {
      final newContext = context ?? ProtobufDecodingContext();
      newContext.enter(value);
      try {
        return value
            .map((e) => newContext.decode<T>(value, kind: itemsKind))
            .toSet();
      } finally {
        newContext.leave();
      }
    }
    throw ArgumentError.value(value);
  }

  @override
  Object? protobufTreeEncode(Set<T> value, {ProtobufEncodingContext? context}) {
    final newContext = context ?? ProtobufEncodingContext();
    newContext.enter(value);
    try {
      return value.map((e) => newContext.encode(e, kind: itemsKind)).toList();
    } finally {
      newContext.leave();
    }
  }

  @override
  Set<T> randomExample({RandomExampleContext? context}) {
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
    final result = <T>{};
    for (var i = 0; i < length; i++) {
      result.add(itemsKind.randomExample(context: context));
    }
    context.depth--;
    return result;
  }

  @override
  String toString() {
    final sb = StringBuffer();
    sb.writeln('SetKind(');
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
