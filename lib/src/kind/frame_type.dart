library math.calculator;

import 'dart:typed_data';

/// Type of frame.
abstract class FrameType<T> {
  static const FrameType<bool> forBool = _BoolFrameType();
  static const FrameType<int> forInt = _IntFrameType();
  static const FrameType<int> forInt32 = _Int32FrameType();
  static const FrameType<double> forFloat64 = _Float64FrameType();
  static const FrameType<DateTime> forDateTime = _DateTimeFrameType();
  static const FrameType<String> forString = _StringFrameType();

  const factory FrameType({
    required T zero,
    double Function(T a, T b)? distanceMetric,
  }) = _FrameType<T>;

  const FrameType.constructor();

  /// Returns zero value.
  T get zero;

  /// Calculates distance between two objects.
  double distance(T a, T b);

  /// Tells whether the argument is a valid instance of `T`.
  bool isValid(Object value) => value is T;

  /// Returns a fixed-length list filled with [zero].
  List<T> newList(int length, {bool growable = false}) {
    return List<T>.filled(length, zero, growable: growable);
  }

  /// Returns a fixed-length list filled with items in the [Iterable].
  List<T> newListFrom(Iterable<T> iterable, {bool growable = false}) {
    return List<T>.from(iterable, growable: growable);
  }
}

/// Superclass for objects that can provide their own [FrameType].
abstract class FrameTypeful {
  const FrameTypeful();

  /// Returns [FrameType] of this object.
  FrameType getFrameType();
}

class _BoolFrameType extends FrameType<bool> {
  const _BoolFrameType() : super.constructor();

  @override
  bool get zero => false;

  @override
  double distance(bool a, bool b) => a == b ? 0 : 1;
}

class _DateTimeFrameType extends FrameType<DateTime> {
  static final _zero = DateTime.fromMicrosecondsSinceEpoch(0);

  const _DateTimeFrameType() : super.constructor();

  @override
  DateTime get zero => _zero;

  @override
  double distance(DateTime a, DateTime b) =>
      (a.microsecondsSinceEpoch - b.microsecondsSinceEpoch).abs().toDouble();
}

class _Float64FrameType extends FrameType<double> {
  const _Float64FrameType() : super.constructor();

  @override
  double get zero => 0.0;

  @override
  double distance(double a, double b) => (a - b).abs().toDouble();

  @override
  List<double> newList(int length, {bool growable = false}) {
    if (growable == false) {
      return Float64List(length);
    }
    return super.newList(length, growable: growable);
  }
}

class _FrameType<T> extends FrameType<T> {
  @override
  final T zero;
  final double Function(T a, T b)? distanceMetric;

  const _FrameType({required this.zero, this.distanceMetric})
      : super.constructor();

  @override
  double distance(T a, T b) {
    return distanceMetric!(a, b);
  }
}

class _Int32FrameType extends _IntBaseFrameType {
  const _Int32FrameType();

  @override
  List<int> newList(int length, {bool growable = false}) {
    if (growable == false) {
      return Int32List(length);
    }
    return super.newList(length, growable: growable);
  }
}

abstract class _IntBaseFrameType extends FrameType<int> {
  const _IntBaseFrameType() : super.constructor();

  @override
  int get zero => 0;

  @override
  double distance(int a, int b) => (a - b).abs().toDouble();
}

class _IntFrameType extends _IntBaseFrameType {
  const _IntFrameType();
}

class _StringFrameType extends FrameType<String> {
  const _StringFrameType() : super.constructor();

  @override
  String get zero => '';

  @override
  double distance(String a, String b) {
    // TODO: better default distance metric for strings
    if (a.length > b.length) {
      return distance(b, a);
    }
    var d = b.length - a.length;
    for (var i = 0; i < a.length; i++) {
      if (a.codeUnitAt(i) != b.codeUnitAt(i)) {
        d++;
      }
    }
    return d.toDouble();
  }
}
