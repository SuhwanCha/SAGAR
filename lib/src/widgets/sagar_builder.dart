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
    return StreamBuilder<T>(
      stream: context.read<B>().stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return builder(context, snapshot.data as T);
        } else if (snapshot.hasError) {
          return errorBuilder(context);
        } else {
          return loadingBuilder(context);
        }
      },
    );
  }
}
