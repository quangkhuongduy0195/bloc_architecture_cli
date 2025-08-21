class UserEntityGenerator {
  static String gen() {
    return '''

import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  const UserEntity({
    this.id,
    this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.gender,
    this.image,
    this.accessToken,
    this.refreshToken,
    this.birthDate,
    this.phone,
  });
  final int? id;
  final String? username;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final String? image;
  final String? accessToken;
  final String? refreshToken;
  final String? birthDate;
  final String? phone;

  @override
  List<Object?> get props => [
        id,
        username,
        email,
        firstName,
        lastName,
        gender,
        image,
        accessToken,
        refreshToken,
        birthDate,
        phone,
      ];
}
''';
  }
}
