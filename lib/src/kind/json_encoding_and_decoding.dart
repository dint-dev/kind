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
/// # Example
/// ```
/// import 'package:kind/kind.dart';
///
/// void main() {
///   final json = {
///     'message': 'Hello world!',
///   };
///
///   // Decode JSON
///   final context = JsonDecodingContext();
///   final greeting = context.decode(
///     json,
///     kind: Greeting.kind,
///   );
/// }
///
///
/// class Greeting {
///   static final EntityKind<Greeting> kind = EntityKind<Greeting>(
///     name: 'Example',
///     define: (c) {
///       c.requiredString(
///         id: 1,
///         name: 'message', // <-- JSON field name
///         getter: (t) => t.message,
///         setter: (t,v) => t.message = v;
///       );
///       c.constructor = () => Greeting();
///     },
///   );
///
///   String message = '';
/// }
/// ```
class JsonDecodingContext extends DecodingContext {
  /// JSON serialization settings.
  final JsonSettings jsonSettings;

  JsonDecodingContext({
    this.jsonSettings = const JsonSettings(),
    KindLibrary? kindLibrary,
    bool reactive = true,
    Namer? namer,
  }) : super(
          kindLibrary: kindLibrary,
          reactive: reactive,
          namer: namer,
        );

  @override
  String get errorPrimaryLabel => 'JSON decoding error';

  @override
  T decode<T>(Object? json, {required Kind<T> kind}) {
    return kind.jsonTreeDecode(json, context: this);
  }
}

/// JSON serializer.
///
/// # Example
/// ```
/// import 'package:kind/kind.dart';
///
/// void main() {
///   final greeting = Greeting();
///   greeting.message = "Hello world!";
///
///   // Encode JSON
///   final context = JsonEncodingContext();
///   final json = context.encode(
///     greeting,
///     kind: Greeting.kind,
///   );
///   // You get:
///   //   {
///   //     "message": "Hello world!",
///   //   }
///   //
/// }
///
///
/// class Greeting {
///   static final EntityKind<Greeting> kind = EntityKind<Greeting>(
///     name: 'Example',
///     define: (c) {
///       c.requiredString(
///         id: 1,
///         name: 'message', // <-- JSON field name
///         getter: (t) => t.message,
///         setter: (t,v) => t.message = v;
///       );
///       c.constructor = () => Greeting();
///     },
///   );
///
///   String message = '';
/// }
/// ```
class JsonEncodingContext extends EncodingContext {
  /// JSON serialization settings.
  final JsonSettings jsonSettings;

  JsonEncodingContext({
    this.jsonSettings = const JsonSettings(),
    KindLibrary? kindLibrary,
    Namer? namer,
  }) : super(
          kindLibrary: kindLibrary,
          namer: namer,
        );

  @override
  String get errorPrimaryLabel => 'JSON encoding error';

  @override
  Object? encode<T>(T object, {required Kind<T> kind}) {
    if (object == null) {
      return null;
    }
    return kind.jsonTreeEncode(object, context: this);
  }
}
