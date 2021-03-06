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

/// Serialization settings used by [JsonEncodingContext] and [JsonDecodingContext].
class JsonSettings {
  final String defaultDiscriminatorName;
  final String defaultValueName;
  final String? nan;
  final String? infinity;
  final String? negativeInfinity;

  const JsonSettings({
    this.defaultDiscriminatorName = 'type',
    this.defaultValueName = 'value',
    this.nan,
    this.infinity,
    this.negativeInfinity,
  });

  @override
  int get hashCode => defaultDiscriminatorName.hashCode;

  @override
  bool operator ==(other) =>
      other is JsonSettings &&
      defaultDiscriminatorName == other.defaultDiscriminatorName &&
      defaultValueName == other.defaultValueName &&
      nan == other.nan &&
      infinity == other.infinity &&
      negativeInfinity == other.negativeInfinity;
}
