part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}


final class Initialize extends LoginEvent {
  const Initialize();
}

final class LoginSubmitted extends LoginEvent {
  const LoginSubmitted();
}

final class AuthChanged extends LoginEvent {
  final AuthenticationStatus authenticationStatus;

  const AuthChanged({required this.authenticationStatus});

  @override
  List<Object> get props => [authenticationStatus];
}
