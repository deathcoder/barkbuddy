part of 'devices_bloc.dart';

sealed class DevicesEvent extends Equatable {
  const DevicesEvent();
}


final class InitializeDevices extends DevicesEvent {
  const InitializeDevices();

  @override
  List<Object> get props => [];
}

final class DevicesChanged extends DevicesEvent {
  final UserDevices userDevices;

  const DevicesChanged({required this.userDevices});

  @override
  List<Object> get props => [userDevices];
}

final class RegisterDevice extends DevicesEvent {
  final String deviceName;

  const RegisterDevice({required this.deviceName});

  @override
  List<Object> get props => [deviceName];
}

final class DeleteDevice extends DevicesEvent {
  final String deviceId;

  const DeleteDevice({required this.deviceId});

  @override
  List<Object> get props => [deviceId];
}