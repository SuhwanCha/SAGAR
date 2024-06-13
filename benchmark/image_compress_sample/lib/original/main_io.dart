// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:isolate';

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
  bool _isLoading = false;
  ImageProvider? provider;
  Future<Uint8List> compress() async {
    const img = AssetImage('img/img.jpg');
    const config = ImageConfiguration();
    final AssetBundleImageKey key = await img.obtainKey(config);
    final ByteData data = await key.bundle.load(key.name);
    final receivePort = ReceivePort();
    final isolate = await Isolate.spawn<_IsolateMessage>(
      _isolateEntryPoint,
      _IsolateMessage(receivePort.sendPort, data.buffer.asUint8List()),
    );
    final result = await receivePort.first;
    receivePort.close();
    isolate.kill(priority: Isolate.immediate);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Compress Sample'),
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
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

void _isolateEntryPoint(_IsolateMessage message) {
  final sendPort = message.sendPort;
  final result = FlutterImageCompress.compressWithList(
    message.model,
  );
  sendPort.send(result);
}

class _IsolateMessage {
  final SendPort sendPort;
  final Uint8List model;
  _IsolateMessage(this.sendPort, this.model);
}
