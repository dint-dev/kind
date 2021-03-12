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
import 'package:meta/meta.dart';

/// Context object for [Kind.instanceValidate].
abstract class ValidateContext {
  factory ValidateContext() = _DefaultValidateContext;

  const ValidateContext.constructor();

  const factory ValidateContext.throwing() = _ThrowingValidateContext;

  bool get isClosed => false;

  void checkRegExp({required String value, required RegExp regExp}) {
    if (!regExp.hasMatch(value)) {
      invalid(
        value: value,
        message: 'Must match pattern "${regExp.pattern}"',
      );
    }
  }

  void invalid({required Object? value, String? message});

  void validate<T>(T value, {required Kind<T> kind}) {
    kind.instanceValidate(this, value);
  }

  void validateIndex(int index, Object? value, {required Kind kind}) {
    validate(value, kind: kind);
  }

  void validateLength({
    required Object value,
    required int length,
    required int minLength,
    required int? maxLength,
    String label = 'length',
  }) {
    if (length < minLength) {
      invalid(
        value: value,
        message: 'Length must be $minLength or greater',
      );
    }
    if (maxLength != null && length > maxLength) {
      invalid(
        value: value,
        message: 'Length must be $minLength or less',
      );
    }
  }

  void validateProp(String name, Object? value, {required Kind kind}) {
    validate(value, kind: kind);
  }
}

/// Validation error added to [ValidateContext].
class ValidationError extends Error {
  final Object? value;
  final String? message;
  final List? path;

  ValidationError({
    required this.value,
    this.message,
    this.path,
  });

  @override
  int get hashCode => value.hashCode ^ message.hashCode;

  @override
  bool operator ==(other) =>
      other is ValidationError &&
      value == other.value &&
      message == other.message &&
      const ListEquality().equals(path, other.path);

  @override
  String toString() {
    final b = EntityDebugStringBuilder();
    b.writeDartConstructorCall(name: 'ValidationError', namedArguments: [
      MapEntry('value', value),
      MapEntry('message', message),
      MapEntry('path', path),
    ]);
    return b.toString();
  }
}

class _DefaultValidateContext extends ValidateContext {
  final List propStack = [];
  final List valueStack = [];
  final List<ValidationError> errors = [];

  _DefaultValidateContext() : super.constructor();

  @override
  void invalid({
    required Object? value,
    String? message,
  }) {
    errors.add(ValidationError(
      value: value,
      message: message,
    ));
  }

  @override
  void validate<T>(T value, {required Kind<T> kind});

  @override
  void validateIndex(int index, Object? value, {required Kind kind}) {
    propStack.add(index);
    try {
      valueStack.add(value);
      super.validateIndex(index, value, kind: kind);
    } finally {
      valueStack.removeLast();
      propStack.removeLast();
    }
  }

  @override
  void validateProp(String name, Object? value, {required Kind kind}) {
    propStack.add(name);
    try {
      valueStack.add(value);
      super.validateProp(name, value, kind: kind);
    } finally {
      valueStack.removeLast();
      propStack.removeLast();
    }
  }
}

class _ThrowingValidateContext extends ValidateContext {
  @literal
  const _ThrowingValidateContext() : super.constructor();

  @override
  void invalid({
    required Object? value,
    String? message,
  }) {
    throw ValidationError(
      value: value,
      message: message,
    );
  }
}
