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

/// JSON deserializer.
///
/// ## Example
/// ```
/// final deserializer = JsonDeserializer();
/// final value = deserializer.deserialize(jsonValue, kind:kind);
/// ```
class JsonDecodingContext with GraphNodeContext {
  /// JSON serialization settings.
  final JsonSettings jsonSettings;

  /// Optional library of available kinds.
  final KindLibrary? kindLibrary;

  /// Whether to construct reactive objects.
  ///
  /// You can optimize performance by constructing non-reactive objects (when
  /// you don't care about reactivity).
  final bool reactive;

  /// Translates names of kinds and properties.
  final Namer? namer;

  JsonDecodingContext({
    this.jsonSettings = const JsonSettings(),
    this.reactive = true,
    this.kindLibrary,
    this.namer,
  });

  @override
  String get errorPrimaryLabel => 'JSON deserialization error';

  /// Deserializes an object using the given [Kind].
  T decode<T>(Object? value, {required Kind<T> kind}) {
    return kind.jsonTreeDecode(value, context: this);
  }
}

/// JSON serializer.
///
/// ## Example
/// ```
/// final deserializer = JsonSerializer();
/// final jsonValue = deserializer.serialize(value, kind:kind);
/// ```
class JsonEncodingContext with GraphNodeContext {
  /// JSON serialization settings.
  final JsonSettings jsonSettings;

  /// Optional library of available kinds.
  final KindLibrary? kindLibrary;

  /// Whether to construct reactive objects.
  ///
  /// You can optimize performance by constructing non-reactive objects (when
  /// you don't care about reactivity).
  final bool reactive;

  /// Translates names of kinds and properties.
  final Namer? namer;

  JsonEncodingContext({
    this.jsonSettings = const JsonSettings(),
    this.kindLibrary,
    this.reactive = true,
    this.namer,
  });

  @override
  String get errorPrimaryLabel => 'JSON serialization error';

  /// Serializes the object using the given [Kind].
  Object? encode<T>(T value, {required Kind<T> kind}) {
    if (value == null) {
      return null;
    }
    return kind.jsonTreeEncode(value, context: this);
  }
}
