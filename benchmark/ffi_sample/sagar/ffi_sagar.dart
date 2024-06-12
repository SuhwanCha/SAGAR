import 'dart:async';
import 'dart:ffi' as ffi;

import 'package:sagar/src/isolate.dart';

typedef NativeBinaryOp = ffi.Int32 Function(ffi.Int32, ffi.Int32);
typedef BinaryOp = int Function(int, int);

class Simple {
  static Future<String> get platformVersion async {
    final ex = ffi.DynamicLibrary.executable();
    final nativeSum = ex.lookupFunction<NativeBinaryOp, BinaryOp>("nativeSum");

    final sagar = Sagar<String>();
    final result = await sagar.execute(() async {
      return nativeSum(31, 63).toString();
    });
    return result;
  }
}
