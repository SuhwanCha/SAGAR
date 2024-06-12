import 'dart:io';
import 'package:image/image.dart';
import 'package:sagar/sagar.dart';

class ImageCropper {
  Future<File> crop(File original) async {
    final sagar = Sagar<File>();
    return sagar.execute(() async {
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
    });
  }
}
