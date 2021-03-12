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

/// Superclass of [JsonDecodingContext] and [ProtobufDecodingContext].
abstract class DecodingContext with GraphNodeContext {
  /// Optional library of available kinds.
  final KindLibrary? kindLibrary;

  /// Whether to construct reactive objects.
  ///
  /// You can optimize performance by constructing non-reactive objects (when
  /// you don't care about reactivity).
  final bool reactive;

  /// Translates names of kinds and properties. Default is null.
  ///
  /// If the value is null, the original names of kinds and properties will be
  /// used.
  final Namer? namer;

  DecodingContext({
    this.kindLibrary,
    this.reactive = true,
    this.namer,
  });

  /// Deserializes an object using the given [Kind].
  T decode<T>(Object? value, {required Kind<T> kind});

  /// Returns a new error.
  GraphNodeError newUnsupportedTypeError(Object? value) {
    return newGraphNodeError(
      value: value,
      reason: 'Unsupported type',
    );
  }
}

/// Superclass of [JsonEncodingContext] and [ProtobufEncodingContext].
abstract class EncodingContext with GraphNodeContext {
  /// Optional library of available kinds.
  final KindLibrary? kindLibrary;

  /// Translates names of kinds and properties. Default is null.
  ///
  /// If the value is null, the original names of kinds and properties will be
  /// used.
  final Namer? namer;

  EncodingContext({
    this.kindLibrary,
    this.namer,
  });

  /// Serializes the object using the given [Kind].
  Object? encode<T>(T object, {required Kind<T> kind});

  /// Returns a new error.
  GraphNodeError newUnsupportedTypeError(Object? value) {
    return newGraphNodeError(
      value: value,
      reason: 'Unsupported type',
    );
  }
}
