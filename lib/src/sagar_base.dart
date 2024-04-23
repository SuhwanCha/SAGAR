part of '../sagar.dart';

abstract class Executable<T extends Object?> {
  Future<T> execute();
}

abstract class Streamable<T extends Object?> extends Executable<Stream<T>> {
  Stream<T> get stream;
}

abstract class SagarBase<T extends Object?>
    with ChangeNotifier
    implements Executable<T> {
  Stream<T>? _stream;
  Stream<T>? get stream => _stream;

  bool _isolateKilled = false;

  bool get isIsolateKilled => _isolateKilled;

  void init() {
    _stream = Sagar<T>().getStream(execute);

    // stream?.listen(_onChanged);
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
    assert(_stream != null, 'Isolate is null');

    _stream = null;
  }

  // void emit(T value) {
  //   if (!_isolateKilled) {
  //     _stream.
  //   }
  // }
}
