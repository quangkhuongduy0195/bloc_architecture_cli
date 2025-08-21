import 'dart:io';
import 'package:path/path.dart' as path;
import '../templates/component_templates.dart';
import '../utils/string_utils.dart';

class ComponentGenerator {
  Future<void> generate(String projectPath, String componentType, String componentName, {String? featureName}) async {
    switch (componentType.toLowerCase()) {
      case 'model':
        await _generateModel(projectPath, componentName, featureName: featureName);
        break;
      case 'repository':
        await _generateRepository(projectPath, componentName, featureName: featureName);
        break;
      case 'usecase':
        await _generateUseCase(projectPath, componentName, featureName: featureName);
        break;
      case 'controller':
        await _generateController(projectPath, componentName, featureName: featureName);
        break;
      case 'screen':
        await _generateScreen(projectPath, componentName, featureName: featureName);
        break;
      case 'widget':
        await _generateWidget(projectPath, componentName, featureName: featureName);
        break;
      case 'service':
        await _generateService(projectPath, componentName, featureName: featureName);
        break;
      default:
        throw Exception('Unknown component type: $componentType');
    }
  }

  Future<void> _generateModel(String projectPath, String componentName, {String? featureName}) async {
    final className = StringUtils.toPascalCase(componentName);
    final fileName = StringUtils.toSnakeCase(componentName);
    
    final content = ComponentTemplates.generateModel(className);
    
    String filePath;
    String displayPath;
    
    if (featureName != null) {
      // Generate in feature directory as entity
      filePath = path.join(projectPath, 'lib', 'features', featureName, 'domain', 'entities', '${fileName}.dart');
      displayPath = 'lib/features/$featureName/domain/entities/${fileName}.dart';
    } else {
      // Generate in core directory as model
      filePath = path.join(projectPath, 'lib', 'core', 'models', '${fileName}_model.dart');
      displayPath = 'lib/core/models/${fileName}_model.dart';
    }
    
    await Directory(path.dirname(filePath)).create(recursive: true);
    await File(filePath).writeAsString(content);
    
    print('Created: $displayPath');
  }

  Future<void> _generateRepository(String projectPath, String componentName, {String? featureName}) async {
    final className = StringUtils.toPascalCase(componentName);
    final fileName = StringUtils.toSnakeCase(componentName);
    
    final abstractContent = ComponentTemplates.generateRepositoryInterface(className);
    final implContent = ComponentTemplates.generateRepositoryImplementation(className, fileName);
    
    String abstractPath, implPath;
    String displayAbstractPath, displayImplPath;
    
    if (featureName != null) {
      // Generate in feature directory
      abstractPath = path.join(projectPath, 'lib', 'features', featureName, 'domain', 'repositories', '${fileName}_repository.dart');
      implPath = path.join(projectPath, 'lib', 'features', featureName, 'data', 'repositories', '${fileName}_repository_impl.dart');
      displayAbstractPath = 'lib/features/$featureName/domain/repositories/${fileName}_repository.dart';
      displayImplPath = 'lib/features/$featureName/data/repositories/${fileName}_repository_impl.dart';
    } else {
      // Generate in core directory
      abstractPath = path.join(projectPath, 'lib', 'core', 'repositories', '${fileName}_repository.dart');
      implPath = path.join(projectPath, 'lib', 'core', 'repositories', '${fileName}_repository_impl.dart');
      displayAbstractPath = 'lib/core/repositories/${fileName}_repository.dart';
      displayImplPath = 'lib/core/repositories/${fileName}_repository_impl.dart';
    }
    
    await Directory(path.dirname(abstractPath)).create(recursive: true);
    await Directory(path.dirname(implPath)).create(recursive: true);
    await File(abstractPath).writeAsString(abstractContent);
    await File(implPath).writeAsString(implContent);
    
    print('Created: $displayAbstractPath');
    print('Created: $displayImplPath');
  }

