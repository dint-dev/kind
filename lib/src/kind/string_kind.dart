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

import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:kind/kind.dart';
import 'package:meta/meta.dart';
import 'package:protobuf/protobuf.dart' as protobuf;

/// [Kind] for [String].
///
/// ## Possible constraints
///   * Length of the string ([minLengthInUtf8], [maxLengthInUtf8])
///   * Disallow newlines ([isSingleLine])
///   * Regular expression ([regExp])
///
/// ## Example
/// ```
/// final kind = StringKind(
///   minLengthInUtf8: 1,
///   maxLengthInUtf8: 64,
///   regExp: RegExp(r'^[a-z ]+$'),
///   examples: [
///     'a valid value',
///   ],
/// );
/// ```
///
/// ## Generating random examples
///
/// By default, [randomExample] chooses a random (valid) length and picks a
/// random substring from some non-sensical text.
///
/// If you have defined [declaredExamples], [randomExample] returns one of the example
/// values.
///
/// ## Specifying random example generator
/// ```
/// import 'package:kind/kind.dart';
///
/// final kind = StringKind(
///   randomExampleGenerator: (context) {
///     final i = context.random.nextInt(3);
///     return ['a', 'b', 'c'][i];
///   },
/// )
/// ```
///
@sealed
class StringKind extends PrimitiveKind<String> implements Entity {
  /// [Kind] for [StringKind].
  ///
  /// The purpose of annotation `@protected` is reducing accidental use.
  @protected
  static final EntityKind<StringKind> kind = EntityKind<StringKind>(
    name: 'StringKind',
    define: (c) {
      final minLengthInUtf8Prop = c.requiredUint64(
        id: 1,
        name: 'minLengthInUtf8',
        getter: (t) => t.minLengthInUtf8,
      );
      final maxLengthInUtf8Prop = c.optionalUint64(
        id: 2,
        name: 'maxLengthInUtf8',
        getter: (t) => t.maxLengthInUtf8,
      );
      final singleLineProp = c.requiredBool(
        id: 3,
        name: 'singleLine',
        getter: (t) => t.isSingleLine,
      );
      final patternProp = c.optionalString(
        id: 4,
        name: 'pattern',
        getter: (t) => t.regExp?.pattern,
      );
      c.constructorFromData = (data) {
        final pattern = data.get(patternProp);
        return StringKind(
          minLengthInUtf8: data.get(minLengthInUtf8Prop),
          maxLengthInUtf8: data.get(maxLengthInUtf8Prop),
          isSingleLine: data.get(singleLineProp),
          regExpProvider: pattern == null ? null : () => RegExp(pattern),
        );
      };
    },
  );

  static const _loremIpsum =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'
      ' Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.'
      ' Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.'
      ' Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.';

  // TODO: Better random example generation (many languages, dangerous characters).
  /// Minimum number of UTF-8 bytes.
  ///
  /// The default value is `0`.
  final int minLengthInUtf8;

  /// Optional maximum number of UTF-8 bytes.
  ///
  /// The default value is `null` (no maximum).
  final int? maxLengthInUtf8;

  /// Whether this is a single-line value.
  final bool isSingleLine;

  /// Provider of regular expression.
  final RegExp Function()? _regExpProvider;

  /// String normalizer.
  ///
  /// For example, the function may trim whitespace or convert the string to
  /// lower case.
  final String Function(String value)? normalizer;

  /// Examples.
  final List<String> _examples;

  /// Random example generator.
  final String Function(RandomExampleContext context)? _randomExampleGenerator;

  @override
  final String name;

  @literal
  const StringKind({
    this.name = 'String',
    this.minLengthInUtf8 = 0,
    this.maxLengthInUtf8,
    this.isSingleLine = false,
    RegExp Function()? regExpProvider,
    List<String> examples = const [],
    this.normalizer,
    String Function(RandomExampleContext context)? randomExample,
  })  : assert(minLengthInUtf8 >= 0),
        assert(maxLengthInUtf8 == null || maxLengthInUtf8 >= minLengthInUtf8),
        _regExpProvider = regExpProvider,
        _examples = examples,
        _randomExampleGenerator = randomExample;

  @override
  List<String> get declaredExamples => _examples;

  @override
  int get hashCode {
    return (StringKind).hashCode ^
        minLengthInUtf8.hashCode ^
        maxLengthInUtf8.hashCode ^
        isSingleLine.hashCode;
  }

  @override
  int get protobufFieldType {
    return protobuf.PbFieldType.OS;
  }

  /// Optional regular expression.
  RegExp? get regExp {
    final provider = _regExpProvider;
    if (provider == null) {
      return null;
    }
    return provider();
  }

