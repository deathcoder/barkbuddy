import 'package:barkbuddy/common/collections.dart';
import 'package:barkbuddy/common/log/logger.dart';
import 'package:barkbuddy/home/pages/services/models/user_service.dart' hide UserService;
import 'package:barkbuddy/login/services/users/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class ServicesService {
  static final logger = Logger(name: (ServicesService).toString());

  // todo should be able to use prod in production builds
  final FirebaseFirestore db =
  FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: 'test');

  final UserService userService;

  ServicesService({required this.userService});

  Future<Stream<UserServices>> streamServices() async {
    var user = await userService.getUser();
    if(user == null) {
      throw "Users must be logged in to see their services";
    }
    return db.collection(Collections.users.collection)
        .doc(user.uid)
        .collection(Collections.users.services.collection)
        .snapshots()
        .map((data) => data.docs)
        .map((docs) => docs.where((doc) => doc.exists).map((doc){
      var uid = doc.data()["uid"];
      return switch(uid) {
        Services.gemini => GeminiUserService.fromJson(doc.data()),
        Services.googleTts => GoogleTextToSpeechUserService.fromJson(doc.data()),
        _ => throw "Unsupported service $uid",
      };
    }));
  }

  // todo this service is not needed anymore
  Future<GeminiUserService?> getGeminiUserService() async {
    var user = await userService.getUser();
    if(user == null) {
      throw "Users must be logged in to see their services";
    }
    var serviceSnapshot = await db.collection(Collections.users.collection)
        .doc(user.uid)
        .collection(Collections.users.services.collection)
        .doc(Collections.users.services.geminiId)
        .get();

    if(serviceSnapshot.exists) {
      return GeminiUserService.fromJson(serviceSnapshot.data()!);
    }
    return null;
  }

  Future<GoogleTextToSpeechUserService?> getGoogleTtsUserService() async {
    var user = await userService.getUser();
    if(user == null) {
      throw "Users must be logged in to see their services";
    }
    var serviceSnapshot = await db.collection(Collections.users.collection)
        .doc(user.uid)
        .collection(Collections.users.services.collection)
        .doc(Collections.users.services.googleTtsId)
        .get();

    if(serviceSnapshot.exists) {
      return GoogleTextToSpeechUserService.fromJson(serviceSnapshot.data()!);
    }
    return null;
  }

  Future<void> saveGeminiUserService({required String apiKey}) async {
    var user = await userService.getUser();
    if(user == null) {
      throw "Users must be logged in to save their services";
    }

    var gemini = GeminiUserService(apiKey: apiKey);

    await db.collection(Collections.users.collection)
        .doc(user.uid)
        .collection(Collections.users.services.collection)
        .doc(gemini.uid)
        .set(gemini.toJson());
  }

  Future<void> saveGoogleTtsUserService({required String projectId, required String accessToken}) async {
    var user = await userService.getUser();
    if(user == null) {
      throw "Users must be logged in to save their services";
    }

    var googleTts = GoogleTextToSpeechUserService(projectId: projectId, accessToken: accessToken);

    await db.collection(Collections.users.collection)
        .doc(user.uid)
        .collection(Collections.users.services.collection)
        .doc(googleTts.uid)
        .set(googleTts.toJson());
  }

  Future<void> deleteService({required String serviceId}) async {
    var user = await userService.getUser();
    if(user == null) {
      throw "Users must be logged in to delete their services";
    }

    await db.collection(Collections.users.collection)
        .doc(user.uid)
        .collection(Collections.users.services.collection)
        .doc(serviceId)
        .delete();
  }
}