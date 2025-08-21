class ProjectTemplates {
  static String generatePubspec(String projectName) {
    return '''name: $projectName
description: "A new Flutter project."

publish_to: "none"

version: 1.0.0+1

environment:
  sdk: ^3.5.4
  flutter: 3.24.4

dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter

  cupertino_icons: ^1.0.8
  dio: ^5.7.0
  freezed: ^3.1.0
  freezed_annotation: ^3.1.0
  json_annotation: ^4.9.0
  flutter_bloc: ^9.1.1
  equatable: ^2.0.3
  google_fonts: ^6.2.1
  skeletonizer: ^2.1.0+1
  hive_flutter: ^1.1.0
  hive: ^2.2.3
  shared_preferences: ^2.3.2
  auto_route: ^10.1.2
  device_info_plus: ^11.5.0
  visibility_detector: ^0.4.0+2
  flutter_screenutil: ^5.9.3
  intl: any
  auto_size_text: ^3.0.0
  velocity_x: ^4.2.1
  provider: ^6.1.2
  collection: ^1.18.0
  synchronized: ^3.1.0+1
  flutter_secure_storage: ^9.2.2
  flutter_hooks: ^0.21.3+1
  uuid: ^4.5.1
  flutter_svg: ^2.0.10+1
  logger: ^2.4.0
  pretty_dio_logger: ^1.4.0
  get_it: ^8.0.1
  retrofit: ^4.4.0
  cached_network_image: ^3.4.1
  internet_connection_checker_plus: ^2.5.2
  dartz: ^0.10.1
  injectable: ^2.5.1
  path: ^1.9.1
  path_provider: ^2.1.5

dev_dependencies:
  flutter_test:
    sdk: flutter

  flutter_lints: ^6.0.0
  build_runner: ^2.4.13
  json_serializable: ^6.8.0
  auto_route_generator: ^10.1.0
  retrofit_generator: ">=8.0.0 <10.0.0"
  flutter_gen_runner: ^5.8.0
  injectable_generator: ^2.7.0

flutter:
  uses-material-design: true
  assets:
    - assets/images/
    - assets/icons/
    - assets/translations/
    - assets/navigator/

flutter_gen:
  output: lib/core/collections
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
''';
  }

  static String generateRoot() {
    return '''import 'package:flutter/services.dart';
import '../core/common/common/common_bloc.dart';
import '../core/config.dart';
import '../core/routes/app_routes.dart';
import '../di/injection.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../widgets/indicators/loading_indicator.dart';

class RootApp extends HookWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(
      () {
        getIt<CommonBloc>().add(const CommonInitial());
        getIt<AuthBloc>().add(const AuthIsUserLoggedIn());
        // lifecycleApp();

        /// set the system ui mode to edge to edge
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

        /// set the preferred orientations to portrait up
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        return;
      },
      [],
    );
    return BlocSelector<CommonBloc, CommonState, ThemeMode>(
      selector: (state) => state.themeMode,
      builder: (context, themeMode) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Colors.transparent,
            statusBarIconBrightness: themeMode == ThemeMode.system
                ? MediaQuery.platformBrightnessOf(context) == Brightness.dark
                    ? Brightness.light
                    : Brightness.dark
                : themeMode == ThemeMode.dark
                    ? Brightness.light
                    : Brightness.dark,
          ),
          child: MaterialApp.router(
            key: globalKey,
            debugShowCheckedModeBanner: false,
            showPerformanceOverlay: false,
            themeMode: themeMode,
            theme: lightTheme(context),
            darkTheme: darkTheme(context),
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            routerConfig: appRouter.config(
              navigatorObservers: () => [MyObserver()],
            ),
            builder: (context, child) {
              return Stack(
                children: [
                  child!,
                  const LoadingScreen(),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CommonBloc, CommonState, bool>(
      selector: (state) => state.isLoading,
      builder: (context, isLoading) => Visibility(
        visible: isLoading,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
          ),
          child: const LoadingIndicator(),
        ),
      ),
    );
  }
}''';
  }

  static String generateMain() {
    return '''import 'core/l10n/app_localization_app.dart';
import 'core/common/app_user/app_user_cubit.dart';
import 'core/common/common/common_bloc.dart';
import 'core/config.dart';
import 'di/injection.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'root/root.dart';

/// The entry point of the application.
///
/// Initializes the application and runs the `RootApp` widget.
void main() async {
  Configs.init(() {
    runApp(
      ScreenUtilInit(
        designSize: Configs.designSize,
        minTextAdapt: Configs.minTextAdapter,
        splitScreenMode: Configs.splitScreenMode,
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => getIt<CommonBloc>()),
            BlocProvider(create: (_) => getIt<AuthBloc>()),
            BlocProvider(create: (_) => getIt<AppUserCubit>()),
          ],
          child: AppLocalizations(
            path: 'assets/translations',
            supportedLocales: LanguageLocals.supportedLocales,
            child: const RootApp(),
          ),
        ),
      ),
    );
  });
}
''';
  }

  static String generateCoreBarrel() {
    return '''// Core exports
export 'error/failures.dart';
export 'error/exceptions.dart';
export 'usecases/usecase.dart';
''';
  }

  static String generateFailures() {
    return '''import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure();

  @override
  List<Object> get props => [];
}

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

class NetworkFailure extends Failure {}
''';
  }

  static String generateExceptions() {
    return '''class ServerException implements Exception {}

class CacheException implements Exception {}

class NetworkException implements Exception {}
''';
  }

  static String generateUseCase() {
    return '''import 'package:dartz/dartz.dart';
import '../error/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {
  const NoParams();
}
''';
  }

  static String generateReadme(String projectName) {
    return '''# $projectName

A new Flutter project with clean architecture.

## Getting Started

1. Install dependencies:
```bash
flutter pub get
```

2. Run the app:
```bash
flutter run
```

This project was generated using flutter_gen CLI.
''';
  }
}
