part of 'devices_bloc.dart';

sealed class AbstractDevicesState extends Equatable {
  const AbstractDevicesState();
}


final class DevicesInitial extends AbstractDevicesState {

  @override
  List<Object?> get props => [];
}
