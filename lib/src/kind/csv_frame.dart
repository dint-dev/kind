import 'dart:io';

import 'package:kind/kind.dart';

/// A frame that is loaded from CSV file.
class CsvFrame<T> extends Frame<T> {
  final String uri;
  final List<String>? columnNames;
  final HttpClient? httpClient;
  final Kind kind;

  @override
  final FrameType<T>? frameType;

  CsvFrame({
    required this.uri,
    required this.columnNames,
    required this.kind,
    this.frameType,
    this.httpClient,
  });

  @override
  Stream<T> stream() async* {
    final client = httpClient ?? HttpClient();
    final request = await client.openUrl('GET', Uri.parse(uri));
    request.headers.set(HttpHeaders.acceptHeader, 'text/csv');
    final response = await request.close();
    if (response.statusCode != 200) {
      throw FrameReadError(
        message:
            'HTTP error: ${response.statusCode} (${response.reasonPhrase})',
      );
    }
    final contentType = response.headers.contentType;
    if (contentType != null && contentType.primaryType != 'text/csv') {
      throw FrameReadError(
        message: 'Unexpected content type: ${contentType}',
      );
    }
    final buffer = BytesBuilder();
    await for (var chunk in response) {
      buffer.add(chunk);
    }
    throw UnimplementedError();
  }
}

class FrameReadError {
  final String message;

  FrameReadError({required this.message});

  @override
  String toString() => 'Frame reading error: $message';
}
