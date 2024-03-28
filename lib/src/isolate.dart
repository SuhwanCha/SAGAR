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

  Future<T> executeStream(
    Stream<T> Function() function, {
    T? initialValue,
  }) async {
    final receivePort = ReceivePort();
    final isolateToken = RootIsolateToken.instance;

    final isolate = await Isolate.spawn<SagarPayloadStream<T>>(
      _isolateStreamEntryPoint,
      SagarPayloadStream(
        stream: () {
          final stream = function();
          final controller = StreamController<T>();

          controller.onListen = () {
            stream.listen(
              controller.add,
              onError: controller.addError,
              onDone: controller.close,
              cancelOnError: true,
            );
          };
          return controller.stream;
        },
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

  void _isolateEntryPoint(SagarPayload<T> isolateToken) async {
    final sendPort = isolateToken.sendPort;

    try {
      final data = await isolateToken.function();
      sendPort.send(data);
    } catch (e, t) {
      return Future.error(e, t);
    }
  }

  void _isolateStreamEntryPoint(SagarPayload<Stream<T>> isolateToken) async {
    final sendPort = isolateToken.sendPort;

    try {
      final stream = await isolateToken.function();
      stream.listen(
        sendPort.send,
        onError: sendPort.sendError,
        onDone: sendPort.send,
        cancelOnError: true,
      );
    } catch (e, t) {
      return Future.error(e, t);
    }
  }
}
