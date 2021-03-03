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

/// A library for describing and accessing objects.
///
/// ## Important classes
///   * [Kind] - The superclass of all kinds.
///   * [Entity] and [EntityKind] - Used for declaring your own kinds.
///
library kind;

import 'package:kind/kind.dart';

export 'src/kind/bool_kind.dart';
export 'src/kind/bytes_kind.dart';
export 'src/kind/composite_primitive_kind.dart';
export 'src/kind/date.dart';
export 'src/kind/date_kind.dart';
export 'src/kind/date_time_kind.dart';
export 'src/kind/date_time_with_time_zone.dart';
export 'src/kind/date_time_with_time_zone_kind.dart';
export 'src/kind/entity.dart';
export 'src/kind/entity_data.dart';
export 'src/kind/entity_junction.dart';
export 'src/kind/entity_kind.dart';
export 'src/kind/entity_kind_declaration_context.dart';
export 'src/kind/entity_relation.dart';
export 'src/kind/enum_kind.dart';
export 'src/kind/fields.dart';
export 'src/kind/fields.dart';
export 'src/kind/float_kind.dart';
export 'src/kind/geo_point.dart';
export 'src/kind/geo_point_kind.dart';
export 'src/kind/graph_equality.dart';
export 'src/kind/graph_node_context.dart';
export 'src/kind/graph_node_error.dart';
export 'src/kind/int64_fixnum_kind.dart';
export 'src/kind/int_kind.dart';
export 'src/kind/json_kind.dart';
export 'src/kind/json_serialization.dart';
export 'src/kind/json_settings.dart';
export 'src/kind/kind.dart';
export 'src/kind/kind_library.dart';
export 'src/kind/kind_meaning.dart';
export 'src/kind/list_kind.dart';
export 'src/kind/map_kind.dart';
export 'src/kind/nullable_kind.dart';
export 'src/kind/object_kind.dart';
export 'src/kind/one_of_kind.dart';
export 'src/kind/primitive_kind.dart';
export 'src/kind/prop.dart';
export 'src/kind/prop_declaration_helper.dart';
export 'src/kind/prop_meaning.dart';
export 'src/kind/protobuf.dart';
export 'src/kind/protobuf_schema_generator.dart';
export 'src/kind/reactive_iterable.dart';
export 'src/kind/reactive_list.dart';
export 'src/kind/reactive_map.dart';
export 'src/kind/reactive_mixin.dart';
export 'src/kind/reactive_set.dart';
export 'src/kind/reactive_system.dart';
export 'src/kind/set_kind.dart';
export 'src/kind/string_kind.dart';
export 'src/kind/uuid.dart';
export 'src/kind/uuid_kind.dart';
export 'src/kind/validate_context.dart';
