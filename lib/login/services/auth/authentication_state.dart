import 'package:barkbuddy/login/models/barkbuddy_user.dart';
import 'package:barkbuddy/login/services/auth/authentication_service.dart';
import 'package:equatable/equatable.dart';

sealed class AbstractAuthenticationState extends Equatable {
  const AbstractAuthenticationState();
}

final class AuthenticationState extends AbstractAuthenticationState {
  final AuthenticationStatus authenticationStatus;
  final BarkbuddyUser? user;

  const AuthenticationState({
    required this.authenticationStatus,
    this.user,
  });

  @override
  List<Object> get props => [authenticationStatus];
}
