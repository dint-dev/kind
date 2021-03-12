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

import 'package:fixnum/fixnum.dart';
import 'package:kind/kind.dart';
import 'package:protobuf/protobuf.dart';
import 'package:protobuf/protobuf.dart' as protobuf;

/// Context object for [EntityKind.protobufBuilderInfo].
class ProtobufBuilderInfoContext {}

/// Context for decoding [Protocol Buffers](https://developers.google.com/protocol-buffers)
/// messages.
///
/// [GRPC](https://grpc.io/) uses Protocol Buffers messages, so you can this
/// with GRPC too.
///
/// # Example
/// ```
/// import 'package:kind/kind.dart';
///
/// void main() {
///   final context = ProtobufEncodingContext();
///   final bytes = <int>[
///     // ...
///   ];
///   final greeting = context.decodeBytes<Greeting>(
///     bytes,
///     kind: Greeting.kind,
///   );
/// }
///
/// class Greeting {
///   static final EntityKind<Greeting> kind = EntityKind<Greeting>(
///     name: 'Example',
///     define: (c) {
///       c.requiredString(
///         id: 1, // <-- Protocol Buffers field ID
///         name: 'message', // <-- Protocol Buffers field name
///         getter: (t) => t.message,
///         setter: (t,v) => t.message = v;
///       );
///       c.constructor = () => Greeting();
///     },
///   );
///
///   String message = 'Hello world!';
/// }
/// ```
class ProtobufDecodingContext extends DecodingContext {
  ProtobufDecodingContext({
    KindLibrary? kindLibrary,
    bool reactive = true,
    Namer? namer,
  }) : super(
          kindLibrary: kindLibrary,
          reactive: reactive,
          namer: namer,
        );

  @override
  String get errorPrimaryLabel => 'Protocol Buffers deserialization error';

  @override
  T decode<T>(Object? object, {required Kind<T> kind}) {
    return kind.protobufTreeDecode(object, context: this);
  }

  /// Decodes the bytes.
  ///
  /// # Example
  ///
  /// See documentation for the class [ProtobufDecodingContext].
  ///
  T decodeBytes<T extends Object>(List<int> bytes,
      {required EntityKind<T> kind}) {
    // ignore: invalid_use_of_protected_member
    final builderInfo = kind.protobufBuilderInfo();
    final generatedMessage = builderInfo.createEmptyInstance!();
    generatedMessage.mergeFromBuffer(bytes);
    return decode(generatedMessage, kind: kind);
  }
}

/// Context for encoding [Protocol Buffers](https://developers.google.com/protocol-buffers) messages.
///
/// [GRPC](https://grpc.io/) uses Protocol Buffers messages, so you can this
/// with GRPC too.
///
/// # Example
/// ```
/// import 'package:kind/kind.dart';
///
/// void main() {
///   final context = ProtobufEncodingContext();
///   final greeting = Greeting();
///   final bytes = context.encodeBytes(greeting, kind: Greeting.kind);
/// }
///
/// class Greeting {
///   static final EntityKind<Greeting> kind = EntityKind<Greeting>(
///     name: 'Example',
///     define: (c) {
///       c.requiredString(
///         id: 1, // <-- Protocol Buffers field ID
///         name: 'message', // <-- Protocol Buffers field name
///         getter: (t) => t.message,
///         setter: (t,v) => t.message = v;
///       );
///       c.constructor = () => Greeting();
///     },
///   );
///
///   String message = 'Hello world!';
/// }
/// ```
class ProtobufEncodingContext extends EncodingContext {
  ProtobufEncodingContext({
    KindLibrary? kindLibrary,
    Namer? namer,
  }) : super(
          kindLibrary: kindLibrary,
          namer: namer,
        );

  @override
  String get errorPrimaryLabel => 'Protocol Buffers serialization error';

  @override
  Object encode<T>(T object, {required Kind<T> kind, int? pbType}) {
    final value = kind.protobufTreeEncode(object, context: this);
    if (pbType == null) {
      return value;
    }
    return _pbTyped(value, pbType: pbType);
  }

  /// Encodes an object as bytes.
  ///
  /// # Example
  ///
  /// See documentation for the class [ProtobufEncodingContext].
  ///
  List<int> encodeBytes<T extends Object>(T object,
      {required EntityKind<T> kind}) {
    final generatedMessage = encode(object, kind: kind) as GeneratedMessage;
    return generatedMessage.writeToBuffer();
  }

  static Object _pbTyped(Object value, {required int pbType}) {
    switch (pbType) {
      // -----------
      // int64
      // sint64
      //
      // --> Dart type Int64
      // -----------
      case protobuf.PbFieldType.O6:
        continue int64Case;
      int64Case:
      case protobuf.PbFieldType.OS6:
        if (value is num) {
          return Int64(value.toInt());
        }
        break;

      // -----------
      // repeated int64
      // repeated sint64
      //
      // --> Dart type List<Int64>
      // -----------
      case protobuf.PbFieldType.P6:
        continue int64ListCase;
      int64ListCase:
      case protobuf.PbFieldType.PS6:
        if (value is List) {
          return value.map((e) => Int64(e)).toList();
        }
        break;
    }
    return value;
  }
}
