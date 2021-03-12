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

import 'dart:convert' show utf8;
import 'dart:typed_data' show Uint8List;

import 'package:fixnum/fixnum.dart' show Int64;
import 'package:kind/kind.dart';

/// A helper class for building debug strings.
///
/// Used by `toString()` of [Entity] and [EntityMixin].
class EntityDebugStringBuilder {
  final StringBuffer _sb = StringBuffer();

  @override
  String toString() => _sb.toString();

  /// Writes string.
  void write(String value) {
    _sb.write(value);
  }

  /// Writes debug representation for any object that has [EntityKind].
  void writeDartEntity(Object object, {required EntityKind kind}) {
    _sb.write(kind.name);
    _sb.write('(');
    final nonMutableProps = kind.props.where((element) => !element.isMutable);
    final mutableProps = kind.props.where((element) => element.isMutable);
    var wroteArguments = false;
    for (var prop in nonMutableProps) {
      final propValue = prop.get(object);
      if (prop.kind.instanceIsDefaultValue(propValue)) {
        continue;
      }
      try {
        wroteArguments = true;
        _sb.write('\n  ');
        _sb.write(prop.name);
        _sb.write(': ');
        writeDartObject(propValue);
        _sb.write(',');
      } catch (error, stackTrace) {
        throw TraceableError(
          message:
              'Error when writing kind `${kind.name}` property `${prop.name}`.',
          error: error,
          stackTrace: stackTrace,
        );
      }
    }
    if (wroteArguments) {
      _sb.write('\n');
    }
    _sb.write(')');
    for (var prop in mutableProps) {
      try {
        final propValue = prop.get(object);
        if (prop.kind.instanceIsDefaultValue(propValue)) {
          continue;
        }
        _sb.write('\n..');
        _sb.write(prop.name);
        _sb.write(' = ');
        writeDartObject(propValue);
      } catch (error, stackTrace) {
        throw TraceableError(
          message:
              'Error when writing kind `${kind.name}` property `${prop.name}`.',
          error: error,
          stackTrace: stackTrace,
        );
      }
    }
    if (mutableProps.isNotEmpty) {
      _sb.write('\n');
    }
  }

  /// Writes debug representation for any [List].
  void writeDartList(List object) {
    if (object.isEmpty) {
      // We can always write an empty list
      _sb.write('[]');
    } else if (object.length <= 3) {
      // A list of strings
      _sb.write('[');
      var comma = false;
      for (var item in object) {
        if (comma) {
          _sb.write(', ');
        } else {
          comma = true;
        }
        if (item == null || item is bool || item is num) {
          _sb.write(item);
        } else if (item is String && item.length < 16) {
          writeDartObject(item);
        } else {
          _sb.write('<< ');
          _sb.write(item.runtimeType);
          _sb.write(' >>');
        }
      }
      _sb.write(']');
    } else {
      _sb.write('<< ');
      _sb.write(object.runtimeType);
      _sb.write(' with ');
      _sb.write(object.length);
      _sb.write(' items >>');
    }
  }

  /// Writes debug representation for any [Map].
  void writeDartMap(Map object) {
    _sb.write('<< ');
    _sb.write(object.runtimeType);
    _sb.write(' with ');
    _sb.write(object.length);
    _sb.write(' items >>');
  }

  /// Writes debug representation for any Dart object.
  void writeDartObject(Object? object) {
    if (object == null || object is bool || object is num || object is Int64) {
      _sb.write(object);
    } else if (object is Decimal) {
      _sb.write('Decimal("');
      _sb.write(object.toString());
      _sb.write('")');
    } else if (object is String) {
      writeDartString(object);
    } else if (object is DateTime) {
      _sb.write('DateTime.parse("');
      _sb.write(object.toIso8601String());
      _sb.write('")');
    } else if (object is DateTimeWithTimeZone) {
      _sb.write('DateTimeWithTimeZone.parse("');
      _sb.write(object.toIso8601String());
      _sb.write('")');
    } else if (object is Currency) {
      final code = object.code;
      final isPredefined = Currency.byCode.containsKey(code);
      if (isPredefined) {
        _sb.write('Currency.');
        writeDartString(code.toLowerCase());
      } else {
        _sb.write('Currency.specify(code: ');
        writeDartString(code);
        _sb.write(')');
      }
    } else if (object is CurrencyAmount) {
      _sb.write('CurrencyAmount"');
      _sb.write('(');
      _sb.write(object.amount);
      _sb.write('", ');
      writeDartObject(object.currency);
      _sb.write(')');
    } else if (object is Date) {
      _sb.write('Date(');
      _sb.write(object.year);
      _sb.write(',');
      _sb.write(object.month);
      _sb.write(',');
      _sb.write(object.day);
      _sb.write(')');
    } else if (object is Uuid) {
      _sb.write('Uuid("');
      _sb.write(object.canonicalString);
      _sb.write('")');
    } else if (object is Uint8List) {
      _sb.write('<< ');
      _sb.write(object.runtimeType);
      _sb.write(' with ');
      _sb.write(object.length);
      _sb.write(' bytes >>');
    } else if (object is List) {
      writeDartList(object);
    } else if (object is Set) {
      writeDartSet(object);
    } else if (object is Map) {
      writeDartMap(object);
    } else {
      _sb.write('<< ');
      _sb.write(object.runtimeType);
      _sb.write(' >>');
    }
  }

