import 'dart:io';
import 'package:path/path.dart' as path;
import '../templates/simple_templates.dart';

class ProjectGenerator {
  Future<void> generate(String projectPath, String projectName) async {
    // Create main project directory
    final projectDir = Directory(projectPath);
    await projectDir.create(recursive: true);

    // Create lib directory structure
    await _createDirectoryStructure(projectPath);

    // Generate main files
    await _generateMainFiles(projectPath, projectName);

    // Generate core files
    await _generateCoreFiles(projectPath);

    // Generate example feature
    await _generateExampleFeature(projectPath);
  }

  Future<void> _createDirectoryStructure(String projectPath) async {
    final directories = [
      'lib',
      'lib/root',
      'lib/core',
      'lib/core/auth',
      'lib/core/error',
      'lib/core/feature_flags',
      'lib/core/images',
      'lib/core/l10n',
      'lib/core/network',
      'lib/core/storage',
      'lib/core/theme',
      'lib/core/ui',
      'lib/core/utils',
      'lib/core/usecases',
      'lib/core/updates',
      'lib/features',
      'lib/gen',
      'lib/l10n',
      'lib/l10n/arb',
      'test',
      'test/features',
      'test/core',
    ];

    for (final dir in directories) {
      final directory = Directory(path.join(projectPath, dir));
      await directory.create(recursive: true);
    }
  }

  Future<void> _generateMainFiles(
      String projectPath, String projectName) async {
    // Generate pubspec.yaml
    final pubspecContent = ProjectTemplates.generatePubspec(projectName);
    await File(path.join(projectPath, 'pubspec.yaml'))
        .writeAsString(pubspecContent);

    // Generate main.dart
    final mainContent = ProjectTemplates.generateMain();
    await File(path.join(projectPath, 'lib', 'main.dart'))
        .writeAsString(mainContent);

    // Generate root.dart
    final rootContent = ProjectTemplates.generateRoot();
    await File(path.join(projectPath, 'lib', 'root', 'root.dart'))
        .writeAsString(rootContent);

    // Generate README.md
    final readmeContent = ProjectTemplates.generateReadme(projectName);
    await File(path.join(projectPath, 'README.md'))
        .writeAsString(readmeContent);
  }

  Future<void> _generateCoreFiles(String projectPath) async {
    // Generate core barrel files
    await File(path.join(projectPath, 'lib', 'core', 'core.dart'))
        .writeAsString(ProjectTemplates.generateCoreBarrel());

    // Generate error files
    await File(path.join(projectPath, 'lib', 'core', 'error', 'failures.dart'))
        .writeAsString(ProjectTemplates.generateFailures());

    await File(
            path.join(projectPath, 'lib', 'core', 'error', 'exceptions.dart'))
        .writeAsString(ProjectTemplates.generateExceptions());

    // Generate usecase files
    await File(
            path.join(projectPath, 'lib', 'core', 'usecases', 'usecase.dart'))
        .writeAsString(ProjectTemplates.generateUseCase());
  }

  Future<void> _generateExampleFeature(String projectPath) async {
    final featureDir = path.join(projectPath, 'lib', 'features', 'example');

    // Create feature directories
    final directories = [
      path.join(featureDir, 'data', 'datasources'),
      path.join(featureDir, 'data', 'models'),
      path.join(featureDir, 'data', 'repositories'),
      path.join(featureDir, 'domain', 'entities'),
      path.join(featureDir, 'domain', 'repositories'),
      path.join(featureDir, 'domain', 'usecases'),
      path.join(featureDir, 'presentation', 'controllers'),
      path.join(featureDir, 'presentation', 'screens'),
      path.join(featureDir, 'presentation', 'widgets'),
    ];

    for (final dir in directories) {
      await Directory(dir).create(recursive: true);
    }

    // Create placeholder files
    await File(path.join(featureDir, 'README.md'))
        .writeAsString('# Example Feature\\n\\nThis is an example feature.');
  }
}
