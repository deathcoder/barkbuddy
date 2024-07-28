import 'package:barkbuddy/common/log/logger.dart';
import 'package:barkbuddy/login/models/barkbuddy_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class UserService {
  static final logger = Logger(name: (UserService).toString());

  static const String userCollection = 'users';

  // todo should be able to use prod in production builds
  FirebaseFirestore db =
      FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: 'test');

  Future<BarkbuddyUser?> getUser(String id) async {
    return null;
  }

  Future<void> updateUser(BarkbuddyUser user) async {
    logger
        .info("Starting to update user ${user.uid} with email: ${user.email}");
    await db.collection(userCollection).doc(user.uid).set(
          user.toJson(),
          SetOptions(merge: true),
        );
  }
}
