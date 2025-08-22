class CollectionsGenerator {
  static String gen() {
    return '''export '../../gen/assets.gen.dart';
export './fake.dart';
''';
  }

  static String genFake() {
    return '''import '../../features/auth/data/models/user_model.dart';

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
