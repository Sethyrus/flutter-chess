import 'package:flutter/foundation.dart';

class Debugger {
  static dynamic log(String key, [Object? value]) {
    if (kDebugMode) {
      print('[DEBUG] $key');

      if (value != null) print(value);
    }
  }
}
