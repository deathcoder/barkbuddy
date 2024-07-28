part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();
}


final class Initialize extends LoginEvent {
  const Initialize();

  @override
  List<Object> get props => [];
}

final class LoginSubmitted extends LoginEvent {
  const LoginSubmitted();

  @override
  List<Object> get props => [];
}

final class AuthChanged extends LoginEvent {
  final AuthenticationState authenticationState;

  const AuthChanged({required this.authenticationState});

  @override
  List<Object> get props => [authenticationState];
}
