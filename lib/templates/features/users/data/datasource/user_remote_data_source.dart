class UserRemoteDataSourceGenerator {
  static String gen() {
    return '''import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/common/base/mixin/api_error_handler_mixin.dart';
import '../../../../core/errors/exception.dart';
import '../../../auth/data/models/user_model.dart';
import '../../domain/services/user_service.dart';

@Injectable()
class UserRemoteDataSource with ApiHandlerMixin {
  UserRemoteDataSource(this.userService);
  final UserService userService;

  Future<Either<AppException, UserListResponse>> getUsers({
    int limit = 10,
    int skip = 0,
  }) =>
      request(userService.getUsers(limit: limit, skip: skip));
}
''';
  }
}