  /// Writes debug representation for any [Set].
  void writeDartSet(Set object) {
    if (object.isEmpty) {
      // We can always write an empty list
      _sb.write('{}');
    } else if (object.length <= 3) {
      // A list of strings
      _sb.write('{');
      var comma = false;
      for (var item in object) {
        if (comma) {
          _sb.write(', ');
        } else {
          comma = true;
        }
        if (item == null || item is bool || item is num) {
          _sb.write(item);
        } else if (item is String && item.length < 16) {
          writeDartObject(item);
        } else {
          _sb.write('<< ');
          _sb.write(item.runtimeType);
          _sb.write(' >>');
        }
      }
      _sb.write('}');
    } else {
      _sb.write('<< ');
      _sb.write(object.runtimeType);
      _sb.write(' with ');
      _sb.write(object.length);
      _sb.write(' items >>');
    }
  }

  /// Estimates length of the values when written.
  int estimateLengthOfValues(Iterable<Object?> iterable) {
    final b = EntityDebugStringBuilder();
    for (var item in iterable) {
      b.writeDartObject(item);
    }
    return b._sb.length;
  }

  /// Writes a constructor call, followed by optional assignments.
  void writeDartConstructorCall({
    required String name,
    List arguments = const [],
    Iterable<MapEntry<String, Object?>> namedArguments = const [],
    Iterable<MapEntry<String, Object?>> assignments = const [],
  }) {
    _sb.write(name);
    if (arguments.isEmpty && namedArguments.isEmpty) {
      _sb.write('()');
    } else {
      final argumentsLengthEstimate =
          estimateLengthOfValues(arguments.followedBy(namedArguments));
      var singleLine = argumentsLengthEstimate < 40;
      _sb.write('(');
      var noComma = true;
      for (var argument in arguments) {
        if (singleLine) {
          if (noComma) {
            noComma = false;
          } else {
            _sb.write(', ');
          }
        } else {
          if (noComma) {
            noComma = false;
            _sb.write('\n');
          } else {
            _sb.write(',\n');
          }
          _sb.write('  ');
        }
        writeDartObject(argument);
      }
      for (var argument in namedArguments) {
        if (singleLine) {
          if (noComma) {
            noComma = false;
          } else {
            _sb.write(', ');
          }
        } else {
          if (noComma) {
            noComma = false;
            _sb.write('\n');
          } else {
            _sb.write(',\n');
          }
          _sb.write('  ');
        }
        _sb.write(argument.key);
        _sb.write(': ');
        writeDartObject(argument.value);
      }
      if (!singleLine) {
        _sb.write(',\n');
      }
      _sb.write(')');
    }
    if (assignments.isNotEmpty) {
      for (var entry in assignments.toList()..sort()) {
        _sb.write('\n..');
        _sb.write(entry.key);
        _sb.write(' = ');
        _sb.write(entry.value);
      }
      _sb.write('\n');
    }
  }

  /// Writes debug representation for any [String].
  void writeDartString(String object) {
    if (object.length < 40) {
      _sb.write('"');
      _sb.write(_escapeString(object));
      _sb.write('"');
    } else {
      _sb.write('"');
      _sb.write(_escapeString(object.substring(0, 10)));
      _sb.write('" ... "');
      _sb.write(_escapeString(object.substring(object.length - 10)));
      _sb.write('" (total ');
      _sb.write(utf8.encode(object).length);
      _sb.write(' bytes in UTF-8)');
    }
  }

  static String _escapeString(String s) {
    return s
        .replaceAll(r'\', r'\\')
        .replaceAll('\n', r'\n')
        .replaceAll('\t', r'\t');
  }
}
