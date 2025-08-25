import 'dart:io';
import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:hybrid_cli/create_flavor/create_flavor.dart';
import '../lib/commands/init_command.dart';
import '../lib/commands/feature_command.dart';

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addCommand('init')
    ..addCommand('feature')
    ..addFlag('help', abbr: 'h', help: 'Show usage information')
    ..addFlag('version', abbr: 'v', help: 'Show version information');

  // Add generate command with --feature option
  final flavorCommand = parser.addCommand('flavor');
  flavorCommand
    ..addOption('packageName',
        abbr: 'p', help: 'Package name for iOS and Android if common.')
    ..addOption('packageNameIos',
        abbr: 'i', help: 'Package name specific to iOS.')
    ..addOption('packageNameAndroid',
        abbr: 'a', help: 'Package name specific to Android.')
    ..addOption('displayName',
        abbr: 'd', help: 'Display name of the application.')
    ..addOption('flavorName',
        abbr: 'f', help: 'Flavor name of the application.')
    ..addOption('pathXcProject',
        abbr: 'x', help: 'Path to the Xcode project (optional).')
    ..addOption('iconsLauncher',
        help: 'Supports icons (optional).', defaultsTo: 'false')
    ..addOption('teamId',
        abbr: 't',
        help: 'Team ID of the IOS application (DEFAULT: none).',
        defaultsTo: '""');

  try {
    final results = parser.parse(arguments);

    if (results['help'] as bool) {
      _showHelp(parser);
      return;
    }

    if (results['version'] as bool) {
      print('Hybrid CLI v1.0.0');
      return;
    }

    final command = results.command;
    if (command == null) {
      _showHelp(parser);
      return;
    }

    switch (command.name) {
      case 'init':
        await InitCommand().execute(command);
        break;
      // case 'generate':
      //   await GenerateCommand().execute(command);
      //   break;
      case 'feature':
        await FeatureCommand().execute(command);
        break;
      case 'flavor':
        await FlavorHandler().execute(command);
        break;
      default:
        print('Unknown command: ${command.name}');
        _showHelp(parser);
    }
  } catch (e) {
    print('Error: $e');
    exit(1);
  }
}

void _showHelp(ArgParser parser) {
  print('');
  _logo();
  print('');
  print('Usage: hybrid <command> [arguments]');
  print('');
  print('Available commands:');
  print('  init      Initialize a new Flutter project with clean architecture');
  print('  generate  Generate specific components (model, repository, etc.)');
  print('  feature   Create a new feature module');
  print('');
  // print('generate available options:');
  // print('Usage: hybrid generate <type> <name> [feature_name]');
  // print('   or: hybrid generate <type> <name> --feature=<feature_name>');
  // print('');
  // print('Available types:');
  // print('  model         Generate a data model');
  // print('  repository    Generate a repository');
  // print('  usecase       Generate a use case');
  // print('  controller    Generate a controller');
  // print('  screen        Generate a screen');
  // print('  widget        Generate a widget');
  // print('  service       Generate a service');
  // print('');
  print('feature available options:');
  print('Usage: hybrid feature <options>');
  print('  --name        Specify the feature name');
  print('  --description Specify the feature description');
  print('  --format      Specify the format (json or keys)');
  print('  --skip-unnecessary-keys  Skip unnecessary keys of nested objects');
  print('');
  print('Global options:');
  print(parser.usage);
}

