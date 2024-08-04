import 'dart:async';

import 'package:barkbuddy/home/pages/services/models/user_service.dart';
import 'package:barkbuddy/home/pages/services/services/services_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'services_event.dart';

part 'services_state.dart';

class ServicesBloc extends Bloc<ServicesEvent, AbstractServicesState> {
  final ServicesService servicesService;

  StreamSubscription<UserServices>? servicesSub;

  ServicesBloc({required this.servicesService})
      : super(ServicesState(userServices: const [])) {
    on<InitializeServices>(onInitializeServices);
    on<RegisterGeminiService>(onRegisterGeminiService);
    on<RegisterGoogleTtsService>(onRegisterGoogleTtsService);
    on<RegisterRecorderService>(onRegisterRecorderService);
    on<DeleteService>(onDeleteService);
    on<ServicesChanged>(onServicesChanged);
  }

  Future<void> onInitializeServices(
      InitializeServices event, Emitter<AbstractServicesState> emit) async {
    await servicesSub?.cancel();
    var stream = await servicesService.streamServices();
    servicesSub = stream.listen((services) {
      add(ServicesChanged(userServices: services));
    });
  }

  Future<void> onRegisterGeminiService(
      RegisterGeminiService event, Emitter<AbstractServicesState> emit) async {
    await servicesService.saveGeminiUserService(enabled: event.enabled);
  }

  Future<void> onRegisterRecorderService(RegisterRecorderService event, Emitter<AbstractServicesState> emit) async {
    await servicesService.saveRecorderUserService(enabled: event.enabled);
  }

  Future<void> onRegisterGoogleTtsService(RegisterGoogleTtsService event,
      Emitter<AbstractServicesState> emit) async {
    await servicesService.saveGoogleTtsUserService(
      projectId: event.projectId,
      accessToken: event.accessToken,
      enabled: event.enabled,
    );
  }

  Future<void> onDeleteService(
      DeleteService event, Emitter<AbstractServicesState> emit) async {
    await servicesService.deleteService(serviceId: event.serviceId);
  }

  void onServicesChanged(
      ServicesChanged event, Emitter<AbstractServicesState> emit) {
    emit(ServicesState(userServices: event.userServices));
  }
}
