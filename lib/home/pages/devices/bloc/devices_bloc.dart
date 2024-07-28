import 'dart:async';

import 'package:barkbuddy/home/pages/devices/models/user_device.dart';
import 'package:barkbuddy/home/pages/devices/services/devices/devices_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'devices_event.dart';
part 'devices_state.dart';

class DevicesBloc extends Bloc<DevicesEvent, AbstractDevicesState> {
  final DevicesService devicesService;
  StreamSubscription<UserDevices>? devicesSub;

  DevicesBloc({required this.devicesService}) : super(DevicesState(userDevices: const [])) {
    on<InitializeDevices>(onInitializeDevices);
    on<DevicesChanged>(onDevicesChanged);
    on<RegisterDevice>(onRegisterDevice);
    on<DeleteDevice>(onDeleteDevice);
  }

  Future<void> onInitializeDevices(InitializeDevices event, Emitter<AbstractDevicesState> emit) async {
    await devicesSub?.cancel();
    var stream = await devicesService.streamDevices();
    devicesSub = stream.listen((devices) {
      add(DevicesChanged(userDevices: devices));
    });
  }



  void onDevicesChanged(DevicesChanged event, Emitter<AbstractDevicesState> emit) {
    emit(DevicesState(userDevices: event.userDevices));
  }

  Future<void> onRegisterDevice(RegisterDevice event, Emitter<AbstractDevicesState> emit) async {
    await devicesService.saveCurrentDevice(name: event.deviceName);
  }

  Future<void> onDeleteDevice(DeleteDevice event, Emitter<AbstractDevicesState> emit) async {
    await devicesService.deleteDevice(deviceId: event.deviceId);
  }
}
