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
  final String apiKey;


  const RegisterGeminiService({required this.apiKey});

  @override
  List<Object?> get props => [apiKey];
}

class RegisterGoogleTtsService extends ServicesEvent {
  final String projectId;
  final String accessToken;


  const RegisterGoogleTtsService({required this.projectId, required this.accessToken});

  @override
  List<Object?> get props => [projectId, accessToken];
}

class DeleteService extends ServicesEvent {
  final String serviceId;

  const DeleteService({required this.serviceId});

  @override
  List<Object?> get props => [serviceId];
}