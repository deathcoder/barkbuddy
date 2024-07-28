import 'package:firebase_auth/firebase_auth.dart';
import 'package:json_annotation/json_annotation.dart';

part '../../generated/login/models/barkbuddy_user.g.dart';

@JsonSerializable()
class BarkbuddyUser {
  final String? displayName;
  final String? email;
  final bool emailVerified;
  final bool isAnonymous;
  final DateTime? creationTimestamp;
  final DateTime? lastSignInTime;
  final String? phoneNumber;
  final String? photoUrl;
  final String uid;

  BarkbuddyUser({
    this.displayName,
    this.email,
    required this.emailVerified,
    required this.isAnonymous,
    this.creationTimestamp,
    this.lastSignInTime,
    this.phoneNumber,
    this.photoUrl,
    required this.uid,
  });

  factory BarkbuddyUser.fromJson(Map<String, dynamic> json) =>
      _$BarkbuddyUserFromJson(json);

  Map<String, dynamic> toJson() => _$BarkbuddyUserToJson(this);

  static fromFirebaseUser(User firebaseUser) {
    return BarkbuddyUser(
      displayName: firebaseUser.displayName,
      email: firebaseUser.email,
      emailVerified: firebaseUser.emailVerified,
      isAnonymous: firebaseUser.isAnonymous,
      creationTimestamp: firebaseUser.metadata.creationTime,
      lastSignInTime: firebaseUser.metadata.lastSignInTime,
      phoneNumber: firebaseUser.phoneNumber,
      photoUrl: firebaseUser.photoURL,
      uid: firebaseUser.uid,
    );
  }
}
