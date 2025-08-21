import 'dart:io';
import 'package:args/args.dart';
import 'package:path/path.dart' as path;
import '../generators/project_generator.dart';

class InitCommand {
  Future<void> execute(ArgResults results) async {
    final projectName = results.rest.isNotEmpty ? results.rest.first : null;
    
    if (projectName == null) {
      print('Please provide a project name: flutter_gen init <project_name>');
      return;
    }

    final currentDir = Directory.current.path;
    final projectPath = path.join(currentDir, projectName);
    
    print('Creating Flutter project with clean architecture...');
    print('Project path: $projectPath');
    
    await ProjectGenerator().generate(projectPath, projectName);
    
    print('✓ Project created successfully!');
    print('');
    print('Next steps:');
    print('  cd $projectName');
    print('  flutter pub get');
    print('  flutter run');
  }
}
