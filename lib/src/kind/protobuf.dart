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

/// Context object for [EntityKind.protobufBuilderInfo].
class ProtobufBuilderInfoContext {}

/// Protocol Buffers messages to Dart objects.
class ProtobufDecodingContext with GraphNodeContext {
  /// Optional library of available kinds.
  final KindLibrary? kindLibrary;

  /// Whether to construct reactive objects.
  ///
  /// You can optimize performance by constructing non-reactive objects (when
  /// you don't care about reactivity).
  final bool reactive;

  /// Translates names of kinds and properties.
  final Namer? namer;

  ProtobufDecodingContext({
    this.kindLibrary,
    this.reactive = true,
    this.namer,
  });

  @override
  String get errorPrimaryLabel => 'Protocol Buffers deserialization error';

  /// Decodes the argument.
  ///
  /// You must specify [kind] of the returned value.
  T decode<T>(Object? value, {required Kind<T> kind}) {
    return kind.protobufTreeDecode(value, context: this);
  }

  /// Returns a new error.
  GraphNodeError newUnsupportedTypeError(Object? value) {
    return newGraphNodeError(value: value, reason: 'Unsupported type');
  }
}

/// Converts Dart objects to Protocol Buffers messages.
class ProtobufEncodingContext with GraphNodeContext {
  /// Optional library of available kinds.
  final KindLibrary? kindLibrary;

  /// Translates names of kinds and properties.
  final Namer? namer;

  ProtobufEncodingContext({
    this.kindLibrary,
    this.namer,
  });

  @override
  String get errorPrimaryLabel => 'Protocol Buffers serialization error';

  /// Encodes the argument.
  ///
  /// You must specify [kind] of the argument.
  Object? encode<T>(T value, {required Kind<T> kind}) {
    return kind.protobufTreeEncode(value, context: this);
  }

  /// Returns a new error.
  GraphNodeError newUnsupportedTypeError(Object? value) {
    return newGraphNodeError(value: value, reason: 'Unsupported type');
  }
}
