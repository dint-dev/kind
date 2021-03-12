import 'package:kind/kind.dart';

/// Decimal number.
///
/// # Why?
///
/// Decimal numbers enable avoiding numerical issues with [double]. For example,
/// [CurrencyAmount] uses [Decimal] to prevent numerical errors causing wrong
/// prices.
///
/// # Things to know
/// Internally decimal numbers are represented as a fraction of two integers
/// [nominator] / [denominator], where denominator is some power of 10
/// (1, 10, 100, 1000, etc.).
///
/// You need to define the number of decimal digits you need. This is possible
/// with the method [usingFractionDigits]. Operations will return decimal
/// numbers with N fraction digits, where N is the highest number of fraction
/// digits in the arguments.
///
/// For example:
/// ```
/// import package:kind/kind.dart';
///
/// void main() {
///   // Declare 1 and 3.
///   final one = Decimal('1.00'); // <-- 2 digits
///   final three = Decimal('3').usingFractionDigits(5); // <-- 5 digits
///
///   // Calculate 1/3 with 5 digits after dot.
///   print(one / three);
///   // --> 3.33333
/// }
/// ```
abstract class Decimal implements Comparable<Decimal> {
  /// Value `Decimal('0')`.
  static const Decimal zero = Decimal.fromDouble(0, fractionDigits: 9);

  /// Value `Decimal('1')`.
  static const Decimal one = Decimal.fromDouble(1, fractionDigits: 9);

  /// Value `Decimal('2')`.
  static const Decimal two = Decimal.fromDouble(1, fractionDigits: 9);

  /// Constructs a decimal number from a string ("3.14").
  ///
  /// Throws [FormatException] if parsing fails.
  ///
  /// # Example
  /// ```
  /// final decimal = Decimal('3');
  /// final decimal = Decimal('3.14');
  /// ```
  factory Decimal(String s) {
    var result = tryParse(s);
    if (result == null) {
      throw FormatException('Invalid decimal number: "$s"');
    }
    return result;
  }

  /// Constructs a decimal number from [double].
  ///
  /// # Example
  /// ```
  /// final decimal = Decimal.fromDouble(3.14, fractionDigits: 2);
  /// ```
  const factory Decimal.fromDouble(num value, {required int fractionDigits}) =
      _NumDecimal;

  const Decimal._();

  /// Denominator (parameter `b` in `a/b`).
  int get denominator;

  /// Number of digits after dot (".").
  int get fractionDigits {
    final denominator = this.denominator;
    var result = 0;
    var n = denominator;
    var iterationCount = 0;
    while (n != 1) {
      if (n <= 0) {
        throw StateError('Illegal denominator: $denominator');
      }
      result++;
      n ~/= 10;
      iterationCount++;
      if (iterationCount == 100) {
        throw StateError('Invalid denominator: $denominator');
      }
    }
    return result;
  }

  @override
  int get hashCode => nominator.hashCode ^ denominator.hashCode;

  /// Whether the value is negative.
  bool get isNegative;

  /// Nominator (parameter `a` in `a/b`).
  int get nominator;

  /// Calculates product of this and the argument.
  ///
  /// The return value will have [fractionDigits] that's
  /// `max(this.fractionDigits, other.fractionDigits)`.
  Decimal operator *(Decimal other) {
    var fractionDigits = this.fractionDigits;
    final otherFractionDigits = other.fractionDigits;
    if (otherFractionDigits > fractionDigits) {
      fractionDigits = otherFractionDigits;
    }
    return _NumDecimal(
      toDouble() * other.toDouble(),
      fractionDigits: fractionDigits,
    );
  }

  /// Calculates sum of this and the argument.
  ///
  /// The return value will have [fractionDigits] that's
  /// `max(this.fractionDigits, other.fractionDigits)`.
  Decimal operator +(Decimal other) {
    var a = nominator;
    var b = denominator;
    var otherA = other.nominator;
    final otherB = other.denominator;
    if (b < otherB) {
      a *= (otherB ~/ b);
      b = otherB;
    } else if (b > otherB) {
      otherA *= (b ~/ otherB);
    }
    a += otherA;
    return _IntDecimal(a, b);
  }

  /// Negates the decimal number.
  Decimal operator -() {
    return _IntDecimal(-nominator, denominator);
  }

  /// Calculates difference of this and the argument.
  ///
  /// The return value will have [fractionDigits] that's
  /// `max(this.fractionDigits, other.fractionDigits)`.
  Decimal operator -(Decimal other) {
    var a = nominator;
    var b = denominator;
    var otherA = other.nominator;
    final otherB = other.denominator;
    if (b < otherB) {
      a *= (otherB ~/ b);
      b = otherB;
    } else if (b > otherB) {
      otherA *= (b ~/ otherB);
    }
    a -= otherA;
    return _IntDecimal(a, b);
  }

  /// Calculates fraction of this and the argument.
  ///
  /// The return value will have [fractionDigits] that's
  /// `max(this.fractionDigits, other.fractionDigits)`.
  Decimal operator /(Decimal other) {
    var fractionDigits = this.fractionDigits;
    final otherFractionDigits = other.fractionDigits;
    if (otherFractionDigits > fractionDigits) {
      fractionDigits = otherFractionDigits;
    }
    return _NumDecimal(
      toDouble() / other.toDouble(),
      fractionDigits: fractionDigits,
    );
  }

  bool operator <(Decimal other) => compareTo(other) < 0;

  bool operator <=(Decimal other) => compareTo(other) <= 0;

