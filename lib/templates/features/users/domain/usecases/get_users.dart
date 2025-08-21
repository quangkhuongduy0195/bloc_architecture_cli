class GetUsersGenerator {
  static String gen() {
    return '''

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exception.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../auth/data/models/user_model.dart';
import '../repositories/user_repository.dart';

@Injectable()
class GetUsers extends UsecaseWithParams<UserListResponse, GetUsersParams> {
  GetUsers(this._repository);
  final UserRepository _repository;

  @override
  Future<Either<AppException, UserListResponse>> call(GetUsersParams params) =>
      _repository.getUsers(
        limit: params.limit,
        skip: params.skip,
      );
}

class GetUsersParams {
  GetUsersParams({
    required this.limit,
    required this.skip,
  });
  final int limit;
  final int skip;
}
''';
  }
}
