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

/// [Kind] for [Duration].
///
/// # JSON and Protocol Buffers serialization
///
/// Duration is serialized as a 64-bit floating-point number that
/// represents the duration in seconds.
///
class DurationKind extends Kind<Duration> {
  @protected
  static final EntityKind<DurationKind> kind = EntityKind<DurationKind>(
    name: 'DurationKind',
    define: (c) {
      c.constructor = () => const DurationKind();
    },
  );

  @literal
  const DurationKind();

  @override
  String get name => 'Duration';

  @override
  int get protobufFieldType => const Float64Kind().protobufFieldType;

  @override
  EntityKind<DurationKind> getKind() => kind;

  @override
  bool instanceIsDefaultValue(Object? value) {
    return value is Duration && value.inMicroseconds == 0;
  }

  @override
  Duration jsonTreeDecode(Object? json, {JsonDecodingContext? context}) {
    final float = const Float64Kind().jsonTreeDecode(json, context: context);
    return Duration(microseconds: (float * 1000000).round());
  }

  @override
  Object? jsonTreeEncode(Duration instance, {JsonEncodingContext? context}) {
    return instance.inMicroseconds / 1000000;
  }

  @override
  Duration newInstance() {
    return const Duration();
  }

  @override
  Duration protobufTreeDecode(Object? value,
      {ProtobufDecodingContext? context}) {
    final float =
        const Float64Kind().protobufTreeDecode(value, context: context);
    return Duration(microseconds: (float * 1000000).round());
  }

  @override
  double protobufTreeEncode(Duration instance,
      {ProtobufEncodingContext? context}) {
    return instance.inMicroseconds / 1000000;
  }
}
