import 'dart:io';

import '../create_flavor.dart';

Future<void> createXcodeScheme({
  required String blueprintIdentifierProfile,
  required String blueprintIdentifierDebug,
  required String blueprintIdentifierRelease,
  required String flavor,
}) async {
  final String filePath =
      'ios/Runner.xcodeproj/xcshareddata/xcschemes/$flavor.xcscheme';
  final String directoryPath = 'ios/Runner.xcodeproj/xcshareddata/xcschemes';
  final directory = Directory(directoryPath);
  if (!await directory.exists()) {
    await directory.create(recursive: true);
  }
  final File file = File(filePath);
  if (!await file.exists()) {
    await file.create();
  }

  final StringBuffer content = StringBuffer();
  content.writeln('<?xml version="1.0" encoding="UTF-8"?>');
  content.writeln('<Scheme LastUpgradeVersion = "1340" version = "1.3">');
  content.writeln(
      '  <BuildAction parallelizeBuildables = "YES" buildImplicitDependencies = "YES">');
  content.writeln('    <BuildActionEntries>');
  content.writeln(
      '      <BuildActionEntry buildForTesting = "YES" buildForRunning = "YES" buildForProfiling = "YES" buildForArchiving = "YES" buildForAnalyzing = "YES">');
  content.writeln(
      '        <BuildableReference BuildableIdentifier = "primary" BlueprintIdentifier = "$blueprintIdentifierDebug" BuildableName = "Runner.app" BlueprintName = "Runner" ReferencedContainer = "container:Runner.xcodeproj"/>');
  content.writeln('      </BuildActionEntry>');
  content.writeln('    </BuildActionEntries>');
  content.writeln('  </BuildAction>');
  content.writeln(
      '  <TestAction buildConfiguration = "${BuildType.debug}-$flavor" selectedDebuggerIdentifier = "Xcode.DebuggerFoundation.Debugger.LLDB" selectedLauncherIdentifier = "Xcode.DebuggerFoundation.Launcher.LLDB" shouldUseLaunchSchemeArgsEnv = "YES">');
  content.writeln('    <Testables></Testables>');
  content.writeln('  </TestAction>');
  content.writeln(
      '  <LaunchAction buildConfiguration = "${BuildType.debug}-$flavor" selectedDebuggerIdentifier = "Xcode.DebuggerFoundation.Debugger.LLDB" selectedLauncherIdentifier = "Xcode.DebuggerFoundation.Launcher.LLDB" launchStyle = "0" useCustomWorkingDirectory = "NO" ignoresPersistentStateOnLaunch = "NO" debugDocumentVersioning = "YES" debugServiceExtension = "internal" allowLocationSimulation = "YES">');
  content.writeln('    <BuildableProductRunnable runnableDebuggingMode = "0">');
  content.writeln(
      '      <BuildableReference BuildableIdentifier = "primary" BlueprintIdentifier = "$blueprintIdentifierDebug" BuildableName = "Runner.app" BlueprintName = "Runner" ReferencedContainer = "container:Runner.xcodeproj"/>');
  content.writeln('    </BuildableProductRunnable>');
  content.writeln('    <CommandLineArguments>');
  content.writeln(
      '      <CommandLineArgument argument = "--dart-define=FLAVOR=$flavor" isEnabled = "YES"/>');
  content.writeln(
      '      <CommandLineArgument argument = "--flavor=$flavor" isEnabled = "YES"/>');
  content.writeln('    </CommandLineArguments>');
  content.writeln('  </LaunchAction>');
  content.writeln(
      '  <ProfileAction buildConfiguration = "${BuildType.profile}-$flavor" shouldUseLaunchSchemeArgsEnv = "YES" savedToolIdentifier = "" useCustomWorkingDirectory = "NO" debugDocumentVersioning = "YES">');
  content.writeln('    <BuildableProductRunnable runnableDebuggingMode = "0">');
  content.writeln(
      '      <BuildableReference BuildableIdentifier = "primary" BlueprintIdentifier = "$blueprintIdentifierProfile" BuildableName = "Runner.app" BlueprintName = "Runner" ReferencedContainer = "container:Runner.xcodeproj"/>');
  content.writeln('    </BuildableProductRunnable>');
  content.writeln('  </ProfileAction>');
  content.writeln(
      '  <AnalyzeAction buildConfiguration = "${BuildType.debug}-$flavor"></AnalyzeAction>');
  content.writeln(
      '  <ArchiveAction buildConfiguration = "${BuildType.release}-$flavor" revealArchiveInOrganizer = "YES">');
  content.writeln('  </ArchiveAction>');
  content.writeln('</Scheme>');

  await file.writeAsString(content.toString());
  print('Created scheme file at $filePath');
}

Future<void> copyAndConfigFlavor({
  required String blueprintIdentifierProfile,
  required String blueprintIdentifierDebug,
  required String blueprintIdentifierRelease,
  required String flavor,
}) async {
  final String fileRunnerPath =
      'ios/Runner.xcodeproj/xcshareddata/xcschemes/Runner.xcscheme';
  final String directoryPath = 'ios/Runner.xcodeproj/xcshareddata/xcschemes';
  final String flavorSchemePath =
      'ios/Runner.xcodeproj/xcshareddata/xcschemes/$flavor.xcscheme';

  // Ensure directory exists
  final directory = Directory(directoryPath);
  if (!await directory.exists()) {
    await directory.create(recursive: true);
  }

  // Read the original Runner.xcscheme file
  final File runnerSchemeFile = File(fileRunnerPath);
  if (!await runnerSchemeFile.exists()) {
    throw Exception('Runner.xcscheme file not found at $fileRunnerPath');
  }

  String content = await runnerSchemeFile.readAsString();

  // Replace build configurations with flavor-specific ones
  content = content.replaceAll('buildConfiguration = "Debug"',
      'buildConfiguration = "${BuildType.debug}-$flavor"');
  content = content.replaceAll('buildConfiguration = "Release"',
      'buildConfiguration = "${BuildType.release}-$flavor"');
  content = content.replaceAll('buildConfiguration = "Profile"',
      'buildConfiguration = "${BuildType.profile}-$flavor"');

  // Update BlueprintIdentifiers if they are different
  if (blueprintIdentifierDebug != blueprintIdentifierProfile ||
      blueprintIdentifierDebug != blueprintIdentifierRelease) {
    // For ProfileAction, use the profile identifier
    content = content.replaceAllMapped(
        RegExp(r'<ProfileAction[^>]*>(.*?)</ProfileAction>', dotAll: true),
        (match) {
      String profileSection = match.group(0)!;
      // Replace BlueprintIdentifier in ProfileAction with profile identifier
      profileSection = profileSection.replaceAll(
          RegExp(r'BlueprintIdentifier\s*=\s*"[^"]*"'),
          'BlueprintIdentifier="$blueprintIdentifierProfile"');
      return profileSection;
    });
  }

  // Add flavor-specific command line arguments if they don't exist
  if (!content.contains('--dart-define=FLAVOR=$flavor')) {
    content = content.replaceAll('</BuildableProductRunnable>',
        '</BuildableProductRunnable>\n    <CommandLineArguments>\n      <CommandLineArgument argument="--dart-define=FLAVOR=$flavor" isEnabled="YES"/>\n      <CommandLineArgument argument="--flavor=$flavor" isEnabled="YES"/>\n    </CommandLineArguments>');
  }

  // Write the modified content to the new flavor scheme file
  final File flavorSchemeFile = File(flavorSchemePath);
  await flavorSchemeFile.writeAsString(content);

  print('Configured scheme file at $flavorSchemePath');
}
