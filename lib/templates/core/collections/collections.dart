class CollectionsGenerator {
  static String gen() {
    return '''export './assets.gen.dart';
export './fake.dart';
export './language_codes.dart';
''';
  }

  static String genFake() {
    return '''import '../../features/auth/domain/entities/user.dart';

abstract class Fake {
  static const User user = User(
    id: 0,
    username: 'username',
    email: 'dummy@gmail.com',
    firstName: 'First Name',
    lastName: 'Last Name',
  );

  static List<User> users = List.generate(10, (index) => user);
}
''';
  }
}
