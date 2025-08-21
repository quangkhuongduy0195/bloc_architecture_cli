class InjectionGenerator {
  static String gen() {
    return '''import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../core/network/api_client.dart';
import '../features/auth/services/auth_service.dart';
import '../features/users/domain/services/user_service.dart';
import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  asExtension: true,
)
void configureDependencies() {
  getIt.init();
}

@module
abstract class AppModule {
  @singleton
  Dio get dio => ApiClient().dio;

  @singleton
  UserService get userService => UserService(getIt<Dio>());

  @singleton
  AuthService get authService => AuthService(getIt<Dio>());

  @lazySingleton
  InternetConnection get internetConnection => InternetConnection();
}
''';
  }
}
