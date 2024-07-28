import 'package:barkbuddy/common/collections.dart';
import 'package:barkbuddy/common/log/logger.dart';
import 'package:barkbuddy/login/models/barkbuddy_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class UserService {
  static final logger = Logger(name: (UserService).toString());
  late String userId;

  // todo should be able to use prod in production builds
  FirebaseFirestore db =
      FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: 'test');

  Future<BarkbuddyUser?> getUser() async {
    var userSnapshot = await db.collection(Collections.users.collection)
        .doc(userId)
        .get();
    if(userSnapshot.exists) {
      return BarkbuddyUser.fromJson(userSnapshot.data()!);
    }

    return null;
  }

  Future<void> updateUser(BarkbuddyUser user) async {
    logger
        .info("Starting to update user ${user.uid} with email: ${user.email}");
    userId = user.uid;

    await db.collection(Collections.users.collection)
        .doc(userId)
        .set(user.toJson(), SetOptions(merge: true),
    );
  }
}
