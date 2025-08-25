import 'dart:io';

import 'package:args/args.dart';

import '/create_flavor/android/create_android_flavor.dart';
import '/create_flavor/ios/create_xc_flavor.dart';

abstract class CreateFlavorExit {
  static void notFound({String? message}) {
    print('${message ?? ''} Not found');
    exit(404);
  }
}

enum BuildType {
  debug,
  profile,
  release;

  @override
  String toString() {
    return switch (this) {
      BuildType.debug => 'Debug',
      BuildType.release => 'Release',
      BuildType.profile => 'Profile',
    };
  }
}

class FlavorConfig {
  final String xcPath;
  final String iosPackageName;
  final String androidPackageName;
  final String displayName;
  final String flavorName;
  final String dimension;
  final String runnerEntitlementsPath = 'ios/Runner/Runner.entitlements';
  final String plistPath = 'ios/Runner/Info.plist';
  final String manifestPath = 'android/app/src/main/AndroidManifest.xml';
  final String buildGradlePath = 'android/app/build.gradle.kts';
  final String iosTeamId;
  final bool isEnabledIconsLauncher;

  // ignore: non_constant_identifier_names
  String get ASSETCATALOG_COMPILER_APPICON_NAME =>
      isEnabledIconsLauncher ? '"\${app_display_icon}"' : 'AppIcon';
  // ignore: non_constant_identifier_names
  String get APP_DISPLAY_NAME => '"\${app_display_name}"';

  FlavorConfig({
    this.xcPath = 'ios/Runner.xcodeproj/project.pbxproj',
    required this.iosPackageName,
    required this.androidPackageName,
    required this.displayName,
    required this.flavorName,
    required this.iosTeamId,
    this.dimension = 'default',
    this.isEnabledIconsLauncher = false,
  });
}

Future<void> createFlavor(FlavorConfig config) async {
  await createXcFlavor(config);
  await createAndroidFlavor(config);
}

class FlavorHandler {
  ArgResults? argResults;
  Future<void> execute(ArgResults command) async {
    // Implement execution logic
    argResults = command;
    print('Running create command with the following options:');
    _requiredOption(['packageName', 'packageNameIos']);
    _requiredOption(['packageName', 'packageNameAndroid']);
    _requiredOption(['displayName']);
    _requiredOption(['flavorName']);

    var packageName = argResults?['packageName'];
    var packageNameIos = argResults?['packageNameIos'];
    var packageNameAndroid = argResults?['packageNameAndroid'];
    var displayName = argResults?['displayName'];
    var flavorName = argResults?['flavorName'];
    var pathXcProject = argResults?['pathXcProject'];
    var teamId = argResults?['teamId'];

    print('Creating flavor with the following details:');
    print('Package Name: $packageName');
    print('Package Name iOS: $packageNameIos');
    print('Package Name Android: $packageNameAndroid');
    print('Display Name: $displayName');
    print('Flavor Name: $flavorName');
    print('Path to Xcode Project: $pathXcProject');

    final config = FlavorConfig(
        xcPath: pathXcProject ?? 'ios/Runner.xcodeproj/project.pbxproj',
        iosPackageName: (packageNameIos ?? packageName)!,
        androidPackageName: (packageNameAndroid ?? packageName)!,
        displayName: displayName,
        flavorName: flavorName,
        iosTeamId: teamId,
        isEnabledIconsLauncher:
            (argResults?['iconsLauncher'] ?? 'false') == 'true');

    await createFlavor(config);
  }

  void _requiredOption(List<String> option) {
    final options = List.generate(option.length, (i) => argResults?[option[i]]);

    if (options.every((test) => test == null)) {
      print('Missing required option: $option');
      exit(1);
    }
  }

  Future<void> create() async {
    // await createFlavor(config);
  }

  Future<void> update() async {
    // Implement update logic
  }
}
