import 'dart:io';
import 'package:args/args.dart';
import '../lib/commands/generate_command.dart';
import '../lib/commands/init_command.dart';
import '../lib/commands/feature_command.dart';

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addCommand('init')
    ..addCommand('feature')
    ..addFlag('help', abbr: 'h', help: 'Show usage information')
    ..addFlag('version', abbr: 'v', help: 'Show version information');

  // Add generate command with --feature option
  final generateCommand = parser.addCommand('generate');
  generateCommand.addOption('feature',
      help: 'Generate component in specific feature directory');

  // Add locale command with options
  final localeCommand = parser.addCommand('locale');
  localeCommand.addOption(
    'source-dir',
    abbr: 'S',
    defaultsTo: 'lib/l10n',
    help: 'Folder containing localization files',
  );
  localeCommand.addOption(
    'source-file',
    abbr: 's',
    help: 'File to use for localization',
  );
  localeCommand.addOption(
    'output-dir',
    abbr: 'O',
    defaultsTo: 'lib/core/collections',
    help: 'Output folder stores for the generated file',
  );
  localeCommand.addOption(
    'output-file',
    abbr: 'o',
    defaultsTo: 'locale_keys.g.dart',
    help: 'Output file name',
  );
  localeCommand.addOption(
    'format',
    abbr: 'f',
    defaultsTo: 'keys',
    help: 'Support json or keys formats',
    allowed: ['json', 'keys'],
  );
  localeCommand.addFlag(
    'skip-unnecessary-keys',
    abbr: 'u',
    defaultsTo: false,
    help: 'If true - Skip unnecessary keys of nested objects.',
  );

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
      case 'generate':
        await GenerateCommand().execute(command);
        break;
      case 'feature':
        await FeatureCommand().execute(command);
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
  print('generate available options:');
  print('Usage: hybrid generate <type> <name> [feature_name]');
  print('   or: hybrid generate <type> <name> --feature=<feature_name>');
  print('');
  print('Available types:');
  print('  model         Generate a data model');
  print('  repository    Generate a repository');
  print('  usecase       Generate a use case');
  print('  controller    Generate a controller');
  print('  screen        Generate a screen');
  print('  widget        Generate a widget');
  print('  service       Generate a service');
  print('');
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
