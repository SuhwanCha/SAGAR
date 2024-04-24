import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sagar/sagar.dart';

class SagarProvider<T extends SagarBase> extends ChangeNotifierProvider<T> {
  SagarProvider({
    super.key,
    required super.create,
    super.child,
    bool lazy = true,
    super.builder,
  });

  factory SagarProvider.value({
    required T value,
    Key? key,
    Widget? child,
    bool lazy = true,
    TransitionBuilder? builder,
  }) {
    return SagarProvider(
      key: key,
      create: (_) => value,
      lazy: lazy,
      builder: builder,
      child: child,
    );
  }
}

class MultiSagarProvider extends MultiProvider {
  MultiSagarProvider({
    super.key,
    required super.providers,
    super.child,
  });
}
