import 'package:flutter/material.dart';
import 'package:sagar/src/isolate.dart';

abstract class Executable<T extends Object?> {
  Future<T> execute();
}

abstract class Streamable<T extends Object?> extends Executable<Stream<T>> {
  Stream<T> get stream;
}

abstract class SagarBase<T extends Object?>
    with ChangeNotifier
    implements Executable<T> {
  Future<T>? _future;

  T? _value;
  T? get value => _value;

  bool _hasError = false;
  bool get hasError => _hasError;

  bool _isolateKilled = false;

  bool get isIsolateKilled => _isolateKilled;

  void init() {
    _future = Sagar<T>().execute(() => execute());
    _future!.then((value) {
      _value = value;
      notifyListeners();
    }).catchError((e) {
      print("@@@@");
      print(e);
      _hasError = true;
      notifyListeners();
    });
  }

  Future<void> close() async {
    if (!_isolateKilled) {
      _isolateKilled = true;
      killIsolate();
    }
  }

  // void _onChanged(T value) {
  //   emit(value);
  // }

  void killIsolate() {
    assert(_future != null, 'Isolate is null');

    _future = null;
  }

  // void emit(T value) {
  //   if (!_isolateKilled) {
  //     _stream.
  //   }
  // }
}
