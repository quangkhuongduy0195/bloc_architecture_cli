class ExceptionGenerator {
  static String gen() {
    return '''// Base Exception
abstract class AppException implements Exception {
  AppException({required this.message, this.prefix});
  final String message;
  final String? prefix;

  @override
  String toString() {
    return '\$prefix\$message';
  }
}

// Network related exceptions
class NetworkException extends AppException {
  NetworkException({super.message = 'No internet connection'})
      : super(prefix: 'Network Error: ');
}

class TimeoutException extends AppException {
  TimeoutException({super.message = 'Connection timeout'})
      : super(prefix: 'Timeout Error: ');
}

// Server related exceptions
class ServerException extends AppException {
  ServerException({super.message = 'Internal server error'})
      : super(prefix: 'Server Error: ');
}

class BadRequestException extends AppException {
  BadRequestException({final String? message})
      : super(message: message ?? 'Bad request', prefix: 'Invalid Request: ');
}

class UnauthorizedException extends AppException {
  UnauthorizedException({final String? message})
      : super(message: message ?? 'Unauthorized', prefix: 'Unauthorized: ');
}

class ForbiddenException extends AppException {
  ForbiddenException({final String? message})
      : super(message: message ?? 'Forbidden', prefix: 'Forbidden: ');
}

class NotFoundException extends AppException {
  NotFoundException({final String? message})
      : super(message: message ?? 'Not found', prefix: 'Not Found: ');
}

class RequestCancelledException extends AppException {
  RequestCancelledException({super.message = 'Request cancelled'})
      : super(prefix: 'Request Cancelled: ');
}

// Cache related exceptions
class CacheException extends AppException {
  CacheException({super.message = 'Cache error'})
      : super(prefix: 'Cache Error: ');
}

// Authentication related exceptions
class AuthenticationException extends AppException {
  AuthenticationException({super.message = 'Authentication failed'})
      : super(prefix: 'Authentication Error: ');
}

''';
  }
}
