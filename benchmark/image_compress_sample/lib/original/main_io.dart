// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart' hide TextButton;
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

Future<void> runMain() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  FlutterImageCompress.showNativeLog = true;
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ImageProvider? provider;

  Future<Uint8List> compress() async {
    const img = AssetImage('img/img.jpg');
    const config = ImageConfiguration();
    final AssetBundleImageKey key = await img.obtainKey(config);
    final ByteData data = await key.bundle.load(key.name);
    final result = await FlutterImageCompress.compressWithList(
      data.buffer.asUint8List(),
    );
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Compress Sample'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                final result = await compress();
                setState(() {
                  provider = MemoryImage(result);
                });
              },
              child: const Text('Compress Image'),
            ),
            if (provider != null) Image(image: provider!),
          ],
        ),
      ),
    );
  }
}
