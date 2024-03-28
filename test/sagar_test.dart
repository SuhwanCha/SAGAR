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
}
