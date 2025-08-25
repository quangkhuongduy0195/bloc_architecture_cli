class ApiClientGenerator {
  /// Generates the code for the API client.
  static String gen() {
    return '''import 'package:dio/dio.dart';
import '../config.dart';
import '../errors/exception.dart';

class ApiClient {
  ApiClient() : _dio = Dio() {
    _dio.options.baseUrl = Configs.baseUrl;
    _dio.options.connectTimeout = const Duration(milliseconds: 30000);
    _dio.options.receiveTimeout = const Duration(milliseconds: 30000);
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Add interceptors for logging
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }
  final Dio _dio;
  Dio get dio => _dio;

  // Handle Dio errors
  void handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw TimeoutException();
      case DioExceptionType.badResponse:
        switch (e.response?.statusCode) {
          case 400:
            throw BadRequestException(message: e.response?.data['message']);
          case 401:
            throw UnauthorizedException(message: e.response?.data['message']);
          case 403:
            throw ForbiddenException(message: e.response?.data['message']);
          case 404:
            throw NotFoundException(message: e.response?.data['message']);
          case 500:
          case 501:
          case 502:
          case 503:
            throw ServerException(message: e.response?.data['message']);
          default:
            throw ServerException(
              message: e.response?.data['message'] ?? 'Unknown error occurred',
            );
        }
      case DioExceptionType.cancel:
        throw RequestCancelledException();
      case DioExceptionType.unknown:
        if (e.error.toString().contains('SocketException')) {
          throw NetworkException();
        }
        throw ServerException(message: 'Unknown error occurred');
      default:
        throw ServerException(message: 'Unknown error occurred');
    }
  }

  // Add token to headers
  void setToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer \$token';
  }

  // Remove token from headers
  void removeToken() {
    _dio.options.headers.remove('Authorization');
  }
}
''';
  }
}
