class ApiErrorHandlerMixinGenerator {
  static String gen() {
    return '''import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../errors/exception.dart';

/// A mixin that handles API errors.
///
/// This mixin provides a `request` method that takes a function that returns a
/// `Future` and handles any `DioException` or other exceptions that may occur.
///
/// The `request` method returns a `ResultFuture` object, which contains either
/// a successful result or an error.
mixin ApiHandlerMixin {
  /// Makes an API call and handles any errors that may occur.
  ///
  /// [apiCall] The function that makes the API call.
  ///
  /// Returns a `ResultFuture` object, which contains either a successful result
  /// or an error.
  Future<Either<AppException, T>> request<T>(
    Future<T> apiCall,
  ) async {
    try {
      final result = await apiCall;
      return Right(result);
    } on DioException catch (e, _) {
      return Left(handleError(e));
    } catch (e, _) {
      return Left(
        ServerException(message: e.toString()),
      );
    }
  }

  // Handle Dio errors
  AppException handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException();
      case DioExceptionType.badResponse:
        switch (e.response?.statusCode) {
          case 400:
            return BadRequestException(message: e.response?.data['message']);
          case 401:
            return UnauthorizedException(message: e.response?.data['message']);
          case 403:
            return ForbiddenException(message: e.response?.data['message']);
          case 404:
            return NotFoundException(message: e.response?.data['message']);
          case 500:
          case 501:
          case 502:
          case 503:
            return ServerException(message: e.response?.data['message']);
          default:
            return ServerException(
              message: e.response?.data['message'] ?? 'Unknown error occurred',
            );
        }
      case DioExceptionType.cancel:
        return RequestCancelledException();
      case DioExceptionType.unknown:
        if (e.error.toString().contains('SocketException')) {
          return NetworkException();
        }
        return ServerException(message: 'Unknown error occurred');
      default:
        return ServerException(message: 'Unknown error occurred');
    }
  }
}

''';
  }
}
