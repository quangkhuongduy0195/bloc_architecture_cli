import 'dart:io';
import 'package:args/args.dart';
import 'package:hybrid_cli/create_flavor/create_flavor.dart';
import '../lib/commands/init_command.dart';
import '../lib/commands/feature_command.dart';

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addCommand('init')
    ..addCommand('feature')
    ..addFlag('help', abbr: 'h', help: 'Show usage information')
    ..addFlag('version', abbr: 'v', help: 'Show version information');

  // Add flavor command with options
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
      print('Hybrid CLI v1.0.1');
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
  _helpCommand(parser);
}

void _logo() {
  // ANSI color codes
  const String cyan = '\x1B[36m'; // Cyan
  const String blue = '\x1B[34m'; // Blue
  const String magenta = '\x1B[35m'; // Magenta
  const String yellow = '\x1B[33m'; // Yellow
  const String red = '\x1B[31m'; // Red
  const String green = '\x1B[32m'; // Green
  const String reset = '\x1B[0m'; // Reset color
  const String bold = '\x1B[1m'; // Bold text

  print(
      '${cyan}╔══════════════════════════════════════════════════════════════════╗${reset}');
  print(
      '${cyan}║                                                                  ║${reset}');
  print(
      '${cyan}║    ${bold}${blue}Hybrid CLI - Generate Flutter code with clean architecture${reset}${cyan}    ║${reset}');
  print(
      '${cyan}║                                                                  ║${reset}');
  // Gradient effect: Red -> Magenta -> Blue -> Cyan -> Green -> Yellow
  print(
      '${cyan}║         ${bold}${red}██╗  ██╗${magenta}██╗   ██╗${blue}██████╗ ${cyan}██████╗ ${green}██╗${yellow}██████╗${reset}${cyan}              ║${reset}');
  print(
      '${cyan}║         ${bold}${red}██║  ██║${magenta}╚██╗ ██╔╝${blue}██╔══██╗${cyan}██╔══██╗${green}██║${yellow}██╔══██╗${reset}${cyan}             ║${reset}');
  print(
      '${cyan}║         ${bold}${red}███████║${magenta} ╚████╔╝ ${blue}██████╔╝${cyan}██████╔╝${green}██║${yellow}██║  ██║${reset}${cyan}             ║${reset}');
  print(
      '${cyan}║         ${bold}${red}██╔══██║${magenta}  ╚██╔╝  ${blue}██╔══██╗${cyan}██╔══██╗${green}██║${yellow}██║  ██║${reset}${cyan}             ║${reset}');
  print(
      '${cyan}║         ${bold}${red}██║  ██║${magenta}   ██║   ${blue}██████╔╝${cyan}██║  ██║${green}██║${yellow}██████╔╝${reset}${cyan}             ║${reset}');
  print(
      '${cyan}║         ${bold}${red}╚═╝  ╚═╝${magenta}   ╚═╝   ${blue}╚═════╝ ${cyan}╚═╝  ╚═╝${green}╚═╝${yellow}╚═════╝${reset}${cyan}              ║${reset}');
  print(
      '${cyan}║                                                                  ║${reset}');
  print(
      '${cyan}║                ${bold}${yellow}🚀 Flutter BLoC Generator 🚀${reset}${cyan}                      ║${reset}');
  print(
      '${cyan}║                                                                  ║${reset}');
  print(
      '${cyan}╚══════════════════════════════════════════════════════════════════╝${reset}');
  print('');
}

