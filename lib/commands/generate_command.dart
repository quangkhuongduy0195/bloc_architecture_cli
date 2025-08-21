import 'dart:io';
import 'package:args/args.dart';
import '../generators/component_generator.dart';

class GenerateCommand {
  Future<void> execute(ArgResults results) async {
    final args = results.rest;
    
    if (args.isEmpty) {
      _showUsage();
      return;
    }
    
    String? componentType;
    String? componentName;
    String? featureName;
    
    // Parse arguments: type name [feature]
    if (args.length >= 1) {
      componentType = args[0];
    }
    if (args.length >= 2) {
      componentName = args[1];
    }
    
    // Check for --feature option first, then positional argument
    if (results.wasParsed('feature')) {
      featureName = results['feature'] as String?;
    } else if (args.length >= 3) {
      featureName = args[2];
    }
    
    if (componentType == null || componentName == null) {
      _showUsage();
      return;
    }

    final currentDir = Directory.current.path;
    
    // Check if we're in a Flutter project
    final pubspecFile = File('$currentDir/pubspec.yaml');
    if (!pubspecFile.existsSync()) {
      print('Error: Not in a Flutter project directory. Please run this command from the root of your Flutter project.');
      return;
    }

    if (featureName != null) {
      // Check if feature exists
      final featureDir = Directory('$currentDir/lib/features/$featureName');
      if (!featureDir.existsSync()) {
        print('Error: Feature "$featureName" does not exist. Please create it first with:');
        print('  hybrid feature $featureName');
        return;
      }
      print('Generating $componentType: $componentName in feature "$featureName"');
    } else {
      print('Generating $componentType: $componentName in core');
    }
    
    await ComponentGenerator().generate(currentDir, componentType, componentName, featureName: featureName);
    
    if (featureName != null) {
      print('✓ $componentType "$componentName" generated successfully in feature "$featureName"!');
    } else {
      print('✓ $componentType "$componentName" generated successfully in core!');
    }
  }

  void _showUsage() {
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
    print('Examples:');
    print('  hybrid generate model User                        # Creates in lib/core/models/');
    print('  hybrid generate model User auth                   # Creates in lib/features/auth/domain/entities/');
    print('  hybrid generate model User --feature=auth        # Creates in lib/features/auth/domain/entities/');
    print('  hybrid generate repository UserRepo --feature=auth  # Creates in lib/features/auth/');
  }
}
