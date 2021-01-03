import 'package:kind/kind.dart';

/// Argument for [Kind.decode].
abstract class Data {
  const Data();

  factory Data.fromJson(Map<String, Object> json) = _JsonData;

  bool containsKey(String name);

  Object? get(String name);
}

/// An object that can tell its own a [Kind].
abstract class HasKind {
  Kind getKind();
}

/// Describes schema of a class, decodes instances, and encodes instances.
///
/// # Example
/// ```
/// class ExampleKind<T extends Example> extends Kind<T> {
///   late StringField<T> someField = StringField<T>(this, 'some');
///
///   @override
///   Example decode(Data data) {
///     return Example(someField: someField.get(data));
///   }
/// }
/// ```
abstract class Kind<T> {
  final String $name;
  final List<Prop> $props = <Prop>[];
  bool _isInitialized = false;

  Kind({required String name}) : $name = name;

  /// Decodes an instance of `T`.
  ///
  /// # Example
  /// ```
  /// class ExampleKind<T extends Example> extends Kind<T> {
  ///   late StringField<T> someField = StringField<T>(this, 'some');
  ///
  ///   @override
  ///   Example decode(Data data) {
  ///     return Example(someField: someField.get(data));
  ///   }
  /// }
  /// ```
  Object decode(Data data);

  /// Encodes
  Map<String, Object?> encodeJsonObject(covariant T value) {
    if (!_isInitialized) {
      _isInitialized = true;
      try {
        decode(Data.fromJson({}));
      } catch (error) {
        // Ignore
      }
    }
    final result = <String, Object?>{};
    for (var prop in $props) {
      result[prop.$name] = prop.$get(value);
    }
    return result;
  }
}

class _JsonData extends Data {
  final Map<String, Object> json;

  _JsonData(this.json);

  @override
  bool containsKey(String name) => json.containsKey(name);

  @override
  Object? get(String name) => json[name];
}
