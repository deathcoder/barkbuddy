import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'devices_event.dart';
part 'devices_state.dart';

class DevicesBloc extends Bloc<DevicesEvent, AbstractDevicesState> {
  DevicesBloc() : super(DevicesInitial()) {
    on<DevicesEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
