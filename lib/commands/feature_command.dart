import 'dart:io';
import 'package:args/args.dart';
import '../generators/feature_generator.dart';

class FeatureCommand {
  Future<void> execute(ArgResults results) async {
    final featureName = results.rest.isNotEmpty ? results.rest.first : null;
    
    if (featureName == null) {
      print('Please provide a feature name: flutter_gen feature <feature_name>');
      return;
    }

    final currentDir = Directory.current.path;
    
    // Check if we're in a Flutter project
    final pubspecFile = File('$currentDir/pubspec.yaml');
    if (!pubspecFile.existsSync()) {
      print('Error: Not in a Flutter project directory. Please run this command from the root of your Flutter project.');
      return;
    }

    print('Creating feature: $featureName');
    
    await FeatureGenerator().generate(currentDir, featureName);
    
    print('✓ Feature "$featureName" created successfully!');
    print('');
    print('Generated files:');
    print('  lib/features/$featureName/data/');
    print('  lib/features/$featureName/domain/');
    print('  lib/features/$featureName/presentation/');
  }
}
