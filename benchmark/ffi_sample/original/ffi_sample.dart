import 'dart:async';
import 'dart:ffi' as ffi;
import 'dart:isolate';

typedef NativeBinaryOp = ffi.Int32 Function(ffi.Int32, ffi.Int32);
typedef BinaryOp = int Function(int, int);

class Simple {
  static Future<String> get platformVersion async {
    final ex = ffi.DynamicLibrary.executable();
    final nativeSum = ex.lookupFunction<NativeBinaryOp, BinaryOp>("nativeSum");
    final receivePort = ReceivePort();
    final isolate = await Isolate.spawn<_Message>(
      _isolateEntryPoint,
      _Message(
        receivePort.sendPort,
        nativeSum,
      ),
      onExit: receivePort.sendPort,
    );
    final result = await receivePort.first;
    receivePort.close();
    isolate.kill(priority: Isolate.immediate);
    return result;
  }
}

class _Message {
  final SendPort sendPort;
  final dynamic message;
  _Message(this.sendPort, this.message);
}

void _isolateEntryPoint(_Message message) {
  final sendPort = message.sendPort;
  final nativeSum = message.message as BinaryOp;
  final result = nativeSum(31, 63);
  sendPort.send(result.toString());
}
