part of 'devices_bloc.dart';

sealed class AbstractDevicesState extends Equatable {
  const AbstractDevicesState();
}


final class DevicesState extends AbstractDevicesState {
  final UserDevices userDevices;
  final DateTime noCache;

  DevicesState({required this.userDevices}) : noCache = DateTime.now();

  @override
  List<Object?> get props => [userDevices, noCache];
}
