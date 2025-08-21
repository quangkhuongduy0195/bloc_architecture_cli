import 'dart:io';
import 'package:args/args.dart';
import 'package:hybrid_cli/templates/core/common/app_user/app_user_cubit.dart';
import 'package:hybrid_cli/templates/core/l10n/translations.dart';
import 'package:hybrid_cli/templates/features/auth/domain/repositories/authentication_repository.dart';
import 'package:hybrid_cli/templates/features/dashboard/calendar_page.dart';
import 'package:path/path.dart' as path;
import '../commands/locale_command.dart';
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
import '../templates/features/auth/data/datasource/auth_local_data_source.dart';
import '../templates/features/auth/data/datasource/auth_remote_data_source.dart';
import '../templates/features/auth/data/models/user_model.dart';
import '../templates/features/auth/data/repositories/authentication_repository_impl.dart';
import '../templates/features/auth/domain/entities/user_entity.dart';
import '../templates/features/auth/domain/usecases/auth_check.dart';
import '../templates/features/auth/domain/usecases/auth_login.dart';
import '../templates/features/auth/domain/usecases/auth_logout.dart';
import '../templates/features/auth/domain/usecases/auth_sign_up.dart';
import '../templates/features/auth/presentation/bloc/auth_bloc.dart';
import '../templates/features/auth/presentation/bloc/auth_event.dart';
import '../templates/features/auth/presentation/bloc/auth_state.dart';
import '../templates/features/auth/presentation/pages/login_page.dart';
import '../templates/features/auth/domain/services/auth_service.dart';
import '../templates/features/dashboard/chart_page.dart';
import '../templates/features/dashboard/dashboard_page.dart';
import '../templates/features/dashboard/home_page.dart';
import '../templates/features/dashboard/setting_page.dart';
import '../templates/features/dashboard/time_page.dart';
import '../templates/features/users/data/datasource/user_remote_data_source.dart';
import '../templates/features/users/data/repositories/user_repository_impl.dart';
import '../templates/features/users/domain/repositories/user_repository.dart';
import '../templates/features/users/domain/services/user_service.dart';
import '../templates/features/users/domain/usecases/get_users.dart';
import '../templates/features/users/presentation/bloc/user_bloc.dart';
import '../templates/features/users/presentation/bloc/user_event.dart';
import '../templates/features/users/presentation/bloc/user_state.dart';
import '../templates/features/users/presentation/pages/user_list.dart';
import '../templates/simple_templates.dart';
import '../templates/widgets/button_custom.dart';
import '../templates/widgets/cache_image.dart';
import '../templates/widgets/common/base_loading_indicator.dart';
import '../templates/widgets/common/base_page_state.dart';
import '../templates/widgets/common/title_widget.dart';
import '../templates/widgets/dialogs.dart';
import '../templates/widgets/fetch_more_indicator.dart';
import '../templates/widgets/indicators/loading.dart';
import '../templates/widgets/indicators/loading_indicator.dart';
import '../templates/widgets/indicators/loading_manager.dart';
import '../templates/widgets/language.dart';
import '../templates/widgets/refresh_widget.dart';
import '../templates/widgets/setting_ui.dart';
import '../templates/widgets/shader_mask.dart';
import '../templates/widgets/size_box.dart';
import '../templates/widgets/text_field_custom.dart';
import '../templates/widgets/theme_model.dart';
import '../templates/widgets/user_info_list_title.dart';

class ProjectGenerator {
  Future<void> generate(String projectPath, String projectName) async {
    // Create main project directory
    final projectDir = Directory(projectPath);
    await projectDir.create(recursive: true);

    _runFlutterCreateProjectSync(projectPath, projectName);

    // Create lib directory structure
    await _createDirectoryStructure(projectPath);

    // Generate main files
    await _generateMainFiles(projectPath, projectName);

    // Generate core files
    await _generateCoreFiles(projectPath);

    await _generateDiFiles(projectPath);

    // Generate example feature
    await _generateExampleFeature(projectPath);

    await _copyAssets(projectPath);

    await _copyl10nFiles(projectPath);

    await _removeTestFiles(projectPath);

    await _runFlutterPubGetSync(projectPath, projectName);

    await _runOtherCommandsSync(projectPath, projectName);
  }

  Future<void> _createDirectoryStructure(String projectPath) async {
    final directories = [
      'assets',
      'lib',
      'lib/root',
      'lib/core',
      'lib/core/collections',
      'lib/core/common',
      'lib/core/common/app_user',
      'lib/core/common/base',
      'lib/core/common/base/mixin',
      'lib/core/common/common',
      'lib/core/errors',
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
      'lib/widgets',
      'lib/widgets/common',
      'lib/widgets/indicators',
      'test',
      'test/features',
      'test/core',
    ];

    for (final dir in directories) {
      final directory = Directory(path.join(projectPath, dir));
      await directory.create(recursive: true);
    }
  }

