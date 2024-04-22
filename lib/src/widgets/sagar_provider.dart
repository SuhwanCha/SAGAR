import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sagar/sagar.dart';

class SagarProvider<T extends SagarBase> extends ChangeNotifierProvider<T> {
  SagarProvider({
    super.key,
    required super.create,
    super.child,
    bool lazy = true,
    TransitionBuilder? builder,
  });
}

class MultiSagarProvider extends MultiProvider {
  MultiSagarProvider({
    super.key,
    required super.providers,
    super.child,
  });
}
