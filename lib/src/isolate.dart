import 'dart:isolate';
import 'dart:ui';

import 'package:sagar/sagar.dart';

class Sagar<T> {
  Stream<T> getStream(
    Future<T> Function() function,
  ) {
    return Stream.fromFuture(
      execute(function),
    );
  }

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

    receivePort.close();
    isolate.kill(priority: Isolate.immediate);
    return result;
  }

  void _isolateEntryPoint(SagarPayload<T> isolateToken) {
    final sendPort = isolateToken.sendPort;
    isolateToken.function
        .call()
        .then((value) => sendPort.send(value))
        .catchError((e, t) => sendPort.send(e));
  }
}
