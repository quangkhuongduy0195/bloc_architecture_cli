class KeysExtGenerator {
  static String gen() {
    return '''import 'package:flutter/material.dart';

extension FormKeysExt on GlobalKey<FormState> {
  bool get isValid => currentState?.validate() ?? false;
}

''';
  }
}
