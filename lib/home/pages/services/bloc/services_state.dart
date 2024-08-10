part of 'services_bloc.dart';

final class ServicesState extends Equatable {
  final UserServices userServices;
  final bool enabled;
  final DateTime noCache;


  ServicesState({required this.userServices, this.enabled = false}) : noCache = DateTime.now();

  ServicesState copyWith({
    UserServices? userServices,
    bool? enabled,
  }) {
    return ServicesState(
      userServices: userServices ?? this.userServices,
      enabled: enabled ?? this.enabled
    );
  }

  @override
  List<Object> get props => [userServices, noCache];
}
