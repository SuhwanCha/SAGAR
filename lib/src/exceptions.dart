part of '../sagar.dart';

sealed class SagarException implements Exception {
  final String message;

  SagarException(this.message);

  @override
  String toString() {
    return 'SagarException: $message';
  }
}

final class SagarReceiverPortEmptyException extends SagarException {
  SagarReceiverPortEmptyException() : super('The receiver port is empty.');
}

final class SagarResultTypeException extends SagarException {
  SagarResultTypeException({
    required this.expectedType,
    required this.actualType,
  }) : super('The result type does not match the expected type. \n'
            'Expected: $expectedType \n'
            'Actual: $actualType');

  final Type expectedType;
  final Type actualType;
}
