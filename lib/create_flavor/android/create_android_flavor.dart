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
