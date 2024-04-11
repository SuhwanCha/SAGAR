part of '../sagar.dart';

class Sagar<T> {
  Future<T> execute(Future<T> Function() function) async {
    final receivePort = ReceivePort();
    final isolateToken = RootIsolateToken.instance;

    final isolate = await Isolate.spawn<SagarPayload<T>>(
      _isolateEntryPoint,
      SagarPayload(
        function: function,
        sendPort: receivePort.sendPort,
        isolateToken: isolateToken,
      ),
      onExit: receivePort.sendPort,
    );

    final result = await receivePort.first;

    if (result is! T) {
      receivePort.close();
      isolate.kill(priority: Isolate.immediate);
      throw SagarResultTypeException(
        expectedType: T,
        actualType: result.runtimeType,
      );
    }

    receivePort.close();
    isolate.kill(priority: Isolate.immediate);
    return result;
  }

  Future<Stream<T>> executeStream(
    Stream<T> stream, {
    T? initialValue,
  }) async {
    final StreamController<T> controller = StreamController<T>.broadcast();

    final receivePort = ReceivePort();
    final isolateToken = RootIsolateToken.instance;

    final isolate = await Isolate.spawn<SagarPayloadStream<T>>(
      _isolateStreamEntryPoint,
      SagarPayloadStream(
        stream: stream,
        onError: (e, t) {
          receivePort.sendPort.send(SagarStreamErrorException(e, t));
        },
        sendPort: receivePort.sendPort,
        isolateToken: isolateToken,
      ),
      onExit: receivePort.sendPort,
    );

    if (initialValue != null) {
      controller.add(initialValue);
    }

    receivePort.listen((message) {
      if (message == _SagarFlags.streamEnd) {
        receivePort.close();
        isolate.kill(priority: Isolate.immediate);
      } else if (message == _SagarFlags.streamError ||
          message is SagarStreamErrorException) {
        receivePort.close();
        isolate.kill(priority: Isolate.immediate);
        controller.addError(message);
      } else if (message is T) {
        controller.add(message);
      }
    });

    return controller.stream;
  }

  void _isolateEntryPoint(SagarPayload<T> isolateToken) async {
    final sendPort = isolateToken.sendPort;

    try {
      final data = await isolateToken.function();
      sendPort.send(data);
    } catch (e, t) {
      return Future.error(e, t);
    }
  }

  void _isolateStreamEntryPoint(SagarPayloadStream<T> isolateToken) async {
    final sendPort = isolateToken.sendPort;

    try {
      final stream = isolateToken.stream;
      stream.listen(
        sendPort.send,
        onError: isolateToken.onError,
        onDone: () => sendPort.send(_SagarFlags.streamEnd),
        cancelOnError: true,
      );
    } catch (e, t) {
      return Future.error(e, t);
    }
  }
}
