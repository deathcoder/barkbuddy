import 'dart:async';

import 'package:barkbuddy/login/services/auth/authentication_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'login_event.dart';
part 'login_state.dart';

enum LoginStatus { initial, inProgress, success, failure, loggedOut }

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationService authenticationService;
  StreamSubscription<AuthenticationStatus>? authSub;

  LoginBloc({
    required this.authenticationService,
  })  : super(const LoginState()) {
    on<Initialize>(onInitialize);
    on<LoginSubmitted>(onLoginSubmitted);
    on<AuthChanged>(onAuthChanged);
  }

  Future<void> onLoginSubmitted(
      LoginSubmitted event,
      Emitter<LoginState> emit,
      ) async {
    emit(state.copyWith(status: LoginStatus.inProgress));
    try {
      await authenticationService.signInWithGoogle();
    } catch (_) {
      emit(state.copyWith(status: LoginStatus.failure));
    }
  }

  Future<void> onInitialize(Initialize event, Emitter<LoginState> emit) async {
    await authSub?.cancel();
    authSub = authenticationService.status.listen((authStatus){
      add(AuthChanged(authenticationStatus: authStatus));
    });
  }

  Future<void> onAuthChanged(AuthChanged event, Emitter<LoginState> emit) async {
    if(event.authenticationStatus == AuthenticationStatus.authenticated) {
      emit(state.copyWith(status: LoginStatus.success));
    } else {
      emit(state.copyWith(status: LoginStatus.loggedOut));
    }
  }
}
