import 'package:kind/kind.dart';
import 'package:kind/nodes.dart';

/// Frame is a typed collection that is not necessarily stored in the local
/// memory.
///
/// Frame may be mutable or immutable.
///
/// # Comparison with other classes
///   * [List] and [Set]
///     * _List_ and _Set_ store objects in the memory.
///     * Frame is not necessary stored in the memory. The size of frame may be
///       gigabytes, terabytes, or even petabytes. Calculations may be done
///       remotely.
///     * Frame may have [Calculator] for performing operations on items.
///   * [Stream]
///     * Stream enables asynchronous reading of long or infinite sequences.
///       Previously seen items can't be seen again.
///     * Frame always has a finite size and items can be seen infinite times.
///     * Frame may have [Calculator] for performing operations on items.
abstract class Frame<T> {
  FrameType<T>? get frameType;

  Frame<R> expand<R>(List<R> Function(T item) f, {FrameType<R>? frameType}) {
    return _MappedFrame<T, R>(
      this,
      (s) => s.expand(f),
      frameType: frameType,
    );
  }

  Frame<R> map<R>(R Function(T item) f, {required FrameType<R> frameType}) {
    return _MappedFrame<T, R>(this, (s) => s.map(f), frameType: frameType);
  }

  Frame<double> mapToFloat64(double Function(T item) f) {
    return map(f, frameType: FrameType.forFloat64);
  }

  Frame<int> mapToInt(int Function(T item) f) {
    return map(f, frameType: FrameType.forInt);
  }

  Frame<String> mapToString(String Function(T item) f) {
    return map(f, frameType: FrameType.forString);
  }

  Frame<T> skip(int n) {
    return _MappedFrame<T, T>(
      this,
      (s) => s.skip(n),
      frameType: frameType,
    );
  }

  Frame<T> sorted() {
    return _MappedFrame<T, T>(this, (stream) async* {
      final list = await stream.toList();
      list.sort();
      for (var item in list) {
        yield (item);
      }
    }, frameType: frameType);
  }

  /// Streams all items.
  Stream<T> stream();

  /// Streams all items in chunks, which may be faster than per-item streaming
  /// with [stream].
  Stream<List<T>> streamChunks() => stream().map((element) => <T>[element]);

  Frame<T> take(int n) {
    return _MappedFrame<T, T>(
      this,
      (s) => s.take(n),
      frameType: frameType,
    );
  }

  Future<List<T>> toList() {
    return stream().toList();
  }

  /// Loads all data to the memory and constructs a [MemoryFrame].
  ///
  /// If the data does not fit into the memory, throws [StateError].
  Future<MemoryFrame<T>> toMemoryFrame() {
    return toList()
        .then((list) => MemoryFrame<T>(items: list, frameType: frameType));
  }

  Future<Set<T>> toSet() {
    return stream().toSet();
  }

  Frame<T> where(bool Function(T item) f) {
    return _MappedFrame<T, T>(
      this,
      (s) => s.where(f),
      frameType: frameType,
    );
  }

  Frame<T> whereE(Kind<T> kind, Expression<bool> Function(Kind<T> item) f) {
    final expression = f(kind);
    return where((item) => item != null && expression.$evaluateWithItem(item));
  }
}

class _MappedFrame<X, Y> extends Frame<Y> {
  final Frame<X> _frame;
  final Stream<Y> Function(Stream<X> stream) _mapper;

  @override
  final FrameType<Y>? frameType;

  _MappedFrame(this._frame, this._mapper, {this.frameType});

  @override
  Stream<Y> stream() => _mapper(_frame.stream());

  @override
  Stream<List<Y>> streamChunks() => stream().map((item) => [item]);
}
