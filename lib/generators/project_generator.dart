import 'dart:io';
import 'package:args/args.dart';
import 'package:hybrid_cli/templates/l10n/en.dart';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';
import '../templates/l10n/ja.dart';
import '../templates/l10n/vi.dart';
import '../templates/templates.dart';

class ProjectGenerator {
  Future<void> generate(String projectPath, String projectName) async {
    // Create main project directory
    final projectDir = Directory(projectPath);
    await projectDir.create(recursive: true);

    await _runFlutterCreateProjectSync(projectPath, projectName);

    await updatePubspecYaml(projectPath);

    await _createBuildYaml(projectPath);

    await _createL10nYaml(projectPath);

    await _createAnalyticsYaml(projectPath);

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

    await _runFlutterPubAddsSync(projectPath, projectName);

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
      'lib/l10n',
      'lib/l10n/arb',
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
    } catch (e) {
      print('Error: $e');
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

  Future<void> updatePubspecYaml(String projectPath) async {
    try {
      // Đọc file pubspec.yaml hiện tại
      final file = File(path.join(projectPath, 'pubspec.yaml'));
      final yamlString = await file.readAsString();

      // Parse YAML thành Map
      final yamlDoc = loadYaml(yamlString);
      final pubspecMap = Map<String, dynamic>.from(yamlDoc);

      // Thêm yaml dependency
      if (pubspecMap['dependencies'] == null) {
        pubspecMap['dependencies'] = <String, dynamic>{};
      }

      final dependencies =
          Map<String, dynamic>.from(pubspecMap['dependencies']);
      pubspecMap['dependencies'] = dependencies;

      // Cập nhật flutter section
      if (pubspecMap['flutter'] == null) {
        pubspecMap['flutter'] = <String, dynamic>{};
      }

      final flutter = Map<String, dynamic>.from(pubspecMap['flutter']);
      flutter['generate'] = true;
      flutter['uses-material-design'] = true;
      flutter['assets'] = [
        'assets/images/',
        'assets/icons/',
        'assets/navigator/',
      ];
      pubspecMap['flutter'] = flutter;

      // Tạo nội dung YAML mới (đơn giản)
      final newYamlContent = _buildYamlContent(pubspecMap);

      // Ghi lại file
      await file.writeAsString(newYamlContent);

      print('Updated pubspec.yaml successfully!');
    } catch (e) {
      print('Error updating pubspec.yaml: $e');
    }
  }

  String _buildYamlContent(Map<String, dynamic> data) {
    final buffer = StringBuffer();

    // Basic info
    buffer.writeln('name: ${data['name']}');
    buffer.writeln('description: "${data['description']}"');
    buffer.writeln('publish_to: \'${data['publish_to']}\'');
    buffer.writeln();

    buffer.writeln('version: ${data['version']}');
    buffer.writeln();

    // Environment
    buffer.writeln('environment:');
    final env = data['environment'] as Map;
    env.forEach((key, value) {
      buffer.writeln('  $key: $value');
    });
    buffer.writeln();

    // Dependencies
    buffer.writeln('dependencies:');
    final deps = data['dependencies'] as Map;
    deps.forEach((key, value) {
      if (value is Map && value.containsKey('sdk')) {
        buffer.writeln('  $key:');
        buffer.writeln('    sdk: ${value['sdk']}');
      } else {
        buffer.writeln('  $key: $value');
      }
    });
    buffer.writeln();

    // Dev dependencies
    buffer.writeln('dev_dependencies:');
    final devDeps = data['dev_dependencies'] as Map;
    devDeps.forEach((key, value) {
      if (value is Map && value.containsKey('sdk')) {
        buffer.writeln('  $key:');
        buffer.writeln('    sdk: ${value['sdk']}');
      } else {
        buffer.writeln('  $key: $value');
      }
    });
    buffer.writeln();

    // Flutter section
    buffer.writeln('flutter:');
    final flutter = data['flutter'] as Map;
    flutter.forEach((key, value) {
      if (key == 'assets' && value is List) {
        buffer.writeln('  $key:');
        for (final asset in value) {
          buffer.writeln('    - $asset');
        }
      } else {
        buffer.writeln('  $key: $value');
      }
    });

    return buffer.toString();
  }

  Future<void> _runFlutterPubAddsSync(
      String projectPath, String projectName) async {
    final packages = [
      'dio',
      'json_serializable',
      'json_annotation',
      'flutter_bloc',
      'equatable',
      'google_fonts',
      'skeletonizer',
      'hive_flutter',
      'hive',
      'shared_preferences',
      'auto_route',
      'device_info_plus',
      'visibility_detector',
      'flutter_screenutil',
      'intl',
      'auto_size_text',
      'velocity_x',
      'provider',
      'collection',
      'synchronized',
      'flutter_hooks',
      'uuid',
      'flutter_svg',
      'logger',
      'pretty_dio_logger',
      'get_it',
      'retrofit',
      'cached_network_image',
      'internet_connection_checker_plus',
      'dartz',
      'injectable',
      'path_provider',
    ];
    final packages_dev = [
      'build_runner',
      'auto_route_generator',
      'retrofit_generator',
      'flutter_gen_runner',
      'injectable_generator',
    ];
    try {
      print('Running flutter pub add flutter_localizations --sdk=flutter...');
      final result = Process.runSync(
        'flutter',
        ['pub', 'add', 'flutter_localizations', '--sdk=flutter'],
        workingDirectory: projectPath,
      );
      if (result.exitCode == 0) {
        print('✅ flutter pub add flutter_localizations --sdk=flutter');
      } else {
        print(
            '❌ flutter pub add flutter_localizations --sdk=flutter failed: ${result.stderr}');
      }
    } catch (e) {
      print('Error: $e');
    }
    // 'flutter_secure_storage',
    try {
      print('Running flutter pub add flutter_secure_storage...');
      final result = Process.runSync(
        'flutter',
        [
          'pub',
          'add',
          'flutter_secure_storage',
        ],
        workingDirectory: projectPath,
      );

      if (result.exitCode == 0) {
        print('✅ flutter pub add flutter_secure_storage completed');
      } else {
        print(
            '❌ flutter pub add flutter_secure_storage failed: ${result.stderr}');
      }
    } catch (e) {
      print('Error: $e');
    }

    try {
      print('Running flutter pub add dev...');
      final result = Process.runSync(
        'flutter',
        ['pub', 'add', '--dev', ...packages_dev],
        workingDirectory: projectPath,
      );

      if (result.exitCode == 0) {
        print('✅ flutter pub add dev completed');
      } else {
        print('❌ flutter pub add dev failed: ${result.stderr}');
      }
    } catch (e) {
      print('Error: $e');
    }

    try {
      print('Running flutter pub add packages...');
      final result = Process.runSync(
        'flutter',
        ['pub', 'add', ...packages],
        workingDirectory: projectPath,
      );

      if (result.exitCode == 0) {
        print('✅ flutter pub add packages completed');
      } else {
        print('❌ flutter pub add packages failed: ${result.stderr}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _generateMainFiles(
      String projectPath, String projectName) async {
    // Generate pubspec.yaml
    // final pubspecContent = ProjectTemplates.generatePubspec(projectName);
    // await File(path.join(projectPath, 'pubspec.yaml'))
    //     .writeAsString(pubspecContent);

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
    final l10nDir = Directory(path.join(projectPath, 'lib', 'l10n', 'arb'));
    if (!await l10nDir.exists()) {
      await l10nDir.create(recursive: true);
    }

    await File(path.join(projectPath, 'lib', 'l10n', 'arb', 'intl_en.arb'))
        .writeAsString(EnGenerator.gen());

    await File(path.join(projectPath, 'lib', 'l10n', 'arb', 'intl_ja.arb'))
        .writeAsString(JaGenerator.gen());

    await File(path.join(projectPath, 'lib', 'l10n', 'arb', 'intl_vi.arb'))
        .writeAsString(ViGenerator.gen());
  }

  Future<void> _createBuildYaml(String projectPath) async {
    final buildYaml = File(path.join(projectPath, 'build.yaml'));
    if (!await buildYaml.exists()) {
      await buildYaml.create(recursive: true);
    }

    await buildYaml.writeAsString('''
targets:
  \$default:
    sources:
      exclude:
        - bin/*.dart
    builders:
      json_serializable:
        options:
          include_if_null: false
          explicit_to_json: true
          generic_argument_factories: false
          # field_rename: snake
      flutter_gen_runner:
        options:
          output: lib/gen
          assets:
            outputs:
              class_name: Assets
              style: camel-case
          integrations:
            flutter_svg: true
          fonts:
            outputs:
              class_name: MyFontFamily
            enabled: true
          exclude: null

    ''');
  }

  Future<void> _createL10nYaml(String projectPath) async {
    final l10nYaml = File(path.join(projectPath, 'l10n.yaml'));
    if (!await l10nYaml.exists()) {
      await l10nYaml.create(recursive: true);
    }

    await l10nYaml.writeAsString('''
arb-dir: lib/l10n/arb
template-arb-file: intl_en.arb
output-localization-file: app_localizations.dart
output-class: AppLocalizations
output-dir: lib/gen/l10n
nullable-getter: true
preferred-supported-locales: ["en","ja", "vi"]
use-deferred-loading: false
synthetic-package: false
    ''');
  }

  Future<void> _createAnalyticsYaml(String projectPath) async {
    final analyticsYaml = File(path.join(projectPath, 'analysis_options.yaml'));
    if (!await analyticsYaml.exists()) {
      await analyticsYaml.create(recursive: true);
    }

    await analyticsYaml.writeAsString('''
include: package:flutter_lints/flutter.yaml

analyzer:
  exclude:
    - "**.freezed.dart"
    - "**.g.dart"
    - "**.mocks.dart"
    - "**/core/localization/generated/**"
  errors:
    invalid_annotation_target: ignore

linter:
  rules:
    avoid_print: true
    prefer_single_quotes: true
    avoid_function_literals_in_foreach_calls: false
    avoid_annotating_with_dynamic: true
    always_declare_return_types: true
    unnecessary_new: true
    avoid_empty_else: true
    directives_ordering: true
    avoid_unused_constructor_parameters: true
    prefer_relative_imports: true
    curly_braces_in_flow_control_structures: false
    constant_identifier_names: false
    empty_catches: false
    depend_on_referenced_packages: false
    use_key_in_widget_constructors: false
    require_trailing_commas: true
    unnecessary_await_in_return: true
    unnecessary_brace_in_string_interps: true
    unnecessary_const: true
    unnecessary_constructor_name: true
    unnecessary_getters_setters: true
    unnecessary_lambdas: false
    unnecessary_late: true
    unnecessary_null_aware_assignments: true
    unnecessary_null_checks: true
    unnecessary_null_in_if_null_operators: true
    unnecessary_nullable_for_final_variable_declarations: true
    unnecessary_overrides: true
    unnecessary_parenthesis: true
    unnecessary_raw_strings: false
    unnecessary_statements: true
    unnecessary_string_escapes: true
    unnecessary_string_interpolations: true
    unnecessary_this: true
    unnecessary_to_list_in_spreads: true
    no_duplicate_case_values: true
    sort_constructors_first: true
    no_leading_underscores_for_local_identifiers: true
    avoid_void_async: true
    ''');
  }
}
