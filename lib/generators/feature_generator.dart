import 'dart:io';
import 'package:path/path.dart' as path;
import '../templates/feature_templates.dart';
import '../utils/string_utils.dart';

class FeatureGenerator {
  Future<void> generate(String projectPath, String featureName) async {
    final featureDir = path.join(projectPath, 'lib', 'features', featureName);

    // Create feature directories
    await _createFeatureDirectories(featureDir);

    // Generate feature files
    await _generateFeatureFiles(featureDir, featureName);

    // Update app routes
    await _updateAppRoutes(projectPath, featureName);

    await _commandBuildRunner(projectPath);
  }

  Future<void> _createFeatureDirectories(String featureDir) async {
    final directories = [
      path.join(featureDir, 'data', 'datasources'),
      path.join(featureDir, 'data', 'models'),
      path.join(featureDir, 'data', 'repositories'),
      path.join(featureDir, 'domain', 'entities'),
      path.join(featureDir, 'domain', 'repositories'),
      path.join(featureDir, 'domain', 'usecases'),
      path.join(featureDir, 'domain', 'services'),
      path.join(featureDir, 'presentation', 'bloc'),
      path.join(featureDir, 'presentation', 'pages'),
      path.join(featureDir, 'presentation', 'widgets'),
    ];

    for (final dir in directories) {
      await Directory(dir).create(recursive: true);
    }
  }

  Future<void> _generateFeatureFiles(
      String featureDir, String featureName) async {
    final className = StringUtils.toPascalCase(featureName);
    final fileName = StringUtils.toSnakeCase(featureName);

    // Domain layer
    await File(path.join(
            featureDir, 'domain', 'entities', '${fileName}_entity.dart'))
        .writeAsString(FeatureTemplates.generateEntity(className, fileName));

    await File(path.join(featureDir, 'domain', 'repositories',
            '${fileName}_repository.dart'))
        .writeAsString(
            FeatureTemplates.generateRepository(className, fileName));

    await File(
            path.join(featureDir, 'domain', 'usecases', 'get_${fileName}.dart'))
        .writeAsString(FeatureTemplates.generateUseCase(className, fileName));

    await File(path.join(
            featureDir, 'domain', 'services', '${fileName}_service.dart'))
        .writeAsString(FeatureTemplates.generateService(className, fileName));

    // Data layer
    await File(
            path.join(featureDir, 'data', 'models', '${fileName}_model.dart'))
        .writeAsString(FeatureTemplates.generateModel(className, fileName));

    await File(path.join(featureDir, 'data', 'datasources',
            '${fileName}_remote_datasource.dart'))
        .writeAsString(
            FeatureTemplates.generateRemoteDataSource(className, fileName));

    await File(path.join(featureDir, 'data', 'datasources',
            '${fileName}_local_datasource.dart'))
        .writeAsString(
            FeatureTemplates.generateLocalDataSource(className, fileName));

    await File(path.join(featureDir, 'data', 'repositories',
            '${fileName}_repository_impl.dart'))
        .writeAsString(
            FeatureTemplates.generateRepositoryImpl(className, fileName));

    // Presentation layer
    await File(path.join(
            featureDir, 'presentation', 'bloc', '${fileName}_bloc.dart'))
        .writeAsString(FeatureTemplates.generateBloc(className, fileName));

    await File(path.join(
            featureDir, 'presentation', 'bloc', '${fileName}_event.dart'))
        .writeAsString(FeatureTemplates.generateEvent(className, fileName));

    await File(path.join(
            featureDir, 'presentation', 'bloc', '${fileName}_state.dart'))
        .writeAsString(FeatureTemplates.generateState(className, fileName));

    await File(path.join(
            featureDir, 'presentation', 'pages', '${fileName}_page.dart'))
        .writeAsString(FeatureTemplates.generatePage(className, fileName));

    await File(path.join(
            featureDir, 'presentation', 'widgets', '${fileName}_widget.dart'))
        .writeAsString(FeatureTemplates.generateWidget(className, fileName));
  }

  Future<void> _updateAppRoutes(String projectPath, String featureName) async {
    final appRoutesPath =
        path.join(projectPath, 'lib', 'core', 'routes', 'app_routes.dart');
    final appRoutesFile = File(appRoutesPath);

    if (!await appRoutesFile.exists()) {
      print('Warning: app_routes.dart not found at $appRoutesPath');
      return;
    }

    final className = StringUtils.toPascalCase(featureName);

    // Re-read the updated content
    final updatedContent = await appRoutesFile.readAsString();

    // Create new route entry
    final newRoute = '''    CustomRoute(
      page: ${className}Route.page,
      path: '/${featureName.toLowerCase()}',
      transitionsBuilder: customAnimation,
    ),
''';

    // Find the position to insert (before the closing ]);
    final pattern = RegExp(r'(\s*)\];');
    final match = pattern.firstMatch(updatedContent);

    if (match != null) {
      final finalContent =
          updatedContent.replaceFirst(pattern, '$newRoute${match.group(1)}];');
      await appRoutesFile.writeAsString(finalContent);
      print('✅ Added route for $featureName feature to app_routes.dart');
    } else {
      print('Warning: Could not find routes list in app_routes.dart');
    }
  }

  Future<void> _commandBuildRunner(String projectPath) async {
    print('🚀 Running build_runner to generate necessary files...');
    final result = await Process.run(
      'flutter',
      ['pub', 'run', 'build_runner', 'build', '-d'],
      workingDirectory: projectPath,
      runInShell: true,
    );

    if (result.exitCode == 0) {
      print('✅ Successfully ran build_runner');
    } else {
      print('❌ build_runner failed with exit code ${result.exitCode}');
      print(result.stdout);
      print(result.stderr);
    }
  }
}
