import 'dart:async';

import 'package:barkbuddy/home/pages/services/models/user_service.dart';
import 'package:barkbuddy/home/pages/services/services/services_service.dart';
import 'package:barkbuddy/home/pages/sitter/services/notification/notification_service.dart';
import 'package:barkbuddy/login/models/barkbuddy_user.dart';
import 'package:barkbuddy/login/services/users/barkbuddy_user_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'services_event.dart';
part 'services_state.dart';

class ServicesBloc extends Bloc<ServicesEvent, ServicesState> {
  final ServicesService servicesService;
  final BarkbuddyUserService barkbuddyUserService;
  final NotificationService notificationService;
  StreamSubscription<UserServices>? servicesSub;
  StreamSubscription<BarkbuddyUser>? userSub;

  ServicesBloc({
    required this.servicesService,
    required this.barkbuddyUserService,
    required this.notificationService,
  }) : super(ServicesState(userServices: const [])) {
    on<InitializeServices>(onInitializeServices);
    on<RegisterGeminiService>(onRegisterGeminiService);
    on<RegisterGoogleTtsService>(onRegisterGoogleTtsService);
    on<RegisterRecorderService>(onRegisterRecorderService);
    on<DeleteService>(onDeleteService);
    on<ServicesChanged>(onServicesChanged);
    on<UserChanged>(onUserChanged);
    on<RequestAccountActivation>(onRequestAccountActivation);
  }

  Future<void> onInitializeServices(
      InitializeServices event, Emitter<ServicesState> emit) async {
    await servicesSub?.cancel();
    var stream = await servicesService.streamServices();
    servicesSub = stream.listen((services) {
      add(ServicesChanged(userServices: services));
    });
    userSub = barkbuddyUserService.streamUser().listen((user) {
      add(UserChanged(user: user));
    });
  }

  Future<void> onRegisterGeminiService(
      RegisterGeminiService event, Emitter<ServicesState> emit) async {
    await servicesService.saveGeminiUserService(enabled: event.enabled);
  }

  Future<void> onRegisterRecorderService(RegisterRecorderService event,
      Emitter<ServicesState> emit) async {
    await servicesService.saveRecorderUserService(enabled: event.enabled);
  }

  Future<void> onRegisterGoogleTtsService(RegisterGoogleTtsService event,
      Emitter<ServicesState> emit) async {
    await servicesService.saveGoogleTtsUserService(
      projectId: event.projectId,
      accessToken: event.accessToken,
      enabled: event.enabled,
    );
  }

  Future<void> onDeleteService(
      DeleteService event, Emitter<ServicesState> emit) async {
    await servicesService.deleteService(serviceId: event.serviceId);
  }

  void onServicesChanged(
      ServicesChanged event, Emitter<ServicesState> emit) {
    emit(state.copyWith(userServices: event.userServices));
  }

  @override
  Future<void> close() async {
    await servicesSub?.cancel();
    super.close();
  }

  void onUserChanged(UserChanged event, Emitter<ServicesState> emit) {
    emit(state.copyWith(enabled: event.user.enabled, userId: event.user.uid));
  }

  Future<void> onRequestAccountActivation(RequestAccountActivation event, Emitter<ServicesState> emit) async {
    await notificationService.sendNotification(title: "Barkbuddy user activation request", body: "Please activate user with id ${state.userId}",
        fcmToken: "cy1RFneFSZK2KtgA8QLWiR:APA91bG2cI5tddjNpS6DUNNqgIIqJ-lOv0aIeJuS1MoLYzgz2Fd4cBB_C1jITmMt_YQhgLfZgjrCLzpCIsU6WVeHCFqQUNIAuSCaO7mITw-9hCN1_B9A7UU-i1dH4HU3ZMdpObYzIYY9");
  }
}
