class UserServiceGenerator {
  static String gen() {
    return '''

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../auth/data/models/user_model.dart';

part 'user_service.g.dart';

@RestApi()
abstract class UserService {
  factory UserService(Dio dio, {String? baseUrl}) = _UserService;

  @GET('/users')
  Future<UserListResponse> getUsers({
    @Query('limit') required int limit,
    @Query('skip') required int skip,
  });

  @GET('/users/{id}')
  Future<User> getUser(@Path('id') String id);

  @POST('/users')
  Future<void> createUser(@Body() Map<String, dynamic> body);

  @PUT('/users/{id}')
  Future<void> updateUser(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

  @DELETE('/users/{id}')
  Future<void> deleteUser(@Path('id') String id);
}
''';
  }
}
