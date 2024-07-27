part of 'login_bloc.dart';

final class LoginState extends Equatable {
  const LoginState({
    this.status = LoginStatus.initial,
  });

  final LoginStatus status;

  LoginState copyWith({
    LoginStatus? status,
  }) {
    return LoginState(
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [status];
}
