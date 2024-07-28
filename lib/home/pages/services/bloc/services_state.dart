part of 'services_bloc.dart';

sealed class AbstractServicesState extends Equatable {
  const AbstractServicesState();
}

final class ServicesState extends AbstractServicesState {
  final UserServices userServices;
  final DateTime noCache;


  ServicesState({required this.userServices}) : noCache = DateTime.now();

  @override
  List<Object> get props => [userServices, noCache];
}
