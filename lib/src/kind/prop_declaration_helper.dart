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

/// A helper class used for declaring [Prop] instances.
mixin PropDeclarationHelperMixin<T extends Object> {
  void addProp(Prop<T, dynamic> prop);

  /// Constructs a [Prop] for `V?`.
  ///
  /// ## Example
  /// ```
  /// declare.optional<Something>(
  ///   id: 1,
  ///   name: 'x',
  ///   kind: Something.kind,
  /// );
  /// ```
  Prop<T, V?> optional<V>({
    required int id,
    required String name,
    required Kind<V> kind,
    EntityRelation? relation,
    List<PropMeaning> meanings = const [],
    Field<V?> Function(T t)? field,
    V? Function(T t)? getter,
    void Function(T t, V? value)? setter,
  }) {
    final prop = Prop<T, V?>(
      id: id,
      name: name,
      kind: NullableKind<V?>(kind),
      relation: relation,
      meanings: meanings,
      field: field,
      getter: getter,
      setter: setter,
    );
    addProp(prop);
    return prop;
  }

  /// Constructs a [Prop] for `bool` by using [BoolKind].
  ///
  /// ## Example
  /// ```
  /// declare.optionalBool(
  ///   id: 1,
  ///   name: 'x',
  /// );
  /// ```
  Prop<T, bool?> optionalBool({
    required int id,
    required String name,
    Field<bool?> Function(T t)? field,
    bool? Function(T t)? getter,
    void Function(T t, bool? value)? setter,
  }) {
    const kind = NullableKind<bool>(BoolKind());
    final prop = Prop<T, bool?>(
      id: id,
      name: name,
      kind: kind,
      field: field,
      getter: getter,
      setter: setter,
    );
    addProp(prop);
    return prop;
  }

  /// Constructs a [Prop] for `List<int>?` by using [ListKind].
  ///
  /// ## Example
  /// ```
  /// declare.optionalBytes(
  ///   id: 1,
  ///   name: 'x',
  /// );
  /// ```
  Prop<T, List<int>?> optionalBytes({
    required int id,
    required String name,
    int minLength = 0,
    int? maxLength,
    Field<List<int>?> Function(T t)? field,
    List<int>? Function(T t)? getter,
    void Function(T t, List<int>? value)? setter,
  }) {
    var kind = const NullableKind<List<int>>(BytesKind());
    if (minLength != 0 || maxLength != null) {
      kind = NullableKind<List<int>>(BytesKind(
        minLength: minLength,
        maxLength: maxLength,
      ));
    }
    final prop = Prop<T, List<int>?>(
      id: id,
      name: name,
      kind: kind,
      field: field,
      getter: getter,
      setter: setter,
    );
    addProp(prop);
    return prop;
  }

  /// Constructs a [Prop] for `Date?` by using [DateKind].
  ///
  /// ## Example
  /// ```
  /// declare.optionalDate(
  ///   id: 1,
  ///   name: 'x',
  /// );
  /// ```
  Prop<T, Date?> optionalDate({
    required int id,
    required String name,
    Field<Date?> Function(T t)? field,
    Date? Function(T t)? getter,
    void Function(T t, Date? value)? setter,
  }) {
    const kind = NullableKind<Date>(DateKind());
    final prop = Prop<T, Date?>(
      id: id,
      name: name,
      kind: kind,
      field: field,
      getter: getter,
      setter: setter,
    );
    addProp(prop);
    return prop;
  }

  /// Constructs a [Prop] for `DateTime?` by using [DateTimeKind].
  ///
  /// ## Example
  /// ```
  /// declare.optionalDateTime(
  ///   id: 1,
  ///   name: 'x',
  /// );
  /// ```
  Prop<T, DateTime?> optionalDateTime({
    required int id,
    required String name,
    Field<DateTime?> Function(T t)? field,
    DateTime? Function(T t)? getter,
    void Function(T t, DateTime? value)? setter,
  }) {
    const kind = NullableKind<DateTime>(DateTimeKind());
    final prop = Prop<T, DateTime?>(
      id: id,
      name: name,
      kind: kind,
      field: field,
      getter: getter,
      setter: setter,
    );
    addProp(prop);
    return prop;
  }

  /// Constructs a [Prop] for `DateTimeWithTimeZone?` by using [DateTimeWithTimeZoneKind].
  ///
  /// ## Example
  /// ```
  /// declare.optionalDateTimeWithTimeZone(
  ///   id: 1,
  ///   name: 'x',
  /// );
  /// ```
  Prop<T, DateTimeWithTimeZone?> optionalDateTimeWithTimeZone({
    required int id,
    required String name,
    Field<DateTimeWithTimeZone?> Function(T t)? field,
    DateTimeWithTimeZone? Function(T t)? getter,
    void Function(T t, DateTimeWithTimeZone? value)? setter,
  }) {
    const kind = NullableKind<DateTimeWithTimeZone>(DateTimeWithTimeZoneKind());
    final prop = Prop<T, DateTimeWithTimeZone?>(
      id: id,
      name: name,
      kind: kind,
      field: field,
      getter: getter,
      setter: setter,
    );
    addProp(prop);
    return prop;
  }

  /// Constructs a [Prop] for 32-bit `double?` by using [Float32Kind].
  ///
  /// ## Example
  /// ```
  /// declare.optionalFloat32(
  ///   id: 1,
  ///   name: 'x',
  /// );
  /// ```
  Prop<T, double?> optionalFloat32({
    required int id,
    required String name,
    double? min,
    double? max,
    Field<double?> Function(T t)? field,
    double? Function(T t)? getter,
    void Function(T t, double? value)? setter,
  }) {
    var kind = const NullableKind<double>(Float32Kind());
    if (min != null || max != null) {
      kind = NullableKind<double>(
        Float32Kind(
          min: min,
          max: max,
        ),
      );
    }
    final prop = Prop<T, double?>(
      id: id,
      name: name,
      kind: kind,
      field: field,
      getter: getter,
      setter: setter,
    );
    addProp(prop);
    return prop;
  }

  /// Constructs a [Prop] for 64-bit `double?` by using [Float64Kind].
  ///
  /// ## Example
  /// ```
  /// declare.optionalFloat64(
  ///   id: 1,
  ///   name: 'x',
  /// );
  /// ```
  Prop<T, double?> optionalFloat64({
    required int id,
    required String name,
    double? min,
    double? max,
    Field<double?> Function(T t)? field,
    double? Function(T t)? getter,
    void Function(T t, double? value)? setter,
  }) {
    var kind = const NullableKind<double>(Float64Kind());
    if (min != null || max != null) {
      kind = NullableKind<double>(
        Float64Kind(
          min: min,
          max: max,
        ),
      );
    }
    final prop = Prop<T, double?>(
      id: id,
      name: name,
      kind: kind,
      field: field,
      getter: getter,
      setter: setter,
    );
    addProp(prop);
    return prop;
  }

  /// Constructs a [Prop] for `GeoPoint?` by using [GeoPointKind].
  ///
  /// ## Example
  /// ```
  /// declare.optionalGeoPoint(
  ///   id: 1,
  ///   name: 'x',
  /// );
  /// ```
  Prop<T, GeoPoint?> optionalGeoPoint({
    required int id,
    required String name,
    Field<GeoPoint?> Function(T t)? field,
    GeoPoint? Function(T t)? getter,
    void Function(T t, GeoPoint? value)? setter,
  }) {
    const kind = NullableKind<GeoPoint>(GeoPointKind());
    final prop = Prop<T, GeoPoint?>(
      id: id,
      name: name,
      kind: kind,
      field: field,
      getter: getter,
      setter: setter,
    );
    addProp(prop);
    return prop;
  }

  /// Constructs a [Prop] for 32-bit signed `int?` by using [Int32Kind].
  ///
  /// ## Example
  /// ```
  /// declare.optionalInt32(
  ///   id: 1,
  ///   name: 'x',
  /// );
  /// ```
  Prop<T, int?> optionalInt32({
    required int id,
    required String name,
    int? min,
    int? max,
    Field<int?> Function(T t)? field,
    int? Function(T t)? getter,
    void Function(T t, int? value)? setter,
  }) {
    var kind = const NullableKind<int>(Int32Kind());
    if (min != null || max != null) {
      kind = NullableKind<int>(
        Int32Kind(
          min: min,
          max: max,
        ),
      );
    }
    final prop = Prop<T, int?>(
      id: id,
      name: name,
      kind: kind,
      field: field,
      getter: getter,
      setter: setter,
    );
    addProp(prop);
    return prop;
  }

  /// Constructs a [Prop] for 64-bit signed `int?` by using [Int64Kind].
  ///
  /// ## Example
  /// ```
  /// declare.optionalInt64(
  ///   id: 1,
  ///   name: 'x',
  /// );
  /// ```
  Prop<T, int?> optionalInt64({
    required int id,
    required String name,
    int? min,
    int? max,
    Field<int?> Function(T t)? field,
    int? Function(T t)? getter,
    void Function(T t, int? value)? setter,
  }) {
    var kind = const NullableKind<int>(Int64Kind());
    if (min != null || max != null) {
      kind = NullableKind<int>(
        Int64Kind(
          min: min,
          max: max,
        ),
      );
    }
    final prop = Prop<T, int?>(
      id: id,
      name: name,
      kind: kind,
      field: field,
      getter: getter,
      setter: setter,
    );
    addProp(prop);
    return prop;
  }

  /// Constructs a [Prop] for 64-bit signed `Int64?` by using [Int64FixNumKind].
  ///
  /// ## Example
  /// ```
  /// declare.optionalInt64FixNum(
  ///   id: 1,
  ///   name: 'x',
  /// );
  /// ```
  Prop<T, Int64?> optionalInt64FixNum({
    required int id,
    required String name,
    Int64? min,
    Int64? max,
    bool unsigned = false,
    bool fixedLength = false,
    Field<Int64?> Function(T t)? field,
    Int64? Function(T t)? getter,
    void Function(T t, Int64? value)? setter,
  }) {
    var kind = const NullableKind<Int64>(Int64FixNumKind());
    if (min != null ||
        max != null ||
        unsigned != false ||
        fixedLength != false) {
      kind = NullableKind<Int64>(Int64FixNumKind(
        min: min,
        max: max,
        unsigned: unsigned,
        fixed: fixedLength,
      ));
    }
    final prop = Prop<T, Int64?>(
      id: id,
      name: name,
      kind: kind,
      field: field,
      getter: getter,
      setter: setter,
    );
    addProp(prop);
    return prop;
  }

  /// Constructs a [Prop] for `List<T>?` by using [ListKind].
  ///
  /// ## Example
  /// ```
  /// declare.optionalList<String>(
  ///   id: 1,
  ///   name: 'x',
  ///   itemsKind: const StringKind(),
  ///   minLength: 2,
  ///   maxLength: 3,
  /// );
  /// ```
  Prop<T, List<V>?> optionalList<V>({
    required int id,
    required String name,
    required Kind<V> itemsKind,
    int minLength = 0,
    int? maxLength,
    bool noWrapping = false,
    Field<List<V>?> Function(T t)? field,
    List<V>? Function(T t)? getter,
    void Function(T t, List<V>? value)? setter,
  }) {
    final kind = NullableKind<List<V>>(ListKind<V>(
      itemsKind,
      minLength: minLength,
      maxLength: maxLength,
    ));
    final prop = Prop<T, List<V>?>(
      id: id,
      name: name,
      kind: kind,
      field: field,
      getter: getter,
      setter: setter,
    );
    addProp(prop);
    return prop;
  }

  /// Constructs a [Prop] for `Map<K,V>?` by using [MapKind].
  ///
  /// ## Example
  /// ```
  /// declare.optionalMap<String,String>(
  ///   id: 1,
  ///   name: 'x',
  ///   keyKind: const StringKind(),
  ///   valueKind: const StringKind(),
  /// );
  /// ```
  Prop<T, Map<K, V>?> optionalMap<K, V>(
      {required int id,
      required String name,
      required Kind<K> keyKind,
      required Kind<V> valueKind,
      Field<Map<K, V>?> Function(T t)? field,
      Map<K, V>? Function(T t)? getter}) {
    final kind = NullableKind<Map<K, V>>(MapKind<K, V>(
      keyKind,
      valueKind,
    ));
    final prop = Prop<T, Map<K, V>?>(
      id: id,
      name: name,
      kind: kind,
      field: field,
      getter: getter,
    );
    addProp(prop);
    return prop;
  }

  /// Constructs a [Prop] for `Set<T>?` by using [SetKind].
  ///
  /// ## Example
  /// ```
  /// declare.optionalSet<String>(
  ///   id: 1,
  ///   name: 'x',
  ///   itemsKind: const StringKind(),
  ///   minLength: 2,
  ///   maxLength: 3,
  /// );
  /// ```
  Prop<T, Set<V>?> optionalSet<V>(
      {required int id,
      required String name,
      required Kind<V> itemsKind,
      int minLength = 0,
      int? maxLength,
      Field<Set<V>?> Function(T t)? field,
      Set<V>? Function(T t)? getter}) {
    final kind = NullableKind<Set<V>>(SetKind<V>(
      itemsKind,
      minLength: minLength,
      maxLength: maxLength,
    ));
    final prop = Prop<T, Set<V>?>(
      id: id,
      name: name,
      kind: kind,
      field: field,
      getter: getter,
    );
    addProp(prop);
    return prop;
  }

  /// Constructs a [Prop] for `String?` by using [StringKind].
  ///
  /// ## Example
  /// ```
  /// declare.optionalString(
  ///   id: 1,
  ///   name: 'x',
  ///   minLengthInUtf8: 2,
  ///   maxLengthInUtf8: 3,
  ///   pattern: 'some pattern',
  ///   examples: const ['a valid value'],
  /// );
  /// ```
  Prop<T, String?> optionalString({
    required int id,
    required String name,
    int minLengthInUtf8 = 0,
    int? maxLengthInUtf8,
    bool isSingleLine = false,
    RegExp Function()? regExpProvider,
    Field<String?> Function(T t)? field,
    String? Function(T t)? getter,
    void Function(T t, String? value)? setter,
  }) {
    var kind = const NullableKind<String>(StringKind());
    if (minLengthInUtf8 != 0 ||
        maxLengthInUtf8 != null ||
        isSingleLine ||
        regExpProvider != null) {
      kind = NullableKind<String>(
        StringKind(
          minLengthInUtf8: minLengthInUtf8,
          maxLengthInUtf8: maxLengthInUtf8,
        ),
      );
    }
    final prop = Prop<T, String?>(
      id: id,
      name: name,
      kind: kind,
      field: field,
      getter: getter,
      setter: setter,
    );
    addProp(prop);
    return prop;
  }

  /// Constructs a [Prop] for 32-bit unsigned `int?` by using [Uint32Kind].
  ///
  /// ## Example
  /// ```
  /// declare.optionalUint32(
  ///   id: 1,
  ///   name: 'x',
  /// );
  /// ```
  Prop<T, int?> optionalUint32({
    required int id,
    required String name,
    int? min,
    int? max,
    Field<int?> Function(T t)? field,
    int? Function(T t)? getter,
    void Function(T t, int? value)? setter,
  }) {
    var kind = const NullableKind<int>(Uint32Kind());
    if (min != null || max != null) {
      kind = NullableKind<int>(
        Uint32Kind(
          min: min,
          max: max,
        ),
      );
    }
    final prop = Prop<T, int?>(
      id: id,
      name: name,
      kind: kind,
      field: field,
      getter: getter,
      setter: setter,
    );
    addProp(prop);
    return prop;
  }

  /// Constructs a [Prop] for 64-bit unsigned `int?` by using [Uint64Kind].
  ///
  /// ## Example
  /// ```
  /// declare.optionalUint32(
  ///   id: 1,
  ///   name: 'x',
  /// );
  /// ```
  Prop<T, int?> optionalUint64({
    required int id,
    required String name,
    int? min,
    int? max,
    Field<int?> Function(T t)? field,
    int? Function(T t)? getter,
    void Function(T t, int? value)? setter,
  }) {
    var kind = const NullableKind<int>(Uint64Kind());
    if (min != null || max != null) {
      kind = NullableKind<int>(
        Uint64Kind(
          min: min,
          max: max,
        ),
      );
    }
    final prop = Prop<T, int?>(
      id: id,
      name: name,
      kind: kind,
      field: field,
      getter: getter,
      setter: setter,
    );
    addProp(prop);
    return prop;
  }

  /// Constructs a [Prop] for `V`.
  ///
  /// ## Example
  /// ```
  /// declare.required<Something>(
  ///   id: 1,
  ///   name: 'x',
  ///   kind: Something.kind,
  /// );
  /// ```
  Prop<T, V> required<V>({
    required int id,
    required String name,
    required Kind<V> kind,
    EntityRelation? relation,
    List<PropMeaning> meanings = const [],
    Field<V> Function(T t)? field,
    V Function(T t)? getter,
    void Function(T t, V value)? setter,
  }) {
    final prop = Prop<T, V>(
      id: id,
      name: name,
      kind: kind,
      relation: relation,
      meanings: meanings,
      field: field,
      getter: getter,
      setter: setter,
    );
    addProp(prop);
    return prop;
  }

  /// Constructs a [Prop] for `bool` by using [BoolKind].
  ///
  /// ## Example
  /// ```
  /// declare.requiredBool(
  ///   id: 1,
  ///   name: 'x',
  /// );
  /// ```
  Prop<T, bool> requiredBool({
    required int id,
    required String name,
    bool? defaultValue,
    Field<bool> Function(T t)? field,
    bool Function(T t)? getter,
    void Function(T t, bool value)? setter,
  }) {
    const kind = BoolKind();
    final prop = Prop<T, bool>(
      id: id,
      name: name,
      kind: kind,
      defaultValue: defaultValue,
      field: field,
      getter: getter,
      setter: setter,
    );
    addProp(prop);
    return prop;
  }

  /// Constructs a [Prop] for `List<int>` by using [ListKind].
  ///
  /// ## Example
  /// ```
  /// declare.requiredBytes(
  ///   id: 1,
  ///   name: 'x',
  /// );
  /// ```
  Prop<T, List<int>> requiredBytes({
    required int id,
    required String name,
    int minLength = 0,
    int? maxLength,
    Field<List<int>> Function(T t)? field,
    List<int> Function(T t)? getter,
    void Function(T t, List<int> value)? setter,
  }) {
    var kind = const BytesKind();
    if (minLength != 0 || maxLength != null) {
      kind = BytesKind(
        minLength: minLength,
        maxLength: maxLength,
      );
    }
    final prop = Prop<T, List<int>>(
      id: id,
      name: name,
      kind: kind,
      field: field,
      getter: getter,
      setter: setter,
    );
    addProp(prop);
    return prop;
  }

  /// Constructs a [Prop] for `Date` by using [DateKind].
  ///
  /// ## Example
  /// ```
  /// declare.requiredDate(
  ///   id: 1,
  ///   name: 'x',
  /// );
  /// ```
  Prop<T, Date> requiredDate({
    required int id,
    required String name,
    Field<Date> Function(T t)? field,
    Date Function(T t)? getter,
    void Function(T t, Date value)? setter,
  }) {
    const kind = DateKind();
    final prop = Prop<T, Date>(
      id: id,
      name: name,
      kind: kind,
      field: field,
      getter: getter,
      setter: setter,
    );
    addProp(prop);
    return prop;
  }

  /// Constructs a [Prop] for `DateTime` by using [DateTimeKind].
  ///
  /// ## Example
  /// ```
  /// declare.requiredDateTime(
  ///   id: 1,
  ///   name: 'x',
  /// );
  /// ```
  Prop<T, DateTime> requiredDateTime({
    required int id,
    required String name,
    Field<DateTime> Function(T t)? field,
    DateTime Function(T t)? getter,
    void Function(T t, DateTime value)? setter,
  }) {
    const kind = DateTimeKind();
    final prop = Prop<T, DateTime>(
      id: id,
      name: name,
      kind: kind,
      field: field,
      getter: getter,
      setter: setter,
    );
    addProp(prop);
    return prop;
  }

  /// Constructs a [Prop] for `DateTimeWithTimeZone` by using [DateTimeWithTimeZoneKind].
  ///
  /// ## Example
  /// ```
  /// declare.requiredDateTimeWithTimeZone(
  ///   id: 1,
  ///   name: 'x',
  /// );
  /// ```
  Prop<T, DateTimeWithTimeZone> requiredDateTimeWithTimeZone({
    required int id,
    required String name,
    Field<DateTimeWithTimeZone> Function(T t)? field,
    DateTimeWithTimeZone Function(T t)? getter,
    void Function(T t, DateTimeWithTimeZone value)? setter,
  }) {
    const kind = DateTimeWithTimeZoneKind();
    final prop = Prop<T, DateTimeWithTimeZone>(
      id: id,
      name: name,
      kind: kind,
      field: field,
      getter: getter,
      setter: setter,
    );
    addProp(prop);
    return prop;
  }

  /// Constructs a [Prop] for `V` enum by using [EnumKind].
  ///
  /// ## Example
  /// ```
  /// declare.optional<Something>(
  ///   id: 1,
  ///   name: 'x',
  ///   kind: Something.kind,
  /// );
  /// ```
  Prop<T, V> requiredEnum<V>({
    required int id,
    required String name,
    required List<EnumKindEntry<V>> entries,
    Field<V> Function(T t)? field,
    V Function(T t)? getter,
    void Function(T t, V value)? setter,
  }) {
    final prop = Prop<T, V>(
      id: id,
      name: name,
      kind: EnumKind<V>(entries: entries),
      getter: getter,
      setter: setter,
    );
    addProp(prop);
    return prop;
  }

  /// Constructs a [Prop] for 32-bit `double` by using [Float32Kind].
  ///
  /// ## Example
  /// ```
  /// declare.requiredFloat32(
  ///   id: 1,
  ///   name: 'x',
  /// );
  /// ```
  Prop<T, double> requiredFloat32({
    required int id,
    required String name,
    double? defaultValue,
    double? min,
    double? max,
    Field<double> Function(T t)? field,
    double Function(T t)? getter,
    void Function(T t, double value)? setter,
  }) {
    var kind = const Float32Kind();
    if (min != null || max != null) {
      kind = Float32Kind(
        min: min,
        max: max,
      );
    }
    final prop = Prop<T, double>(
      id: id,
      name: name,
      kind: kind,
      defaultValue: defaultValue,
      field: field,
      getter: getter,
      setter: setter,
    );
    addProp(prop);
    return prop;
  }

  /// Constructs a [Prop] for 64-bit `double` by using [Float64Kind].
  ///
  /// ## Example
  /// ```
  /// declare.requiredFloat64(
  ///   id: 1,
  ///   name: 'x',
  /// );
  /// ```
  Prop<T, double> requiredFloat64({
    required int id,
    required String name,
    double? defaultValue,
    double? min,
    double? max,
    Field<double> Function(T t)? field,
    double Function(T t)? getter,
    void Function(T t, double value)? setter,
  }) {
    var kind = const Float64Kind();
    if (min != null || max != null) {
      kind = Float64Kind(
        min: min,
        max: max,
      );
    }
    final prop = Prop<T, double>(
      id: id,
      name: name,
      kind: kind,
      defaultValue: defaultValue,
      field: field,
      getter: getter,
      setter: setter,
    );
    addProp(prop);
    return prop;
  }

  /// Constructs a [Prop] for `GeoPoint` by using [GeoPointKind].
  ///
  /// ## Example
  /// ```
  /// declare.requiredGeoPoint(
  ///   id: 1,
  ///   name: 'x',
  /// );
  /// ```
  Prop<T, GeoPoint> requiredGeoPoint({
    required int id,
    required String name,
    Field<GeoPoint> Function(T t)? field,
    GeoPoint Function(T t)? getter,
    void Function(T t, GeoPoint value)? setter,
  }) {
    const kind = GeoPointKind();
    final prop = Prop<T, GeoPoint>(
      id: id,
      name: name,
      kind: kind,
      field: field,
      getter: getter,
      setter: setter,
    );
    addProp(prop);
    return prop;
  }

  /// Constructs a [Prop] for 32-bit signed `int` by using [Int32Kind].
  ///
  /// ## Example
  /// ```
  /// declare.requiredInt32(
  ///   id: 1,
  ///   name: 'x',
  ///   min: 1,
  /// );
  /// ```
  Prop<T, int> requiredInt32({
    required int id,
    required String name,
    int? defaultValue,
    int? min,
    int? max,
    Field<int> Function(T t)? field,
    int Function(T t)? getter,
    void Function(T t, int value)? setter,
  }) {
    var kind = const Int32Kind();
    if (min != null || max != null) {
      kind = Int32Kind(
        min: min,
        max: max,
      );
    }
    final prop = Prop<T, int>(
      id: id,
      name: name,
      kind: kind,
      defaultValue: defaultValue,
      field: field,
      getter: getter,
      setter: setter,
    );
    addProp(prop);
    return prop;
  }

  /// Constructs a [Prop] for 64-bit signed `int` by using [Int64Kind].
  ///
  /// ## Example
  /// ```
  /// declare.requiredInt64(
  ///   id: 1,
  ///   name: 'x',
  ///   min: 1,
  /// );
  /// ```
  Prop<T, int> requiredInt64({
    required int id,
    required String name,
    int? min,
    int? max,
    Field<int> Function(T t)? field,
    int Function(T t)? getter,
    void Function(T t, int value)? setter,
  }) {
    var kind = const Int64Kind();
    if (min != null || max != null) {
      kind = Int64Kind(
        min: min,
        max: max,
      );
    }
    final prop = Prop<T, int>(
      id: id,
      name: name,
      kind: kind,
      field: field,
      getter: getter,
      setter: setter,
    );
    addProp(prop);
    return prop;
  }

  /// Constructs a [Prop] for 64-bit signed `Int64` by using [Int64FixNumKind].
  ///
  /// ## Example
  /// ```
  /// declare.requiredInt64FixNum(
  ///   id: 1,
  ///   name: 'x',
  ///   min: Int64(1),
  /// );
  /// ```
  Prop<T, Int64> requiredInt64FixNum({
    required int id,
    required String name,
    Int64? defaultValue,
    Int64? min,
    Int64? max,
    bool unsigned = false,
    bool fixedLength = false,
    Field<Int64> Function(T t)? field,
    Int64 Function(T t)? getter,
    void Function(T t, Int64 value)? setter,
  }) {
    var kind = const Int64FixNumKind();
    if (min != null ||
        max != null ||
        unsigned != false ||
        fixedLength != false) {
      kind = Int64FixNumKind(
        min: min,
        max: max,
        unsigned: unsigned,
        fixed: fixedLength,
      );
    }
    final prop = Prop<T, Int64>(
      id: id,
      name: name,
      kind: kind,
      defaultValue: defaultValue,
      field: field,
      getter: getter,
      setter: setter,
    );
    addProp(prop);
    return prop;
  }

  /// Constructs a [Prop] for `List<T>` by using [ListKind].
  ///
  /// ## Example
  /// ```
  /// declare.requiredList<String>(
  ///   id: 1,
  ///   name: 'x',
  ///   itemsKind: const StringKind(),
  ///   minLength: 2,
  ///   maxLength: 3,
  /// );
  /// ```
  Prop<T, List<V>> requiredList<V>({
    required int id,
    required String name,
    required Kind<V> itemsKind,
    int minLength = 0,
    int? maxLength,
    EntityRelation? relation,
    List<PropMeaning> meanings = const [],
    String? description,
    ListField<V> Function(T t)? field,
    List<V> Function(T t)? getter,
    void Function(T t, List<V> value)? setter,
  }) {
    final kind = ListKind<V>(
      itemsKind,
      minLength: minLength,
      maxLength: maxLength,
    );
    final prop = Prop<T, List<V>>(
      id: id,
      name: name,
      kind: kind,
      relation: relation,
      meanings: meanings,
      description: description,
      field: field,
      getter: getter,
      setter: setter,
    );
    addProp(prop);
    return prop;
  }

  /// Constructs a [Prop] for `Map<K,V>` by using [MapKind].
  ///
  /// ## Example
  /// ```
  /// declare.requiredMap<String,String>(
  ///   id: 1,
  ///   name: 'x',
  ///   keyKind: const StringKind(),
  ///   valueKind: const StringKind(),
  /// );
  /// ```
  Prop<T, Map<K, V>> requiredMap<K, V>({
    required int id,
    required String name,
    required Kind<K> keyKind,
    required Kind<V> valueKind,
    Field<Map<K, V>> Function(T t)? field,
    Map<K, V> Function(T t)? getter,
    void Function(T t, Map<K, V> value)? setter,
  }) {
    final kind = MapKind<K, V>(
      keyKind,
      valueKind,
    );
    final prop = Prop<T, Map<K, V>>(
      id: id,
      name: name,
      kind: kind,
      field: field,
      getter: getter,
      setter: setter,
    );
    addProp(prop);
    return prop;
  }

  /// Constructs a [Prop] for `Set<T>` by using [SetKind].
  ///
  /// ## Example
  /// ```
  /// declare.requiredSet<String>(
  ///   id: 1,
  ///   name: 'x',
  ///   itemsKind: const StringKind(),
  ///   minLength: 2,
  ///   maxLength: 3,
  /// );
  /// ```
  Prop<T, Set<V>> requiredSet<V>({
    required int id,
    required String name,
    required Kind<V> itemsKind,
    int minLength = 0,
    int? maxLength,
    EntityRelation? relation,
    List<PropMeaning> meanings = const [],
    String? description,
    SetField<V> Function(T t)? field,
    Set<V> Function(T t)? getter,
    void Function(T t, Set<V> value)? setter,
  }) {
    final kind = SetKind<V>(
      itemsKind,
      minLength: minLength,
      maxLength: maxLength,
    );
    final prop = Prop<T, Set<V>>(
      id: id,
      name: name,
      kind: kind,
      relation: relation,
      meanings: meanings,
      description: description,
      field: field,
      getter: getter,
      setter: setter,
    );
    addProp(prop);
    return prop;
  }

  /// Constructs a [Prop] for `String` by using [StringKind].
  ///
  /// ## Example
  /// ```
  /// declare.requiredString(
  ///   id: 1,
  ///   name: 'x',
  ///   minLengthInUtf8: 2,
  ///   maxLengthInUtf8: 3,
  ///   pattern: 'some pattern',
  ///   examples: const ['a valid value'],
  /// );
  /// ```
  Prop<T, String> requiredString({
    required int id,
    required String name,
    String? defaultValue,
    int minLengthInUtf8 = 0,
    int? maxLengthInUtf8,
    bool singleLine = false,
    RegExp Function()? regExpProvider,
    List<String> examples = const [],
    List<PropMeaning> meanings = const [],
    String? description,
    Field<String> Function(T t)? field,
    String Function(T t)? getter,
    void Function(T t, String value)? setter,
  }) {
    var kind = const StringKind();
    if (minLengthInUtf8 != 0 ||
        maxLengthInUtf8 != null ||
        singleLine ||
        regExpProvider != null ||
        examples.isNotEmpty) {
      kind = StringKind(
        minLengthInUtf8: minLengthInUtf8,
        maxLengthInUtf8: maxLengthInUtf8,
        singleLine: singleLine,
        regExpProvider: regExpProvider,
        examples: examples,
      );
    }
    final prop = Prop<T, String>(
      id: id,
      name: name,
      kind: kind,
      defaultValue: defaultValue,
      meanings: meanings,
      description: description,
      field: field,
      getter: getter,
      setter: setter,
    );
    addProp(prop);
    return prop;
  }

  /// Constructs a [Prop] for 32-bit unsigned `int` by using [Uint32Kind].
  ///
  /// ## Example
  /// ```
  /// declare.requiredUint32(
  ///   id: 1,
  ///   name: 'x',
  /// );
  /// ```
  Prop<T, int> requiredUint32({
    required int id,
    required String name,
    int? defaultValue,
    int? min,
    int? max,
    Field<int> Function(T t)? field,
    int Function(T t)? getter,
    void Function(T t, int value)? setter,
  }) {
    var kind = const Uint32Kind();
    if (min != null || max != null) {
      kind = Uint32Kind(
        min: min,
        max: max,
      );
    }
    final prop = Prop<T, int>(
      id: id,
      name: name,
      kind: kind,
      defaultValue: defaultValue,
      field: field,
      getter: getter,
      setter: setter,
    );
    addProp(prop);
    return prop;
  }

  /// Constructs a [Prop] for 64-bit unsigned `int` by using [Uint64Kind].
  ///
  /// ## Example
  /// ```
  /// declare.requiredUint64(
  ///   id: 1,
  ///   name: 'x',
  /// );
  /// ```
  Prop<T, int> requiredUint64({
    required int id,
    required String name,
    int? defaultValue,
    int? min,
    int? max,
    Field<int> Function(T t)? field,
    int Function(T t)? getter,
    void Function(T t, int value)? setter,
  }) {
    var kind = const Uint64Kind();
    if (min != null || max != null) {
      kind = Uint64Kind(
        min: min,
        max: max,
      );
    }
    final prop = Prop<T, int>(
      id: id,
      name: name,
      kind: kind,
      defaultValue: defaultValue,
      field: field,
      getter: getter,
      setter: setter,
    );
    addProp(prop);
    return prop;
  }
}
