part of 'services_bloc.dart';

final class ServicesState extends Equatable {
  final UserServices userServices;
  final bool enabled;
  final String? userId;
  final DateTime noCache;


  ServicesState({required this.userServices, this.enabled = false, this.userId}) : noCache = DateTime.now();

  ServicesState copyWith({
    UserServices? userServices,
    String? userId,
    bool? enabled,
  }) {
    return ServicesState(
        userServices: userServices ?? this.userServices,
        enabled: enabled ?? this.enabled,
        userId: userId ?? this.userId
    );
  }

  @override
  List<Object?> get props => [userServices, userId, enabled, noCache];
}
