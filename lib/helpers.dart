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

library kind.helpers;

import 'package:fixnum/fixnum.dart';
import 'package:kind/kind.dart';

String debugStringForConstructorCall({
  required String name,
  required List arguments,
  List<DebugNamedArgument> assignments = const [],
}) {
  final sb = StringBuffer();
  sb.write(name);
  if (arguments.isEmpty) {
    sb.write('()');
  } else {
    final argumentDebugStrings =
        arguments.map((e) => debugStringForValue(e)).toList();
    final argumentsLengthEstimate = argumentDebugStrings.fold<int>(
      arguments.length * 4,
      (n, s) {
        return n + s.length;
      },
    );
    var singleLine = argumentsLengthEstimate < 40;
    sb.write('(');
    var isFirst = true;
    for (var argument in argumentDebugStrings) {
      if (singleLine) {
        if (isFirst) {
          isFirst = false;
        } else {
          sb.write(', ');
        }
      } else {
        sb.write('\n  ');
      }
      sb.write(debugStringForValue(argument));
    }
    if (!singleLine) {
      sb.write(',\n');
    }
    sb.write(')');
  }
  if (assignments.isNotEmpty) {
    for (var entry in assignments.toList()..sort()) {
      sb.write('\n..');
      sb.write(entry.name);
      sb.write(' = ');
      sb.write(entry.value);
    }
    sb.write('\n');
  }
  return sb.toString();
}

String debugStringForValue(Object? value, {int preferredMaxLength = 80}) {
  if (value == null || value is bool || value is num) {
    return value.toString();
  }
  if (value is DebugNamedArgument) {
    return '${value.name}: ${debugStringForValue(value.value)}';
  }
  if (value is Int64) {
    final s = value.toString();
    if (value.toString().length < 9) {
      return 'Int64(${value.toInt()})';
    }
    return 'Int64.parse("$s")';
  }
  if (value is String) {
    return _debugStringForString(
      value,
      preferredMaxLength: preferredMaxLength,
    );
  }
  if (value is Date) {
    return 'Date(${value.year}, ${value.month}, ${value.day})';
  }
  if (value is DateTime) {
    return 'DateTime.parse("${value.toIso8601String()}")';
  }
  if (value is DateTimeWithTimeZone) {
    return 'DateTimeWithTimeZone.parse("${value.toIso8601String()}")';
  }
  if (value is List) {
    return _debugStringForListOrSet(
      value,
      isList: true,
      preferredMaxLength: preferredMaxLength,
    );
  }
  if (value is Set) {
    return _debugStringForListOrSet(
      value,
      isList: false,
      preferredMaxLength: preferredMaxLength,
    );
  }
  if (value is Map) {
    if (value.isEmpty) {
      return '{}';
    }
    final sb = StringBuffer();
    sb.write('{\n');
    for (var entry in value.entries) {
      sb.write('  ');
      if (sb.length >= preferredMaxLength) {
        sb.write('...\n');
        break;
      }
      sb.write(debugStringForValue(entry.key));
      sb.write(': ');
      sb.write(debugStringForValue(entry.value));
      sb.write(',\n');
    }
    sb.write('}');
    return sb.toString();
  }
  return '<< ${value.runtimeType} >>';
}

String _debugStringForListOrSet(Iterable value,
    {bool isList = true, int preferredMaxLength = 80}) {
  if (value.isEmpty) {
    return isList ? '[]' : '{}';
  }
  final sb = StringBuffer();
  sb.write(isList ? '[' : '{');
  sb.write(' ');
  var comma = false;
  for (var item in value) {
    if (comma) {
      sb.write(', ');
    } else {
      comma = true;
    }
    final itemString = debugStringForValue(item);
    if (sb.length + itemString.length >= preferredMaxLength) {
      sb.write('...');
      break;
    }
    sb.write(itemString);
  }
  sb.write(' ');
  sb.write(isList ? ']' : '}');
  return sb.toString();
}

String _debugStringForString(String value, {int preferredMaxLength = 80}) {
  if (value.length >= preferredMaxLength && preferredMaxLength >= 10) {
    return '<< String with ${value.runes.length} runes: ${_debugStringForString(value.substring(10))} + more >>';
  }
  final sb = StringBuffer();
  sb.write('"');
  sb.write(value
      .replaceAll(r'\', r'\\')
      .replaceAll('\n', '\\n"\n  "')
      .replaceAll('\t', r'\t')
      .replaceAll('\"', r'\"'));
  sb.write('"');
  return sb.toString();
}

class DebugNamedArgument {
  final String name;
  final Object? value;
  DebugNamedArgument(this.name, this.value);
}
