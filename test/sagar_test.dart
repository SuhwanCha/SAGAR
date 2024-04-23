import 'package:flutter_test/flutter_test.dart';

import 'package:sagar/sagar.dart';

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
}
