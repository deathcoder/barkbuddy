abstract interface class NotificationService {
  get fcmToken;

  Future<void> initialize();

  Future<void> sendNotification({required String title, required String body});
}