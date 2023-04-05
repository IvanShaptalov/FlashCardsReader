import 'package:flutter/foundation.dart';

void debugPrint(Object message) {
  if (kDebugMode) {
    print(message);
  }
  // TODO save logs to file
}
