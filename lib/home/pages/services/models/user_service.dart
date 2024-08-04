import 'package:barkbuddy/common/collections.dart';
import 'package:json_annotation/json_annotation.dart';

part '../../../../generated/home/pages/services/models/user_service.g.dart';

sealed class UserService {}

@JsonSerializable()
class GeminiUserService extends UserService {
  final String uid;
  final bool enabled;

  GeminiUserService({required this.enabled, this.uid = Services.gemini});

  factory GeminiUserService.fromJson(Map<String, dynamic> json) =>
      _$GeminiUserServiceFromJson(json);

  Map<String, dynamic> toJson() => _$GeminiUserServiceToJson(this);
}

@JsonSerializable()
class GoogleTextToSpeechUserService extends UserService {
  final String uid;
  final String projectId;
  final String accessToken;
  final bool enabled;

  GoogleTextToSpeechUserService({
    required this.projectId,
    required this.accessToken,
    required this.enabled,
    this.uid = Services.googleTts,
  });

  factory GoogleTextToSpeechUserService.fromJson(Map<String, dynamic> json) =>
      _$GoogleTextToSpeechUserServiceFromJson(json);

  Map<String, dynamic> toJson() => _$GoogleTextToSpeechUserServiceToJson(this);
}

@JsonSerializable()
class RecorderUserService extends UserService {
  final String uid;
  final bool enabled;

  RecorderUserService({required this.enabled, this.uid = Services.recorder});

  factory RecorderUserService.fromJson(Map<String, dynamic> json) =>
      _$RecorderUserServiceFromJson(json);

  Map<String, dynamic> toJson() => _$RecorderUserServiceToJson(this);
}

typedef UserServices = Iterable<UserService>;

extension UserServicesUtils on UserServices {
  bool get containsGeminiService => any((service) => switch(service) {
    GeminiUserService() => true,
    _ => false,
  });

  bool get containsGoogleTextToSpeechService => any((service) => switch(service) {
    GoogleTextToSpeechUserService() => true,
    _ => false,
  });

  bool get containsRecorderService => any((service) => switch(service) {
    RecorderUserService() => true,
    _ => false,
  });
}