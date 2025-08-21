class AuthServiceGenerator {
  static String gen() {
    return '''import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../data/models/user_model.dart';

part 'auth_service.g.dart';

@RestApi()
abstract class AuthService {
  factory AuthService(Dio dio, {String? baseUrl}) = _AuthService;

  @POST('/auth/login')
  Future<User> loginUser(@Body() Map<String, dynamic> body);

  @POST('/users')
  Future<User> registerUser(@Body() Map<String, dynamic> body);
}
''';
  }
}
