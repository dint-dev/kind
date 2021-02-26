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

import 'package:collection/collection.dart';
import 'package:kind/kind.dart';

/// A collection of [Kind] instances.
class KindLibrary {
  final List<Kind> items;

  KindLibrary(this.items);

  @override
  int get hashCode => const ListEquality().hash(items);

  @override
  bool operator ==(Object other) =>
      other is KindLibrary && const ListEquality().equals(items, other.items);
}
