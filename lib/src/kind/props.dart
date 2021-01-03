import 'package:kind/kind.dart';
import 'package:kind/nodes.dart';

/// [Prop] for [bool] fields.
class BoolProp<T> extends Prop<T, bool> {
  BoolProp(
    Kind<T> kind,
    String name, {
    bool Function(T target)? getter,
    void Function(T target, bool value)? setter,
  }) : super(
          kind,
          name,
          defaultValue: false,
          getter: getter,
          setter: setter,
        );
}

/// [Prop] for [DateTime] fields.
class DateTimeProp<T> extends Prop<T, DateTime> {
  DateTimeProp(
    Kind<T> kind,
    String name, {
    DateTime Function(T target)? getter,
    void Function(T target, DateTime value)? setter,
  }) : super(
          kind,
          name,
          defaultValue: DateTime.fromMicrosecondsSinceEpoch(0),
          getter: getter,
          setter: setter,
        );
}

/// [Prop] for [double] fields.
class DoubleProp<T> extends Prop<T, double> {
  DoubleProp(
    Kind<T> kind,
    String name, {
    double Function(T target)? getter,
    void Function(T target, double value)? setter,
  }) : super(
          kind,
          name,
          defaultValue: 0.0,
          getter: getter,
          setter: setter,
        );
}

/// [Prop] for [int] fields.
class IntProp<T> extends Prop<T, int> {
  IntProp(
    Kind<T> kind,
    String name, {
    int Function(T target)? getter,
    void Function(T target, int value)? setter,
  }) : super(
          kind,
          name,
          defaultValue: 0,
          getter: getter,
          setter: setter,
        );
}

class ListProp<T, V> extends Prop<T, List<V>> {
  final int $minLength;
  final int? $maxLength;

  ListProp(
    Kind<T> kind,
    String name, {
    List<V> Function(T target)? getter,
    void Function(T target, List<V> value)? setter,
    int minLength = 0,
    int? maxLength,
  })  : $minLength = minLength,
        $maxLength = maxLength,
        super(
          kind,
          name,
          defaultValue: const [],
          getter: getter,
          setter: setter,
        );
}

/// [Prop] for nullable fields.
class NullableProp<T, V> extends Prop<T, V?> {
  final Prop<T, V> $prop;

  NullableProp(
    Prop<T, V> prop, {
    V Function(T target)? getter,
    void Function(T target, V? value)? setter,
  })  : $prop = prop,
        super(
          prop.$kind,
          prop.$name,
          defaultValue: null,
          getter: getter,
          setter: setter,
        );
}

abstract class Prop<T, V> extends Expression<V> {
  final Kind<T> $kind;
  final String $name;
  final V Function(T target)? $getter;
  final void Function(T target, V value)? $setter;
  final V $defaultValue;

  Prop(
    Kind<T> kind,
    String name, {
    required V defaultValue,
    V Function(T target)? getter,
    void Function(T target, V value)? setter,
  })  : $kind = kind,
        $name = name,
        $defaultValue = defaultValue,
        $getter = getter,
        $setter = setter {
    kind.$props.add(this);
  }

  @override
  V $evaluateWithItem(Object item) {
    final getter = $getter;
    if (getter != null) {
      if (item is T) {
        return getter(item as T);
      }
    }
    throw ArgumentError.value(item);
  }

  V? $get(Object? value) {
    final getter = $getter;
    if (getter == null) {
      return $defaultValue;
    }
    return getter(value as T);
  }

  Expression<bool> operator <(Expression right) {
    return ComparisonOpExpression(this, ComparisonOp.lt, right);
  }

  Expression<bool> operator <<(Expression right) {
    return ComparisonOpExpression(this, ComparisonOp.eq, right);
  }

  Expression<bool> operator <=(Expression right) {
    return ComparisonOpExpression(this, ComparisonOp.le, right);
  }

  Expression<bool> operator >(Expression right) {
    return ComparisonOpExpression(this, ComparisonOp.gt, right);
  }

  Expression<bool> operator >=(Expression right) {
    return ComparisonOpExpression(this, ComparisonOp.ge, right);
  }

  Expression<bool> equals(Expression right) {
    return ComparisonOpExpression(this, ComparisonOp.eq, right);
  }

  V get(Data data) {
    if (data.containsKey($name)) {
      return data.get($name) as V;
    }
    return $defaultValue;
  }

  Expression<bool> inRange(V min, V max) {
    return AndExpression(this >= Literal<V>(min), this <= Literal<V>(max));
  }

  Expression<bool> notEquals(Expression right) {
    return ComparisonOpExpression(this, ComparisonOp.ne, right);
  }
}

class PropInfo<T, V> {
  final Kind<T> kind;
  final String name;
  final V Function(T target)? getter;
  final void Function(T target, V value)? setter;

  PropInfo(this.kind, this.name, {this.getter, this.setter});
}

class SetProp<T, V> extends Prop<T, Set<V>> {
  final int $minLength;
  final int? $maxLength;

  SetProp(
    Kind<T> kind,
    String name, {
    Set<V> Function(T target)? getter,
    void Function(T target, Set<V> value)? setter,
    int minLength = 0,
    int? maxLength,
  })  : $minLength = minLength,
        $maxLength = maxLength,
        super(
          kind,
          name,
          defaultValue: const {},
          getter: getter,
          setter: setter,
        );
}

class StringProp<T> extends Prop<T, String> {
  final int $minLength;
  final int? $maxLength;

  StringProp(
    Kind<T> kind,
    String name, {
    String Function(T target)? getter,
    void Function(T target, String value)? setter,
    int minLength = 0,
    int? maxLength,
  })  : $minLength = minLength,
        $maxLength = maxLength,
        super(
          kind,
          name,
          defaultValue: '',
          getter: getter,
          setter: setter,
        );
}
