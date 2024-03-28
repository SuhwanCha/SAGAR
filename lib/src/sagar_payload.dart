import 'dart:isolate';
import 'dart:ui';

/// A payload that can be sent to an isolate.
class SagarPayload<T> {
  const SagarPayload({
    required this.function,
    required this.sendPort,
    this.isolateToken,
  });

  /// The function to be executed in the isolate.
  final Future<T> Function() function;

  /// The send port to send messages to the isolate.
  final SendPort sendPort;

  /// The isolate token to identify the isolate.
  final RootIsolateToken? isolateToken;
}
