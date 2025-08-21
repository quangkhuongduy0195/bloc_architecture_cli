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
  print('Hybrid CLI - Generate Flutter code with clean architecture');
  print('');
  print('Usage: hybrid <command> [arguments]');
  print('');
  print('Available commands:');
  print('  init      Initialize a new Flutter project with clean architecture');
  print('  generate  Generate specific components (model, repository, etc.)');
  print('  feature   Create a new feature module');
  print('');
  print('Global options:');
  print(parser.usage);
}
