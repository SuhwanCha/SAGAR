# SAGAR

Sagar is a package that provides a simple way to use isolates in Dart.
Sagar(סָגַר) means `Isolate` in Hebrew.

<https://codecov.io/gh/SuhwanCha/SAGAR/graphs/tree.svg?token=QNuJYnoO68>

[![codecov](https://codecov.io/gh/SuhwanCha/SAGAR/graphs/tree.svg?token=QNuJYnoO68)](https://codecov.io/gh/SuhwanCha/SAGAR)

[![codecov](https://codecov.io/gh/SuhwanCha/SAGAR/graph/badge.svg?token=QNuJYnoO68)](https://codecov.io/gh/SuhwanCha/SAGAR)

## How to use

1. Add the dependency to your `pubspec.yaml` file.

```yaml
dependencies:
  sagar: ^0.0.1
```

1. Import the package.

```dart
import 'package:sagar/sagar.dart';
```

1. Create an Sagar class than extends SagarBase

```dart
class Sagar2 extends SagarBase<int> {
  @override
  Future<int> execute() async {
    await Future.delayed(Duration.zero);
    return Future.value(1);
  }
}
```

`execute` method is the method that will be executed in the isolate.

1. Create SagarProvider

```dart
SagarProvider(
  create: (_) => Sagar2()..init(),
  child: const SizedBox.shrink(),
),
```

Also you can use SagarProvider.value

```dart
SagarProvider.value(
  value: Sagar2()..init(),
  child: const SizedBox.shrink(),
),
```

> Note that you should call `init` method after creating Sagar class.

1. Use SagarBuilder to get the result of Sagar

```dart
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
)
```