void _logo() {
  print('╔══════════════════════════════════════════════════════════════════╗');
  print('║                                                                  ║');
  print('║    Hybrid CLI - Generate Flutter code with clean architecture    ║');
  print('║                                                                  ║');
  print('║         ██╗  ██╗██╗   ██╗██████╗ ██████╗ ██╗██████╗              ║');
  print('║         ██║  ██║╚██╗ ██╔╝██╔══██╗██╔══██╗██║██╔══██╗             ║');
  print('║         ███████║ ╚████╔╝ ██████╔╝██████╔╝██║██║  ██║             ║');
  print('║         ██╔══██║  ╚██╔╝  ██╔══██╗██╔══██╗██║██║  ██║             ║');
  print('║         ██║  ██║   ██║   ██████╔╝██║  ██║██║██████╔╝             ║');
  print('║         ╚═╝  ╚═╝   ╚═╝   ╚═════╝ ╚═╝  ╚═╝╚═╝╚═════╝              ║');
  print('║                                                                  ║');
  print('║                🚀 Flutter BLoC Generator 🚀                      ║');
  print('║                                                                  ║');
  print('╚══════════════════════════════════════════════════════════════════╝');
  print('');
}

class CreateCommand extends Command {
  @override
  final name = 'create';
  @override
  final description = 'Create a new application flavor';

  void _requiredOption(List<String> option) {
    final options = List.generate(option.length, (i) => argResults?[option[i]]);

    if (options.every((test) => test == null)) {
      print('Missing required option: $option\n$usage');
      exit(1);
    }
  }

  CreateCommand() {
    argParser
      ..addOption('packageName',
          abbr: 'p', help: 'Package name for iOS and Android if common.')
      ..addOption('packageNameIos',
          abbr: 'i', help: 'Package name specific to iOS.')
      ..addOption('packageNameAndroid',
          abbr: 'a', help: 'Package name specific to Android.')
      ..addOption('displayName',
          abbr: 'd', help: 'Display name of the application.')
      ..addOption('flavorName',
          abbr: 'f', help: 'Flavor name of the application.')
      ..addOption('pathXcProject',
          abbr: 'x', help: 'Path to the Xcode project (optional).')
      ..addOption('iconsLauncher',
          help: 'Supports icons (optional).', defaultsTo: 'false')
      ..addOption('teamId',
          abbr: 't',
          help: 'Team ID of the IOS application (DEFAULT: none).',
          defaultsTo: '""');
  }

  @override
  Future<void> run() async {
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
}

class UpdateCommand extends Command {
  @override
  final name = 'update';
  @override
  final description = 'Update an existing application flavor';

  UpdateCommand() {
    argParser
      ..addOption('flavorName',
          help: 'Flavor name of the application.', mandatory: true)
      ..addOption('packageNameIos', help: 'New package name specific to iOS.')
      ..addOption('packageNameAndroid',
          help: 'New package name specific to Android.')
      ..addOption('displayNameIos', help: 'New display name specific to iOS.')
      ..addOption('displayNameAndroid',
          help: 'New display name specific to Android.')
      ..addOption('newFlavorName', help: 'New flavor name of the application.');
  }

  @override
  void run() {
    var flavorName = argResults?['flavorName'];
    var packageNameIos = argResults?['packageNameIos'];
    var packageNameAndroid = argResults?['packageNameAndroid'];
    var displayNameIos = argResults?['displayNameIos'];
    var displayNameAndroid = argResults?['displayNameAndroid'];
    var newFlavorName = argResults?['newFlavorName'];

    print('Updating flavor "$flavorName" with the following details:');
    if (packageNameIos != null) print('New Package Name iOS: $packageNameIos');
    if (packageNameAndroid != null)
      print('New Package Name Android: $packageNameAndroid');
    if (displayNameIos != null) print('New Display Name iOS: $displayNameIos');
    if (displayNameAndroid != null)
      print('New Display Name Android: $displayNameAndroid');
    if (newFlavorName != null) print('New Flavor Name: $newFlavorName');
  }
}

Future<void> runnerArgs(List<String> arguments) async {
  var runner =
      CommandRunner('flavor', 'A tool for managing application flavors')
        ..addCommand(CreateCommand())
        ..addCommand(UpdateCommand());

  await runner.run(arguments).catchError((error) {
    print(error);
    if (error is UsageException) {
      print('\n${error.usage}');
    }
  });
}
