class UserRepositoryGenerator {
  static String gen() {
    return '''
import 'package:dartz/dartz.dart';

import '../../../../core/errors/exception.dart';
import '../../../auth/data/models/user_model.dart';

abstract class UserRepository {
  const UserRepository();

  Future<Either<AppException, UserListResponse>> getUsers({
    int limit = 10,
    int skip = 0,
  });
}
''';
  }
}