  Future<void> _runFlutterCreateProjectSync(
      String projectPath, String projectName) async {
    try {
      print('Running flutter create $projectName...');

      final result = Process.runSync(
        'flutter',
        ['create', '$projectName'],
      );

      if (result.exitCode == 0) {
        print('✅ flutter create $projectName completed');
      } else {
        print('❌ flutter create $projectName failed: ${result.stderr}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _runOtherCommandsSync(
      String projectPath, String projectName) async {
    try {
      print('Running flutter pub run build_runner build -d...');
      final result = Process.runSync(
        'flutter',
        ['pub', 'run', 'build_runner', 'build', '-d'],
        workingDirectory: projectPath,
      );

      if (result.exitCode == 0) {
        print('✅ flutter pub run build_runner build -d completed');
      } else {
        print(
            '❌ flutter pub run build_runner build -d failed: ${result.stderr}');
      }

      // Generate locale keys
      print('🔄 Generating locale keys...');
      await _generateLocaleKeys(projectPath);
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _generateLocaleKeys(String projectPath) async {
    try {
      // Create a mock ArgResults for LocaleCommand
      final localeParser = ArgParser();
      localeParser.addOption('source-dir', defaultsTo: 'lib/l10n');
      localeParser.addOption('source-file');
      localeParser.addOption('output-dir', defaultsTo: 'lib/core/collections');
      localeParser.addOption('output-file', defaultsTo: 'locale_keys.g.dart');
      localeParser.addOption('format', defaultsTo: 'keys');
      localeParser.addFlag('skip-unnecessary-keys', defaultsTo: false);

      // Parse with default values
      final mockArgs = localeParser.parse([]);

      // Change to project directory temporarily
      final originalDir = Directory.current;
      Directory.current = Directory(projectPath);

      try {
        final localeCommand = LocaleCommand();
        await localeCommand.execute(mockArgs);
        print('✅ Locale keys generated successfully');
      } finally {
        // Restore original directory
        Directory.current = originalDir;
      }
    } catch (e) {
      print('⚠️  Error generating locale keys: $e');
    }
  }

  Future<void> _removeTestFiles(String projectPath) async {
    try {
      final testDir = Directory(path.join(projectPath, 'test'));
      if (await testDir.exists()) {
        await testDir.list().forEach((file) async {
          if (file is File) {
            await file.delete();
          }
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _runFlutterPubGetSync(
      String projectPath, String projectName) async {
    // try {
    //   print('Running flutter pub get...');
    //   final result = Process.runSync(
    //     'flutter',
    //     ['pub', 'get'],
    //     workingDirectory: projectPath,
    //   );

    //   if (result.exitCode == 0) {
    //     print('✅ flutter pub get completed');
    //   } else {
    //     print('❌ flutter pub get failed: ${result.stderr}');
    //   }
    // } catch (e) {
    //   print('Error: $e');
    // }
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
      'errors',
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
    await _generateExampleAuth(projectPath);

    await _generateExampleUser(projectPath);

    await _generateExampleDashboard(projectPath);

    await _generateWidgets(projectPath);
  }

  Future<void> _generateExampleAuth(String projectPath) async {
    final featureDir = path.join(projectPath, 'lib', 'features', 'auth');

    // Create feature directories
    final directories = [
      path.join(featureDir, 'data', 'datasources'),
      path.join(featureDir, 'data', 'models'),
      path.join(featureDir, 'data', 'repositories'),
      path.join(featureDir, 'domain', 'services'),
      path.join(featureDir, 'domain', 'entities'),
      path.join(featureDir, 'domain', 'repositories'),
      path.join(featureDir, 'domain', 'usecases'),
      path.join(featureDir, 'presentation', 'bloc'),
      path.join(featureDir, 'presentation', 'pages'),
      path.join(featureDir, 'presentation', 'widgets'),
    ];

    for (final dir in directories) {
      await Directory(dir).create(recursive: true);
    }
    // Generate data
    await File(path.join(featureDir, 'data', 'models', 'user_model.dart'))
        .writeAsString(UserModelGenerator.gen());

    await File(path.join(featureDir, 'data', 'repositories',
            'authentication_repository_impl.dart'))
        .writeAsString(AuthenticationRepositoryImplGenerator.gen());

    await File(path.join(
            featureDir, 'data', 'datasources', 'auth_local_data_source.dart'))
        .writeAsString(AuthLocalDataSourceGenerator.gen());

    await File(path.join(
            featureDir, 'data', 'datasources', 'auth_remote_data_source.dart'))
        .writeAsString(AuthRemoteDataSourceGenerator.gen());

    // Generate domain
    await File(path.join(featureDir, 'domain', 'usecases', 'auth_check.dart'))
        .writeAsString(AuthCheckGenerator.gen());

    await File(path.join(featureDir, 'domain', 'usecases', 'auth_logout.dart'))
        .writeAsString(AuthLogoutGenerator.gen());

    await File(path.join(featureDir, 'domain', 'usecases', 'auth_login.dart'))
        .writeAsString(AuthLoginGenerator.gen());

    await File(path.join(featureDir, 'domain', 'usecases', 'auth_sign_up.dart'))
        .writeAsString(AuthSignUpGenerator.gen());

    await File(path.join(featureDir, 'domain', 'repositories',
            'authentication_repository.dart'))
        .writeAsString(AuthenticationRepositoryGenerator.gen());

    await File(path.join(featureDir, 'domain', 'entities', 'user_entity.dart'))
        .writeAsString(UserEntityGenerator.gen());

    await File(path.join(featureDir, 'domain', 'services', 'auth_service.dart'))
        .writeAsString(AuthServiceGenerator.gen());

    // Generate presentation layer
    await File(path.join(featureDir, 'presentation', 'bloc', 'auth_bloc.dart'))
        .writeAsString(AuthBlocGenerator.gen());

    await File(path.join(featureDir, 'presentation', 'bloc', 'auth_event.dart'))
        .writeAsString(AuthEventGenerator.gen());

    await File(path.join(featureDir, 'presentation', 'bloc', 'auth_state.dart'))
        .writeAsString(AuthStateGenerator.gen());

    await File(
            path.join(featureDir, 'presentation', 'pages', 'login_page.dart'))
        .writeAsString(LoginPageGenerator.gen());
  }

  Future<void> _generateDiFiles(String projectPath) async {
    await File(path.join(projectPath, 'lib', 'di', 'injection.dart'))
        .writeAsString(InjectionGenerator.gen());
  }

  Future<void> _generateExampleUser(String projectPath) async {
    final featureDir = path.join(projectPath, 'lib', 'features', 'user');

    // Create feature directories
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

    // Generate data
    await File(path.join(
            featureDir, 'data', 'repositories', 'user_repository_impl.dart'))
        .writeAsString(UserRepositoryImplGenerator.gen());

    await File(path.join(
            featureDir, 'data', 'datasources', 'user_remote_data_source.dart'))
        .writeAsString(UserRemoteDataSourceGenerator.gen());

    // Generate domain
    await File(path.join(featureDir, 'domain', 'usecases', 'get_users.dart'))
        .writeAsString(GetUsersGenerator.gen());

    await File(path.join(featureDir, 'domain', 'services', 'user_service.dart'))
        .writeAsString(UserServiceGenerator.gen());

    await File(path.join(
            featureDir, 'domain', 'repositories', 'user_repository.dart'))
        .writeAsString(UserRepositoryGenerator.gen());

    // Generate presentation layer
    await File(path.join(featureDir, 'presentation', 'bloc', 'user_bloc.dart'))
        .writeAsString(UserBlocGenerator.gen());

    await File(path.join(featureDir, 'presentation', 'bloc', 'user_event.dart'))
        .writeAsString(UserEventGenerator.gen());

    await File(path.join(featureDir, 'presentation', 'bloc', 'user_state.dart'))
        .writeAsString(UserStateGenerator.gen());

    await File(path.join(featureDir, 'presentation', 'pages', 'user_list.dart'))
        .writeAsString(UserListGenerator.gen());
  }

  Future<void> _generateExampleDashboard(String projectPath) async {
    final featureDir = path.join(projectPath, 'lib', 'features', 'dashboard');

    await Directory(featureDir).create(recursive: true);

    // Generate presentation layer
    await File(path.join(featureDir, 'calendar_page.dart'))
        .writeAsString(CalendarPageGenerator.gen());

    await File(path.join(featureDir, 'chart_page.dart'))
        .writeAsString(ChartPageGenerator.gen());

    await File(path.join(featureDir, 'dashboard_page.dart'))
        .writeAsString(DashboardPageGenerator.gen());

    await File(path.join(featureDir, 'home_page.dart'))
        .writeAsString(HomePageGenerator.gen());

    await File(path.join(featureDir, 'setting_page.dart'))
        .writeAsString(SettingPageGenerator.gen());

    await File(path.join(featureDir, 'time_page.dart'))
        .writeAsString(TimePageGenerator.gen());
  }

  Future<void> _generateWidgets(String projectPath) async {
    await File(path.join(projectPath, 'lib', 'widgets', 'shader_mask.dart'))
        .writeAsString(WidgetShaderMaskGenerator.gen());

    await File(path.join(projectPath, 'lib', 'widgets', 'size_box.dart'))
        .writeAsString(WidgetSizeBoxGenerator.gen());

    await File(
            path.join(projectPath, 'lib', 'widgets', 'text_field_custom.dart'))
        .writeAsString(WidgetTextFieldCustomGenerator.gen());

    await File(path.join(projectPath, 'lib', 'widgets', 'theme_model.dart'))
        .writeAsString(WidgetThemeModeGenerator.gen());

    await File(path.join(
            projectPath, 'lib', 'widgets', 'user_info_list_title.dart'))
        .writeAsString(WidgetUserInfoListTitleGenerator.gen());

    await File(path.join(projectPath, 'lib', 'widgets', 'button_custom.dart'))
        .writeAsString(WidgetButtonCustomGenerator.gen());

    await File(path.join(projectPath, 'lib', 'widgets', 'cache_image.dart'))
        .writeAsString(WidgetCacheImageGenerator.gen());

    await File(path.join(projectPath, 'lib', 'widgets', 'dialogs.dart'))
        .writeAsString(WidgetDialogsGenerator.gen());

    await File(path.join(
            projectPath, 'lib', 'widgets', 'fetch_more_indicator.dart'))
        .writeAsString(WidgetFetchMoreIndicatorGenerator.gen());

    await File(path.join(projectPath, 'lib', 'widgets', 'language.dart'))
        .writeAsString(WidgetLanguagePickerGenerator.gen());

    await File(path.join(projectPath, 'lib', 'widgets', 'refresh_widget.dart'))
        .writeAsString(WidgetRefreshGenerator.gen());

    await File(path.join(projectPath, 'lib', 'widgets', 'setting_ui.dart'))
        .writeAsString(WidgetSettingUiGenerator.gen());

    await File(path.join(
      projectPath,
      'lib',
      'widgets',
      'common',
      'base_loading_indicator.dart',
    )).writeAsString(WidgetBaseLoadingIndicatorGenerator.gen());

    await File(path.join(
      projectPath,
      'lib',
      'widgets',
      'common',
      'base_page_state.dart',
    )).writeAsString(WidgetBasePageStateGenerator.gen());

    await File(path.join(
      projectPath,
      'lib',
      'widgets',
      'common',
      'title_widget.dart',
    )).writeAsString(WidgetTitleGenerator.gen());

    await File(path.join(
      projectPath,
      'lib',
      'widgets',
      'indicators',
      'loading_indicator.dart',
    )).writeAsString(WidgetLoadingIndicatorGenerator.gen());

    await File(path.join(
      projectPath,
      'lib',
      'widgets',
      'indicators',
      'loading_manager.dart',
    )).writeAsString(WidgetLoadingManagerGenerator.gen());

    await File(path.join(
      projectPath,
      'lib',
      'widgets',
      'indicators',
      'loading.dart',
    )).writeAsString(WidgetLoadingGenerator.gen());
  }

  Future<void> _copyAssets(String projectPath) async {
    final assetsDir = Directory(path.join(projectPath, 'assets'));
    if (!await assetsDir.exists()) {
      await assetsDir.create(recursive: true);
    }

    // Get the package root directory by finding the current script's location
    final script = Platform.script;
    final packageRoot = script.scheme == 'file'
        ? Directory(path.dirname(path.dirname(script.toFilePath())))
        : Directory.current;

    final exampleAssetsDir =
        Directory(path.join(packageRoot.path, 'lib', 'templates', 'assets'));

    final sampleAssetsExist = await exampleAssetsDir.exists();
    print('Sample assets exist: $sampleAssetsExist - $exampleAssetsDir');
    if (sampleAssetsExist) {
      final folders = exampleAssetsDir.listSync().whereType<Directory>();
      for (final folder in folders) {
        final baseName = path.basename(folder.path);
        final destFolder = Directory(path.join(assetsDir.path, baseName));
        if (!await destFolder.exists()) {
          await destFolder.create(recursive: true);
        }

        final files = folder.listSync();
        for (final file in files) {
          if (file is File) {
            final destFile =
                File(path.join(destFolder.path, path.basename(file.path)));
            await file.copy(destFile.path);
          }
        }
      }
    }
  }

  Future<void> _copyl10nFiles(String projectPath) async {
    final l10nDir = Directory(path.join(projectPath, 'lib', 'l10n'));
    if (!await l10nDir.exists()) {
      await l10nDir.create(recursive: true);
    }

    // Get the package root directory by finding the current script's location
    final script = Platform.script;
    final packageRoot = script.scheme == 'file'
        ? Directory(path.dirname(path.dirname(script.toFilePath())))
        : Directory.current;

    final exampleL10nDir =
        Directory(path.join(packageRoot.path, 'lib', 'templates', 'l10n'));

    final sampleL10nExist = await exampleL10nDir.exists();

    if (sampleL10nExist) {
      final files = exampleL10nDir.listSync().whereType<File>();
      for (final file in files) {
        final destFile =
            File(path.join(l10nDir.path, path.basename(file.path)));
        await file.copy(destFile.path);
      }
    }
  }
}
