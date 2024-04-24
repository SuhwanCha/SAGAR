import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sagar/sagar.dart';

class SagarBuilder<T, B extends SagarBase<T>> extends StatelessWidget {
  const SagarBuilder({
    super.key,
    required this.builder,
    required this.errorBuilder,
    required this.loadingBuilder,
  });

  final Widget Function(BuildContext context, T value) builder;
  final Widget Function(BuildContext context) errorBuilder;
  final Widget Function(BuildContext context) loadingBuilder;

  @override
  Widget build(BuildContext context) {
    return Consumer<B>(
      builder: (context, _, child) {
        final sagar = context.read<B>();

        if (sagar.value != null) {
          return builder(context, sagar.value as T);
        } else {
          if (sagar.hasError) {
            return errorBuilder(context);
          }
          return loadingBuilder(context);
        }
      },
    );
  }
}
