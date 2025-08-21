class ProjectTemplates {
  static String generatePubspec(String projectName) {
    return '''name: $projectName
description: A new Flutter project with clean architecture.
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'
  flutter: ">=1.17.0"

dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  flutter_bloc: ^8.1.3
  get_it: ^7.6.4
  
  # Network
  dio: ^5.3.2
  
  # Local Storage
  shared_preferences: ^2.2.2
  
  # Utils
  equatable: ^2.0.5
  dartz: ^0.10.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0

flutter:
  uses-material-design: true
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
    return '''import 'core/app_localization/app_localization_app.dart';
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
}''';
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
