class UserModelGenerator {
  static String gen() {
    return '''import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/user_entity.dart';

part 'user_model.g.dart';

@JsonSerializable()
class User extends UserEntity {
  factory User.fromJson(Map<String, dynamic> json) => _\$UserFromJson(json);
  factory User.createFromEntity(UserEntity entity) {
    return User(
      id: entity.id,
      username: entity.username,
      email: entity.email,
      firstName: entity.firstName,
      lastName: entity.lastName,
      gender: entity.gender,
      image: entity.image,
      accessToken: entity.accessToken,
      refreshToken: entity.refreshToken,
      birthDate: entity.birthDate,
      phone: entity.phone,
    );
  }
  const User({
    super.id,
    super.username,
    super.email,
    super.firstName,
    super.lastName,
    super.gender,
    super.image,
    super.accessToken,
    super.refreshToken,
    super.birthDate,
    super.phone,
  });

  String get name => '\$firstName \$lastName';

  Map<String, dynamic> toJson() {
    return _\$UserToJson(this);
  }
}

@JsonSerializable()
class UserListResponse {
  factory UserListResponse.merge(
    UserListResponse oldData,
    UserListResponse newData,
  ) {
    return UserListResponse(
      users: [...oldData.users, ...newData.users],
      total: newData.total,
      skip: newData.skip,
      limit: newData.limit,
    );
  }
  factory UserListResponse.empty() {
    return const UserListResponse(users: []);
  }
  const UserListResponse({
    required this.users,
    this.total = 0,
    this.skip = 0,
    this.limit = 0,
  });

  factory UserListResponse.fromJson(Map<String, dynamic> json) =>
      _\$UserListResponseFromJson(json);

  final List<User> users;
  @JsonKey(defaultValue: 0)
  final int total;
  @JsonKey(defaultValue: 0)
  final int skip;
  @JsonKey(defaultValue: 0)
  final int limit;

  Map<String, dynamic> toJson() {
    return _\$UserListResponseToJson(this);
  }

  bool get hasMore => users.length < total;
}

extension UserListResponseX on UserListResponse {
  UserListResponse merge(UserListResponse newData) {
    return UserListResponse(
      users: [...users, ...newData.users],
      total: newData.total,
      skip: newData.skip,
      limit: newData.limit,
    );
  }
}

''';
  }
}
