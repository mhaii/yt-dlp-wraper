import 'package:injector/injector.dart';

class DI {
  DI._();

  static Future<void> init() async {
    final injector = Injector.appInstance;
  }
}