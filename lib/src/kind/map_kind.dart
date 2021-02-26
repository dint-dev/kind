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

/// [Kind] for [Map].
///
/// ## Example
/// ```
/// import 'package:kind/kind';
///
/// final example = MapKind<String,int>(StringKind(), Int64Kind());
/// ```
@sealed
class MapKind<K, V> extends Kind<Map<K, V>> {
  /// [Kind] for [KindMeaning].
  ///
  /// The purpose of annotation `@protected` is reducing accidental use.
  @protected
  static final EntityKind<MapKind> kind = EntityKind<MapKind>(
    name: 'MapKind',
    build: (c) {
      final keyKindProp = c.required<Kind>(
        id: 1,
        name: 'keyKind',
        kind: Kind.kind,
        getter: (t) => t.keyKind,
      );
      final valueKindProp = c.required<Kind>(
        id: 2,
        name: 'valueKind',
        kind: Kind.kind,
        getter: (t) => t.valueKind,
      );
      c.constructorFromData = (data) {
        return MapKind(
          data.get(keyKindProp),
          data.get(valueKindProp),
        );
      };
    },
  );

  final Kind<K> keyKind;
  final Kind<V> valueKind;

  @literal
  const MapKind(this.keyKind, this.valueKind);

  @override
  int get hashCode => keyKind.hashCode ^ valueKind.hashCode;

  @override
  String get name => 'Map';

  @override
  int get protobufFieldType {
    throw UnimplementedError();
  }

  @override
  EntityKind<MapKind> getKind() => kind;

  @override
  Map<K, V> jsonTreeDecode(Object? json, {JsonDecodingContext? context}) {
    context ??= JsonDecodingContext();
    if (json is Map) {
      final result = <K, V>{};
      for (var entry in json.entries) {
        final key = context.decode(
          entry.key,
          kind: keyKind,
        );
        final value = context.decode(
          entry.value,
          kind: valueKind,
        );
        result[key] = value;
      }
      return result;
    } else {
      throw context.newGraphNodeError(
        value: json,
        reason: 'Expected JSON map',
      );
    }
  }

  @override
  Object? jsonTreeEncode(Map<K, V> value, {JsonEncodingContext? context}) {
    context ??= JsonEncodingContext();
    final jsonObject = <String, Object?>{};
    for (var entry in value.entries) {
      final key = entry.key;
      final value = entry.value;
      final keyJson = keyKind.jsonTreeEncode(key);
      if (keyJson is! String) {
        throw context.newGraphNodeError(
          value: key,
          reason:
              'Expected key to be encoded as JSON string, but was encoded as ${keyJson.runtimeType}: $key',
        );
      }
      final valueJson = context.encode(value, kind: valueKind);
      jsonObject[keyJson] = valueJson;
    }
    return jsonObject;
  }

  @override
  Map<K, V> newInstance() => ReactiveMap.wrap(<K, V>{});

  @override
  Map<K, V> protobufTreeDecode(Object? value,
      {ProtobufDecodingContext? context}) {
    throw UnimplementedError();
  }

  @override
  Object? protobufTreeEncode(Map<K, V> value,
      {ProtobufEncodingContext? context}) {
    throw UnimplementedError();
  }

  @override
  Map<K, V> randomExample({RandomExampleContext? context}) {
    context ??= RandomExampleContext();
    if (context.minimizeNewInstances) {
      return <K, V>{};
    }
    context.nonPrimitivesCount++;
    context.depth++;
    final length = context.random.nextInt(4);
    final result = <K, V>{};
    for (var i = 0; i < length; i++) {
      final key = keyKind.randomExample(context: context);
      final value = valueKind.randomExample(context: context);
      result[key] = value;
    }
    context.depth--;
    return result;
  }
}
