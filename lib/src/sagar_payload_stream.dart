import 'dart:isolate';

import 'package:flutter/services.dart';

class SagarPayloadStream<T> {
  const SagarPayloadStream({
    required this.stream,
    required this.sendPort,
    this.isolateToken,
  });

  /// The function to be executed in the isolate.
  final Stream<T> stream;

  /// The send port to send messages to the isolate.
  final SendPort sendPort;

  /// The isolate token to identify the isolate.
  final RootIsolateToken? isolateToken;
}
