class AuthBlocGenerator {
  static String gen() {
    return '''import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/common/app_user/app_user_cubit.dart';
import '../../../../core/common/base/base_bloc.dart';
import '../../../../core/common/base/base_event.dart';
import '../../../../core/common/base/base_state.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/routes/app_routes.gr.dart';
import '../../data/models/user_model.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/auth_check.dart';
import '../../domain/usecases/auth_login.dart';
import '../../domain/usecases/auth_logout.dart';
import '../../domain/usecases/auth_sign_up.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@LazySingleton()
class AuthBloc extends BaseBloc<AuthEvent, AuthState> {
  AuthBloc({
    required AuthSignUp authSignUp,
    required AuthLogin authLogin,
    required AuthLogout authLogout,
    required AuthCheck authCheck,
    required AppUserCubit appUserCubit,
  })  : _authCheck = authCheck,
        _authSignUp = authSignUp,
        _authLogin = authLogin,
        _authLogout = authLogout,
        _appUserCubit = appUserCubit,
        super(const AuthInitial()) {
    on<AuthIsUserLoggedIn>(_isUserLoggedIn);
    on<AuthUserLoggedOut>(_logoutUser);
    on<AuthUserLoggedIn>(_loginUser);
    on<AuthUserSignedUp>(_signUpUser);
  }
  final AuthSignUp _authSignUp;
  final AuthLogin _authLogin;
  final AuthLogout _authLogout;
  final AuthCheck _authCheck;
  final AppUserCubit _appUserCubit;

  Completer<bool> authCheck = Completer<bool>();

  void _setAuthCheck(bool value) {
    if (authCheck.isCompleted) {
      authCheck = Completer<bool>();
    }
    authCheck.complete(value);
  }

  Future<void> _isUserLoggedIn(
    AuthIsUserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    final user = await _authCheck.call();
    if (user != null) {
      _appUserCubit.updateUser(user);
      _setAuthCheck(true);
      emit(AuthSuccess(user));
    } else {
      _setAuthCheck(false);
    }
  }

  Future<void> _logoutUser(
    AuthUserLoggedOut event,
    Emitter<AuthState> emit,
  ) async {
    await _authLogout.call();
    _appUserCubit.updateUser(null);
    _setAuthCheck(false);
    emit(const AuthInitial());
    appRouter.pushAndPopUntil(LoginRoute(), predicate: (_) => false);
  }

  Future<void> _loginUser(
    AuthUserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    final LoginParam params = LoginParam(
      username: event.username,
      password: event.password,
    );

    startLoading();
    final result = await _authLogin.call(params);
    stopLoading();
    result.fold(
      (error) {
        log(error.toString());
        String message = error.message;
        emit(AuthAppException(message));
      },
      (user) {
        _appUserCubit.updateUser(user);
        _setAuthCheck(true);
        emit(AuthSuccess(user));
      },
    );
  }

  Future<void> _signUpUser(
    AuthUserSignedUp event,
    Emitter<AuthState> emit,
  ) async {
    final SignUpParam params = SignUpParam(
      username: event.username,
      password: event.password,
    );

    final result = await _authSignUp.call(params);
    result.fold(
      (error) {
        String message = error.message;
        emit(AuthAppException(message));
      },
      (user) {
        _appUserCubit.updateUser(user);
        _setAuthCheck(true);
        emit(AuthSuccess(user));
      },
    );
  }
}
''';
  }
}
