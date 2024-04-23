import 'package:flutter_test/flutter_test.dart';

import 'package:sagar/sagar.dart';

class SagarBase2 extends SagarBase<int> {
  @override
  Future<int> execute() async {
    await Future.delayed(const Duration(seconds: 1));
    return Future.value(1);
  }
}

void main() {
  test('adds one to input values', () async {
    final sagar = Sagar<int>();
    final result = await sagar.execute(() async {
      return 1 + 1;
    });

    expect(result, 2);
  });

  test('read json', () async {
    final sagar = Sagar<String>();
    final result = await sagar.execute(() async {
      Future.delayed(const Duration(seconds: 1));
      const data = "{'name': 'John Doe'}";
      return data;
    });

    expect(result, "{'name': 'John Doe'}");
  });
  test('read json on stream', () async {
    final sagar = Sagar<String>();
    final result = await sagar.execute(() async {
      final stream = Stream<String>.periodic(
        const Duration(seconds: 1),
        (i) => i % 2 == 0 ? "{'name': 'John Doe'}" : "{'name': 'Jane Doe'}",
      ).take(2);
      return stream.first;
    });

    expect(result, "{'name': 'John Doe'}");
  });

  test('exception', () async {
    final sagar = Sagar<Map<String, dynamic>>();
    dynamic exception;
    try {
      await sagar.execute(() async {
        throw Exception('Error');
      });
    } catch (e) {
      exception = e;
    }

    expect(exception, isNotNull);
  });

  test(
    'sagar use isolate without init',
    () {
      final sagarBase = SagarBase2();
      expect(sagarBase.isIsolateKilled, false);

      expect(sagarBase.close(), throwsA(isA<AssertionError>()));
    },
  );

  test(
    'sagar close',
    () async {
      final sagarBase = SagarBase2();

      sagarBase.init();

      await sagarBase.close();
      expect(sagarBase.isIsolateKilled, true);
    },
  );

  test(
    'sagar emit',
    () async {
      final sagarBase = SagarBase2();

      sagarBase.init();

      final value = await sagarBase.stream?.first;
      expect(value, 1);
    },
  );
}
