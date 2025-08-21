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
  }

  Future<void> _createFeatureDirectories(String featureDir) async {
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
  }

  Future<void> _generateFeatureFiles(String featureDir, String featureName) async {
    final className = StringUtils.toPascalCase(featureName);
    final fileName = StringUtils.toSnakeCase(featureName);

    // Domain layer
    await File(path.join(featureDir, 'domain', 'entities', '${fileName}_entity.dart'))
        .writeAsString(FeatureTemplates.generateEntity(className));

    await File(path.join(featureDir, 'domain', 'repositories', '${fileName}_repository.dart'))
        .writeAsString(FeatureTemplates.generateRepository(className));

    await File(path.join(featureDir, 'domain', 'usecases', 'get_${fileName}.dart'))
        .writeAsString(FeatureTemplates.generateUseCase(className, fileName));

    // Data layer
    await File(path.join(featureDir, 'data', 'models', '${fileName}_model.dart'))
        .writeAsString(FeatureTemplates.generateModel(className, fileName));

    await File(path.join(featureDir, 'data', 'datasources', '${fileName}_remote_datasource.dart'))
        .writeAsString(FeatureTemplates.generateRemoteDataSource(className, fileName));

    await File(path.join(featureDir, 'data', 'datasources', '${fileName}_local_datasource.dart'))
        .writeAsString(FeatureTemplates.generateLocalDataSource(className, fileName));

    await File(path.join(featureDir, 'data', 'repositories', '${fileName}_repository_impl.dart'))
        .writeAsString(FeatureTemplates.generateRepositoryImpl(className, fileName));

    // Presentation layer
    await File(path.join(featureDir, 'presentation', 'controllers', '${fileName}_controller.dart'))
        .writeAsString(FeatureTemplates.generateController(className, fileName));

    await File(path.join(featureDir, 'presentation', 'screens', '${fileName}_screen.dart'))
        .writeAsString(FeatureTemplates.generateScreen(className, fileName));

    await File(path.join(featureDir, 'presentation', 'widgets', '${fileName}_widget.dart'))
        .writeAsString(FeatureTemplates.generateWidget(className, fileName));
  }
}
