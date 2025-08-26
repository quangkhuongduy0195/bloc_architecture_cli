import 'dart:io';

import '../create_flavor.dart';
import 'create_app_name_manifest.dart';
import 'update_gradle.dart';

Future<void> createAndroidFlavor(FlavorConfig config) async {
  final gradlePath = config.buildGradlePath;
  final flavorName = config.flavorName;
  final dimension = config.dimension;
  final displayName = config.displayName;
  final androidPackage = config.androidPackageName;

  final file = File(gradlePath);
  var content = await file.readAsString();

  content = addFlavorDimension(content, dimension);
  content = addOrUpdateProductFlavors(
      content, flavorName, dimension, displayName, androidPackage);

  await file.writeAsString(content);

  await updateAndroidManifest(config.manifestPath);

  print('New product flavor added or updated successfully.');
}

Future<String?> getPackageNameAndroid() async {
  // Thử tìm build.gradle.kts trước (Kotlin DSL)
  String path = 'android/app/build.gradle.kts';
  File file = File(path);

  // Nếu không có .kts, thử .gradle (Groovy DSL)
  if (!await file.exists()) {
    path = 'android/app/build.gradle';
    file = File(path);
  }

  try {
    if (!await file.exists()) {
      print('build.gradle or build.gradle.kts file not found');
      return null;
    }

    final content = await file.readAsString();

    // Cho Kotlin DSL (build.gradle.kts) - sử dụng = thay vì space
    final regexKts = RegExp(r'applicationId\s*=\s*"([^"]+)"');
    final matchKts = regexKts.firstMatch(content);

    if (matchKts != null) {
      final packageName = matchKts.group(1)!.trim();
      return packageName;
    }

    // Cho Groovy DSL (build.gradle) - sử dụng space
    final regex = RegExp(r'applicationId\s+"([^"]+)"');
    final match = regex.firstMatch(content);

    if (match != null) {
      final packageName = match.group(1)!.trim();
      return packageName;
    }

    // Thử với single quotes
    final regexSingle = RegExp(r"applicationId\s*=?\s*'([^']+)'");
    final matchSingle = regexSingle.firstMatch(content);

    if (matchSingle != null) {
      final packageName = matchSingle.group(1)!.trim();
      return packageName;
    }

    // Nếu không tìm thấy applicationId, thử tìm namespace
    final namespaceRegexKts = RegExp(r'namespace\s*=\s*"([^"]+)"');
    final namespaceMatchKts = namespaceRegexKts.firstMatch(content);

    if (namespaceMatchKts != null) {
      final packageName = namespaceMatchKts.group(1)!.trim();
      return packageName;
    }

    final namespaceRegex = RegExp(r'namespace\s+"([^"]+)"');
    final namespaceMatch = namespaceRegex.firstMatch(content);

    if (namespaceMatch != null) {
      final packageName = namespaceMatch.group(1)!.trim();
      return packageName;
    }

    return null;
  } catch (e) {
    print('Error reading Android package name: $e');
    return null;
  }
}
