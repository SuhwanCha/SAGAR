part of '../sagar.dart';

abstract class Executable<T extends Object?> {
  Future<T> execute();
}

abstract class Streamable<T extends Object?> extends Executable<Stream<T>> {
  Stream<T> get stream;
}

abstract class SagarBase<T extends Object?> implements Streamable<T> {
  late final Isolate _isolate;
  late final _controller = StreamController<T>.broadcast();

  bool _isolateKilled = false;

  @override
  Stream<T> get stream => _controller.stream;

  Future<Stream<T>> executeStream(
    Stream<T> stream, {
    T? initialValue,
  });

  bool get isIsolateKilled => _isolateKilled;

  Future<void> close() async {
    if (!_isolateKilled) {
      _isolateKilled = true;
      killIsolate();
    }
  }

  void onChanged(T value) {
    emit(value);
  }

  void killIsolate() {
    return _isolate.kill(priority: Isolate.immediate);
  }

  void emit(T value) {
    if (!_isolateKilled) {
      _controller.add(value);
    }
  }
}
