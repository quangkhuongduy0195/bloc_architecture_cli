class PreferencesGenerator {
  /// Generates the code for preferences.
  static String gen() {
    return '''

library preferences;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const secureStorage = FlutterSecureStorage(
  aOptions: AndroidOptions(encryptedSharedPreferences: true),
  iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
);

const keyAppName = 'architecture_template';

const kKeyBoxName = '\${keyAppName}_box_name';

String getBoxKey(String boxName) => '\${keyAppName}_box_\$boxName';
''';
  }
}
