// ignore: depend_on_referenced_packages
import 'package:sagar/sagar.dart';

class Sagar2 extends SagarBase<int> {
  @override
  Future<int> execute() async {
    await Future.delayed(Duration.zero);
    return Future.value(1);
  }
}
