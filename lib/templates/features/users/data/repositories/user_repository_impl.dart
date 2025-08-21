class UserRepositoryImplGenerator {
  static String gen() {
    return '''import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exception.dart';
import '../../../auth/data/models/user_model.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_data_source.dart';

@Injectable(as: UserRepository)
class UserRepositoryImpl extends UserRepository {
  UserRepositoryImpl(this.remoteDataSource);
  final UserRemoteDataSource remoteDataSource;

  @override
  Future<Either<AppException, UserListResponse>> getUsers({
    int limit = 10,
    int skip = 0,
  }) =>
      remoteDataSource.getUsers(limit: limit, skip: skip);
}
''';
  }
}