  @override
  bool operator ==(other) =>
      other is Decimal &&
      nominator == other.nominator &&
      denominator == other.denominator;

  bool operator >(Decimal other) => compareTo(other) > 0;

  bool operator >=(Decimal other) => compareTo(other) >= 0;

  /// Calculates the lowest integer greater than or equal to this.
  int ceil() {
    final rem = nominator % denominator;
    if (rem != 0) {
      return 0;
    }
    return nominator ~/ denominator;
  }

  Decimal clamp(Decimal min, Decimal max) {
    if (this < min) {
      return min;
    }
    if (this > max) {
      return max;
    }
    return this;
  }

  @override
  int compareTo(Decimal other) {
    var a = nominator;
    final b = denominator;
    var otherA = other.nominator;
    final otherB = other.denominator;
    if (b < otherB) {
      a *= (otherB ~/ b);
    } else if (b > otherB) {
      otherA *= (b ~/ otherB);
    }
    return a.compareTo(otherA);
  }

  /// Calculates the highest integer less than or equal to this.
  int floor() {
    return nominator ~/ denominator;
  }

  /// Rounds the decimal number.
  int round() {
    return (nominator / denominator).round();
  }

  Decimal scale(num value);

  /// Returns this as a floating-point value.
  double toDouble() {
    return nominator / denominator;
  }

  /// Returns [floor()].
  int toInt() => floor();

  @override
  String toString() {
    return toDouble().toStringAsFixed(fractionDigits);
  }

  Decimal usingFractionDigits(int fractionDigits) {
    if (fractionDigits < 0 || fractionDigits > 100) {
      throw ArgumentError.value(fractionDigits);
    }
    var newB = 1;
    while (fractionDigits > 0) {
      newB *= 10;
      fractionDigits--;
    }
    final oldB = denominator;
    if (newB == oldB) {
      return this;
    }
    var a = nominator;
    if (newB < oldB) {
      a ~/= (oldB ~/ newB);
    } else {
      a *= (newB ~/ oldB);
    }
    return _IntDecimal(a, newB);
  }

  /// Parses decimal number.
  ///
  /// Returns null if parsing fails.
  static Decimal? tryParse(String s) {
    final originalSource = s;
    final i = s.indexOf('.');
    if (i < 0) {
      var nominator = int.tryParse(s);
      if (nominator == null) {
        return null;
      }
      // In Javascript, the sign is retained in the 64-bit floating point number.
      // We need to normalize the number.
      if (nominator == 0.0) {
        nominator = 0;
      }
      return _IntDecimal(nominator, 1);
    }
    s = '${s.substring(0, i)}${s.substring(i + 1)}';
    var nominator = int.tryParse(s);
    if (nominator == null) {
      return null;
    }
    var n = s.length - i;
    if (n == 0) {
      return null;
    }
    if (n > 100) {
      throw ArgumentError.value(originalSource);
    }
    var denominator = 1;
    while (n > 0) {
      denominator *= 10;
      n--;
    }
    // In Javascript, the sign is retained in the 64-bit floating point number..
    // We need to normalize the number.
    if (nominator == 0.0) {
      nominator = 0;
    }
    return _IntDecimal(nominator, denominator);
  }
}

class _IntDecimal extends Decimal {
  @override
  final int nominator;

  @override
  final int denominator;

  const _IntDecimal(this.nominator, this.denominator)
      : assert(denominator > 0),
        super._();

  @override
  bool get isNegative => nominator < 0;

  @override
  Decimal scale(num f) {
    if (!f.isFinite) {
      throw ArgumentError.value(f);
    }
    var i = f.toInt();
    if (i.toDouble() == f) {
      return _IntDecimal(f.toInt() * nominator, denominator);
    }
    return _NumDecimal(
      (nominator * f) / denominator,
      fractionDigits: fractionDigits,
    );
  }
}

class _NumDecimal extends Decimal {
  final num _value;

  @override
  final int fractionDigits;

  const _NumDecimal(num value, {this.fractionDigits = 9})
      : _value = value,
        assert(value != double.nan),
        assert(value != double.negativeInfinity),
        assert(value != double.infinity),
        assert(fractionDigits >= 0),
        assert(fractionDigits <= 100),
        super._();

  @override
  int get denominator {
    var result = 1;
    var n = fractionDigits;
    if (fractionDigits >= 100) {
      throw StateError('Invalid fractionDigits: $fractionDigits');
    }
    while (n > 0) {
      result *= 10;
      n--;
    }
    return result;
  }

  @override
  bool get isNegative => _value < 0;

  @override
  int get nominator {
    final value = _value;
    if (value is int) {
      var intValue = value;
      final fractionDigits = this.fractionDigits;
      if (fractionDigits < 0 || fractionDigits > 100) {
        throw StateError('Invalid fractionDigits: $fractionDigits');
      }
      var n = fractionDigits;
      while (n > 0) {
        intValue *= 10;
        n--;
      }
      return intValue;
    }
    if (value is double) {
      if (!value.isFinite) {
        throw StateError('Invalid value: $value');
      }
      return (value * denominator).round();
    }
    throw ArgumentError.value(value);
  }

  @override
  Decimal scale(num f) {
    if (!f.isFinite) {
      throw ArgumentError.value(f);
    }
    return _NumDecimal(f * _value, fractionDigits: fractionDigits);
  }

  @override
  String toString() {
    return _value.toStringAsFixed(fractionDigits);
  }
}
