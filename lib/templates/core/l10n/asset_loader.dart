class l10nAssetLoaderGenerator {
  /// Generates the code for the [AssetLoader] class.
  static String gen() {
    return '''import 'dart:convert';
import 'dart:ui';

import 'package:flutter/services.dart';

import 'app_localization.dart';

/// abstract class used to building your Custom AssetLoader
/// Example:
/// ```
///class FileAssetLoader extends AssetLoader {
///  @override
///  Future<Map<String, dynamic>> load(String path, Locale locale) async {
///    final file = File(path);
///    return json.decode(await file.readAsString());
///  }
///}
/// ```
abstract class AssetLoader {
  const AssetLoader();
  Future<Map<String, dynamic>?> load(String path, Locale locale);
}

///
/// default used is RootBundleAssetLoader which uses flutter's AssetLoader
///
class RootBundleAssetLoader extends AssetLoader {
  const RootBundleAssetLoader();

  String getLocalePath(String basePath, Locale locale) {
    return '\$basePath/\${locale.toStringWithSeparator(separator: "_")}.json';
  }

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) async {
    var localePath = getLocalePath(path, locale);
    return json.decode(await rootBundle.loadString(localePath));
  }
}
''';
  }
}
