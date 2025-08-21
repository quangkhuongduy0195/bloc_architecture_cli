class ConnectionCheckerGenerator {
  /// Generates the code for the connection checker.
  static String gen() {
    return '''

import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract interface class ConnectionChecker {
  Future<bool> get isConnected;
}

@Injectable(as: ConnectionChecker)
class ConnectionCheckerImpl implements ConnectionChecker {
  ConnectionCheckerImpl(this.internetConnection);
  final InternetConnection internetConnection;

  @override
  Future<bool> get isConnected => internetConnection.hasInternetAccess;
}
''';
  }
}
