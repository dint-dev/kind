import 'package:kind/kind.dart';

/// A [Frame] that is stored in the memory.
class MemoryFrame<T> extends Frame<T> {
  final List<T> items;

  @override
  final FrameType<T>? frameType;

  MemoryFrame({required this.items, this.frameType});

  @override
  Stream<T> stream() => Stream<T>.fromIterable(items);

  @override
  Stream<List<T>> streamChunks() => Stream<List<T>>.value(items);
}