  @override
  bool operator ==(other) {
    return other is StringKind &&
        name == other.name &&
        minLengthInUtf8 == other.minLengthInUtf8 &&
        maxLengthInUtf8 == other.maxLengthInUtf8 &&
        isSingleLine == other.isSingleLine &&
        _regExpProvider == other._regExpProvider &&
        const ListEquality<String>()
            .equals(declaredExamples, other.declaredExamples);
  }

  @override
  EntityKind<StringKind> getKind() => kind;

  @override
  void instanceValidateConstraints(ValidateContext context, String value) {
    if (minLengthInUtf8 != 0 || maxLengthInUtf8 != null) {
      context.validateLength(
        value: value,
        label: 'length (in UTF-8)',
        length: _stringLengthInUtf8(value),
        minLength: minLengthInUtf8,
        maxLength: maxLengthInUtf8,
      );
    }
    if (isSingleLine && value.contains('\n')) {
      context.invalid(
        value: value,
        message: 'Strings with multiple lines are not allowed.',
      );
    }
    final regExp = this.regExp;
    if (regExp != null) {
      context.checkRegExp(
        value: value,
        regExp: regExp,
      );
    }
    super.instanceValidateConstraints(context, value);
  }

  @override
  String jsonTreeDecode(Object? json, {JsonDecodingContext? context}) {
    if (json is String) {
      return json;
    } else {
      context ??= JsonDecodingContext();
      throw context.newGraphNodeError(
        value: json,
        reason: 'Expected JSON string.',
      );
    }
  }

  @override
  String jsonTreeEncode(String value, {JsonEncodingContext? context}) {
    return value;
  }

  @override
  String newInstance() {
    return '';
  }

  @override
  String protobufTreeDecode(Object? value, {ProtobufDecodingContext? context}) {
    if (value is String) {
      return value;
    }
    throw ArgumentError.value(value);
  }

  @override
  String protobufTreeEncode(String value, {ProtobufEncodingContext? context}) {
    return value;
  }

  @override
  String randomExample({RandomExampleContext? context}) {
    context ??= RandomExampleContext();
    final f = _randomExampleGenerator;
    if (f != null) {
      return f(context);
    }

    // Do we have declared examples?
    final declaredExamples = this.declaredExamples;
    if (declaredExamples.isNotEmpty) {
      final index = context.random.nextInt(declaredExamples.length);
      return declaredExamples[index];
    }

    // Use "lorem ipsum"
    final minLength = minLengthInUtf8;
    var maxLength = maxLengthInUtf8 ?? 64;
    if (maxLength > 64) {
      maxLength = minLength + 64;
    }
    if (minLength > _loremIpsum.length || maxLength > _loremIpsum.length) {
      return _loremIpsum;
    }
    final length = minLength + context.random.nextInt(maxLength - minLength);
    final start = context.random.nextInt(_loremIpsum.length - length);
    return _loremIpsum.substring(start, start + length);
  }

  @override
  String toString() {
    final arguments = <String>[];
    if (isSingleLine) {
      arguments.add('singleLine: true');
    }
    if (minLengthInUtf8 != 0) {
      arguments.add('minLengthInUtf8: $minLengthInUtf8');
    }
    if (maxLengthInUtf8 != 0) {
      arguments.add('maxLengthInUtf8: $maxLengthInUtf8');
    }
    if (regExp != null) {
      arguments.add('regExp: ...');
    }
    if (normalizer != null) {
      arguments.add('normalizer: ...');
    }
    return 'StringKind(${arguments.join(', ')})';
  }

  /// Creates a copy that has a different [maxLengthInUtf8].
  StringKind withMaxLengthInUtf8(int? n) {
    if (n != null && n < 0) {
      throw ArgumentError.value(n);
    }
    return StringKind(
      minLengthInUtf8: minLengthInUtf8,
      maxLengthInUtf8: n,
      isSingleLine: isSingleLine,
      regExpProvider: _regExpProvider,
      normalizer: normalizer,
      examples: _examples,
      randomExample: _randomExampleGenerator,
    );
  }

  /// Creates a copy that has a different [maxLengthInUtf8].
  StringKind withMinLengthInUtf8(int n) {
    if (n < 0) {
      throw ArgumentError.value(n);
    }
    return StringKind(
      minLengthInUtf8: n,
      maxLengthInUtf8: maxLengthInUtf8,
      isSingleLine: isSingleLine,
      regExpProvider: _regExpProvider,
      normalizer: normalizer,
      examples: _examples,
      randomExample: _randomExampleGenerator,
    );
  }

  static int _stringLengthInUtf8(String value) {
    // Optimize the common case of empty string.
    if (value.isEmpty) {
      return 0;
    }

    // Optimize the common case of only simple latin characters.
    if (value.codeUnits.every((e) => e < 128)) {
      return value.length;
    }

    // Otherwise we encode the string in UTF-8.
    // TODO: Avoid encoding
    return utf8.encode(value).length;
  }
}
