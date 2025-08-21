class UserModelGenerator {
  static String gen() {
    return '''import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';

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

  static String genUserJson() {
    return '''// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _\$UserFromJson(Map<String, dynamic> json) => User(
      id: (json['id'] as num?)?.toInt(),
      username: json['username'] as String?,
      email: json['email'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      gender: json['gender'] as String?,
      image: json['image'] as String?,
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
      birthDate: json['birthDate'] as String?,
      phone: json['phone'] as String?,
    );

Map<String, dynamic> _\$UserToJson(User instance) => <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      if (instance.username case final value?) 'username': value,
      if (instance.email case final value?) 'email': value,
      if (instance.firstName case final value?) 'firstName': value,
      if (instance.lastName case final value?) 'lastName': value,
      if (instance.gender case final value?) 'gender': value,
      if (instance.image case final value?) 'image': value,
      if (instance.accessToken case final value?) 'accessToken': value,
      if (instance.refreshToken case final value?) 'refreshToken': value,
      if (instance.birthDate case final value?) 'birthDate': value,
      if (instance.phone case final value?) 'phone': value,
    };

UserListResponse _\$UserListResponseFromJson(Map<String, dynamic> json) =>
    UserListResponse(
      users: (json['users'] as List<dynamic>)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num?)?.toInt() ?? 0,
      skip: (json['skip'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _\$UserListResponseToJson(UserListResponse instance) =>
    <String, dynamic>{
      'users': instance.users.map((e) => e.toJson()).toList(),
      'total': instance.total,
      'skip': instance.skip,
      'limit': instance.limit,
    };
''';
  }
}
