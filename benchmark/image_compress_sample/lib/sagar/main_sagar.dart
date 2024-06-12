// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart' hide TextButton;
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:sagar/sagar.dart';

Future<void> runMain() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  FlutterImageCompress.showNativeLog = true;
}

class Sagar extends SagarBase<Uint8List> {
  @override
  Future<Uint8List> execute() async {
    const img = AssetImage('img/img.jpg');
    const config = ImageConfiguration();
    final AssetBundleImageKey key = await img.obtainKey(config);
    final ByteData data = await key.bundle.load(key.name);
    final result = await FlutterImageCompress.compressWithList(
      data.buffer.asUint8List(),
    );
    return result;
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final sagar = Sagar();
    return SagarProvider.value(
      value: sagar,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Image Compress Sample'),
        ),
        body: SagarBuilder<Uint8List, Sagar>(
          builder: (context, value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () => sagar.init(),
                    child: const Text('Compress Image'),
                  ),
                  Image(image: MemoryImage(value)),
                ],
              ),
            );
          },
          errorBuilder: (context) {
            return const Center(
              child: Text('Error'),
            );
          },
          loadingBuilder: (context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
