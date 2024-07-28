abstract interface class NotificationService {
  Future<String?> get fcmToken;

  Future<void> initialize();

  Future<void> sendNotification({required String title, required String body, required String fcmToken});
}