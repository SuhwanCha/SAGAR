import 'dart:io';
import 'dart:isolate';
import 'package:image/image.dart';

class ImageCropper {
  Future<File> cropIsolate(File original) async {
    final receivePort = ReceivePort();
    final isolate = await Isolate.spawn<IsolatePayload>(
      _isolateEntryPoint,
      IsolatePayload(original, receivePort.sendPort),
    );
    final croppedFile = await receivePort.first;
    receivePort.close();
    isolate.kill(priority: Isolate.immediate);
    return croppedFile;
  }

  static Future<File> crop(File original) async {
    final image = decodeImage(original.readAsBytesSync())!;
    final cropped = copyCrop(image,
        x: 0,
        y: 0,
        width: image.width,
        height: image.height,
        radius: 0,
        antialias: true);
    final String name = original.path.split(RegExp(r'(/|\\)')).last;
    final croppedFile = File('${original.parent.path}/cropped4-$name');
    await croppedFile.writeAsBytes(encodePng(cropped));
    return croppedFile;
  }
}

void _isolateEntryPoint(IsolatePayload message) {
  ImageCropper.crop(message.original).then((croppedFile) {
    message.sendPort.send(croppedFile);
  });
}

class IsolatePayload {
  final File original;
  final SendPort sendPort;
  IsolatePayload(this.original, this.sendPort);
}
