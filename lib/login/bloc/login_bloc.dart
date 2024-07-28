import 'dart:async';

import 'package:barkbuddy/login/services/auth/authentication_service.dart';
import 'package:barkbuddy/login/services/auth/authentication_state.dart';
import 'package:barkbuddy/login/services/users/user_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'login_event.dart';
part 'login_state.dart';

enum LoginStatus { initial, inProgress, success, failure, loggedOut }

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationService authenticationService;
  final UserService userService;

  StreamSubscription<AuthenticationState>? authSub;

  LoginBloc({
    required this.authenticationService,
    required this.userService,
  })  : super(const LoginState()) {
    on<InitializeLogin>(onInitializeLogin);
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

  Future<void> onInitializeLogin(InitializeLogin event, Emitter<LoginState> emit) async {
    await authSub?.cancel();
    authSub = authenticationService.stateStream.listen((authState){
      add(AuthChanged(authenticationState: authState));
    });
  }

  Future<void> onAuthChanged(AuthChanged event, Emitter<LoginState> emit) async {
    if(event.authenticationState.authenticationStatus == AuthenticationStatus.authenticated) {
      await userService.updateUser(event.authenticationState.user!);
      emit(state.copyWith(status: LoginStatus.success));
    } else {
      emit(state.copyWith(status: LoginStatus.loggedOut));
    }
  }

  @override
  Future<void> close() async {
    await authSub?.cancel();
    await super.close();
  }
}