  Future<void> _generateUseCase(String projectPath, String componentName, {String? featureName}) async {
    final className = StringUtils.toPascalCase(componentName);
    final fileName = StringUtils.toSnakeCase(componentName);
    
    final content = ComponentTemplates.generateUseCase(className, fileName);
    
    String filePath, displayPath;
    
    if (featureName != null) {
      filePath = path.join(projectPath, 'lib', 'features', featureName, 'domain', 'usecases', '${fileName}_usecase.dart');
      displayPath = 'lib/features/$featureName/domain/usecases/${fileName}_usecase.dart';
    } else {
      filePath = path.join(projectPath, 'lib', 'core', 'usecases', '${fileName}_usecase.dart');
      displayPath = 'lib/core/usecases/${fileName}_usecase.dart';
    }
    
    await Directory(path.dirname(filePath)).create(recursive: true);
    await File(filePath).writeAsString(content);
    
    print('Created: $displayPath');
  }

  Future<void> _generateController(String projectPath, String componentName, {String? featureName}) async {
    final className = StringUtils.toPascalCase(componentName);
    final fileName = StringUtils.toSnakeCase(componentName);
    
    final content = ComponentTemplates.generateController(className, fileName);
    
    String filePath, displayPath;
    
    if (featureName != null) {
      filePath = path.join(projectPath, 'lib', 'features', featureName, 'presentation', 'controllers', '${fileName}_controller.dart');
      displayPath = 'lib/features/$featureName/presentation/controllers/${fileName}_controller.dart';
    } else {
      filePath = path.join(projectPath, 'lib', 'core', 'controllers', '${fileName}_controller.dart');
      displayPath = 'lib/core/controllers/${fileName}_controller.dart';
    }
    
    await Directory(path.dirname(filePath)).create(recursive: true);
    await File(filePath).writeAsString(content);
    
    print('Created: $displayPath');
  }

  Future<void> _generateScreen(String projectPath, String componentName, {String? featureName}) async {
    final className = StringUtils.toPascalCase(componentName);
    final fileName = StringUtils.toSnakeCase(componentName);
    
    final content = ComponentTemplates.generateScreen(className, fileName);
    
    String filePath, displayPath;
    
    if (featureName != null) {
      filePath = path.join(projectPath, 'lib', 'features', featureName, 'presentation', 'screens', '${fileName}_screen.dart');
      displayPath = 'lib/features/$featureName/presentation/screens/${fileName}_screen.dart';
    } else {
      filePath = path.join(projectPath, 'lib', 'core', 'screens', '${fileName}_screen.dart');
      displayPath = 'lib/core/screens/${fileName}_screen.dart';
    }
    
    await Directory(path.dirname(filePath)).create(recursive: true);
    await File(filePath).writeAsString(content);
    
    print('Created: $displayPath');
  }

  Future<void> _generateWidget(String projectPath, String componentName, {String? featureName}) async {
    final className = StringUtils.toPascalCase(componentName);
    final fileName = StringUtils.toSnakeCase(componentName);
    
    final content = ComponentTemplates.generateWidget(className);
    
    String filePath, displayPath;
    
    if (featureName != null) {
      filePath = path.join(projectPath, 'lib', 'features', featureName, 'presentation', 'widgets', '${fileName}_widget.dart');
      displayPath = 'lib/features/$featureName/presentation/widgets/${fileName}_widget.dart';
    } else {
      filePath = path.join(projectPath, 'lib', 'core', 'widgets', '${fileName}_widget.dart');
      displayPath = 'lib/core/widgets/${fileName}_widget.dart';
    }
    
    await Directory(path.dirname(filePath)).create(recursive: true);
    await File(filePath).writeAsString(content);
    
    print('Created: $displayPath');
  }

  Future<void> _generateService(String projectPath, String componentName, {String? featureName}) async {
    final className = StringUtils.toPascalCase(componentName);
    final fileName = StringUtils.toSnakeCase(componentName);
    
    final content = ComponentTemplates.generateService(className);
    
    String filePath, displayPath;
    
    if (featureName != null) {
      filePath = path.join(projectPath, 'lib', 'features', featureName, 'data', 'datasources', '${fileName}_service.dart');
      displayPath = 'lib/features/$featureName/data/datasources/${fileName}_service.dart';
    } else {
      filePath = path.join(projectPath, 'lib', 'core', 'services', '${fileName}_service.dart');
      displayPath = 'lib/core/services/${fileName}_service.dart';
    }
    
    await Directory(path.dirname(filePath)).create(recursive: true);
    await File(filePath).writeAsString(content);
    
    print('Created: $displayPath');
  }
}