void _helpCommand(ArgParser parser) {
  // ANSI color codes
  const cyan = '\x1B[36m'; // Cyan
  const yellow = '\x1B[33m'; // Yellow
  const green = '\x1B[32m'; // Green
  const blue = '\x1B[34m'; // Blue
  const magenta = '\x1B[35m'; // Magenta
  const bold = '\x1B[1m'; // Bold
  const reset = '\x1B[0m'; // Reset

  print(
      '${bold}${cyan}Usage:${reset} ${bold}hybrid <command> [arguments]${reset}');
  print('');

  print('${bold}${yellow}📚 Available Commands:${reset}');
  print(
      '  ${bold}${green}init${reset}      🚀 Initialize a new Flutter project with clean architecture');
  print(
      '  ${bold}${green}feature${reset}   📦 Create a new feature module with BLoC pattern');
  print(
      '  ${bold}${green}flavor${reset}    🎯 Create and manage app flavors (staging, production, etc.)');
  print('');

  print('${bold}${yellow}📖 Command Details:${reset}');
  print('');

  // Init command
  print('${bold}${blue}■ init${reset} - Project Initialization');
  print('  Creates a new Flutter project with clean architecture structure');
  print('  ${bold}Usage:${reset} hybrid init <project_name>');
  print(
      '  ${bold}Example:${reset} ${magenta}hybrid init my_awesome_app${reset}');
  print('');

  // Feature command
  print('${bold}${blue}■ feature${reset} - Feature Module Generator');
  print('  Creates a complete feature module with BLoC pattern');
  print('  ${bold}Usage:${reset} hybrid feature [options]');
  print('  ${bold}Options:${reset}');
  print(
      '    ${green}--name${reset}                      Feature name (required)');
  print('    ${green}--description${reset}               Feature description');
  print(
      '    ${green}--format${reset}                    Output format (json or keys)');
  print(
      '    ${green}--skip-unnecessary-keys${reset}     Skip unnecessary nested keys');
  print(
      '  ${bold}Example:${reset} ${magenta}hybrid feature --name auth --description "User authentication"${reset}');
  print('');

  // Flavor command
  print('${bold}${blue}■ flavor${reset} - App Flavor Management');
  print(
      '  Creates and manages different app environments (staging, production, etc.)');
  print('  ${bold}Usage:${reset} hybrid flavor [options]');
  print('  ${bold}Options:${reset}');
  print(
      '    ${green}-p, --packageName${reset}           Package name for both platforms');
  print(
      '    ${green}-i, --packageNameIos${reset}        iOS-specific package name');
  print(
      '    ${green}-a, --packageNameAndroid${reset}    Android-specific package name');
  print('    ${green}-d, --displayName${reset}           App display name');
  print(
      '    ${green}-f, --flavorName${reset}            Flavor name (staging, dev, prod, etc.)');
  print(
      '    ${green}-x, --pathXcProject${reset}         Path to Xcode project (optional)');
  print(
      '    ${green}-t, --teamId${reset}                iOS Team ID (optional)');
  print(
      '    ${green}--iconsLauncher${reset}             Enable custom icons (default: false)');
  print('');
  print('  ${bold}Examples:${reset}');
  print('    ${magenta}# Simple staging flavor${reset}');
  print(
      '    ${magenta}hybrid flavor -p com.example.app.staging -d "App Staging" -f staging${reset}');
  print('');
  print('    ${magenta}# Different package names for each platform${reset}');
  print(
      '    ${magenta}hybrid flavor -i com.example.ios.dev -a com.example.android.dev -d "Dev Build" -f dev${reset}');
  print('');

  print('${bold}${yellow}⚙️  Global Options:${reset}');
  print('  ${green}-h, --help${reset}        Show this help information');
  print('  ${green}-v, --version${reset}     Show version information');
  print('');

  print('${bold}${yellow}💡 Quick Start Examples:${reset}');
  print(
      '  ${magenta}hybrid init my_flutter_app${reset}                           # Create new project');
  print(
      '  ${magenta}hybrid feature --name user --description "User management"${reset}   # Add feature');
  print(
      '  ${magenta}hybrid flavor -p com.myapp.staging -d "Staging" -f staging${reset}   # Add flavor');
  print(
      '  ${magenta}hybrid --help${reset}                                        # Show help');
  print('');

  print('${bold}${cyan}🌐 More Information:${reset}');
  print(
      '  Documentation: ${blue}https://github.com/your-repo/hybrid-cli${reset}');
  print(
      '  Issues & Support: ${blue}https://github.com/your-repo/hybrid-cli/issues${reset}');
  print('');
}
