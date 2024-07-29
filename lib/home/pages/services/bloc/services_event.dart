part of 'services_bloc.dart';

sealed class ServicesEvent extends Equatable {
  const ServicesEvent();
}

class InitializeServices extends ServicesEvent {
  @override
  List<Object?> get props => [];
}

final class ServicesChanged extends ServicesEvent {
  final UserServices userServices;

  const ServicesChanged({required this.userServices});

  @override
  List<Object> get props => [userServices];
}

class RegisterGeminiService extends ServicesEvent {
  final bool enabled;

  const RegisterGeminiService({required this.enabled});

  @override
  List<Object?> get props => [enabled];
}

class RegisterGoogleTtsService extends ServicesEvent {
  final String projectId;
  final String accessToken;
  final bool enabled;

  const RegisterGoogleTtsService({
    required this.projectId,
    required this.accessToken,
    required this.enabled,
  });

  @override
  List<Object?> get props => [projectId, accessToken, enabled];
}

class DeleteService extends ServicesEvent {
  final String serviceId;

  const DeleteService({required this.serviceId});

  @override
  List<Object?> get props => [serviceId];
}
