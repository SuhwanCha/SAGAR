import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sagar/sagar.dart';
import 'package:sagar/src/isolate.dart';

class SagarBase2 extends SagarBase<int> {
  @override
  Future<int> execute() async {
    await Future.delayed(Duration.zero);
    return Future.value(1);
  }
}

class Sagar2 extends SagarBase<int> {
  @override
  Future<int> execute() async {
    await Future.delayed(Duration.zero);
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

  test('get Stream', () async {
    Sagar<int> sagar = Sagar();
    final stream = sagar.getStream(() async {
      await Future.delayed(const Duration(seconds: 1));
      return 1;
    });

    expect(stream, isA<Stream<int>>());
    await Future.delayed(const Duration(seconds: 2));

    expect(await stream.first, 1);
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

  testWidgets('sargarBuilder', (widgetTester) async {
    final sagar = Sagar2();
    final widget = SagarProvider.value(
      value: sagar..init(),
      builder: (context, child) {
        return SagarBuilder<int, Sagar2>(
          builder: (context, value) {
            return Text(value.toString());
          },
          errorBuilder: (context) {
            return const Text('Error');
          },
          loadingBuilder: (context) {
            return const CircularProgressIndicator();
          },
        );
      },
    );

    await widgetTester.pumpWidget(widget);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
