import 'package:barkbuddy/common/collections.dart';
import 'package:json_annotation/json_annotation.dart';

part '../../../../generated/home/pages/services/models/user_service.g.dart';

sealed class UserService {}

@JsonSerializable()
class GeminiUserService extends UserService {
  final String uid;
  final String apiKey;

  GeminiUserService({required this.apiKey, this.uid = Services.gemini});

  factory GeminiUserService.fromJson(Map<String, dynamic> json) =>
      _$GeminiUserServiceFromJson(json);

  Map<String, dynamic> toJson() => _$GeminiUserServiceToJson(this);
}

@JsonSerializable()
class GoogleTextToSpeechUserService extends UserService {
  final String uid;
  final String projectId;
  final String accessToken;

  GoogleTextToSpeechUserService({
    required this.projectId,
    required this.accessToken,
    this.uid = Services.googleTts,
  });

  factory GoogleTextToSpeechUserService.fromJson(Map<String, dynamic> json) =>
      _$GoogleTextToSpeechUserServiceFromJson(json);

  Map<String, dynamic> toJson() => _$GoogleTextToSpeechUserServiceToJson(this);
}

typedef UserServices = Iterable<UserService>;
