import 'dart:io';
import 'package:hybrid_cli/templates/core/common/app_user/app_user_cubit.dart';
import 'package:hybrid_cli/templates/core/l10n/translations.dart';
import 'package:path/path.dart' as path;
import '../templates/core/collections/collections.dart';
import '../templates/core/collections/language_codes.dart';
import '../templates/core/common/app_user/app_user_state.dart';
import '../templates/core/common/base/app_bloc_observer.dart';
import '../templates/core/common/base/base_bloc.dart';
import '../templates/core/common/base/base_event.dart';
import '../templates/core/common/base/base_state.dart';
import '../templates/core/common/base/mixin/api_error_handler_mixin.dart';
import '../templates/core/common/base/mixin/log_mixin.dart';
import '../templates/core/common/base/mixin/persisted_mixin.dart';
import '../templates/core/common/common/common_bloc.dart';
import '../templates/core/common/common/common_event.dart';
import '../templates/core/common/common/common_state.dart';
import '../templates/core/config.dart';
import '../templates/core/errors/exception.dart';
import '../templates/core/extensions/constants.dart';
import '../templates/core/extensions/context_extension.dart';
import '../templates/core/extensions/extensions.dart';
import '../templates/core/extensions/keys_ext.dart';
import '../templates/core/extensions/map.dart';
import '../templates/core/extensions/string_ext.dart';
import '../templates/core/l10n/app_localization.dart';
import '../templates/core/l10n/app_localization_app.dart';
import '../templates/core/l10n/asset_loader.dart';
import '../templates/core/l10n/exceptions.dart';
import '../templates/core/l10n/localization.dart';
import '../templates/core/l10n/plural_rules.dart';
import '../templates/core/l10n/public.dart';
import '../templates/core/l10n/public_ext.dart';
import '../templates/core/l10n/utils.dart';
import '../templates/core/network/api_client.dart';
import '../templates/core/network/connection_checker.dart';
import '../templates/core/network/network_info.dart';
import '../templates/core/routes/app_routes.dart';
import '../templates/core/styles/dimensions.dart';
import '../templates/core/styles/theme.dart';
import '../templates/core/usecase/usecase.dart';
import '../templates/core/utils/logger.dart';
import '../templates/core/utils/preferences.dart';
import '../templates/di/injection.dart';
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

    await _generateDiFiles(projectPath);

    // Generate example feature
    await _generateExampleFeature(projectPath);
  }

  Future<void> _createDirectoryStructure(String projectPath) async {
    final directories = [
      'lib',
      'lib/root',
      'lib/core',
      'lib/core/collections',
      'lib/core/common',
      'lib/core/common/app_user',
      'lib/core/common/base',
      'lib/core/common/base/mixin',
      'lib/core/common/common',
      'lib/core/error',
      'lib/core/extensions',
      'lib/core/l10n',
      'lib/core/network',
      'lib/core/routes',
      'lib/core/styles',
      'lib/core/usecases',
      'lib/core/utils',
      'lib/di',
      'lib/core/storage',
      'lib/core/theme',
      'lib/core/ui',
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
    await File(path.join(projectPath, 'lib', 'core', 'config.dart'))
        .writeAsString(ConfigGenerator.gen());

    // Generate collections files
    await File(path.join(
            projectPath, 'lib', 'core', 'collections', 'collections.dart'))
        .writeAsString(CollectionsGenerator.gen());

    // Generate fake file
    await File(
            path.join(projectPath, 'lib', 'core', 'collections', 'fake.dart'))
        .writeAsString(CollectionsGenerator.genFake());

    // Generate language codes file
    await File(path.join(
            projectPath, 'lib', 'core', 'collections', 'language_codes.dart'))
        .writeAsString(LanguageCodesGenerator.gen());

    // Generate Common
    await File(path.join(
      projectPath,
      'lib',
      'core',
      'common',
      'app_user',
      'app_user_cubit.dart',
    )).writeAsString(AppUserCubitGenerator.gen());

    await File(path.join(
      projectPath,
      'lib',
      'core',
      'common',
      'app_user',
      'app_user_state.dart',
    )).writeAsString(AppUserStateGenerator.gen());

    await File(path.join(
      projectPath,
      'lib',
      'core',
      'common',
      'base',
      'mixin',
      'api_error_handler_mixin.dart',
    )).writeAsString(
      ApiErrorHandlerMixinGenerator.gen(),
    );

    await File(path.join(
      projectPath,
      'lib',
      'core',
      'common',
      'base',
      'mixin',
      'log_mixin.dart',
    )).writeAsString(
      LogMixinGenerator.gen(),
    );

    await File(path.join(
      projectPath,
      'lib',
      'core',
      'common',
      'base',
      'mixin',
      'persisted_mixin.dart',
    )).writeAsString(
      PersistedMixinGenerator.gen(),
    );

    await File(path.join(
      projectPath,
      'lib',
      'core',
      'common',
      'base',
      'app_bloc_observer.dart',
    )).writeAsString(
      AppBlocObserverGenerator.gen(),
    );

    await File(path.join(
      projectPath,
      'lib',
      'core',
      'common',
      'base',
      'base_bloc.dart',
    )).writeAsString(
      BaseBlocGenerator.gen(),
    );

    await File(path.join(
      projectPath,
      'lib',
      'core',
      'common',
      'base',
      'base_event.dart',
    )).writeAsString(
      BlocEventGenerator.gen(),
    );

    await File(path.join(
      projectPath,
      'lib',
      'core',
      'common',
      'base',
      'base_state.dart',
    )).writeAsString(
      BaseStateGenerator.gen(),
    );

    await File(path.join(
      projectPath,
      'lib',
      'core',
      'common',
      'common',
      'common_bloc.dart',
    )).writeAsString(
      CommonBlocGenerator.gen(),
    );

    await File(path.join(
      projectPath,
      'lib',
      'core',
      'common',
      'common',
      'common_event.dart',
    )).writeAsString(
      CommonEventGenerator.gen(),
    );

    await File(path.join(
      projectPath,
      'lib',
      'core',
      'common',
      'common',
      'common_state.dart',
    )).writeAsString(
      CommonStateGenerator.gen(),
    );

    await File(path.join(
      projectPath,
      'lib',
      'core',
      'error',
      'exception.dart',
    )).writeAsString(
      ExceptionGenerator.gen(),
    );

    await File(path.join(
      projectPath,
      'lib',
      'core',
      'extensions',
      'constants.dart',
    )).writeAsString(
      CconstantsGenerator.gen(),
    );

    await File(path.join(
      projectPath,
      'lib',
      'core',
      'extensions',
      'context_extension.dart',
    )).writeAsString(
      ContextExtensionGenerator.gen(),
    );

    await File(path.join(
      projectPath,
      'lib',
      'core',
      'extensions',
      'extensions.dart',
    )).writeAsString(
      ExtensionsGenerator.gen(),
    );

    await File(path.join(
      projectPath,
      'lib',
      'core',
      'extensions',
      'keys_ext.dart',
    )).writeAsString(
      KeysExtGenerator.gen(),
    );

    await File(path.join(
      projectPath,
      'lib',
      'core',
      'extensions',
      'map.dart',
    )).writeAsString(
      MapGenerator.gen(),
    );

    await File(path.join(
      projectPath,
      'lib',
      'core',
      'extensions',
      'string_ext.dart',
    )).writeAsString(
      StringExtGenerator.gen(),
    );

    await File(path.join(
      projectPath,
      'lib',
      'core',
      'l10n',
      'app_localization_app.dart',
    )).writeAsString(
      l10nAppLocalizationAppGenerator.gen(),
    );

    await File(path.join(
      projectPath,
      'lib',
      'core',
      'l10n',
      'app_localization.dart',
    )).writeAsString(
      l10nAppLocalizationGenerator.gen(),
    );

    await File(path.join(
      projectPath,
      'lib',
      'core',
      'l10n',
      'asset_loader.dart',
    )).writeAsString(
      l10nAssetLoaderGenerator.gen(),
    );

    await File(path.join(
      projectPath,
      'lib',
      'core',
      'l10n',
      'exceptions.dart',
    )).writeAsString(
      l10nExceptionsGenerator.gen(),
    );

    await File(path.join(
      projectPath,
      'lib',
      'core',
      'l10n',
      'localization.dart',
    )).writeAsString(
      l10nLocalizationGenerator.gen(),
    );

    await File(path.join(
      projectPath,
      'lib',
      'core',
      'l10n',
      'plural_rules.dart',
    )).writeAsString(
      l10nPluralRulesGenerator.gen(),
    );

    await File(path.join(
      projectPath,
      'lib',
      'core',
      'l10n',
      'public_ext.dart',
    )).writeAsString(
      l10nPublicExtensionsGenerator.gen(),
    );

    await File(path.join(
      projectPath,
      'lib',
      'core',
      'l10n',
      'public.dart',
    )).writeAsString(
      l10nPublicGenerator.gen(),
    );

    await File(path.join(
      projectPath,
      'lib',
      'core',
      'l10n',
      'translations.dart',
    )).writeAsString(
      l10nTranslationsGenerator.gen(),
    );

    await File(path.join(
      projectPath,
      'lib',
      'core',
      'l10n',
      'utils.dart',
    )).writeAsString(
      l10nUtilsGenerator.gen(),
    );

    await File(path.join(
      projectPath,
      'lib',
      'core',
      'network',
      'api_client.dart',
    )).writeAsString(
      ApiClientGenerator.gen(),
    );

    await File(path.join(
      projectPath,
      'lib',
      'core',
      'network',
      'connection_checker.dart',
    )).writeAsString(
      ConnectionCheckerGenerator.gen(),
    );

    await File(path.join(
      projectPath,
      'lib',
      'core',
      'network',
      'network_info.dart',
    )).writeAsString(
      NetworkInfoGenerator.gen(),
    );

    await File(path.join(
      projectPath,
      'lib',
      'core',
      'routes',
      'app_routes.dart',
    )).writeAsString(
      AppRoutesGenerator.gen(),
    );

    await File(path.join(
      projectPath,
      'lib',
      'core',
      'styles',
      'dimensions.dart',
    )).writeAsString(
      DimensionsGenerator.gen(),
    );

    await File(path.join(
      projectPath,
      'lib',
      'core',
      'styles',
      'theme.dart',
    )).writeAsString(
      ThemeGenerator.gen(),
    );

    await File(path.join(
      projectPath,
      'lib',
      'core',
      'usecases',
      'usecase.dart',
    )).writeAsString(
      UsecaseGenerator.gen(),
    );

    await File(path.join(
      projectPath,
      'lib',
      'core',
      'utils',
      'logger.dart',
    )).writeAsString(
      LoggerGenerator.gen(),
    );

    await File(path.join(
      projectPath,
      'lib',
      'core',
      'utils',
      'preferences.dart',
    )).writeAsString(
      PreferencesGenerator.gen(),
    );

    // // Generate error files
    // await File(path.join(projectPath, 'lib', 'core', 'error', 'failures.dart'))
    //     .writeAsString(ProjectTemplates.generateFailures());

    // await File(
    //         path.join(projectPath, 'lib', 'core', 'error', 'exceptions.dart'))
    //     .writeAsString(ProjectTemplates.generateExceptions());

    // // Generate usecase files
    // await File(
    //         path.join(projectPath, 'lib', 'core', 'usecases', 'usecase.dart'))
    //     .writeAsString(ProjectTemplates.generateUseCase());
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

  Future<void> _generateDiFiles(String projectPath) async {
    await File(path.join(projectPath, 'lib', 'di', 'injection.dart'))
        .writeAsString(InjectionGenerator.gen());
  }
}
